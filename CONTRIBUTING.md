# Contributing

Thanks for your interest in contributing!

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a branch
4. Make changes
5. Test thoroughly
6. Submit pull request

## Development

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
- Follow existing style

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
1. **ShellCheck Validation** - Validates shell script syntax and best practices
2. **Dry Run Test** - Tests installation preview without making changes
3. **Full Installation** - Complete installation test with all components
4. **Node.js Version Matrix** - Tests all LTS versions (18, 20, 22, 24)
5. **Bats Tests** - Runs automated test suite
6. **Rollback Test** - Verifies backup and rollback functionality

**Node.js Testing:**
- Tests NVM installation
- Verifies each LTS version installs correctly
- Confirms npm is updated to latest for Node.js 24
- Validates npm functionality

All tests must pass before merging.

## Documentation

- Update README.md for new features
- Add comments in code
- Update relevant docs in `docs/`
- Keep it concise

## Pull Requests

1. Clear description of changes
2. Reference related issues
3. Ensure tests pass
4. Update documentation

## Commit Messages

Use clear messages:

```
Add support for custom fonts
Fix stow conflict handling
Update documentation for rollback
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
