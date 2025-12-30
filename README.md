Dotfiles Installer — Professional Ubuntu (apt) Setup

Overview
--------
This repository contains opinionated dotfiles and an installer tailored for apt-based systems (Ubuntu 24.04 LTS recommended). The installer focuses on being safe, idempotent, and beginner-friendly while retaining opinionated defaults for power users.

Highlights
----------
- Non-destructive by default: existing files are backed up before being changed.
- Dry-run mode to preview changes without modifying the system.
- CI-friendly: non-interactive operation and automated prerequisite installation in CI.
- Optional verification for downloaded binaries (checksums).
- Rollback helper to restore backed-up files.

Requirements
------------
- Ubuntu 24.04 LTS (recommended) or another apt-based distribution
- Internet connection

Quick start
-----------
Preview what the installer will do (safe):

  ./install.sh --dry-run --log=installer.log

Run non-interactively (CI / automation):

  ./install.sh --yes --log=installer.log

Run interactively (recommended for first-time use):

  ./install.sh

Available flags
---------------
- --dry-run       Show planned actions without making changes
- --yes, -y       Assume "yes" to all prompts (useful for CI)
- --log FILE      Append stdout/stderr to FILE

Backup & rollback
-----------------
- The installer records backups of modified files to a manifest: ~/.dotfiles_backups_<timestamp>.txt
- To restore from a manifest, use: scripts/rollback.sh [manifest-file]

Security & verification
-----------------------
- Downloads (for example, Neovim AppImage) can be verified with SHA256. Set NEOVIM_SHA256 to enable verification before moving binaries into place.

Testing & CI
------------
- The repository includes basic bats tests (tests/). CI runs ShellCheck and shfmt checks, executes the dry-run installer, and uploads logs and previews as artifacts.
- CI is configured for ubuntu-24.04 LTS and is non-destructive by default.

Contributing
------------
Contributions are welcome. Please open a PR with a clear description and reasoning for changes. The CI will validate shell scripts; please ensure scripts pass ShellCheck and shfmt where applicable.

License
-------
Copyright (c) 2025 Muhammad Asyrafi Hidayatullah. All Rights Reserved.
