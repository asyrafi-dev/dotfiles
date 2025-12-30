#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Preflight error on line $LINENO" >&2; exit 1' ERR

ASSUME_YES=${ASSUME_YES:-0}
DRY_RUN=${DRY_RUN:-0}
CI=${CI:-}

echo "[+] Running pre-installation checks..."

# 1. Check for internet connection
echo "  -> Checking internet connectivity..."
if ! ping -c 1 1.1.1.1 >/dev/null 2>&1 && ! curl -s --head http://www.google.com/ >/dev/null 2>&1; then
  echo "     ERROR: No internet connection detected. Please check your network."
  exit 1
fi

# 2. Check package manager (apt)
echo "  -> Verifying package manager (apt) is available..."
if ! command -v apt-get >/dev/null 2>&1; then
  echo "     ERROR: apt-get not found. This installer supports apt-based systems only." >&2
  exit 1
fi

# 3. Acquire and keep-alive sudo permissions
echo "  -> Acquiring administrator (sudo) permissions..."
if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would acquire sudo credentials"
else
  sudo -v
  ( while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done ) 2>/dev/null &
  SUDO_PID=$!
  trap 'kill "${SUDO_PID}" >/dev/null 2>&1 || true' EXIT
fi

# 4. Attempt to load the FUSE kernel module for AppImage support
echo "  -> Checking for FUSE kernel module..."
if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would try to load fuse module"
else
  if ! sudo modprobe fuse; then
    echo "     WARNING: FUSE kernel module could not be loaded. AppImages may not function correctly."
  fi
fi

# 5. Check for required commands and optionally install
echo "  -> Checking required commands..."
declare -A PKG_MAP=( ["git"]="git" ["stow"]="stow" ["curl"]="curl" ["wget"]="wget" ["unzip"]="unzip" ["fc-cache"]="fontconfig" )
MISSING=()
for cmd in "${!PKG_MAP[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    MISSING+=("${PKG_MAP[$cmd]}")
  fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "     The following packages are missing: ${MISSING[*]}"
  echo "     You can install them with: sudo apt-get install -y ${MISSING[*]}"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "DRY-RUN: would install missing packages: ${MISSING[*]}"
  else
    if [ "$ASSUME_YES" -eq 1 ] || [ -n "$CI" ]; then
      echo "Installing missing packages: ${MISSING[*]}"
      sudo apt-get update
      sudo apt-get install -y "${MISSING[@]}"
    else
      read -rp "Install missing packages now? [y/N] " resp
      if [[ $resp =~ ^[Yy]$ ]]; then
        sudo apt-get update
        sudo apt-get install -y "${MISSING[@]}"
      else
        echo "Please install the required packages and re-run the installer."
        exit 1
      fi
    fi
  fi
fi

echo "[+] Pre-installation checks passed successfully."
echo
