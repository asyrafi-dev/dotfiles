# Dotfiles for Ubuntu 24.04 LTS

[![CI](https://github.com/YOUR_USERNAME/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USERNAME/dotfiles/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04%20LTS-orange.svg)](https://ubuntu.com/)
[![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)

Professional dotfiles configuration for Ubuntu 24.04 LTS with automated installation and rollback support.

## Features

- Automated installation with interactive Git setup
- Automatic backup and rollback support
- Dry-run mode for safe preview
- Idempotent and non-destructive
- CI/CD ready

## What Gets Installed

- **Neovim v0.11.5** with LazyVim
- **Git** with 30+ useful aliases
- **Tmux** with vi-mode and mouse support
- **FZF, Ripgrep, fd-find** for fast searching
- **5 Nerd Fonts** (Hack, JetBrains Mono, Fira Code, Meslo, Cascadia Code)
- **Optimized Bash** with git-aware prompt

## Quick Start

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Make scripts executable
chmod +x install.sh scripts/*.sh

# Install
./install.sh
```

The installer will prompt you to configure Git (name and email) during installation.

### Using Make

```bash
make install      # Install dotfiles
make dry-run      # Preview changes
make verify       # Verify installation
make setup-git    # Configure Git
make test         # Run tests
```

## Post-Installation

```bash
# Restart terminal
source ~/.bashrc

# Setup Neovim plugins (first time)
nvim

# Configure Git (if skipped)
bash scripts/setup-git-user.sh
```

## Configuration

### Git Setup

```bash
bash scripts/setup-git-user.sh
```

Or manually:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Add/Remove Packages

Edit `packages/apt.txt` and re-run installer:
```bash
nano packages/apt.txt
./install.sh
```

### Customize Dotfiles

All configurations are symlinked to your home directory:
- `~/.bashrc` - Bash configuration
- `~/.gitconfig` - Git configuration
- `~/.tmux.conf` - Tmux configuration
- `~/.config/nvim/` - Neovim configuration

Edit these files directly to customize.

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
```bash
ll              # List all files
gs              # Git status
ga .            # Git add all
gc              # Git commit
gp              # Git push
gl              # Git log graph
vim             # Neovim
```

### Git Aliases
```bash
git st          # Status
git s           # Short status
git cm "msg"    # Commit with message
git lg          # Log graph
git cob name    # Create branch
git d           # Diff
git ds          # Diff staged
git unstage     # Unstage files
git undo        # Undo last commit
git aliases     # Show all aliases
```

## Backup and Rollback

Files are automatically backed up before changes:
```bash
~/.dotfiles_backups_<timestamp>.txt
```

Restore previous configuration:
```bash
./scripts/rollback.sh
```

## Command Options

```bash
./install.sh [OPTIONS]

Options:
  --dry-run       Preview changes without modifying system
  --yes, -y       Non-interactive mode (skip prompts)
  --log FILE      Log output to file
  -h, --help      Show help message
```

## Troubleshooting

### Neovim AppImage Issues

```bash
sudo apt install fuse libfuse2
sudo modprobe fuse
```

### Fonts Not Showing

```bash
fc-cache -fv
# Restart terminal and select a Nerd Font in terminal preferences
```

### Stow Conflicts

```bash
mv ~/.bashrc ~/.bashrc.backup
./install.sh
```

### Rollback Changes

```bash
./scripts/rollback.sh
```

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for more solutions.

## Customization Examples

### Add Bash Aliases

Edit `~/.bashrc`:
```bash
alias update='sudo apt update && sudo apt upgrade -y'
alias myproject='cd ~/projects/myproject'
```

Reload:
```bash
source ~/.bashrc
```

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

Reload:
```bash
tmux source-file ~/.tmux.conf
```

### Add Neovim Plugins

Create `~/.config/nvim/lua/plugins/custom.lua`:
```lua
return {
  { "folke/tokyonight.nvim" },
  { "github/copilot.vim" },
}
```

Restart Neovim to install.

## Repository Structure

```
dotfiles/
├── .github/              # CI workflows and templates
├── docs/                 # Additional documentation
├── home/                 # Dotfiles (stowed to ~/)
│   ├── bash/.bashrc
│   ├── git/.gitconfig
│   └── tmux/.tmux.conf
├── packages/
│   └── apt.txt          # System packages list
├── scripts/
│   ├── setup-git-user.sh      # Interactive Git setup
│   ├── install-neovim.sh      # Neovim installer
│   ├── install-nerd-fonts.sh  # Fonts installer
│   ├── install-lazyvim.sh     # LazyVim setup
│   ├── preflight.sh           # System checks
│   ├── rollback.sh            # Rollback helper
│   └── verify-install.sh      # Verify installation
├── tests/               # Test files
├── install.sh           # Main installer
├── Makefile             # Convenience commands
└── README.md            # This file
```

## Documentation

- [Quick Start](docs/QUICK_START.md) - Quick reference guide
- [Customization](docs/CUSTOMIZATION.md) - Detailed customization guide
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions

## Testing

```bash
# Run tests
make test

# Check scripts with ShellCheck
make shellcheck

# Clean generated files
make clean
```

## Contributing

Contributions are welcome. Please ensure:
- Scripts pass ShellCheck validation
- Changes are tested on Ubuntu 24.04 LTS
- Documentation is updated accordingly

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

MIT License - See [LICENSE](LICENSE) for details.

Copyright (c) 2025 Muhammad Asyrafi Hidayatullah

## Acknowledgments

- [LazyVim](https://github.com/LazyVim/LazyVim) - Neovim configuration
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) - Patched fonts
- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink management
