#!/usr/bin/env bash
set -euo pipefail
trap 'echo "ERROR on line $LINENO" >&2; exit 1' ERR

# Default options
DRY_RUN=0
ASSUME_YES=0
LOG_FILE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --yes|-y) ASSUME_YES=1; shift;;
    --dry-run) DRY_RUN=1; shift;;
    --log) LOG_FILE="$2"; shift 2;;
    --log=*) LOG_FILE="${1#*=}"; shift;;
    -h|--help) echo "Usage: $0 [--yes] [--dry-run] [--log FILE]"; exit 0;;
    *) echo "Unknown argument: $1"; exit 1;;
  esac
done

if [ -n "$LOG_FILE" ]; then
  mkdir -p "$(dirname "$LOG_FILE")"
  echo "Logging to $LOG_FILE"
  exec > >(tee -a "$LOG_FILE") 2>&1
fi

BACKUP_MANIFEST="${BACKUP_MANIFEST:-$HOME/.dotfiles_backups_$(date +%s).txt}"
mkdir -p "$(dirname "$BACKUP_MANIFEST")"
touch "$BACKUP_MANIFEST"
export ASSUME_YES DRY_RUN LOG_FILE BACKUP_MANIFEST

echo "[+] Starting Dotfiles Installation..."
echo

