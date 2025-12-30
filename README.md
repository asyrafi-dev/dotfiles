# Dotfiles for Ubuntu 24.04 LTS

[![CI](https://github.com/YOUR_USERNAME/dotfiles/workflows/CI/badge.svg)](https://github.com/YOUR_USERNAME/dotfiles/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04%20LTS-orange.svg)](https://ubuntu.com/)

Professional dotfiles configuration for Ubuntu 24.04 LTS with automated installation, backup, and rollback capabilities.

## Overview

This repository provides a complete development environment setup that can be deployed with a single command. Designed for disaster recovery scenarios where you need to quickly restore your development environment on a fresh Ubuntu installation.

## Features

- Automated installation with safety checks
- Automatic backup of existing configurations
- Rollback support for safe recovery
- Dry-run mode for previewing changes
- Idempotent and non-destructive operations
- CI-friendly with non-interactive mode

## What Gets Installed

### Development Tools
- Neovim v0.11.5 with LazyVim configuration
- Git with optimized settings
- Tmux with vi-mode and mouse support
- FZF for fuzzy finding
- Ripgrep for fast text search
- fd-find for fast file search

### Fonts
- Hack Nerd Font
- JetBrains Mono Nerd Font
- Fira Code Nerd Font
- Meslo Nerd Font
- Cascadia Code Nerd Font

### Configurations
- Bash with custom aliases and git-aware prompt
- Git with useful aliases and diff/merge tools
- Tmux with custom keybindings
- Neovim with LazyVim starter configuration

## Quick Start

### Using Make (Recommended)

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Make scripts executable (required first time)
chmod +x install.sh scripts/*.sh

# Preview installation
make dry-run

# Run installation
make install

# Verify installation
make verify
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Make scripts executable
chmod +x install.sh scripts/*.sh

# Run the installer
./install.sh
```

### Preview Before Installing

```bash
# See what will be changed without modifying the system
./install.sh --dry-run
```

### Non-Interactive Installation

```bash
# For automation or CI/CD pipelines
./install.sh --yes --log=install.log
```

## Requirements

- Ubuntu 24.04 LTS (or other apt-based distributions)
- Internet connection
- Sudo privileges

## Customization

### Before Installation

Edit personal information in configuration files:

```bash
# Update Git user information
nano home/git/.gitconfig
```

Add or remove system packages:

```bash
# Edit package list
nano packages/apt.txt
```

### After Installation

All configurations are symlinked to your home directory:
- `~/.bashrc` - Bash configuration
- `~/.gitconfig` - Git configuration
- `~/.tmux.conf` - Tmux configuration
- `~/.config/nvim/` - Neovim configuration

Edit these files directly to customize your environment.

## Backup and Rollback

### Automatic Backups

The installer automatically backs up files before replacing them:

```bash
# Backups are timestamped
~/.bashrc.bak.1735567890
~/.config/nvim.bak.1735567890

# Backup manifest
~/.dotfiles_backups_1735567890.txt
```

### Restore Previous Configuration

```bash
# Rollback using the latest manifest
./scripts/rollback.sh

# Or specify a particular manifest
./scripts/rollback.sh ~/.dotfiles_backups_1735567890.txt
```

## Post-Installation

### Verify Installation

```bash
# Run verification script
bash scripts/verify-install.sh
```

### Setup Neovim

```bash
# Launch Neovim for the first time
nvim

# LazyVim will automatically install plugins
# Wait for completion, then restart nvim
```

### Update Git Configuration

```bash
# Set your personal information
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Usage

### Command Line Options

```bash
./install.sh [OPTIONS]

Options:
  --dry-run       Preview changes without modifying the system
  --yes, -y       Non-interactive mode (assume yes to all prompts)
  --log FILE      Log output to specified file
  -h, --help      Show help message
```

### Tmux Keybindings

- `Ctrl+b |` - Split window vertically
- `Ctrl+b -` - Split window horizontally
- `Alt+Arrow` - Navigate between panes
- `Ctrl+b r` - Reload configuration

### FZF Keybindings

- `Ctrl+T` - Fuzzy find files
- `Ctrl+R` - Fuzzy find command history
- `Alt+C` - Fuzzy change directory

## Troubleshooting

### Neovim AppImage Issues

If the AppImage doesn't run due to FUSE issues:

```bash
# Install FUSE
sudo apt-get install fuse libfuse2

# Load FUSE module
sudo modprobe fuse
```

### Font Issues

If fonts don't appear after installation:

```bash
# Rebuild font cache
fc-cache -fv

# Restart your terminal or logout/login
```

### Stow Conflicts

If stow reports conflicts:

```bash
# Backup conflicting files manually
mv ~/.bashrc ~/.bashrc.backup

# Re-run the installer
./install.sh
```

## Repository Structure

```
dotfiles/
├── .github/
│   ├── workflows/
│   │   └── ci.yml                 # CI/CD pipeline
│   ├── ISSUE_TEMPLATE/            # Issue templates
│   └── pull_request_template.md   # PR template
├── docs/
│   ├── QUICK_START.md             # Quick start guide
│   └── TROUBLESHOOTING.md         # Troubleshooting guide
├── home/                          # Dotfiles to be stowed
│   ├── bash/.bashrc              # Bash configuration
│   ├── git/.gitconfig            # Git configuration
│   └── tmux/.tmux.conf           # Tmux configuration
├── packages/
│   └── apt.txt                   # System packages list
├── scripts/
│   ├── preflight.sh              # Pre-installation checks
│   ├── install-neovim.sh         # Neovim installer
│   ├── install-nerd-fonts.sh     # Fonts installer
│   ├── install-lazyvim.sh        # LazyVim installer
│   ├── rollback.sh               # Rollback helper
│   └── verify-install.sh         # Installation verification
├── tests/                        # Test files
├── .gitignore                    # Git ignore rules
├── CHANGELOG.md                  # Version history
├── CONTRIBUTING.md               # Contribution guidelines
├── LICENSE                       # MIT License
├── README.md                     # This file
└── install.sh                    # Main installer
```

## Testing

### Using Make

```bash
# Run all tests
make test

# Run ShellCheck
make shellcheck
```

### Manual Testing

```bash
# Install bats testing framework
sudo apt-get install bats

# Run tests
bats tests/basic.bats
```

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

See [CHANGELOG.md](CHANGELOG.md) for version history.

## License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Muhammad Asyrafi Hidayatullah

## Acknowledgments

- [LazyVim](https://github.com/LazyVim/LazyVim) - Neovim configuration
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) - Patched fonts
- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink management
