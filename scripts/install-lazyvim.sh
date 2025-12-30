#!/usr/bin/env bash
set -euo pipefail
trap 'echo "LazyVim installer error on line $LINENO" >&2; exit 1' ERR

NVIM="$HOME/.config/nvim"
BACKUP="$HOME/.config/nvim.bak.$(date +%s)"

if [ -d "$NVIM" ]; then
  echo "Backing up existing Neovim config to $BACKUP"
  mv "$NVIM" "$BACKUP"
fi

git clone https://github.com/LazyVim/starter "$NVIM"
rm -rf "$NVIM/.git"
