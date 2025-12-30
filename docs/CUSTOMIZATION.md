# Customization

## Git Setup

### Interactive

```bash
bash scripts/setup-git-user.sh
```

### Manual

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Packages

### Add Packages

Edit `packages/apt.txt`:

```bash
nano packages/apt.txt
```

Add package names (one per line), then:

```bash
./install.sh
```

## Bash

Edit `~/.bashrc`:

```bash
nvim ~/.bashrc
```

Add aliases:

```bash
alias update='sudo apt update && sudo apt upgrade -y'
alias myproject='cd ~/projects/myproject'
```

Reload:

```bash
source ~/.bashrc
```

## Git

Edit `~/.gitconfig`:

```bash
nvim ~/.gitconfig
```

Add aliases:

```ini
[alias]
  pushf = push --force-with-lease
  amend = commit --amend --no-edit
  undo = reset HEAD~1 --soft
```

## Tmux

Edit `~/.tmux.conf`:

```bash
nvim ~/.tmux.conf
```

Change prefix (uncomment):

```bash
unbind C-b
set -g prefix C-a
bind C-a send-prefix
```

Reload:

```bash
tmux source-file ~/.tmux.conf
```

## Neovim

### Add Plugins

Create `~/.config/nvim/lua/plugins/custom.lua`:

```lua
return {
  { "folke/tokyonight.nvim" },
  { "github/copilot.vim" },
}
```

Restart Neovim.

### Change Theme

Edit `~/.config/nvim/lua/config/options.lua`:

```lua
vim.cmd[[colorscheme tokyonight]]
```

See [LazyVim docs](https://www.lazyvim.org/) for more.

## Node.js

### NVM Commands

```bash
nvm install 18          # Install Node 18 LTS
nvm install 20          # Install Node 20 LTS (recommended)
nvm install 22          # Install Node 22 LTS
nvm use 20              # Switch to Node 20
nvm alias default 20    # Set default
nvm ls                  # List installed
nvm ls-remote --lts     # List all LTS versions
```

### Global Packages

```bash
npm install -g yarn pnpm typescript eslint prettier nodemon

# tree-sitter-cli already installed during setup
tree-sitter --version
```

### Update npm

```bash
npm install -g npm@latest
```

Note: npm automatically updated to latest for Node.js 24. Other versions use bundled npm. tree-sitter-cli installed globally via npm during setup.

### Recommended LTS Versions

- **Node.js 18 LTS** (Hydrogen) - Maintenance until April 2025
- **Node.js 20 LTS** (Iron) - Active LTS until April 2026
- **Node.js 22 LTS** (Jod) - Active LTS until April 2027
- **Node.js 24** - Latest (will be LTS in October 2025) ⭐ Default

All versions include tree-sitter-cli installed globally via npm.

## Fonts

### Change Terminal Font

1. Open terminal preferences
2. Select Nerd Font (Hack, JetBrains Mono, Fira Code)
3. Restart terminal

### Add More Fonts

Edit `scripts/install-nerd-fonts.sh`:

```bash
["FontName"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontName.zip"
```

Run:

```bash
bash scripts/install-nerd-fonts.sh
```

## Backup

Commit your changes:

```bash
cd ~/dotfiles
git add .
git commit -m "My customizations"
git push
```

## Sync to Another Machine

```bash
git clone https://github.com/asyrafi-dev/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Reset

### Rollback

```bash
./scripts/rollback.sh
```

### Fresh Install

```bash
cd ~/dotfiles
git pull origin main
./install.sh
```
