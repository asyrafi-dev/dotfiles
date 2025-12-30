# Troubleshooting

## Neovim Issues

### AppImage won't run

**Error**: `fuse: failed to exec fusermount`

**Fix**:
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

### Fonts not showing

```bash
fc-cache -fv
# Restart terminal
```

Verify:
```bash
fc-list | grep -i "nerd"
```

### Terminal not using font

1. Open terminal preferences
2. Select Nerd Font
3. Restart terminal

## Stow Issues

### Conflicts

**Error**: `WARNING: in simulation mode`

**Fix**:
```bash
mv ~/.bashrc ~/.bashrc.backup
mv ~/.gitconfig ~/.gitconfig.backup
mv ~/.tmux.conf ~/.tmux.conf.backup
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
source ~/.bashrc
# Or restart terminal
```

### Not finding files

```bash
# Check fd installed
which fd

# Link if needed
sudo ln -sf $(which fdfind) /usr/local/bin/fd
```

## Installation Issues

### Package install fails

```bash
sudo apt-get update
sudo apt-get install -f
./install.sh
```

### Permission denied

```bash
chmod +x install.sh scripts/*.sh
./install.sh
```

### Internet issues

```bash
ping -c 3 google.com
sudo apt-get update
```

## Rollback Issues

### Script fails

```bash
# Find backup
ls -la ~/.dotfiles_backups_*

# Manual restore
mv ~/.bashrc.bak.TIMESTAMP ~/.bashrc
mv ~/.config/nvim.bak.TIMESTAMP ~/.config/nvim
```

## Git Issues

### "Please tell me who you are"

```bash
bash scripts/setup-git-user.sh
```

### "Not a git repository"

```bash
git init
```

### Branch ahead/behind

```bash
git push    # If ahead
git pull    # If behind
```

## Getting Help

1. Check error message
2. Read this guide
3. Check logs: `cat install.log`
4. Run dry-run: `./install.sh --dry-run`
5. Open issue on GitHub
