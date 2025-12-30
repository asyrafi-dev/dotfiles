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

### Built-in Aliases

The dotfiles include many useful aliases:

```bash
# Navigation
..              # cd ..
...             # cd ../..
....            # cd ../../..

# Files
ll              # ls -alF
la              # ls -A
lt              # ls -ltrh (by time)
lsize           # ls -lSrh (by size)

# Git
gs              # git status
ga              # git add
gc              # git commit
gp              # git push
gl              # git log --oneline --graph
lg              # lazygit

# System
update          # apt update && upgrade
cleanup         # apt autoremove && autoclean
myip            # show public IP

# Editor
vim, vi, v      # nvim
```

### Built-in Functions

```bash
mkcd dirname    # Create and enter directory
extract file    # Extract any archive format
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

### Built-in Features

The dotfiles include an enhanced tmux config:

- True color support (works with Kitty and LazyVim)
- Vi-style copy mode with clipboard integration
- Mouse support
- Better status bar styling
- Pane resize with Ctrl+Arrow

### Change prefix (uncomment in config):

```bash
unbind C-b
set -g prefix C-a
bind C-a send-prefix
```

### Key Bindings

```
Ctrl+b |        Split vertical (in current path)
Ctrl+b -        Split horizontal (in current path)
Ctrl+b c        New window (in current path)
Alt+Arrow       Navigate panes
Ctrl+Arrow      Resize panes
Ctrl+b r        Reload config
```

### Copy Mode (vi-style)

```
Ctrl+b [        Enter copy mode
v               Start selection
y               Copy to clipboard
q               Exit copy mode
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

## Kitty Terminal

Edit `~/.config/kitty/kitty.conf`:

```bash
nvim ~/.config/kitty/kitty.conf
```

### Change Font

```conf
font_family      JetBrainsMono Nerd Font
font_size 14.0
```

### Change Theme

The default theme is Tokyo Night. To change:

```conf
# Catppuccin Mocha
foreground #cdd6f4
background #1e1e2e
```

### Useful Settings

```conf
# Transparency
background_opacity 0.95

# Cursor
cursor_shape beam
cursor_blink_interval 0.5

# Window
hide_window_decorations yes
```

Reload Kitty: `Ctrl+Shift+F5`

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

## PHP

### Check Version

```bash
php -v
php -m                  # List installed modules
```

### Install Additional Extensions

```bash
sudo apt install php8.4-redis php8.4-memcached php8.4-imagick
```

### Composer Commands

```bash
composer init           # Create new project
composer install        # Install dependencies
composer require pkg    # Add package
composer update         # Update dependencies
composer dump-autoload  # Regenerate autoloader
```

### Laravel Development

```bash
# Create new Laravel project
composer create-project laravel/laravel myapp
cd myapp

# Start development server
php artisan serve

# Common artisan commands
php artisan make:controller UserController
php artisan make:model User -m
php artisan migrate
```

### PHP Configuration

Edit PHP CLI config:
```bash
sudo nvim /etc/php/8.4/cli/php.ini
```

Common settings:
```ini
memory_limit = 512M
upload_max_filesize = 100M
post_max_size = 100M
max_execution_time = 300
```

## Podman

### Basic Commands

```bash
# Run container (rootless)
podman run -d -p 8080:80 nginx
podman run -it ubuntu bash

# Container management
podman ps                    # Running containers
podman ps -a                 # All containers
podman stop <id>             # Stop container
podman rm <id>               # Remove container
podman logs <id>             # View logs
```

### Docker Compatibility

Add to `~/.bashrc`:
```bash
alias docker=podman
alias docker-compose=podman-compose
```

### Podman Compose

```bash
# Start services
podman-compose up -d

# Stop services
podman-compose down

# View logs
podman-compose logs -f

# Rebuild
podman-compose up -d --build
```

### Rootless Configuration

Podman runs rootless by default. Config files:
```
~/.config/containers/registries.conf    # Registry settings
~/.config/containers/storage.conf       # Storage settings
```

### Common Images

```bash
podman pull nginx
podman pull postgres:16
podman pull redis:alpine
podman pull node:20-alpine
podman pull php:8.4-fpm
```

## kubectl

### Basic Commands

```bash
# Check version
kubectl version --client

# Cluster info
kubectl cluster-info
kubectl get nodes

# Pod management
kubectl get pods
kubectl get pods -A                  # All namespaces
kubectl describe pod <name>
kubectl logs <pod>
kubectl exec -it <pod> -- bash
```

### Deployments

```bash
kubectl get deployments
kubectl apply -f deployment.yaml
kubectl delete -f deployment.yaml
kubectl rollout status deployment/<name>
kubectl rollout undo deployment/<name>
```

### Services

```bash
kubectl get services
kubectl expose deployment <name> --port=80 --type=LoadBalancer
kubectl port-forward svc/<name> 8080:80
```

### Contexts and Namespaces

```bash
# View contexts
kubectl config get-contexts
kubectl config current-context

# Switch context
kubectl config use-context <name>

# Set default namespace
kubectl config set-context --current --namespace=<name>
```

### Short Alias

The `k` alias is already configured:
```bash
k get pods              # Same as kubectl get pods
k get svc               # Same as kubectl get services
k apply -f file.yaml    # Same as kubectl apply -f file.yaml
```

### Autocompletion

kubectl autocompletion is automatically enabled. Restart terminal or:
```bash
source ~/.bashrc
```

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

### Uninstall

```bash
./scripts/uninstall.sh
```

### Fresh Install

```bash
cd ~/dotfiles
git pull origin main
./install.sh
```

## System Maintenance

### Update Everything

```bash
make update
# Or
~/bin/update-system.sh
```

This updates:
- System packages (apt)
- Neovim plugins (Lazy)
- npm global packages
- Bun runtime

### Manual Updates

```bash
# System packages
sudo apt update && sudo apt upgrade -y

# Neovim plugins
nvim --headless "+Lazy! sync" +qa

# npm packages
npm update -g

# Bun
bun upgrade

# NVM
nvm install node --reinstall-packages-from=node
```
