#!/usr/bin/env bash
set -e

echo "[+] Starting Dotfiles Installation..."
echo

# Ensure all scripts in the scripts/ directory are executable
chmod +x scripts/*.sh >/dev/null 2>&1

# Run all pre-installation checks
bash scripts/preflight.sh

# --- System Package Installation ---
echo "[+] Installing system dependencies..."
echo "  -> Updating package lists (apt-get update)..."
sudo apt-get update

echo "  -> Installing packages from 'packages/apt.txt'..."
grep -vE '^\s*#|^\s*$' packages/apt.txt | xargs sudo apt-get install -y --no-install-recommends

# --- Post-installation Setup ---
echo "[+] Performing post-installation setup..."

# Link fd-find to fd if it exists
if command -v fdfind &> /dev/null; then
    echo "  -> Linking 'fdfind' to 'fd'..."
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
fi

# Run individual component installers
bash scripts/install-neovim.sh
bash scripts/install-nerd-fonts.sh
bash scripts/install-lazyvim.sh

# Apply dotfiles configuration using Stow
echo "  -> Applying configuration files with Stow..."
# Remove potentially conflicting files before stowing
rm -f ~/.bashrc
(cd home && stow -t ~ --no-folding *)

# --- Final Instructions ---
echo
echo "--------------------------------------------------"
echo "Installation Complete"
echo "--------------------------------------------------"
echo
echo "Next steps:"
echo "1. Restart your terminal for all changes to take effect."
echo "2. After restarting, launch 'nvim' to allow LazyVim to complete its plugin setup."
echo
