#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Rollback script error on line $LINENO" >&2; exit 1' ERR

MANIFEST="${1:-$HOME/.dotfiles_backups_latest.txt}"
if [ ! -f "$MANIFEST" ]; then
  # try to find the most recent manifest
  MANIFEST=$(ls -1t $HOME/.dotfiles_backups_* 2>/dev/null | head -n1 || true)
fi

if [ -z "$MANIFEST" ] || [ ! -f "$MANIFEST" ]; then
  echo "No backup manifest found. Nothing to rollback.";
  exit 1
fi

echo "Using manifest: $MANIFEST"

while IFS=: read -r key path; do
  case "$key" in
    bashrc)
      echo "Restoring ~/.bashrc from $path"
      if [ -f "$path" ]; then
        mv -v "$path" "$HOME/.bashrc"
      else
        echo "Backup $path not found; skipping"
      fi
      ;;
    nvim_config)
      echo "Restoring Neovim config from $path"
      if [ -d "$path" ]; then
        rm -rf "$HOME/.config/nvim"
        mv -v "$path" "$HOME/.config/nvim"
      else
        echo "Backup $path not found; skipping"
      fi
      ;;
    *)
      echo "Unknown manifest entry: $key:$path"
      ;;
  esac
done < "$MANIFEST"

echo "Rollback complete (manual verification recommended)."