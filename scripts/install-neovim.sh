#!/usr/bin/env bash
set -e

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
nvim --version | head -n 2
