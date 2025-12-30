# Get Started

## For First-Time Users

### Step 1: Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Step 2: Make Scripts Executable

```bash
chmod +x install.sh scripts/*.sh
```

### Step 3: Customize Configuration

Edit your personal information:

```bash
nano home/git/.gitconfig
```

Change:
```ini
[user]
  name = Your Name          # Replace with your name
  email = you@email.com     # Replace with your email
```

### Step 4: Preview Installation (Optional)

```bash
./install.sh --dry-run
```

This shows what will be installed without making changes.

### Step 5: Run Installation

```bash
./install.sh
```

Or use Make:
```bash
make install
```

### Step 6: Restart Terminal

```bash
source ~/.bashrc
```

Or close and reopen your terminal.

### Step 7: Verify Installation

```bash
bash scripts/verify-install.sh
```

Or use Make:
```bash
make verify
```

### Step 8: Setup Neovim

```bash
nvim
```

Wait for LazyVim to install plugins, then restart Neovim.

## For Disaster Recovery

If your PC crashed and you need to restore your environment:

```bash
# On fresh Ubuntu 24.04 LTS installation
sudo apt update && sudo apt install -y git
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh scripts/*.sh
./install.sh --yes
```

This will restore your entire development environment automatically.

## Common Commands

```bash
# Preview changes
make dry-run

# Install
make install

# Verify
make verify

# Run tests
make test

# Check scripts
make shellcheck

# Clean generated files
make clean
```

## What Happens During Installation

1. System checks (internet, sudo, packages)
2. Install system packages from `packages/apt.txt`
3. Download and install Neovim v0.11.5
4. Download and install 5 Nerd Fonts
5. Setup LazyVim configuration
6. Apply dotfiles using GNU Stow
7. Create backups of existing files
8. Verify installation

## After Installation

Your environment will have:
- Modern text editor (Neovim with LazyVim)
- Optimized terminal (Bash with custom prompt)
- Terminal multiplexer (Tmux)
- Fast search tools (fzf, ripgrep, fd)
- Beautiful fonts (Nerd Fonts)
- Git with useful aliases

## Customization

All configurations are in your home directory:
- `~/.bashrc` - Bash settings
- `~/.gitconfig` - Git settings
- `~/.tmux.conf` - Tmux settings
- `~/.config/nvim/` - Neovim settings

Edit these files to customize your environment.

## Need Help?

- Read [docs/QUICK_START.md](docs/QUICK_START.md)
- Check [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- Review [README.md](README.md)
- Open an issue on GitHub

## Rollback

If something goes wrong:

```bash
./scripts/rollback.sh
```

This restores your previous configuration.

---

You're ready to go! Enjoy your new development environment.
