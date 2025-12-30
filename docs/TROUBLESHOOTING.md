# Troubleshooting Guide

## Neovim Issues

### AppImage won't run

**Error**: `fuse: failed to exec fusermount`

**Solution**:
```bash
sudo apt-get install fuse libfuse2
sudo modprobe fuse
```

### Alternative: Extract AppImage

```bash
cd /tmp
wget https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage
./nvim-linux-x86_64.appimage --appimage-extract
sudo mv squashfs-root /opt/nvim
sudo ln -sf /opt/nvim/AppRun /usr/local/bin/nvim
```

## Font Issues

### Fonts not appearing

```bash
# Rebuild font cache
fc-cache -fv

# Verify fonts installed
fc-list | grep -i "nerd"

# Restart terminal or logout/login
```

### Terminal not using Nerd Font

1. Open terminal preferences
2. Select a Nerd Font (e.g., "Hack Nerd Font")
3. Restart terminal

## Stow Issues

### Conflicts detected

**Error**: `WARNING: in simulation mode; no actions taken`

**Solution**:
```bash
# Backup conflicting files
mv ~/.bashrc ~/.bashrc.backup
mv ~/.gitconfig ~/.gitconfig.backup
mv ~/.tmux.conf ~/.tmux.conf.backup

# Re-run installer
./install.sh
```

### Manual stow

```bash
cd ~/dotfiles/home
stow -t ~ --no-folding --adopt -- *
```

## FZF Issues

### Keybindings not working

```bash
# Source bashrc again
source ~/.bashrc

# Or restart terminal
```

### FZF not finding files

```bash
# Check if fd is installed
which fd

# If not, link fdfind to fd
sudo ln -sf $(which fdfind) /usr/local/bin/fd
```

## Installation Issues

### Package installation fails

```bash
# Update package lists
sudo apt-get update

# Fix broken dependencies
sudo apt-get install -f

# Re-run installer
./install.sh
```

### Permission denied

```bash
# Make scripts executable
chmod +x install.sh scripts/*.sh

# Run with proper permissions
./install.sh
```

### Internet connection issues

```bash
# Test connectivity
ping -c 3 google.com

# Check DNS
cat /etc/resolv.conf

# Try different mirror
sudo apt-get update
```

## Rollback Issues

### Rollback script fails

```bash
# Find backup manifest
ls -la ~/.dotfiles_backups_*

# Manually restore
mv ~/.bashrc.bak.TIMESTAMP ~/.bashrc
mv ~/.config/nvim.bak.TIMESTAMP ~/.config/nvim
```

## Getting Help

If issues persist:
1. Check logs: `cat install.log`
2. Run dry-run: `./install.sh --dry-run`
3. Verify system: `bash scripts/verify-install.sh`
4. Open an issue on GitHub with:
   - Ubuntu version: `lsb_release -a`
   - Error messages
   - Steps to reproduce
