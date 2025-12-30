# Architecture Documentation

## Overview

This dotfiles repository follows a modular architecture with clear separation of concerns.

## Installation Flow

```
install.sh
    |
    +-- preflight.sh (system checks)
    |
    +-- apt package installation
    |
    +-- install-neovim.sh
    |
    +-- install-nerd-fonts.sh
    |
    +-- install-lazyvim.sh
    |
    +-- GNU Stow (apply dotfiles)
    |
    +-- verify-install.sh (optional)
```

## Components

### Main Installer (install.sh)

Entry point for the installation process. Handles:
- Command-line argument parsing
- Logging setup
- Backup manifest creation
- Orchestration of installation steps
- Conflict resolution

**Key Features**:
- Dry-run mode
- Non-interactive mode
- Logging support
- Error handling with traps

### Preflight Checks (scripts/preflight.sh)

Validates system requirements before installation:
- Internet connectivity
- Package manager availability
- Sudo permissions
- Required commands
- FUSE kernel module

### Component Installers

#### install-neovim.sh
- Downloads Neovim AppImage
- Optional SHA256 verification
- Installs to /usr/local/bin/nvim

#### install-nerd-fonts.sh
- Downloads multiple Nerd Fonts
- Extracts to ~/.local/share/fonts
- Rebuilds font cache

#### install-lazyvim.sh
- Clones LazyVim starter configuration
- Backs up existing Neovim config
- Removes .git directory

### Dotfiles Management

Uses GNU Stow for symlink management:
- Non-destructive by default
- Automatic conflict detection
- Backup of conflicting files
- Adopts existing files when appropriate

### Backup System

**Manifest Format**:
```
~/.dotfiles_backups_<timestamp>.txt
```

**Content**:
```
bashrc:/home/user/.bashrc.bak.1735567890
nvim_config:/home/user/.config/nvim.bak.1735567890
```

### Rollback System (scripts/rollback.sh)

Restores backed-up configurations:
- Reads backup manifest
- Restores files to original locations
- Handles both files and directories

### Verification (scripts/verify-install.sh)

Post-installation checks:
- Command availability
- File existence
- Symlink verification
- Font installation
- Git configuration

## Configuration Structure

### home/ Directory

Organized by application:
```
home/
├── bash/
│   └── .bashrc
├── git/
│   └── .gitconfig
└── tmux/
    └── .tmux.conf
```

Stow creates symlinks:
```
~/.bashrc -> ~/dotfiles/home/bash/.bashrc
~/.gitconfig -> ~/dotfiles/home/git/.gitconfig
~/.tmux.conf -> ~/dotfiles/home/tmux/.tmux.conf
```

### packages/ Directory

Contains package lists:
- `apt.txt` - System packages for apt-get

Format:
```
# Comments start with #
package-name
another-package
```

## Error Handling

All scripts use:
```bash
set -euo pipefail
trap 'echo "ERROR on line $LINENO" >&2; exit 1' ERR
```

This ensures:
- Exit on error
- Exit on undefined variable
- Exit on pipe failure
- Error reporting with line numbers

## Environment Variables

### Used by Scripts

- `ASSUME_YES` - Non-interactive mode flag
- `DRY_RUN` - Dry-run mode flag
- `LOG_FILE` - Log file path
- `BACKUP_MANIFEST` - Backup manifest path
- `CI` - CI environment detection
- `NEOVIM_SHA256` - Optional Neovim checksum

### Exported Variables

Scripts export variables for child processes:
```bash
export ASSUME_YES DRY_RUN LOG_FILE BACKUP_MANIFEST
```

## Testing Strategy

### Unit Tests (tests/basic.bats)

Basic functionality tests:
- Script existence
- Executable permissions
- Dry-run completion

### Integration Tests (CI)

GitHub Actions workflow tests:
- ShellCheck validation
- Dry-run installation
- Full installation
- Verification

## Security Considerations

1. **Sudo Usage**: Only when necessary
2. **Download Verification**: Optional SHA256 checksums
3. **Backup Before Modify**: All changes backed up
4. **Non-destructive**: Existing files preserved
5. **Error Handling**: Fail-safe with traps

## Extensibility

### Adding New Packages

Edit `packages/apt.txt`:
```
new-package-name
```

### Adding New Dotfiles

1. Create directory in `home/`:
   ```bash
   mkdir -p home/app
   ```

2. Add configuration:
   ```bash
   cp ~/.apprc home/app/.apprc
   ```

3. Stow will automatically handle it

### Adding New Installers

1. Create script in `scripts/`:
   ```bash
   scripts/install-newtool.sh
   ```

2. Add to `install.sh`:
   ```bash
   bash scripts/install-newtool.sh
   ```

3. Follow existing patterns:
   - Use `set -euo pipefail`
   - Check `DRY_RUN` flag
   - Respect `ASSUME_YES` flag
   - Add error traps

## Performance Considerations

- Parallel downloads where possible
- Minimal package installation
- Efficient font cache rebuilding
- Stow operations are fast (symlinks only)

## Maintenance

### Regular Updates

1. Update Neovim version in `install-neovim.sh`
2. Update package list in `packages/apt.txt`
3. Update LazyVim configuration
4. Test on fresh Ubuntu 24.04 LTS installation

### Version Management

Follow semantic versioning:
- Major: Breaking changes
- Minor: New features
- Patch: Bug fixes

Update `CHANGELOG.md` for all changes.
