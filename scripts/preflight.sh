#!/usr/bin/env bash
set -e

echo "[+] Running pre-installation checks..."

# 1. Check for internet connection
echo "  -> Checking internet connectivity..."
if ! ping -c 1 1.1.1.1 >/dev/null 2>&1 && ! curl -s --head http://www.google.com/ >/dev/null 2>&1; then
  echo "     ERROR: No internet connection detected. Please check your network."
  exit 1
fi

# 2. Check if running on an Ubuntu-based system
echo "  -> Verifying operating system compatibility..."
if ! lsb_release -si | grep -qi ubuntu; then
  echo "     ERROR: This script is intended for Ubuntu-based systems only."
  exit 1
fi

# 3. Acquire and keep-alive sudo permissions
echo "  -> Acquiring administrator (sudo) permissions..."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# 4. Attempt to load the FUSE kernel module for AppImage support
echo "  -> Checking for FUSE kernel module..."
if ! sudo modprobe fuse; then
  echo "     WARNING: FUSE kernel module could not be loaded. AppImages may not function correctly."
fi

echo "[+] Pre-installation checks passed successfully."
echo
