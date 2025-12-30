# Changelog

All notable changes to this project.

## [Unreleased]

### Added

- ASCII art banner with colored output
- Node.js installer with LTS version selection (18/20/22/24)
- CI/CD pipeline with matrix testing for all Node.js versions
- Enhanced rollback script (handles all dotfiles)
- Node.js/NVM verification in verify script
- Interactive Git user configuration
- Smart CI mode detection (safe for users, works in GitHub Actions)

### Changed

- Node.js 24 set as default (npm updated to latest)
- npm update only for Node.js 24, other versions use bundled npm
- Improved error handling across all scripts
- Better backup system with manifest tracking

### Fixed

- CI mode now properly installs different Node.js versions
- Rollback script now handles .gitconfig and .tmux.conf
- Verification script checks Node.js/NVM installation

## [1.0.0] - 2025-12-30

Initial release.

### Included

- Neovim v0.11.5 with LazyVim
- Node.js LTS via NVM (18/20/22/24)
- Git with 30+ aliases
- Tmux with vi-mode and mouse support
- FZF, Ripgrep, fd-find for fast searching
- 5 Nerd Fonts (Hack, JetBrains Mono, Fira Code, Meslo, Cascadia Code)
- Bash with git-aware prompt
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
