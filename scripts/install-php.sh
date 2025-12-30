#!/usr/bin/env bash
set -euo pipefail
trap 'echo "PHP installer error on line $LINENO" >&2; exit 1' ERR

ASSUME_YES=${ASSUME_YES:-0}
DRY_RUN=${DRY_RUN:-0}
CI=${CI:-}

PHP_VERSION="8.4"

echo "[php] Installing PHP $PHP_VERSION"

# Check if PHP already installed
if command -v php >/dev/null 2>&1; then
  CURRENT_VERSION=$(php -v | head -n 1 | awk '{print $2}')
  echo "PHP already installed: v$CURRENT_VERSION"
  
  if [ "${ASSUME_YES:-0}" -eq 0 ] && [ -z "${CI:-}" ]; then
    read -rp "Do you want to reinstall/update PHP? [y/N] " reinstall
    if [[ ! $reinstall =~ ^[Yy]$ ]]; then
      echo "Skipping PHP installation."
      exit 0
    fi
  else
    echo "PHP already installed, skipping."
    exit 0
  fi
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: would add ondrej/php PPA"
  echo "DRY-RUN: would install PHP $PHP_VERSION"
  echo "DRY-RUN: would install common PHP extensions"
  exit 0
fi

# Install software-properties-common if not available
if ! command -v add-apt-repository >/dev/null 2>&1; then
  echo "Installing software-properties-common..."
  sudo apt-get update
  sudo apt-get install -y software-properties-common
fi

# Add ondrej/php PPA
echo "Adding ondrej/php repository..."
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install PHP and common extensions
echo "Installing PHP $PHP_VERSION..."
sudo apt-get install -y \
  php${PHP_VERSION} \
  php${PHP_VERSION}-cli \
  php${PHP_VERSION}-common \
  php${PHP_VERSION}-curl \
  php${PHP_VERSION}-mbstring \
  php${PHP_VERSION}-xml \
  php${PHP_VERSION}-zip \
  php${PHP_VERSION}-mysql \
  php${PHP_VERSION}-pgsql \
  php${PHP_VERSION}-sqlite3 \
  php${PHP_VERSION}-gd \
  php${PHP_VERSION}-intl \
  php${PHP_VERSION}-bcmath \
  php${PHP_VERSION}-opcache

# Install Composer if not installed
if ! command -v composer >/dev/null 2>&1; then
  echo "Installing Composer..."
  cd /tmp
  
  # Download installer
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  
  # Get expected hash from Composer website
  EXPECTED_HASH=$(curl -sS https://composer.github.io/installer.sig)
  ACTUAL_HASH=$(php -r "echo hash_file('sha384', 'composer-setup.php');")
  
  # Verify hash
  if [ "$EXPECTED_HASH" = "$ACTUAL_HASH" ]; then
    echo "Installer verified"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/local/bin/composer
    sudo chmod +x /usr/local/bin/composer
  else
    echo "ERROR: Composer installer corrupt (hash mismatch)"
    php -r "unlink('composer-setup.php');"
    exit 1
  fi
fi

# Verify installation
if command -v php >/dev/null 2>&1; then
  INSTALLED_VERSION=$(php -v | head -n 1)
  echo
  echo "Installation complete!"
  echo "================================"
  echo "$INSTALLED_VERSION"
  if command -v composer >/dev/null 2>&1; then
    echo "Composer: $(composer --version 2>/dev/null | head -n 1)"
  fi
  echo
  echo "Installed extensions:"
  php -m | grep -E "^(curl|mbstring|xml|zip|mysql|pgsql|sqlite|gd|intl|bcmath|opcache)$" | sort
  echo
  echo "Useful commands:"
  echo "  php -v                  - Show PHP version"
  echo "  php -m                  - List installed modules"
  echo "  composer --version      - Show Composer version"
  echo "  composer init           - Create new project"
  echo "  composer install        - Install dependencies"
  echo
  echo "Configuration files:"
  echo "  /etc/php/${PHP_VERSION}/cli/php.ini"
else
  echo "ERROR: PHP installation failed"
  exit 1
fi
