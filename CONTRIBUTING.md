# Contributing Guidelines

Thank you for considering contributing to this project. This document outlines the process and standards for contributions.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your changes
4. Make your changes
5. Test your changes thoroughly
6. Submit a pull request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/dotfiles.git
cd dotfiles

# Make scripts executable
chmod +x install.sh scripts/*.sh

# Test in dry-run mode
./install.sh --dry-run
```

## Code Standards

### Shell Scripts

All shell scripts must:
- Use `#!/usr/bin/env bash` shebang
- Include `set -euo pipefail` for error handling
- Pass ShellCheck validation
- Include error traps where appropriate
- Use meaningful variable names
- Include comments for complex logic

### Testing

Before submitting:
- Test on Ubuntu 24.04 LTS
- Run dry-run mode: `./install.sh --dry-run`
- Verify no errors in actual installation
- Test rollback functionality if applicable
- Run existing tests: `bats tests/basic.bats`
- Check with ShellCheck: `shellcheck install.sh scripts/*.sh`

### CI Pipeline

The repository includes automated CI testing via GitHub Actions:
- **ShellCheck** - Validates shell script syntax
- **Dry-run test** - Tests preview mode
- **Full installation** - Tests complete installation
- **Bats tests** - Runs test suite
- **Rollback test** - Tests backup and rollback

CI runs automatically on push and pull requests.

### Documentation

- Update README.md if adding new features
- Add comments to complex code sections
- Update relevant documentation files
- Keep documentation clear and concise

## Pull Request Process

1. Ensure your code passes all checks
2. Update documentation as needed
3. Provide a clear description of changes
4. Reference any related issues
5. Wait for review and address feedback

## Commit Messages

Use clear, descriptive commit messages:

```
Add feature: Brief description

Detailed explanation of what changed and why.
```

Examples:
- `Add support for custom font installation`
- `Fix stow conflict handling in installer`
- `Update documentation for rollback process`

## Reporting Issues

When reporting issues, include:
- Ubuntu version
- Steps to reproduce
- Expected behavior
- Actual behavior
- Relevant log output
- Any error messages

## Code of Conduct

- Be respectful and constructive
- Focus on the code, not the person
- Accept constructive criticism gracefully
- Help others learn and grow

## Questions

If you have questions, please open an issue with the "question" label.

Thank you for contributing!
