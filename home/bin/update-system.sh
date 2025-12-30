#!/usr/bin/env bash
set -euo pipefail

echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean

# Update Neovim plugins if nvim is installed
if command -v nvim >/dev/null 2>&1; then
  echo "Updating Neovim plugins..."
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
fi

# Update npm global packages if npm is installed
if command -v npm >/dev/null 2>&1; then
  echo "Updating npm global packages..."
  npm update -g 2>/dev/null || true
fi

# Update Bun if installed
if command -v bun >/dev/null 2>&1; then
  echo "Updating Bun..."
  bun upgrade 2>/dev/null || true
fi

echo
echo "System update complete!"
echo "Run 'source ~/.bashrc' to reload shell configuration."
