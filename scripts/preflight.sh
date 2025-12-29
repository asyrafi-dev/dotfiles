#!/usr/bin/env bash
set -e

ping -c 1 1.1.1.1 >/dev/null || {
  echo "No internet"
  exit 1
}

lsb_release -si | grep -qi ubuntu || {
  echo "Ubuntu only"
  exit 1
}

sudo -v

echo "Preflight OK"
