#!/usr/bin/env bash
set -euo pipefail

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
echo "System update complete!"
