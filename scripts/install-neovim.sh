#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Neovim installer error on line $LINENO" >&2; exit 1' ERR

if command -v nvim >/dev/null 2>&1; then
  echo "Neovim already installed; skipping." 
  nvim --version | head -n 2 || true
  exit 0
fi

cd /tmp

# Download Neovim AppImage v0.11.5
echo "Downloading Neovim v0.11.5..."
curl -LO https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.appimage

# Beri permission executable
chmod +x nvim-linux-x86_64.appimage

# Pindahkan ke /usr/local/bin
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim

# Verifikasi instalasi
echo "Neovim installed successfully!"
if command -v nvim >/dev/null 2>&1; then
  nvim --version | head -n 2
fi
