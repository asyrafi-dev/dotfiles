#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Node.js installer error on line $LINENO" >&2; exit 1' ERR

ASSUME_YES=${ASSUME_YES:-0}
DRY_RUN=${DRY_RUN:-0}
CI=${CI:-}

NVM_VERSION="v0.40.3"

echo "[nodejs] Installing Node.js via NVM"

# Check if nvm already installed
if [ -d "$HOME/.nvm" ]; then
  echo "NVM already installed"
  # shellcheck source=/dev/null
  [ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"
  
  # Check if Node is already installed
  if command -v node >/dev/null 2>&1; then
    CURRENT_NODE_VERSION=$(node -v | cut -d'.' -f1 | sed 's/v//')
    echo "Node.js already installed: $(node -v)"
    echo "npm version: $(npm -v)"
    
    # In CI mode, check if we need to install a different version
    if [ -n "${CI:-}" ] && [ "${ASSUME_YES:-0}" -eq 1 ]; then
      # CI mode: allow installing different versions
      echo "CI mode: will proceed to install/switch Node.js version"
    elif [ "${ASSUME_YES:-0}" -eq 0 ]; then
      # Interactive mode: ask user
      read -rp "Do you want to install another Node.js version? [y/N] " install_another
      if [[ ! $install_another =~ ^[Yy]$ ]]; then
        echo "Skipping Node.js installation."
        exit 0
      fi
    else
      # Non-interactive non-CI mode: skip
      echo "Node.js already installed, skipping."
      exit 0
    fi
  fi
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would install NVM $NVM_VERSION"
  echo "DRY-RUN: would show LTS versions and let user choose"
  echo "DRY-RUN: would update npm to latest (only for Node 24)"
  exit 0
fi

# Install NVM if not exists
if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing NVM $NVM_VERSION..."
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
  
  # Load NVM
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Display available LTS versions
echo
echo "Available Node.js LTS versions:"
echo "================================"
echo "1) Node.js 18 LTS - Hydrogen (Maintenance until April 2025)"
echo "2) Node.js 20 LTS - Iron (Active LTS until April 2026)"
echo "3) Node.js 22 LTS - Jod (Active LTS until April 2027)"
echo "4) Node.js 24    - Latest (Current, will be LTS in October 2025) ⭐ Default"
echo

# Non-interactive mode: install Node 24
if [ "${ASSUME_YES:-0}" -eq 1 ] || [ -n "${CI:-}" ]; then
  NODE_VERSION="24"
  echo "Non-interactive mode: installing Node.js $NODE_VERSION"
else
  # Interactive mode: let user choose
  read -rp "Choose Node.js version [1-4, default: 4]: " choice
  
  case ${choice:-4} in
    1) NODE_VERSION="18" ;;
    2) NODE_VERSION="20" ;;
    3) NODE_VERSION="22" ;;
    4) NODE_VERSION="24" ;;
    *)
      echo "Invalid choice, using Node.js 24"
      NODE_VERSION="24"
      ;;
  esac
fi

# Install chosen Node.js version
echo
echo "Installing Node.js $NODE_VERSION..."
nvm install "$NODE_VERSION"
nvm use "$NODE_VERSION"
nvm alias default "$NODE_VERSION"

# Verify installation
echo
echo "Verifying Node.js installation..."
echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"

# Update npm to latest ONLY for Node.js 24
if [ "$NODE_VERSION" = "24" ]; then
  echo
  echo "Updating npm to latest version (Node.js 24)..."
  npm install -g npm@latest
  echo "npm updated to: $(npm -v)"
else
  echo
  echo "Using npm version bundled with Node.js $NODE_VERSION"
  echo "To update npm later: npm install -g npm@latest"
fi

# Final verification
echo
echo "Installation complete!"
echo "================================"
echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"
echo
echo "Useful commands:"
echo "  nvm ls                  - List installed versions"
echo "  nvm install 18          - Install another version"
echo "  nvm use 18              - Switch to another version"
echo "  nvm alias default 18    - Set default version"
if [ "$NODE_VERSION" != "24" ]; then
  echo "  npm install -g npm@latest - Update npm (optional)"
fi
