#!/usr/bin/env bash
set -euo pipefail
trap 'echo "LazyGit installer error on line $LINENO" >&2; exit 1' ERR

ASSUME_YES=${ASSUME_YES:-0}
DRY_RUN=${DRY_RUN:-0}
CI=${CI:-}

echo "[lazygit] Installing LazyGit"

# Check if lazygit already installed
if command -v lazygit >/dev/null 2>&1; then
  CURRENT_VERSION=$(lazygit --version | head -n 1 | awk '{print $NF}' | sed 's/version=//')
  echo "LazyGit already installed: $CURRENT_VERSION"
  
  if [ "${ASSUME_YES:-0}" -eq 0 ] && [ -z "${CI:-}" ]; then
    read -rp "Do you want to reinstall/update LazyGit? [y/N] " reinstall
    if [[ ! $reinstall =~ ^[Yy]$ ]]; then
      echo "Skipping LazyGit installation."
      exit 0
    fi
  else
    echo "LazyGit already installed, skipping."
    exit 0
  fi
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would install LazyGit from GitHub releases"
  exit 0
fi

# Get latest version from GitHub
echo "Fetching latest LazyGit version..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

if [ -z "$LAZYGIT_VERSION" ]; then
  echo "ERROR: Could not fetch LazyGit version"
  exit 1
fi

echo "Installing LazyGit v$LAZYGIT_VERSION..."

# Download and install
cd /tmp
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -f lazygit lazygit.tar.gz

# Verify installation
if command -v lazygit >/dev/null 2>&1; then
  INSTALLED_VERSION=$(lazygit --version | head -n 1 | awk '{print $NF}' | sed 's/version=//')
  echo
  echo "Installation complete!"
  echo "================================"
  echo "LazyGit version: $INSTALLED_VERSION"
  echo
  echo "Usage:"
  echo "  lazygit              - Launch LazyGit in current repo"
  echo "  lazygit --version    - Show version"
  echo
  echo "Keybindings:"
  echo "  ?                    - Show help"
  echo "  q                    - Quit"
  echo "  Enter                - Confirm/Open"
else
  echo "ERROR: LazyGit installation failed"
  exit 1
fi
