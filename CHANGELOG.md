# Changelog

All notable changes to this project.

## [Unreleased]

### Added

- Kitty terminal installer (GPU-accelerated, recommended for LazyVim)
- Complete LazyVim requirements (tree-sitter, gcc, clipboard tools)
- LazyGit terminal UI for Git
- Python packages installer (pynvim for Neovim Python support)
- Additional LazyVim dependencies (luarocks, imagemagick, sqlite3)
- npm global packages (tree-sitter-cli, neovim, mermaid-cli)
- ASCII art banner with colored output
- Node.js installer with LTS version selection (18/20/22/24)
- Bun installer (fast JavaScript runtime and toolkit)
- CI/CD pipeline with matrix testing for all Node.js versions
- Enhanced rollback script (handles all dotfiles)
- Node.js/NVM verification in verify script
- Bun verification in verify script
- Kitty verification in verify script
- Interactive Git user configuration
- Smart CI mode detection (safe for users, works in GitHub Actions)
- Comprehensive LazyVim dependency checks

### Changed

- Node.js 24 set as default (npm updated to latest)
- npm update only for Node.js 24, other versions use bundled npm
- Improved error handling across all scripts
- Better backup system with manifest tracking
- Enhanced package list with all LazyVim dependencies
- Verification script now checks LazyVim requirements
- Installation order optimized (Kitty first, then Neovim)

### Fixed

- CI mode now properly installs different Node.js versions
- Rollback script now handles .gitconfig and .tmux.conf
- Verification script checks Node.js/NVM installation
- LazyVim display issues prevented with Kitty terminal
- All LazyVim dependencies now properly installed
- Removed duplicate packages from apt.txt (nodejs, npm, gcc already covered)
- tree-sitter-cli now installed via npm (not available in Ubuntu apt)
- pynvim installed with proper --break-system-packages flag
- All LazyVim npm packages (neovim, mermaid-cli) installed globally

## [1.0.0] - 2025-12-30

Initial release.

### Included

- Kitty terminal (GPU-accelerated, recommended for LazyVim)
- Neovim v0.11.5 with LazyVim (built with LuaJIT)
- Node.js LTS via NVM (18/20/22/24)
- Bun runtime and toolkit
- Git with 30+ aliases
- LazyGit terminal UI
- Tmux with vi-mode and mouse support
- FZF, Ripgrep, fd-find for fast searching
- 5 Nerd Fonts (Hack, JetBrains Mono, Fira Code, Meslo, Cascadia Code)
- Bash with git-aware prompt
- Complete LazyVim dependencies (tree-sitter, gcc, clipboard tools)
- Automated installation with dry-run mode
- Backup and rollback functionality
- CI/CD testing with GitHub Actions
- Complete documentation

### Features

- One-command installation
- Interactive prompts with safe defaults
- Non-interactive mode for automation
- Automatic backups before changes
- Comprehensive verification
- Ubuntu 24.04 LTS optimized

---

See commit history for detailed changes.
