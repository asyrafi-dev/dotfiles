#!/usr/bin/env bash
set -e

cd /tmp
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

nvim --version | head -n 2
