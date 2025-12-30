# Changelog

All notable changes to this project.

## [Unreleased]

### Added

- Kitty terminal installer (GPU-accelerated, recommended for LazyVim)
- Kitty configuration file with Tokyo Night theme and optimized settings
- Complete LazyVim requirements (tree-sitter, gcc, clipboard tools)
- LazyGit installer from GitHub releases (latest version)
- Python packages installer (pynvim for Neovim Python support)
- PHP 8.4 installer with Composer and common extensions
- Podman installer (rootless container runtime with podman-compose)
- kubectl installer with checksum verification and autocompletion
- MariaDB 12.3 installer from official repository
- Additional LazyVim dependencies (luarocks, imagemagick, sqlite3)
- npm global packages (tree-sitter-cli, neovim, mermaid-cli)
- Bun PATH configuration in dotfiles bashrc
- ASCII art banner with colored output
- Node.js installer with LTS version selection (18/20/22/24)
- Bun installer (fast JavaScript runtime and toolkit)
- CI/CD pipeline with matrix testing for all Node.js versions
- Enhanced rollback script (handles all dotfiles)
- Comprehensive verification script (all dependencies)
- Interactive Git user configuration
- Smart CI mode detection (safe for users, works in GitHub Actions)
- Error traps in all scripts for consistent error handling
- Improved test coverage (15 tests)
- Makefile targets: rollback, uninstall, update
- Uninstall script for clean removal
- Update script for system maintenance
- .editorconfig for consistent coding styles
- .gitattributes for line ending consistency
- Enhanced bashrc with 40+ aliases and utility functions
- Enhanced tmux config with true color, vi-copy mode, better styling
- FZF Tokyo Night color scheme integration
- Utility functions: mkcd, extract

### Changed

- Node.js 24 set as default (npm updated to latest)
- npm update only for Node.js 24, other versions use bundled npm
- Improved error handling across all scripts
- Better backup system with manifest tracking
- Enhanced package list with all LazyVim dependencies
- Verification script now checks all LazyVim requirements including Kitty config
- Installation order optimized (Kitty → Neovim → Fonts → LazyGit → LazyVim → Node.js → Python → Bun)
- Documentation improved with complete installation notes
- CI workflow updated with comprehensive testing
- Bashrc enhanced with more aliases, functions, and better history
- Tmux config improved with true color support, vi-copy mode, and modern styling
- Update script now updates Neovim plugins, npm packages, and Bun

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
- lazygit installed from GitHub releases (not available in Ubuntu 24.04 apt)

## [1.0.0] - 2025-12-30

Initial release.

### Included

- Kitty terminal (GPU-accelerated, recommended for LazyVim)
- Neovim v0.11.5 with LazyVim (built with LuaJIT)
- Node.js LTS via NVM (18/20/22/24)
- Bun runtime and toolkit
- PHP 8.4 with Composer
- Podman (rootless containers)
- kubectl (Kubernetes CLI)
- MariaDB 12.3 (database server)
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
