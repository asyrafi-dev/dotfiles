#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Uninstall error on line $LINENO" >&2; exit 1' ERR

echo "Dotfiles Uninstaller"
echo "===================="
echo
echo "This will remove dotfiles configurations from your system."
echo "Your original files will be restored from backups if available."
echo

# Confirm uninstall
read -rp "Are you sure you want to uninstall? [y/N] " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
  echo "Uninstall cancelled."
  exit 0
fi

echo
echo "Starting uninstall..."

# 1. Remove stow symlinks
echo "[1/6] Removing symlinks..."
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
if [ -d "$DOTFILES_DIR/home" ]; then
  cd "$DOTFILES_DIR/home"
  for dir in */; do
    [ -d "$dir" ] || continue
    stow -D -t ~ "${dir%/}" 2>/dev/null || true
  done
  echo "✓ Symlinks removed"
else
  echo "⚠ Dotfiles directory not found, skipping symlink removal"
fi

# 2. Restore backups
echo "[2/6] Restoring backups..."
RESTORED=0
for backup in "$HOME"/.bashrc.bak.* "$HOME"/.gitconfig.bak.* "$HOME"/.tmux.conf.bak.*; do
  [ -f "$backup" ] || continue
  original="${backup%.bak.*}"
  if [ ! -f "$original" ] || [ -L "$original" ]; then
    echo "  → Restoring $(basename "$original")"
    rm -f "$original"
    mv "$backup" "$original"
    ((RESTORED++))
  fi
done
if [ $RESTORED -gt 0 ]; then
  echo "✓ Restored $RESTORED backup(s)"
else
  echo "ℹ No backups to restore"
fi

# 3. Remove LazyVim config (optional)
echo "[3/6] Checking Neovim config..."
if [ -d "$HOME/.config/nvim" ]; then
  read -rp "Remove LazyVim configuration? [y/N] " remove_nvim
  if [[ $remove_nvim =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.config/nvim"
    rm -rf "$HOME/.local/share/nvim"
    rm -rf "$HOME/.local/state/nvim"
    rm -rf "$HOME/.cache/nvim"
    echo "✓ Neovim config removed"
  else
    echo "ℹ Neovim config kept"
  fi
fi

# 4. Remove NVM (optional)
echo "[4/6] Checking NVM..."
if [ -d "$HOME/.nvm" ]; then
  read -rp "Remove NVM and Node.js? [y/N] " remove_nvm
  if [[ $remove_nvm =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.nvm"
    echo "✓ NVM removed"
  else
    echo "ℹ NVM kept"
  fi
fi

# 5. Remove Bun (optional)
echo "[5/6] Checking Bun..."
if [ -d "$HOME/.bun" ]; then
  read -rp "Remove Bun? [y/N] " remove_bun
  if [[ $remove_bun =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.bun"
    echo "✓ Bun removed"
  else
    echo "ℹ Bun kept"
  fi
fi

# 6. Remove Kitty (optional)
echo "[6/6] Checking Kitty..."
if [ -d "$HOME/.local/kitty.app" ]; then
  read -rp "Remove Kitty terminal? [y/N] " remove_kitty
  if [[ $remove_kitty =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.local/kitty.app"
    rm -f "$HOME/.local/share/applications/kitty.desktop"
    sudo rm -f /usr/local/bin/kitty
    echo "✓ Kitty removed"
  else
    echo "ℹ Kitty kept"
  fi
fi

# Clean up backup manifests
echo
read -rp "Remove backup manifests? [y/N] " remove_manifests
if [[ $remove_manifests =~ ^[Yy]$ ]]; then
  rm -f "$HOME"/.dotfiles_backups_*.txt
  echo "✓ Backup manifests removed"
fi

echo
echo "Uninstall Complete!"
echo "==================="
echo
echo "The following were NOT removed (manual removal required):"
echo "  - System packages installed via apt"
echo "  - Neovim AppImage (/usr/local/bin/nvim)"
echo "  - LazyGit (/usr/local/bin/lazygit)"
echo "  - Nerd Fonts (~/.local/share/fonts)"
echo
echo "To remove Neovim: sudo rm /usr/local/bin/nvim"
echo "To remove LazyGit: sudo rm /usr/local/bin/lazygit"
echo "To remove fonts: rm -rf ~/.local/share/fonts && fc-cache -fv"
echo
echo "Restart your terminal to apply changes."
