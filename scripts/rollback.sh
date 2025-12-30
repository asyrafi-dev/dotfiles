#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Rollback script error on line $LINENO" >&2; exit 1' ERR

echo "Dotfiles Rollback Script"
echo "========================"
echo

# Find the most recent manifest
MANIFEST="${1:-}"
if [ -z "$MANIFEST" ] || [ ! -f "$MANIFEST" ]; then
  echo "Searching for backup manifest..."
  newest=""
  for f in "$HOME"/.dotfiles_backups_*.txt; do
    [ -e "$f" ] || continue
    if [ -z "$newest" ] || [ "$f" -nt "$newest" ]; then
      newest="$f"
    fi
  done
  MANIFEST="${newest:-}"
fi

if [ -z "$MANIFEST" ] || [ ! -f "$MANIFEST" ]; then
  echo "❌ No backup manifest found. Nothing to rollback."
  echo
  echo "Backup manifests are created during installation in:"
  echo "  ~/.dotfiles_backups_*.txt"
  exit 1
fi

echo "Using manifest: $MANIFEST"
echo

# Show what will be rolled back
echo "Files to be restored:"
while IFS=: read -r key path; do
  if [ -f "$path" ] || [ -d "$path" ]; then
    echo "  ✓ $key → $path"
  else
    echo "  ✗ $key → $path (backup not found)"
  fi
done < "$MANIFEST"
echo

# Confirm rollback
read -rp "Proceed with rollback? [y/N] " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
  echo "Rollback cancelled."
  exit 0
fi

echo
echo "Rolling back..."

# Perform rollback
RESTORED=0
FAILED=0

while IFS=: read -r key path; do
  case "$key" in
    bashrc)
      if [ -f "$path" ]; then
        echo "→ Restoring ~/.bashrc"
        cp "$HOME/.bashrc" "$HOME/.bashrc.before_rollback" 2>/dev/null || true
        mv "$path" "$HOME/.bashrc"
        ((RESTORED++))
      else
        echo "✗ Backup not found: $path"
        ((FAILED++))
      fi
      ;;
    gitconfig)
      if [ -f "$path" ]; then
        echo "→ Restoring ~/.gitconfig"
        cp "$HOME/.gitconfig" "$HOME/.gitconfig.before_rollback" 2>/dev/null || true
        mv "$path" "$HOME/.gitconfig"
        ((RESTORED++))
      else
        echo "✗ Backup not found: $path"
        ((FAILED++))
      fi
      ;;
    tmux)
      if [ -f "$path" ]; then
        echo "→ Restoring ~/.tmux.conf"
        cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.before_rollback" 2>/dev/null || true
        mv "$path" "$HOME/.tmux.conf"
        ((RESTORED++))
      else
        echo "✗ Backup not found: $path"
        ((FAILED++))
      fi
      ;;
    nvim_config)
      if [ -d "$path" ]; then
        echo "→ Restoring ~/.config/nvim"
        if [ -d "$HOME/.config/nvim" ]; then
          mv "$HOME/.config/nvim" "$HOME/.config/nvim.before_rollback"
        fi
        mv "$path" "$HOME/.config/nvim"
        ((RESTORED++))
      else
        echo "✗ Backup not found: $path"
        ((FAILED++))
      fi
      ;;
    bash|git|tmux)
      # Handle stow-managed dotfiles
      if [ -f "$path" ]; then
        TARGET="$HOME/.$key"
        echo "→ Restoring $TARGET"
        cp "$TARGET" "${TARGET}.before_rollback" 2>/dev/null || true
        mv "$path" "$TARGET"
        ((RESTORED++))
      else
        echo "✗ Backup not found: $path"
        ((FAILED++))
      fi
      ;;
    *)
      echo "⚠ Unknown manifest entry: $key:$path"
      ;;
  esac
done < "$MANIFEST"

echo
echo "Rollback Summary"
echo "================"
echo "Restored: $RESTORED file(s)"
echo "Failed: $FAILED file(s)"
echo

if [ $FAILED -eq 0 ]; then
  echo "✅ Rollback completed successfully!"
  echo
  echo "Note: Current files backed up to *.before_rollback"
  echo "Reload your terminal: source ~/.bashrc"
else
  echo "⚠️  Rollback completed with $FAILED error(s)"
  echo "Please review the errors above."
fi