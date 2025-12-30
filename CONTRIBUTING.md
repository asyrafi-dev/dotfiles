# Contributing

Thanks for your interest in contributing!

## Quick Start

```bash
git clone https://github.com/asyrafi-dev/dotfiles.git
cd dotfiles
chmod +x install.sh scripts/*.sh
./install.sh --dry-run
```

## Code Standards

### Shell Scripts

- Use `#!/usr/bin/env bash`
- Include `set -euo pipefail`
- Pass ShellCheck validation
- Add comments for complex logic

Example:
```bash
#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO" >&2; exit 1' ERR

# Function description
my_function() {
  local arg=$1
  echo "Processing: $arg"
}
```

### Testing

Before submitting:
- Test on Ubuntu 24.04 LTS
- Run `./install.sh --dry-run`
- Test full installation
- Test rollback if applicable
- Run `bats tests/basic.bats`
- Check with `shellcheck install.sh scripts/*.sh`

### CI Pipeline

Automated tests run on every push and pull request:

**Jobs:**
1. ShellCheck Validation - Validates shell script syntax
2. Dry Run Test - Tests installation preview
3. Full Installation Test - Complete installation with all tools
4. Bats Test Suite - Automated tests
5. Node.js Matrix - Tests all LTS versions (24, 22, 20, 18)
6. Rollback Test - Verifies backup/rollback
7. CI Summary - Aggregates results

**Tools Tested:**
- Kitty Terminal (GPU-accelerated)
- Neovim with LazyVim
- LazyGit (from GitHub releases)
- Node.js with npm packages (tree-sitter-cli, neovim, mermaid-cli)
- Python packages (pynvim)
- PHP 8.4 with Composer
- Podman (rootless containers)
- kubectl (Kubernetes CLI)
- Bun runtime
- All system dependencies (luarocks, imagemagick, sqlite3, etc.)

**Node.js Testing:**
- Node.js 24 is default (npm updated to latest)
- Other versions use bundled npm
- tree-sitter-cli, neovim, mermaid-cli installed for all versions
- All versions tested in parallel
- fail-fast: false ensures complete testing

All tests must pass before merging.

## Documentation

- Update README.md for new features
- Add comments in code
- Update relevant docs in `docs/`
- Keep it concise and clear

## Pull Requests

1. Clear description of changes
2. Reference related issues
3. Ensure tests pass
4. Update documentation

## Commit Messages

Use clear, descriptive messages:
```
Add support for custom fonts
Fix stow conflict handling
Update documentation for rollback
Improve Node.js installation script
```

## Reporting Issues

Include:
- Ubuntu version
- Steps to reproduce
- Expected vs actual behavior
- Error messages
- Log output

## Questions

Open an issue with "question" label.

Thanks for contributing!
