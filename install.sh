#!/usr/bin/env bash
set -euo pipefail
trap 'echo "ERROR on line $LINENO" >&2; exit 1' ERR

# Colors (only if terminal supports it)
if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  MAGENTA='\033[0;35m'
  CYAN='\033[0;36m'
  WHITE='\033[1;37m'
  NC='\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  MAGENTA=''
  CYAN=''
  WHITE=''
  NC=''
fi

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

# Helper functions for colored output
print_success() {
  if [ -n "${GREEN:-}" ]; then
    echo -e "${GREEN}[✓]${NC} $1"
  else
    echo "[+] $1"
  fi
}

print_info() {
  if [ -n "${YELLOW:-}" ]; then
    echo -e "${YELLOW}[→]${NC} $1"
  else
    echo "[+] $1"
  fi
}

print_warning() {
  if [ -n "${YELLOW:-}" ]; then
    echo -e "${YELLOW}[!]${NC} $1"
  else
    echo "[!] $1"
  fi
}

print_error() {
  if [ -n "${RED:-}" ]; then
    echo -e "${RED}[✗]${NC} $1"
  else
    echo "[✗] $1"
  fi
}

print_header() {
  if [ -n "${CYAN:-}" ]; then
    echo -e "${CYAN}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${WHITE}$1${NC}$(printf '%*s' $((47 - ${#1})) '')${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════╝${NC}"
  else
    echo "$1"
    echo "$(printf '=%.0s' {1..50})"
  fi
}

# ASCII Art Banner (only in interactive mode)
if [ -t 1 ] && [ -z "${CI:-}" ]; then
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
else
  echo "Dotfiles Installer for Ubuntu 24.04 LTS"
  echo "========================================"
  echo
fi

# Ensure all scripts in the scripts/ directory are executable
chmod +x scripts/*.sh >/dev/null 2>&1 || true

# Run all pre-installation checks
print_info "Running pre-installation checks..."
bash scripts/preflight.sh

# Confirm before proceeding
echo
if [ "${ASSUME_YES:-0}" -eq 1 ] || [ -n "${CI:-}" ]; then
  print_success "Proceeding non-interactively"
else
  print_warning "This installer will modify your system and install packages."
  read -rp "Do you want to continue? [y/N] " answer
  if [[ ! $answer =~ ^[Yy]$ ]]; then
      print_error "Installation aborted. No changes were made."
      exit 1
  fi
fi

# --- System Package Installation ---
echo
print_header "Installing System Packages"
print_info "Updating package lists..."
if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would run 'sudo apt-get update'"
else
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "ERROR: apt-get not found. This installer requires apt-based systems." >&2
    exit 1
  fi
  sudo apt-get update
fi

print_info "Installing packages from packages/apt.txt..."
if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would install packages listed in packages/apt.txt"
else
  PACKAGES=$(grep -vE '^\s*#|^\s*$' packages/apt.txt || true)
  if [ -n "${PACKAGES:-}" ]; then
    echo "$PACKAGES" | xargs sudo apt-get install -y --no-install-recommends
    print_success "Packages installed successfully"
  else
    print_warning "No packages to install"
  fi
fi
echo

# --- Post-installation Setup ---
print_header "Installing Development Tools"

# Link fd-find to fd if it exists
if command -v fdfind &> /dev/null; then
    print_info "Linking fdfind to fd..."
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    print_success "fd linked successfully"
fi

# Run individual component installers
echo
print_info "Installing Neovim..."
bash scripts/install-neovim.sh
print_success "Neovim installed"

echo
print_info "Installing Nerd Fonts..."
bash scripts/install-nerd-fonts.sh
print_success "Nerd Fonts installed"

echo
print_info "Setting up LazyVim..."
bash scripts/install-lazyvim.sh
print_success "LazyVim configured"

echo
print_info "Installing Node.js..."
bash scripts/install-nodejs.sh
print_success "Node.js installed"

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
  print_header "Verifying Installation"
  if [ -f "scripts/verify-install.sh" ]; then
    bash scripts/verify-install.sh || true
  fi
fi

# --- Git User Configuration ---
if [ "$DRY_RUN" -eq 0 ]; then
  echo
  print_header "Git Configuration"
  CURRENT_GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")
  CURRENT_GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
  
  if [ -z "$CURRENT_GIT_NAME" ] || [ -z "$CURRENT_GIT_EMAIL" ]; then
    print_warning "Git user information is not configured"
    if [ "${ASSUME_YES:-0}" -eq 1 ] || [ -n "${CI:-}" ]; then
      print_warning "Skipping Git configuration in non-interactive mode"
      echo "Run 'bash scripts/setup-git-user.sh' later to configure."
    else
      echo
      read -rp "Would you like to configure it now? [Y/n] " setup_git
      if [[ ! $setup_git =~ ^[Nn]$ ]]; then
        bash scripts/setup-git-user.sh
      else
        print_warning "You can configure Git later:"
        echo "  bash scripts/setup-git-user.sh"
      fi
    fi
  else
    print_success "Git is already configured:"
    echo "  Name:  $CURRENT_GIT_NAME"
    echo "  Email: $CURRENT_GIT_EMAIL"
  fi
fi

# --- Final Instructions ---
echo
if [ -n "${GREEN:-}" ]; then
  echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║${NC}  ${WHITE}Installation Complete!${NC}                      ${GREEN}║${NC}"
  echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
else
  echo "Installation Complete!"
  echo "======================"
fi
echo
echo "Backup manifest: $BACKUP_MANIFEST"
echo
echo "Next steps:"
echo "  1. Restart your terminal:"
echo "     source ~/.bashrc"
echo
echo "  2. Launch Neovim to complete LazyVim setup:"
echo "     nvim"
echo
echo "  3. If you skipped Git configuration:"
echo "     bash scripts/setup-git-user.sh"
echo
echo "  4. Test your new environment:"
echo "     tmux              # Terminal multiplexer"
echo "     Ctrl+T            # Find files (FZF)"
echo "     git aliases       # Show Git shortcuts"
echo
echo "For help: docs/QUICK_START.md"
echo "Rollback: ./scripts/rollback.sh"
echo
