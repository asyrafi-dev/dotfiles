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

Automated tests run on:

- ShellCheck validation
- Dry-run test
- Full installation
- Bats tests
- Rollback test

CI runs on push and pull requests.

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
