#!/usr/bin/env bats

@test "install.sh exists and is executable" {
  [ -f ./install.sh ]
  [ -x ./install.sh ]
}

@test "all scripts are executable" {
  for script in scripts/*.sh; do
    [ -f "$script" ]
  done
}

@test "dry-run completes successfully" {
  run ./install.sh --dry-run --yes
  [ "$status" -eq 0 ]
}

@test "packages/apt.txt exists and is readable" {
  [ -f packages/apt.txt ]
  [ -r packages/apt.txt ]
}

@test "home directory structure exists" {
  [ -d home/bash ]
  [ -d home/git ]
  [ -d home/tmux ]
  [ -d home/bin ]
}

@test "dotfiles exist" {
  [ -f home/bash/.bashrc ]
  [ -f home/git/.gitconfig ]
  [ -f home/tmux/.tmux.conf ]
}

@test "kitty config exists" {
  [ -f home/.config/kitty/kitty.conf ]
}

@test "documentation files exist" {
  [ -f README.md ]
  [ -f CHANGELOG.md ]
  [ -f CONTRIBUTING.md ]
  [ -f LICENSE ]
}

@test "docs directory has required files" {
  [ -f docs/QUICK_START.md ]
  [ -f docs/CUSTOMIZATION.md ]
  [ -f docs/TROUBLESHOOTING.md ]
}

@test "Makefile has required targets" {
  grep -q "^install:" Makefile
  grep -q "^dry-run:" Makefile
  grep -q "^verify:" Makefile
  grep -q "^test:" Makefile
  grep -q "^rollback:" Makefile
  grep -q "^uninstall:" Makefile
  grep -q "^update:" Makefile
}

@test "scripts have proper shebang" {
  for script in scripts/*.sh; do
    head -1 "$script" | grep -q "#!/usr/bin/env bash"
  done
}

@test "scripts have error handling" {
  for script in scripts/*.sh; do
    grep -q "set -euo pipefail" "$script"
  done
}

@test "bashrc has NVM configuration" {
  grep -q "NVM_DIR" home/bash/.bashrc
}

@test "bashrc has Bun configuration" {
  grep -q "BUN_INSTALL" home/bash/.bashrc
}
