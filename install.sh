#!/usr/bin/env bash
set -euo pipefail
trap 'echo "ERROR on line $LINENO" >&2; exit 1' ERR

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

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

# ASCII Art Banner
clear
echo -e "${CYAN}"
cat << "EOF"
    ___                            _____ 
   /   |  _______  ___________ _  / __(_)
  / /| | / ___/ / / / ___/ __ `/ / /_/ / 
 / ___ |(__  ) /_/ / /  / /_/ / / __/ /  
/_/  |_/____/\__, /_/   \__,_/ /_/ /_/   
            /____/                        
EOF
echo -e "${NC}"
echo -e "${MAGENTA}╔════════════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}  ${WHITE}Dotfiles Installer for Ubuntu 24.04 LTS${NC}    ${MAGENTA}║${NC}"
echo -e "${MAGENTA}║${NC}  ${CYAN}Automated setup for your dev environment${NC}   ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════════════╝${NC}"
echo

# Ensure all scripts in the scripts/ directory are executable
chmod +x scripts/*.sh >/dev/null 2>&1

# Run all pre-installation checks
echo -e "${YELLOW}[→]${NC} Running pre-installation checks..."
bash scripts/preflight.sh

# Confirm before proceeding
echo
if [ "${ASSUME_YES:-0}" -eq 1 ] || [ -n "${CI:-}" ]; then
  echo -e "${GREEN}[✓]${NC} Proceeding non-interactively"
else
  echo -e "${YELLOW}[!]${NC} This installer will modify your system and install packages."
  read -rp "Do you want to continue? [y/N] " answer
  if [[ ! $answer =~ ^[Yy]$ ]]; then
      echo -e "${RED}[✗]${NC} Installation aborted. No changes were made."
      exit 1
  fi
fi

# --- System Package Installation ---
echo
echo -e "${CYAN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${WHITE}Installing System Packages${NC}                   ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════╝${NC}"
echo -e "${YELLOW}[→]${NC} Updating package lists..."
if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would run 'sudo apt-get update'"
else
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "ERROR: apt-get not found. This installer requires apt-based systems." >&2
    exit 1
  fi
  sudo apt-get update
fi

echo -e "${YELLOW}[→]${NC} Installing packages from packages/apt.txt..."
if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would install packages listed in packages/apt.txt"
else
  PACKAGES=$(grep -vE '^\s*#|^\s*$' packages/apt.txt || true)
  if [ -n "${PACKAGES:-}" ]; then
    echo "$PACKAGES" | xargs sudo apt-get install -y --no-install-recommends
    echo -e "${GREEN}[✓]${NC} Packages installed successfully"
  else
    echo -e "${YELLOW}[!]${NC} No packages to install"
  fi
fi
echo

# --- Post-installation Setup ---
echo -e "${CYAN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${WHITE}Installing Development Tools${NC}                 ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════╝${NC}"

# Link fd-find to fd if it exists
if command -v fdfind &> /dev/null; then
    echo -e "${YELLOW}[→]${NC} Linking fdfind to fd..."
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    echo -e "${GREEN}[✓]${NC} fd linked successfully"
fi

# Run individual component installers
echo
echo -e "${YELLOW}[→]${NC} Installing Neovim..."
bash scripts/install-neovim.sh
echo -e "${GREEN}[✓]${NC} Neovim installed"

echo
echo -e "${YELLOW}[→]${NC} Installing Nerd Fonts..."
bash scripts/install-nerd-fonts.sh
echo -e "${GREEN}[✓]${NC} Nerd Fonts installed"

echo
echo -e "${YELLOW}[→]${NC} Setting up LazyVim..."
bash scripts/install-lazyvim.sh
echo -e "${GREEN}[✓]${NC} LazyVim configured"

echo
echo -e "${YELLOW}[→]${NC} Installing Node.js..."
bash scripts/install-nodejs.sh
echo -e "${GREEN}[✓]${NC} Node.js installed"

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
  echo -e "${CYAN}╔════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}  ${WHITE}Verifying Installation${NC}                      ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════╝${NC}"
  if [ -f "scripts/verify-install.sh" ]; then
    bash scripts/verify-install.sh || true
  fi
fi

# --- Git User Configuration ---
if [ "$DRY_RUN" -eq 0 ]; then
  echo
  echo -e "${CYAN}╔════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}  ${WHITE}Git Configuration${NC}                           ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════╝${NC}"
  CURRENT_GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")
  CURRENT_GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
  
  if [ -z "$CURRENT_GIT_NAME" ] || [ -z "$CURRENT_GIT_EMAIL" ]; then
    echo -e "${YELLOW}[!]${NC} Git user information is not configured"
    if [ "${ASSUME_YES:-0}" -eq 1 ] || [ -n "${CI:-}" ]; then
      echo -e "${YELLOW}[!]${NC} Skipping Git configuration in non-interactive mode"
      echo "Run 'bash scripts/setup-git-user.sh' later to configure."
    else
      echo
      read -rp "Would you like to configure it now? [Y/n] " setup_git
      if [[ ! $setup_git =~ ^[Nn]$ ]]; then
        bash scripts/setup-git-user.sh
      else
        echo -e "${YELLOW}[!]${NC} You can configure Git later:"
        echo "  bash scripts/setup-git-user.sh"
      fi
    fi
  else
    echo -e "${GREEN}[✓]${NC} Git is already configured:"
    echo "  Name:  $CURRENT_GIT_NAME"
    echo "  Email: $CURRENT_GIT_EMAIL"
  fi
fi

# --- Final Instructions ---
echo
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}  ${WHITE}Installation Complete!${NC}                      ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo
echo -e "${CYAN}Backup manifest:${NC} $BACKUP_MANIFEST"
echo
echo -e "${WHITE}Next steps:${NC}"
echo -e "  ${YELLOW}1.${NC} Restart your terminal:"
echo -e "     ${CYAN}source ~/.bashrc${NC}"
echo
echo -e "  ${YELLOW}2.${NC} Launch Neovim to complete LazyVim setup:"
echo -e "     ${CYAN}nvim${NC}"
echo -e "     (Wait for plugins to install, then restart)"
echo
echo -e "  ${YELLOW}3.${NC} If you skipped Git configuration:"
echo -e "     ${CYAN}bash scripts/setup-git-user.sh${NC}"
echo
echo -e "  ${YELLOW}4.${NC} Test your new environment:"
echo -e "     ${CYAN}tmux${NC}              # Terminal multiplexer"
echo -e "     ${CYAN}Ctrl+T${NC}            # Find files (FZF)"
echo -e "     ${CYAN}Ctrl+R${NC}            # Search history (FZF)"
echo -e "     ${CYAN}git aliases${NC}       # Show Git shortcuts"
echo
echo -e "${MAGENTA}For help:${NC} docs/QUICK_START.md"
echo -e "${MAGENTA}Rollback:${NC} ./scripts/rollback.sh"
echo
