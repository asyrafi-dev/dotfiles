#!/usr/bin/env bash
set -euo pipefail
trap 'echo "LazyVim installer error on line $LINENO" >&2; exit 1' ERR

ASSUME_YES=${ASSUME_YES:-0}
DRY_RUN=${DRY_RUN:-0}

NVIM="$HOME/.config/nvim"
BACKUP="$HOME/.config/nvim.bak.$(date +%s)"

if [ -d "$NVIM" ]; then
  echo "Backing up existing Neovim config to $BACKUP"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "DRY-RUN: would mv $NVIM $BACKUP"
  else
    mv "$NVIM" "$BACKUP"
    # record backup for possible rollback
    if [ -n "${BACKUP_MANIFEST:-}" ]; then
      echo "nvim_config:$BACKUP" >> "$BACKUP_MANIFEST"
    fi
  fi
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would git clone https://github.com/LazyVim/starter $NVIM"
  exit 0
fi

git clone https://github.com/LazyVim/starter "$NVIM"
rm -rf "$NVIM/.git"
