#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Neovim installer error on line $LINENO" >&2; exit 1' ERR

ASSUME_YES=${ASSUME_YES:-0}
DRY_RUN=${DRY_RUN:-0}

if command -v nvim >/dev/null 2>&1; then
  echo "Neovim already installed; skipping."
  nvim --version | head -n 2 || true
  exit 0
fi

echo "[neovim] Target: /usr/local/bin/nvim"
if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would download Neovim AppImage to /tmp and move to /usr/local/bin/nvim"
  echo "DRY-RUN: curl -L -o /tmp/nvim-linux-x86_64.appimage https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.appimage"
  echo "DRY-RUN: chmod +x /tmp/nvim-linux-x86_64.appimage"
  echo "DRY-RUN: sudo mv /tmp/nvim-linux-x86_64.appimage /usr/local/bin/nvim"
  exit 0
fi

cd /tmp

# Ensure downloader available
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
  echo "ERROR: curl or wget is required to download Neovim. Please install them and retry." >&2
  exit 1
fi

NEOVIM_URL="https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.appimage"
TMPFILE="/tmp/nvim-linux-x86_64.appimage"

echo "Downloading Neovim AppImage..."
if command -v curl >/dev/null 2>&1; then
  curl -fL -o "$TMPFILE" "$NEOVIM_URL"
else
  wget -qO "$TMPFILE" "$NEOVIM_URL"
fi
chmod +x "$TMPFILE"

# Optional checksum verification
if [ -n "${NEOVIM_SHA256:-}" ]; then
  if command -v sha256sum >/dev/null 2>&1; then
    echo "Verifying Neovim checksum..."
    calc=$(sha256sum "$TMPFILE" | awk '{print $1}')
    if [ "$calc" != "$NEOVIM_SHA256" ]; then
      echo "ERROR: Neovim checksum mismatch (expected $NEOVIM_SHA256, got $calc)" >&2
      exit 1
    else
      echo "Checksum verification passed."
    fi
  else
    echo "WARNING: sha256sum not available; skipping checksum verification." >&2
  fi
else
  echo "WARNING: NEOVIM_SHA256 not set; skipping checksum verification." >&2
fi

# Move to /usr/local/bin
sudo mv "$TMPFILE" /usr/local/bin/nvim

# Verify
if command -v nvim >/dev/null 2>&1; then
  echo "Neovim installed successfully!"
  nvim --version | head -n 2
else
  echo "Neovim installation failed." >&2
  exit 1
fi
