# GitHub Actions CI/CD

## Overview

This repository uses GitHub Actions for automated testing and validation.

## Workflows

### CI Pipeline (`.github/workflows/ci.yml`)

Runs on:

- Push to `main` or `master` branch
- Pull requests to `main` or `master`
- Manual trigger via workflow_dispatch

### Jobs

1. **ShellCheck Validation**
   - Validates shell script syntax
   - Checks for common shell scripting errors
   - Runs on all `.sh` files

2. **Test Dry Run Mode**
   - Tests installation preview mode
   - Ensures dry-run doesn't modify system
   - Uploads log as artifact

3. **Test Full Installation**
   - Runs complete installation in CI environment
   - Verifies all tools installed correctly
   - Checks dotfiles applied properly
   - Uploads installation log

4. **Run Bats Tests**
   - Executes test suite
   - Validates basic functionality

5. **Test Rollback Functionality**
   - Tests backup creation
   - Validates rollback mechanism
   - Ensures safe recovery

6. **CI Summary**
   - Aggregates all test results
   - Provides overall status

## Artifacts

CI uploads the following artifacts (retained for 7 days):

- `dry-run-log` - Dry-run installation log
- `installation-log` - Full installation log

## Status Badge

Add to README.md:

```markdown
[![CI](https://github.com/asyrafi-dev/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/asyrafi-dev/dotfiles/actions/workflows/ci.yml)
```

## Local Testing

Before pushing, test locally:

```bash
# Check scripts with ShellCheck
shellcheck install.sh scripts/*.sh

# Test dry-run
./install.sh --dry-run --yes

# Run tests
bats tests/basic.bats
```

## Troubleshooting

### ShellCheck Warnings

ShellCheck may report warnings that are safe to ignore. The CI uses `|| true` to not fail on warnings.

### Installation Failures

Check the uploaded artifacts in GitHub Actions for detailed logs.

### Timeout Issues

If jobs timeout, check for:

- Network issues downloading packages
- Slow package installation
- Infinite loops in scripts

## Customization

To modify CI behavior, edit `.github/workflows/ci.yml`:

```yaml
# Change Ubuntu version
runs-on: ubuntu-24.04

# Add new test job
test-custom:
  name: Custom Test
  runs-on: ubuntu-24.04
  steps:
    - uses: actions/checkout@v4
    - run: ./your-test-script.sh
```

## Security

- CI runs in isolated GitHub-hosted runners
- No secrets or credentials required
- Safe to run on forks
- Artifacts are public (don't include sensitive data)
