#!/usr/bin/env bash
set -euo pipefail
trap 'echo "MariaDB installer error on line $LINENO" >&2; exit 1' ERR

ASSUME_YES=${ASSUME_YES:-0}
DRY_RUN=${DRY_RUN:-0}
CI=${CI:-}

MARIADB_VERSION="11.4"

echo "[mariadb] Installing MariaDB $MARIADB_VERSION LTS"

# Check if MariaDB already installed
if command -v mariadb >/dev/null 2>&1; then
  CURRENT_VERSION=$(mariadb --version | awk '{print $5}' | cut -d'-' -f1)
  echo "MariaDB already installed: v$CURRENT_VERSION"
  
  if [ "${ASSUME_YES:-0}" -eq 0 ] && [ -z "${CI:-}" ]; then
    read -rp "Do you want to reinstall/update MariaDB? [y/N] " reinstall
    if [[ ! $reinstall =~ ^[Yy]$ ]]; then
      echo "Skipping MariaDB installation."
      exit 0
    fi
  else
    echo "MariaDB already installed, skipping."
    exit 0
  fi
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would add MariaDB repository"
  echo "DRY-RUN: would install MariaDB $MARIADB_VERSION"
  echo "DRY-RUN: would enable and start MariaDB service"
  exit 0
fi

# Install prerequisites
echo "Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y apt-transport-https curl software-properties-common

# Add MariaDB repository
echo "Adding MariaDB repository..."
sudo mkdir -p /etc/apt/keyrings

# Download signing key from official source
echo "Downloading MariaDB signing key..."
sudo curl -fsSL https://mariadb.org/mariadb_release_signing_key.pgp | sudo gpg --dearmor -o /etc/apt/keyrings/mariadb-keyring.gpg 2>/dev/null || true

# Use Indonesia mirror (Nevacloud) with fallback to official
# Nevacloud is official MariaDB mirror in Indonesia
MIRROR_URL="https://mirror.nevacloud.com/mariadb/repo/$MARIADB_VERSION/ubuntu"
FALLBACK_URL="https://deb.mariadb.org/$MARIADB_VERSION/ubuntu"

echo "Testing mirror availability..."
if curl -fsSL --connect-timeout 5 "$MIRROR_URL/dists/noble/Release" >/dev/null 2>&1; then
  echo "Using Indonesia mirror (Nevacloud)..."
  REPO_URL="$MIRROR_URL"
else
  echo "Indonesia mirror not available, using official MariaDB repository..."
  REPO_URL="$FALLBACK_URL"
fi

echo "deb [signed-by=/etc/apt/keyrings/mariadb-keyring.gpg] $REPO_URL noble main" | sudo tee /etc/apt/sources.list.d/mariadb.list > /dev/null

# Update and install
echo "Installing MariaDB server..."
sudo apt-get update
sudo apt-get install -y mariadb-server mariadb-client

# Enable and start service (skip in CI)
if [ -z "${CI:-}" ]; then
  echo "Enabling MariaDB service..."
  sudo systemctl enable mariadb
  sudo systemctl start mariadb
fi

# Verify installation
echo
echo "Installation complete!"
echo "================================"

if command -v mariadb >/dev/null 2>&1; then
  MARIADB_VERSION_INSTALLED=$(mariadb --version | awk '{print $5}' | cut -d'-' -f1)
  echo "MariaDB version: v$MARIADB_VERSION_INSTALLED"
fi

echo
echo "MariaDB commands:"
echo "  sudo mariadb                  - Connect as root"
echo "  sudo mariadb-secure-installation  - Secure installation"
echo "  sudo systemctl status mariadb - Check service status"
echo "  sudo systemctl restart mariadb - Restart service"
echo
echo "Create database and user:"
echo "  sudo mariadb -e \"CREATE DATABASE mydb;\""
echo "  sudo mariadb -e \"CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';\""
echo "  sudo mariadb -e \"GRANT ALL ON mydb.* TO 'user'@'localhost';\""
echo
echo "Note: Run 'sudo mariadb-secure-installation' to secure your installation"