# Ensure all scripts in the scripts/ directory are executable
chmod +x scripts/*.sh >/dev/null 2>&1

# Run all pre-installation checks
bash scripts/preflight.sh

# Confirm before proceeding
echo
if [ "${ASSUME_YES:-0}" -eq 1 ] || [ -n "${CI:-}" ]; then
  echo "Proceeding non-interactively (assume-yes or CI environment)."
else
  echo "This installer will modify your system and install packages. Review the script before continuing."
  read -rp "Do you want to continue? [y/N] " answer
  if [[ ! $answer =~ ^[Yy]$ ]]; then
      echo "Aborting installation. No changes were made."
      exit 1
  fi
fi

# --- System Package Installation ---
echo "[+] Installing system dependencies..."
echo "  -> Updating package lists (apt-get update)..."
if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would run 'sudo apt-get update'"
else
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "ERROR: apt-get not found. This installer requires apt-based systems." >&2
    exit 1
  fi
  sudo apt-get update
fi

echo "  -> Installing packages from 'packages/apt.txt'..."
if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would install packages listed in packages/apt.txt"
else
  PACKAGES=$(grep -vE '^\s*#|^\s*$' packages/apt.txt || true)
  if [ -n "${PACKAGES:-}" ]; then
    echo "  -> Installing packages:"
    echo "$PACKAGES"
    echo "$PACKAGES" | xargs sudo apt-get install -y --no-install-recommends
  else
    echo "  -> No packages to install (packages/apt.txt is empty or missing)."
  fi
fi
echo

# --- Post-installation Setup ---
echo "[+] Performing post-installation setup..."

# Link fd-find to fd if it exists
if command -v fdfind &> /dev/null; then
    echo "  -> Linking 'fdfind' to 'fd'..."
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
fi

# Run individual component installers
bash scripts/install-neovim.sh
bash scripts/install-nerd-fonts.sh
bash scripts/install-lazyvim.sh

# Apply dotfiles configuration using Stow
echo "  -> Applying configuration files with Stow..."
# Remove potentially conflicting files before stowing
if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would remove or backup ~/.bashrc"
else
  if [ -f "$HOME/.bashrc" ]; then
    BACKUP="$HOME/.bashrc.bak.$(date +%s)"
    echo "  -> Backing up existing ~/.bashrc to $BACKUP"
    mv "$HOME/.bashrc" "$BACKUP"
    echo "bashrc:$BACKUP" >> "$BACKUP_MANIFEST"
  fi
fi

# Helper: detect potential conflicts between home/ and $HOME
conflicts=()
for entry in home/*; do
  [ -e "$entry" ] || continue
  name=$(basename "$entry")
  target="$HOME/$name"
  if [ -e "$target" ] && [ ! -L "$target" ] && [ ! -d "$target" ]; then
    conflicts+=("$name")
  fi
done

if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would run 'stow' to apply dotfiles (preview):"
  if command -v stow >/dev/null 2>&1; then
    echo "Running stow preview (dry-run), output saved to stow-preview.txt"
    set +e
    (cd home && stow -n -t ~ --no-folding --adopt -- *) > stow-preview.txt 2>&1
    stow_status=$?
    set -e
    if [ $stow_status -ne 0 ]; then
      echo "stow preview reported issues. Summary of conflicts (if any):"
      grep -E "existing target|would remove|ERROR" stow-preview.txt || true
      if [ ${#conflicts[@]} -gt 0 ]; then
        echo
        echo "Detected files that would conflict and need backup or removal:"
        for c in "${conflicts[@]}"; do
          echo "  - $HOME/$c"
        done
        echo
        echo "Suggested actions:"
        echo "  * Move the conflicting files to a backup (the installer will do this automatically in real run if you allow it)."
        echo "  * Or remove them if you no longer need them."
      fi
    else
      cat stow-preview.txt
    fi
  else
    echo "DRY-RUN: 'stow' not installed"
  fi
else
  if ! command -v stow >/dev/null 2>&1; then
    echo "ERROR: 'stow' is required to apply dotfiles."
    if [ "$ASSUME_YES" -eq 1 ]; then
      echo "Installing stow..."
      sudo apt-get install -y stow
    else
      read -rp "Install 'stow' now? [y/N] " install_stow
      if [[ $install_stow =~ ^[Yy]$ ]]; then
        sudo apt-get install -y stow
      else
        echo "Cannot continue without 'stow'. Exiting."
        exit 1
      fi
    fi
  fi

  if [ ${#conflicts[@]} -gt 0 ]; then
    echo "The following existing files will conflict with stow and are not symlinks or directories:"
    for c in "${conflicts[@]}"; do
      echo "  - $HOME/$c"
    done
    if [ "${ASSUME_YES:-0}" -eq 1 ] || [ -n "${CI:-}" ]; then
      echo "Backing up conflicting files non-interactively to manifest: $BACKUP_MANIFEST"
      for c in "${conflicts[@]}"; do
        src="$HOME/$c"
        dest="$HOME/$c.dotfiles.bak.$(date +%s)"
        echo "  -> Backing up $src to $dest"
        mv "$src" "$dest"
        echo "$c:$dest" >> "$BACKUP_MANIFEST"
      done
    else
      read -rp "Backup conflicting files now and continue? [y/N] " resp
      if [[ $resp =~ ^[Yy]$ ]]; then
        for c in "${conflicts[@]}"; do
          src="$HOME/$c"
          dest="$HOME/$c.dotfiles.bak.$(date +%s)"
          echo "  -> Backing up $src to $dest"
          mv "$src" "$dest"
          echo "$c:$dest" >> "$BACKUP_MANIFEST"
        done
      else
        echo "Aborting; resolve conflicts manually and re-run the installer."
        exit 1
      fi
    fi
  fi

  # show what will be done
  echo "Preview of stow actions:"
  (cd home && stow -n -t ~ --no-folding --adopt -- *)
  if [ "${ASSUME_YES:-0}" -eq 1 ] || [ -n "${CI:-}" ]; then
    echo "Applying stow changes non-interactively."
    (cd home && stow -t ~ --no-folding --adopt -- *)
  else
    read -rp "Apply these changes? [y/N] " stow_confirm
    if [[ ! $stow_confirm =~ ^[Yy]$ ]]; then
      echo "Skipping stow. You can run 'stow -t ~ --no-folding -- *' manually."
    else
      (cd home && stow -t ~ --no-folding --adopt -- *)
    fi
  fi
fi

# --- Post-Installation Verification ---
if [ "$DRY_RUN" -eq 0 ]; then
  echo
  echo "[+] Running post-installation verification..."
  if [ -f "scripts/verify-install.sh" ]; then
    bash scripts/verify-install.sh || true
  fi
fi

# --- Final Instructions ---
echo
echo "--------------------------------------------------"
echo "Installation Complete"
echo "--------------------------------------------------"
echo
echo "Backup manifest saved to: $BACKUP_MANIFEST"
echo
echo "Next steps:"
echo "1. Restart your terminal for all changes to take effect:"
echo "   source ~/.bashrc"
echo
echo "2. After restarting, launch 'nvim' to allow LazyVim to complete its plugin setup:"
echo "   nvim"
echo
echo "3. Configure your Git identity (IMPORTANT!):"
echo "   git config --global user.name \"Your Name\""
echo "   git config --global user.email \"you@email.com\""
echo
echo "4. Test your setup:"
echo "   - Tmux: tmux"
echo "   - FZF: Ctrl+T (fuzzy find files)"
echo "   - Ripgrep: rg 'search term'"
echo
echo "If you encounter any issues, run: ./scripts/rollback.sh"
echo
