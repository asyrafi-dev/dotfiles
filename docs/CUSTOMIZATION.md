# Customization Guide

## Git Configuration

### Interactive Setup
```bash
bash scripts/setup-git-user.sh
```

### Manual Setup
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Package Management

### Add Packages
Edit `packages/apt.txt`:
```bash
nano packages/apt.txt
```

Add package names (one per line), then re-run:
```bash
./install.sh
```

## Bash Customization

Edit `~/.bashrc`:
```bash
nvim ~/.bashrc
```

Add custom aliases:
```bash
alias update='sudo apt update && sudo apt upgrade -y'
alias myproject='cd ~/projects/myproject'
```

Reload:
```bash
source ~/.bashrc
```

## Git Customization

Edit `~/.gitconfig`:
```bash
nvim ~/.gitconfig
```

Add custom aliases:
```ini
[alias]
  pushf = push --force-with-lease
  amend = commit --amend --no-edit
  undo = reset HEAD~1 --soft
```

## Tmux Customization

Edit `~/.tmux.conf`:
```bash
nvim ~/.tmux.conf
```

Change prefix key (uncomment these lines):
```bash
unbind C-b
set -g prefix C-a
bind C-a send-prefix
```

Reload:
```bash
tmux source-file ~/.tmux.conf
```

## Neovim Customization

### Add Plugins

Create `~/.config/nvim/lua/plugins/custom.lua`:
```lua
return {
  { "folke/tokyonight.nvim" },
  { "github/copilot.vim" },
}
```

Restart Neovim to install.

### Change Colorscheme

Edit `~/.config/nvim/lua/config/options.lua`:
```lua
vim.cmd[[colorscheme tokyonight]]
```

### Documentation

See [LazyVim docs](https://www.lazyvim.org/) for more customization options.

## Font Configuration

### Change Terminal Font

1. Open terminal preferences
2. Select a Nerd Font (Hack, JetBrains Mono, Fira Code)
3. Restart terminal

### Install Additional Fonts

Edit `scripts/install-nerd-fonts.sh` and add to `FONTS` array:
```bash
["FontName"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontName.zip"
```

Run:
```bash
bash scripts/install-nerd-fonts.sh
```

## Backup Customizations

Commit and push your changes:
```bash
cd ~/dotfiles
git add .
git commit -m "Personal customizations"
git push
```

## Sync to Another Machine

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Reset to Defaults

### Rollback All Changes
```bash
./scripts/rollback.sh
```

### Fresh Install
```bash
cd ~/dotfiles
git pull origin main
./install.sh
```
