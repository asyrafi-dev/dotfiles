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

## Node.js Issues

### tree-sitter not found

```bash
# tree-sitter-cli installed via npm during setup
source ~/.bashrc
tree-sitter --version

# Reinstall if needed
npm install -g tree-sitter-cli
```

### NVM not found

```bash
# Reload bashrc
source ~/.bashrc

# Check NVM directory
ls -la ~/.nvm
```

### Node command not found

```bash
# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node (choose your preferred LTS)
nvm install 20
nvm use 20
nvm alias default 20
```

### npm permission errors

```bash
# Don't use sudo with npm - NVM handles permissions

# If issues persist, reinstall Node
nvm uninstall 20
nvm install 20
nvm alias default 20

# tree-sitter-cli will be reinstalled automatically
```

### Update npm

```bash
npm install -g npm@latest
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
