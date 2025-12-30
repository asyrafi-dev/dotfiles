# Quick Start

## Installation

```bash
git clone https://github.com/asyrafi-dev/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh scripts/*.sh
./install.sh
```

## After Install

```bash
kitty                               # Launch Kitty terminal (recommended)
source ~/.bashrc                    # Reload terminal (loads NVM and Bun)
nvim                                # Setup plugins
node -v && npm -v                   # Verify Node.js and npm
tree-sitter --version               # Verify tree-sitter
bun --version                       # Verify Bun
php -v                              # Verify PHP
composer --version                  # Verify Composer
podman --version                    # Verify Podman
kubectl version --client  # Check version
mariadb --version         # Check MariaDB
bash scripts/setup-git-user.sh      # Configure Git if skipped
```

**Note:** Use Kitty terminal for best LazyVim experience. tree-sitter-cli installed globally via npm.

## Make Commands

```bash
make install      # Install dotfiles
make dry-run      # Preview changes
make verify       # Check installation
make setup-git    # Configure Git
make test         # Run tests
make clean        # Clean files
```

## Keybindings

### Kitty Terminal

```
Ctrl+Shift+Enter    New window
Ctrl+Shift+T        New tab
Ctrl+Shift+W        Close window/tab
Ctrl+Shift+]        Next tab
Ctrl+Shift+[        Previous tab
Ctrl+Shift+C        Copy
Ctrl+Shift+V        Paste
```

### Tmux

```
Ctrl+b |        Split vertical
Ctrl+b -        Split horizontal
Alt+Arrow       Navigate panes
Ctrl+b d        Detach
Ctrl+b r        Reload config
```

### FZF

```
Ctrl+T          Find files
Ctrl+R          Search history
Alt+C           Change directory
```

### Bash
```bash
ll              # List all
gs              # Git status
ga .            # Git add all
gc              # Git commit
gp              # Git push
gl              # Git log
vim             # Neovim
node            # Node.js
npm             # npm
```

### Git

```bash
git st          # Status
git cm "msg"    # Commit
git lg          # Log graph
git cob name    # Create branch
git d           # Diff
git unstage     # Unstage
git undo        # Undo commit
git aliases     # Show all
```

### LazyGit

```bash
lazygit         # Launch in current repo
?               # Show help
q               # Quit
Enter           # Confirm/Open
Space           # Stage/Unstage
c               # Commit
P               # Push
p               # Pull
```

## Config Files

```
~/.bashrc               Bash (includes NVM and Bun)
~/.gitconfig            Git
~/.tmux.conf            Tmux
~/.config/nvim/         Neovim
~/.config/kitty/        Kitty terminal
~/.nvm/                 Node Version Manager
~/.bun/                 Bun runtime
```

## Common Tasks

### Configure Git
```bash
bash scripts/setup-git-user.sh
```

### Node.js Management
```bash
nvm install 18          # Install Node 18 LTS
nvm install 20          # Install Node 20 LTS
nvm use 20              # Switch to Node 20
nvm ls                  # List versions
npm install -g npm@latest  # Update npm (optional)

# tree-sitter-cli already installed globally
tree-sitter --version
```

### Bun Usage
```bash
bun --version           # Check version
bun install             # Install dependencies
bun run dev             # Run dev script
bun add react           # Add package
bun create next myapp   # Create new project
```

### PHP Usage
```bash
php -v                  # Check version
php -m                  # List modules
composer --version      # Check Composer
composer init           # Create project
composer install        # Install dependencies
php artisan serve       # Laravel dev server
```

### Podman Usage
```bash
podman --version        # Check version
podman run hello-world  # Test installation
podman ps               # List containers
podman images           # List images
podman-compose up -d    # Start compose
podman-compose down     # Stop compose
```

### kubectl Usage
```bash
kubectl version --client  # Check version
kubectl cluster-info      # Cluster info
kubectl get pods          # List pods
kubectl get nodes         # List nodes
k get pods                # Short alias
```

### MariaDB Usage
```bash
mariadb --version         # Check version
sudo mariadb              # Connect as root
sudo systemctl status mariadb  # Check service
sudo mariadb-secure-installation  # Secure setup
```

Note: MariaDB uses Indonesia mirror (Nevacloud) with fallback to official repository.

### Add System Packages

```bash
nano packages/apt.txt
./install.sh
```

### Update System

```bash
make update             # Update everything
# Or manually:
~/bin/update-system.sh
```

### Rollback

```bash
./scripts/rollback.sh
```

### Verify

```bash
bash scripts/verify-install.sh
```

### Uninstall

```bash
make uninstall          # Remove dotfiles
# Or manually:
bash scripts/uninstall.sh
```
