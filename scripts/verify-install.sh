#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Verification error on line $LINENO" >&2; exit 1' ERR

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
check_command lazygit "LazyGit"
check_command kitty "Kitty Terminal"
echo

echo "[2] Checking Neovim Version..."
if command -v nvim >/dev/null 2>&1; then
  NVIM_VERSION=$(nvim --version | head -n 1)
  echo "$NVIM_VERSION"
  
  # Check if Neovim is built with LuaJIT
  if nvim --version | grep -q "LuaJIT"; then
    echo "✓ Neovim built with LuaJIT (required by LazyVim)"
  else
    echo "⚠ Neovim not built with LuaJIT"
    ((WARNINGS++))
  fi
else
  echo "✗ Neovim not installed"
  ((ERRORS++))
fi
echo

echo "[3] Checking LazyVim Requirements..."
# Check tree-sitter
if command -v tree-sitter >/dev/null 2>&1; then
  echo "✓ tree-sitter installed: $(tree-sitter --version)"
else
  echo "⚠ tree-sitter not found (required for syntax highlighting)"
  ((WARNINGS++))
fi

# Check C compiler
if command -v gcc >/dev/null 2>&1; then
  echo "✓ gcc installed: $(gcc --version | head -n 1)"
else
  echo "⚠ gcc not found (required for tree-sitter compilation)"
  ((WARNINGS++))
fi

# Check Python packages
if python3 -c "import pynvim" 2>/dev/null; then
  echo "✓ pynvim installed"
else
  echo "⚠ pynvim not found (required for Python plugins)"
  ((WARNINGS++))
fi

# Check luarocks
if command -v luarocks >/dev/null 2>&1; then
  echo "✓ luarocks installed: $(luarocks --version | head -n 1)"
else
  echo "⚠ luarocks not found (required for Lua plugins)"
  ((WARNINGS++))
fi

# Check imagemagick
if command -v convert >/dev/null 2>&1; then
  echo "✓ imagemagick installed"
else
  echo "⚠ imagemagick not found (required for image processing)"
  ((WARNINGS++))
fi

# Check sqlite3
if command -v sqlite3 >/dev/null 2>&1; then
  echo "✓ sqlite3 installed: $(sqlite3 --version)"
else
  echo "⚠ sqlite3 not found (required for some plugins)"
  ((WARNINGS++))
fi

# Check mermaid-cli
if command -v mmdc >/dev/null 2>&1; then
  echo "✓ mermaid-cli installed"
else
  echo "⚠ mermaid-cli not found (required for diagram rendering)"
  ((WARNINGS++))
fi

# Check neovim npm package
if npm list -g neovim >/dev/null 2>&1; then
  echo "✓ neovim (npm) installed"
else
  echo "⚠ neovim npm package not found (required for Node.js support)"
  ((WARNINGS++))
fi

# Check clipboard tools
if command -v xclip >/dev/null 2>&1 || command -v xsel >/dev/null 2>&1; then
  echo "✓ Clipboard tools available"
else
  echo "⚠ No clipboard tools found (xclip/xsel recommended)"
  ((WARNINGS++))
fi
echo

echo "[4] Checking Kitty Terminal..."
if command -v kitty >/dev/null 2>&1; then
  KITTY_VERSION=$(kitty --version 2>/dev/null | awk '{print $2}' || echo "unknown")
  echo "✓ Kitty installed: v$KITTY_VERSION"
  
  # Check if Kitty supports true color
  if [ -n "$TERM" ] && [[ "$TERM" == *"kitty"* ]]; then
    echo "✓ Running in Kitty terminal"
  else
    echo "ℹ Not currently running in Kitty (recommended for LazyVim)"
  fi
else
  echo "⚠ Kitty not installed (recommended terminal for LazyVim)"
  ((WARNINGS++))
fi
echo

