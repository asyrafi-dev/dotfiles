#!/usr/bin/env bats

@test "install.sh exists and is executable" {
  [ -f ./install.sh ]
  [ -x ./install.sh ]
}

@test "dry-run completes successfully" {
  run ./install.sh --dry-run --yes
  [ "$status" -eq 0 ]
}
