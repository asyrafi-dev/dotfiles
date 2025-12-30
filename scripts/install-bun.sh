#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Bun installer error on line $LINENO" >&2; exit 1' ERR

ASSUME_YES=${ASSUME_YES:-0}
DRY_RUN=${DRY_RUN:-0}
CI=${CI:-}

echo "[bun] Installing Bun"

# Check if Bun already installed
if command -v bun >/dev/null 2>&1; then
  CURRENT_VERSION=$(bun --version)
  echo "Bun already installed: v$CURRENT_VERSION"
  
  if [ "${ASSUME_YES:-0}" -eq 0 ] && [ -z "${CI:-}" ]; then
    read -rp "Do you want to reinstall/update Bun? [y/N] " reinstall
    if [[ ! $reinstall =~ ^[Yy]$ ]]; then
      echo "Skipping Bun installation."
      exit 0
    fi
  else
    echo "Bun already installed, skipping."
    exit 0
  fi
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would install Bun"
  echo "DRY-RUN: would add Bun to PATH in ~/.bashrc"
  exit 0
fi

# Install Bun
echo "Installing Bun..."
curl -fsSL https://bun.sh/install | bash

# Add Bun to PATH if not already in bashrc
if [ -f "$HOME/.bashrc" ]; then
  if ! grep -q 'BUN_INSTALL' "$HOME/.bashrc"; then
    echo "Adding Bun to PATH in ~/.bashrc..."
    cat >> "$HOME/.bashrc" << 'EOF'

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
EOF
    echo "Bun PATH added to ~/.bashrc"
  else
    echo "Bun PATH already in ~/.bashrc"
  fi
fi

# Load Bun for current session
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Verify installation
if command -v bun >/dev/null 2>&1; then
  BUN_VERSION=$(bun --version)
  echo
  echo "Installation complete!"
  echo "================================"
  echo "Bun version: v$BUN_VERSION"
  echo
  echo "Useful commands:"
  echo "  bun --version       - Show Bun version"
  echo "  bun install         - Install dependencies"
  echo "  bun run dev         - Run dev script"
  echo "  bun add <package>   - Add package"
  echo "  bun create <template> - Create new project"
  echo
  echo "Note: Restart your terminal or run 'source ~/.bashrc' to use Bun"
else
  echo "ERROR: Bun installation failed"
  exit 1
fi
