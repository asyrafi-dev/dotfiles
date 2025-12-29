#!/usr/bin/env bash
set -e

chmod +x scripts/*.sh

bash scripts/preflight.sh

echo "Installing packages..."
sudo apt update
xargs -a packages/apt.txt sudo apt install -y

sudo ln -sf $(which fdfind) /usr/local/bin/fd

bash scripts/install-neovim.sh
bash scripts/install-nerd-fonts.sh
bash scripts/install-lazyvim.sh

echo "Applying dotfiles..."
stow -t ~ home/*

echo "INSTALL COMPLETE"
echo "Restart terminal → set Nerd Font → run: nvim"