echo "[5] Checking Configuration Files..."
check_file "$HOME/.bashrc" "~/.bashrc"
check_file "$HOME/.gitconfig" "~/.gitconfig"
check_file "$HOME/.tmux.conf" "~/.tmux.conf"
check_file "$HOME/.config/nvim/init.lua" "~/.config/nvim/init.lua"
check_file "$HOME/.config/kitty/kitty.conf" "~/.config/kitty/kitty.conf"
echo

echo "[6] Checking Symlinks (Stow)..."
check_symlink "$HOME/.bashrc" "~/.bashrc"
check_symlink "$HOME/.gitconfig" "~/.gitconfig"
check_symlink "$HOME/.tmux.conf" "~/.tmux.conf"
echo

echo "[7] Checking Fonts..."
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

echo "[8] Checking Git Configuration..."
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

echo "[9] Checking Node.js and NVM..."
if [ -d "$HOME/.nvm" ]; then
  echo "✓ NVM directory exists"
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  
  if command -v nvm >/dev/null 2>&1; then
    NVM_VERSION=$(nvm --version 2>/dev/null || echo "unknown")
    echo "✓ NVM installed: v$NVM_VERSION"
  else
    echo "⚠ NVM command not available (may need to reload shell)"
    ((WARNINGS++))
  fi
  
  if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node -v)
    NPM_VERSION=$(npm -v)
    echo "✓ Node.js installed: $NODE_VERSION"
    echo "✓ npm installed: v$NPM_VERSION"
    
    # Check if it's the default version (24)
    NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d'.' -f1 | sed 's/v//')
    if [ "$NODE_MAJOR" = "24" ]; then
      echo "✓ Using Node.js 24 (default)"
    else
      echo "ℹ Using Node.js $NODE_MAJOR"
    fi
  else
    echo "⚠ Node.js not found (may need to reload shell)"
    ((WARNINGS++))
  fi
else
  echo "✗ NVM not installed"
  ((ERRORS++))
fi
echo

echo "[10] Checking Bun..."
if [ -d "$HOME/.bun" ]; then
  echo "✓ Bun directory exists"
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  
  if command -v bun >/dev/null 2>&1; then
    BUN_VERSION=$(bun --version)
    echo "✓ Bun installed: v$BUN_VERSION"
  else
    echo "⚠ Bun command not available (may need to reload shell)"
    ((WARNINGS++))
  fi
else
  echo "⚠ Bun not installed"
  ((WARNINGS++))
fi
echo

echo "[11] Checking PHP..."
if command -v php >/dev/null 2>&1; then
  PHP_VERSION=$(php -v | head -n 1 | awk '{print $2}')
  echo "✓ PHP installed: v$PHP_VERSION"
  
  # Check Composer
  if command -v composer >/dev/null 2>&1; then
    COMPOSER_VERSION=$(composer --version 2>/dev/null | awk '{print $3}')
    echo "✓ Composer installed: v$COMPOSER_VERSION"
  else
    echo "⚠ Composer not found"
    ((WARNINGS++))
  fi
else
  echo "⚠ PHP not installed"
  ((WARNINGS++))
fi
echo

echo "[12] Checking Podman..."
if command -v podman >/dev/null 2>&1; then
  PODMAN_VERSION=$(podman --version | awk '{print $3}')
  echo "✓ Podman installed: v$PODMAN_VERSION"
  
  # Check podman-compose
  if command -v podman-compose >/dev/null 2>&1; then
    echo "✓ podman-compose installed"
  else
    echo "⚠ podman-compose not found"
    ((WARNINGS++))
  fi
else
  echo "⚠ Podman not installed"
  ((WARNINGS++))
fi

# Check kubectl
if command -v kubectl >/dev/null 2>&1; then
  KUBECTL_VERSION=$(kubectl version --client -o yaml 2>/dev/null | grep gitVersion | awk '{print $2}' || echo "installed")
  echo "✓ kubectl installed: $KUBECTL_VERSION"
else
  echo "⚠ kubectl not found"
  ((WARNINGS++))
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
