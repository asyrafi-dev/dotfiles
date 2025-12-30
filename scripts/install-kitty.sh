#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Kitty installer error on line $LINENO" >&2; exit 1' ERR

ASSUME_YES=${ASSUME_YES:-0}
DRY_RUN=${DRY_RUN:-0}
CI=${CI:-}

echo "[kitty] Installing Kitty Terminal"

# Check if Kitty already installed
if command -v kitty >/dev/null 2>&1; then
  CURRENT_VERSION=$(kitty --version | awk '{print $2}')
  echo "Kitty already installed: v$CURRENT_VERSION"
  
  if [ "${ASSUME_YES:-0}" -eq 0 ] && [ -z "${CI:-}" ]; then
    read -rp "Do you want to reinstall/update Kitty? [y/N] " reinstall
    if [[ ! $reinstall =~ ^[Yy]$ ]]; then
      echo "Skipping Kitty installation."
      exit 0
    fi
  else
    echo "Kitty already installed, skipping."
    exit 0
  fi
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would install Kitty terminal"
  echo "DRY-RUN: would create desktop entry"
  echo "DRY-RUN: would set Kitty as default terminal (optional)"
  exit 0
fi

# Install Kitty using official installer
echo "Installing Kitty terminal..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Create symbolic link for easy access
echo "Creating symbolic link..."
sudo ln -sf ~/.local/kitty.app/bin/kitty /usr/local/bin/kitty

# Create desktop entry
echo "Creating desktop entry..."
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/kitty.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Kitty
GenericName=Terminal emulator
Comment=Fast, feature-rich, GPU based terminal
TryExec=kitty
Exec=kitty
Icon=kitty
Categories=System;TerminalEmulator;
EOF

# Copy Kitty icon
if [ -f ~/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png ]; then
  mkdir -p ~/.local/share/icons/hicolor/256x256/apps
  cp ~/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png \
     ~/.local/share/icons/hicolor/256x256/apps/
fi

# Update desktop database
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database ~/.local/share/applications
fi

# Verify installation
if command -v kitty >/dev/null 2>&1; then
  KITTY_VERSION=$(kitty --version | awk '{print $2}')
  echo
  echo "Installation complete!"
  echo "================================"
  echo "Kitty version: v$KITTY_VERSION"
  echo
  echo "Features:"
  echo "  ✓ GPU-accelerated rendering"
  echo "  ✓ True color support"
  echo "  ✓ Ligature support for Nerd Fonts"
  echo "  ✓ Image display in terminal"
  echo "  ✓ Split windows and tabs"
  echo
  echo "Usage:"
  echo "  kitty                    - Launch Kitty terminal"
  echo "  kitty --config NONE      - Launch without config"
  echo "  Ctrl+Shift+Enter         - New window"
  echo "  Ctrl+Shift+T             - New tab"
  echo
  echo "Configuration: ~/.config/kitty/kitty.conf"
  echo
  echo "Note: Kitty is recommended for LazyVim to avoid display issues"
else
  echo "ERROR: Kitty installation failed"
  exit 1
fi
