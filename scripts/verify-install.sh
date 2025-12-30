#!/usr/bin/env bash
set -euo pipefail

echo "Dotfiles Installation Verification"
echo "===================================="
echo

ERRORS=0
WARNINGS=0

check_command() {
  local cmd=$1
  local name=${2:-$cmd}
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "✓ $name installed"
    return 0
  else
    echo "✗ $name NOT found"
    ((ERRORS++))
    return 1
  fi
}

check_file() {
  local file=$1
  local name=${2:-$file}
  if [ -f "$file" ]; then
    echo "✓ $name exists"
    return 0
  else
    echo "✗ $name NOT found"
    ((ERRORS++))
    return 1
  fi
}

check_symlink() {
  local file=$1
  local name=${2:-$file}
  if [ -L "$file" ]; then
    echo "✓ $name is symlinked"
    return 0
  else
    echo "⚠ $name is NOT a symlink (might be regular file)"
    ((WARNINGS++))
    return 1
  fi
}

echo "[1] Checking Core Tools..."
check_command git "Git"
check_command nvim "Neovim"
check_command tmux "Tmux"
check_command fzf "FZF"
check_command rg "Ripgrep"
check_command fd "fd-find"
check_command stow "GNU Stow"
echo

echo "[2] Checking Neovim Version..."
if command -v nvim >/dev/null 2>&1; then
  nvim --version | head -n 1
else
  echo "✗ Neovim not installed"
  ((ERRORS++))
fi
echo

echo "[3] Checking Configuration Files..."
check_file "$HOME/.bashrc" "~/.bashrc"
check_file "$HOME/.gitconfig" "~/.gitconfig"
check_file "$HOME/.tmux.conf" "~/.tmux.conf"
check_file "$HOME/.config/nvim/init.lua" "~/.config/nvim/init.lua"
echo

echo "[4] Checking Symlinks (Stow)..."
check_symlink "$HOME/.bashrc" "~/.bashrc"
check_symlink "$HOME/.gitconfig" "~/.gitconfig"
check_symlink "$HOME/.tmux.conf" "~/.tmux.conf"
echo

echo "[5] Checking Fonts..."
FONT_DIR="$HOME/.local/share/fonts"
if [ -d "$FONT_DIR" ]; then
  FONT_COUNT=$(find "$FONT_DIR" -name "*.ttf" -o -name "*.otf" | wc -l)
  if [ "$FONT_COUNT" -gt 0 ]; then
    echo "✓ Found $FONT_COUNT font files in $FONT_DIR"
  else
    echo "⚠ No fonts found in $FONT_DIR"
    ((WARNINGS++))
  fi
else
  echo "✗ Font directory not found"
  ((ERRORS++))
fi
echo

echo "[6] Checking Git Configuration..."
GIT_NAME=$(git config user.name || echo "")
GIT_EMAIL=$(git config user.email || echo "")
if [ "$GIT_NAME" = "Your Name" ] || [ -z "$GIT_NAME" ]; then
  echo "⚠ Git user.name not configured (still default)"
  ((WARNINGS++))
else
  echo "✓ Git user.name: $GIT_NAME"
fi
if [ "$GIT_EMAIL" = "you@email.com" ] || [ -z "$GIT_EMAIL" ]; then
  echo "⚠ Git user.email not configured (still default)"
  ((WARNINGS++))
else
  echo "✓ Git user.email: $GIT_EMAIL"
fi
echo

echo
echo "Verification Summary"
echo "===================="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo "All checks passed. Installation successful."
  exit 0
elif [ $ERRORS -eq 0 ]; then
  echo "Installation complete with $WARNINGS warning(s)."
  echo "Please review warnings above."
  exit 0
else
  echo "Installation incomplete: $ERRORS error(s), $WARNINGS warning(s)"
  echo "Please review errors above and re-run installer."
  exit 1
fi
