# Dotfiles for Ubuntu 24.04 LTS

[![CI](https://github.com/asyrafi-dev/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/asyrafi-dev/dotfiles/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04%20LTS-orange.svg)](https://ubuntu.com/)

My personal dotfiles for Ubuntu 24.04 LTS. One command to set up everything.

## What's Included

- **Kitty Terminal** - GPU-accelerated terminal (recommended for LazyVim)
- **Neovim v0.11.5** with LazyVim (built with LuaJIT)
- **Node.js LTS** via NVM (18/20/22/24) with npm packages (tree-sitter-cli, neovim, mermaid-cli)
- **Bun** - Fast JavaScript runtime and toolkit
- **PHP 8.4** with Composer and common extensions
- **Podman** - Rootless container runtime (Docker alternative)
- **kubectl** - Kubernetes CLI for cluster management
- **Python packages** - pynvim for Neovim Python support
- **Git** with useful aliases
- **Tmux** with vi-mode and mouse support
- **FZF, Ripgrep, fd-find** for fast searching
- **LazyGit** - Terminal UI for Git
- **Nerd Fonts** (Hack, JetBrains Mono, Fira Code, Meslo, Cascadia Code)
- **Bash** with git-aware prompt
- **Complete LazyVim dependencies** (luarocks, imagemagick, sqlite3, build-essential, clipboard tools)

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
- Node.js 24 (Latest) - Default

**Installation Notes:**
- npm updated to latest for Node.js 24 only
- tree-sitter-cli, neovim, mermaid-cli installed globally via npm
- LazyGit installed from GitHub releases (latest version)
- pynvim installed for Python support
- Kitty terminal recommended for best LazyVim experience

### Using Make

```bash
make install      # Install everything
make dry-run      # Preview changes
make verify       # Check installation
make setup-git    # Configure Git
make update       # Update system and tools
make rollback     # Restore previous config
make uninstall    # Remove dotfiles
```

## After Installation

```bash
kitty                               # Launch Kitty terminal (recommended)
source ~/.bashrc                    # Reload terminal (loads NVM and Bun)
nvim                                # Setup plugins
node -v && npm -v                   # Verify Node.js and npm
tree-sitter --version               # Verify tree-sitter
python3 -c "import pynvim"          # Verify pynvim
bun --version                       # Verify Bun
php -v                              # Verify PHP
composer --version                  # Verify Composer
podman --version                    # Verify Podman
kubectl version --client            # Verify kubectl
bash scripts/setup-git-user.sh      # Configure Git if skipped
```

**Important:** Use Kitty terminal for the best LazyVim experience. It provides:
- True color support
- GPU acceleration
- Proper ligature rendering for Nerd Fonts
- No display issues with LazyVim UI

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
- `~/.bashrc` - Bash (includes NVM and Bun)
- `~/.gitconfig` - Git
- `~/.tmux.conf` - Tmux
- `~/.config/nvim/` - Neovim
- `~/.config/kitty/kitty.conf` - Kitty terminal

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

# tree-sitter-cli is already installed globally
tree-sitter --version
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

### PHP Usage

```bash
# Check version
php -v

# List installed modules
php -m

# Run PHP file
php script.php

# Start built-in server
php -S localhost:8000

# Composer commands
composer init           # Create new project
composer install        # Install dependencies
composer require pkg    # Add package
composer update         # Update dependencies

# Laravel example
composer create-project laravel/laravel myapp
cd myapp
php artisan serve
```

### Podman Usage

```bash
# Check version
podman --version

# Run container (rootless, no sudo needed)
podman run hello-world
podman run -d -p 8080:80 nginx

# Container management
podman ps                    # List running containers
podman ps -a                 # List all containers
podman stop <container>      # Stop container
podman rm <container>        # Remove container

# Image management
podman images                # List images
podman pull nginx            # Pull image
podman rmi <image>           # Remove image

# Docker Compose compatibility
podman-compose up -d         # Start services
podman-compose down          # Stop services
podman-compose logs          # View logs

# Docker alias (add to ~/.bashrc if needed)
alias docker=podman
```

### kubectl Usage

```bash
# Check version
kubectl version --client

# Cluster info
kubectl cluster-info
kubectl get nodes

# Pod management
kubectl get pods                     # List pods
kubectl get pods -A                  # All namespaces
kubectl describe pod <name>          # Pod details
kubectl logs <pod>                   # View logs

# Deployments
kubectl get deployments
kubectl apply -f deployment.yaml
kubectl delete -f deployment.yaml

# Services
kubectl get services
kubectl expose deployment <name> --port=80

# Short alias (already configured)
k get pods                           # Same as kubectl get pods
```

## Keybindings

### Kitty Terminal

```
Ctrl+Shift+Enter    New window
Ctrl+Shift+T        New tab
Ctrl+Shift+W        Close window/tab
Ctrl+Shift+]        Next tab
Ctrl+Shift+[        Previous tab
Ctrl+Shift+L        Next layout
Ctrl+Shift+C        Copy
Ctrl+Shift+V        Paste
```

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
la              # List hidden files
lt              # List by time
gs              # Git status
ga .            # Git add all
gc              # Git commit
gp              # Git push
gl              # Git log graph
lg              # LazyGit
vim             # Opens Neovim
v               # Opens Neovim (short)
update          # Update system
c               # Clear screen
..              # Go up one directory
...             # Go up two directories
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
# Or
make rollback
```

## Uninstall

To completely remove dotfiles from your system:

```bash
./scripts/uninstall.sh
# Or
make uninstall
```

## Update

Keep your system and tools up to date:

```bash
make update
# Or
~/bin/update-system.sh
```

This updates: apt packages, Neovim plugins, npm packages, and Bun.

## Options

```bash
./install.sh --dry-run      # Preview without changes
./install.sh --yes          # Skip all prompts
./install.sh --log file     # Save log to file
```

## Troubleshooting

### LazyVim display issues

Use Kitty terminal for best results:
```bash
kitty
nvim
```

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
