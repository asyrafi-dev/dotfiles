# Quick Start Guide

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh scripts/*.sh
./install.sh
```

## Customization

Before installation, edit:
- `home/git/.gitconfig` - Your name and email
- `packages/apt.txt` - Add/remove packages

## Post-Installation

```bash
# Restart terminal
source ~/.bashrc

# Verify installation
bash scripts/verify-install.sh

# Setup Neovim
nvim
```

## Common Commands

```bash
# Preview changes
./install.sh --dry-run

# Non-interactive install
./install.sh --yes

# Rollback
./scripts/rollback.sh

# Verify
bash scripts/verify-install.sh
```

## Keybindings

### Tmux
- `Ctrl+b |` - Split vertical
- `Ctrl+b -` - Split horizontal
- `Alt+Arrow` - Navigate panes
- `Ctrl+b r` - Reload config

### FZF
- `Ctrl+T` - Find files
- `Ctrl+R` - Search history
- `Alt+C` - Change directory

### Bash Aliases
- `ll` - List all files
- `gs` - Git status
- `ga` - Git add
- `gc` - Git commit
- `gp` - Git push
- `gl` - Git log graph
- `vim` - Opens Neovim
