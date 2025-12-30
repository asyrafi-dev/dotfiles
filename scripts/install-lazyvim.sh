#!/usr/bin/env bash
set -e

NVIM="$HOME/.config/nvim"
BACKUP="$HOME/.config/nvim.bak.$(date +%s)"

[ -d "$NVIM" ] && mv "$NVIM" "$BACKUP"
git clone https://github.com/LazyVim/starter "$NVIM"
rm -rf "$NVIM/.git"
