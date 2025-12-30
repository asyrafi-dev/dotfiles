#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Python packages installer error on line $LINENO" >&2; exit 1' ERR

ASSUME_YES=${ASSUME_YES:-0}
DRY_RUN=${DRY_RUN:-0}
CI=${CI:-}

echo "[python] Installing Python packages for Neovim"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would install pynvim"
  exit 0
fi

# Check if pip3 is available
if ! command -v pip3 >/dev/null 2>&1; then
  echo "ERROR: pip3 not found. Please install python3-pip first."
  exit 1
fi

# Install pynvim (Python support for Neovim)
echo "Installing pynvim..."
if [ -n "${CI:-}" ]; then
  # In CI, use --break-system-packages flag
  pip3 install pynvim --break-system-packages
else
  # Try normal install first, fallback to --break-system-packages if needed
  if ! pip3 install pynvim 2>/dev/null; then
    echo "Normal pip install failed, using --break-system-packages..."
    pip3 install pynvim --break-system-packages
  fi
fi

# Verify installation
if python3 -c "import pynvim" 2>/dev/null; then
  echo "pynvim installed successfully"
else
  echo "WARNING: pynvim installation may have issues"
fi

echo
echo "Python packages installation complete!"
echo "================================"
echo "pynvim: installed"
