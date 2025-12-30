# Quick Start

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh scripts/*.sh
./install.sh
```

## After Install

```bash
source ~/.bashrc                    # Reload terminal
nvim                                # Setup plugins
bash scripts/setup-git-user.sh      # Configure Git if skipped
```

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

## Config Files

```
~/.bashrc           Bash
~/.gitconfig        Git
~/.tmux.conf        Tmux
~/.config/nvim/     Neovim
```

## Common Tasks

### Configure Git
```bash
bash scripts/setup-git-user.sh
```

### Add Packages
```bash
nano packages/apt.txt
./install.sh
```

### Rollback
```bash
./scripts/rollback.sh
```

### Verify
```bash
bash scripts/verify-install.sh
```
