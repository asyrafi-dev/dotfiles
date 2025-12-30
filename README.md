# Dotfiles for Ubuntu 24.04 LTS

[![CI](https://github.com/asyrafi-dev/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/asyrafi-dev/dotfiles/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04%20LTS-orange.svg)](https://ubuntu.com/)

My personal dotfiles for Ubuntu 24.04 LTS. One command to set up everything.

## What's Included

- **Neovim v0.11.5** with LazyVim
- **Node.js LTS** via NVM (choose 18/20/22/24)
- **Bun** - Fast JavaScript runtime and toolkit
- **Git** with useful aliases
- **Tmux** with vi-mode and mouse support
- **FZF, Ripgrep, fd-find** for fast searching
- **Nerd Fonts** (Hack, JetBrains Mono, Fira Code, Meslo, Cascadia Code)
- **Bash** with git-aware prompt

## Installation

```bash
git clone https://github.com/asyrafi-dev/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh scripts/*.sh
./install.sh
```

The installer will ask for your Git name and email during setup.

You'll also be prompted to choose a Node.js LTS version:
- Node.js 18 LTS (Hydrogen)
- Node.js 20 LTS (Iron)
- Node.js 22 LTS (Jod)
- Node.js 24 (Latest) - Default, npm updated to latest

Note: npm is updated to latest only for Node.js 24. Other versions use the bundled npm.

### Using Make

```bash
make install      # Install everything
make dry-run      # Preview changes
make verify       # Check installation
make setup-git    # Configure Git
```

## After Installation

```bash
source ~/.bashrc                    # Reload terminal (loads NVM and Bun)
nvim                                # Setup plugins
node -v                             # Verify Node.js
npm -v                              # Verify npm
bun --version                       # Verify Bun
bash scripts/setup-git-user.sh      # Configure Git if skipped
```

## Configuration

### Git Setup

```bash
bash scripts/setup-git-user.sh
```

### Add/Remove Packages

Edit `packages/apt.txt` and re-run installer:

```bash
nano packages/apt.txt
./install.sh
```

### Edit Dotfiles

All configs are in your home directory:
- `~/.bashrc` - Bash (includes NVM)
- `~/.gitconfig` - Git
- `~/.tmux.conf` - Tmux
- `~/.config/nvim/` - Neovim

### Node.js Management

```bash
# Install different Node version
nvm install 18          # Install Node 18 LTS
nvm install 20          # Install Node 20 LTS
nvm install 22          # Install Node 22 LTS
nvm use 20              # Switch to Node 20

# List installed versions
nvm ls

# Set default version
nvm alias default 20

# Update npm (optional, only if needed)
npm install -g npm@latest

# Install global packages
npm install -g yarn pnpm typescript eslint prettier
```

### Bun Usage

```bash
# Check version
bun --version

# Install dependencies
bun install

# Run scripts
bun run dev
bun run build
bun test

# Add packages
bun add react
bun add -d typescript

# Create new project
bun create react myapp
bun create next myapp

# Run files directly
bun run index.ts
```

## Keybindings

### Tmux

```
Ctrl+b |        Split vertical
Ctrl+b -        Split horizontal
Alt+Arrow       Navigate panes
Ctrl+b r        Reload config
```

### FZF

```
Ctrl+T          Find files
Ctrl+R          Search history
Alt+C           Change directory
```

### Bash Aliases
```bash
ll              # List all files
gs              # Git status
ga .            # Git add all
gc              # Git commit
gp              # Git push
gl              # Git log graph
vim             # Opens Neovim
node            # Node.js REPL
npm             # Node package manager
```

### Git Aliases

```bash
git st          # Status
git cm "msg"    # Commit with message
git lg          # Pretty log graph
git cob name    # Create new branch
git d           # Show diff
git unstage     # Unstage files
git undo        # Undo last commit
git aliases     # Show all aliases
```

## Backup & Rollback

Files are automatically backed up before changes. To rollback:

```bash
./scripts/rollback.sh
```

## Options

```bash
./install.sh --dry-run      # Preview without changes
./install.sh --yes          # Skip all prompts
./install.sh --log file     # Save log to file
```

## Troubleshooting

### Neovim won't start

```bash
sudo apt install fuse libfuse2
sudo modprobe fuse
```

### Fonts not showing

```bash
fc-cache -fv
# Restart terminal and select a Nerd Font in preferences
```

### Stow conflicts

```bash
mv ~/.bashrc ~/.bashrc.backup
./install.sh
```

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for more.

## Customization

### Add Bash Aliases

Edit `~/.bashrc`:

```bash
alias update='sudo apt update && sudo apt upgrade -y'
alias myproject='cd ~/projects/myproject'
```

Reload: `source ~/.bashrc`

### Add Git Aliases

Edit `~/.gitconfig`:

```ini
[alias]
  pushf = push --force-with-lease
  amend = commit --amend --no-edit
```

### Change Tmux Prefix

Edit `~/.tmux.conf`:

```bash
unbind C-b
set -g prefix C-a
bind C-a send-prefix
```

Reload: `tmux source-file ~/.tmux.conf`

### Add Neovim Plugins

Create `~/.config/nvim/lua/plugins/custom.lua`:

```lua
return {
  { "folke/tokyonight.nvim" },
  { "github/copilot.vim" },
}
```

Restart Neovim to install.

## Documentation

- [Quick Start](docs/QUICK_START.md) - Quick reference
- [Customization](docs/CUSTOMIZATION.md) - Detailed customization
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues

## Testing

```bash
make test         # Run tests
make shellcheck   # Check scripts
make clean        # Clean generated files
```

## Contributing

Contributions welcome! Make sure scripts pass ShellCheck and are tested on Ubuntu 24.04 LTS.

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

MIT License - See [LICENSE](LICENSE)

## Credits

- [LazyVim](https://github.com/LazyVim/LazyVim) - Neovim config
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) - Fonts
- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink manager
