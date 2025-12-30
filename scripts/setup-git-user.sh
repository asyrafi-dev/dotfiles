#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Git setup error on line $LINENO" >&2; exit 1' ERR

echo "Git User Configuration"
echo "======================"
echo

# Check if git user is already configured
CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

if [ -n "$CURRENT_NAME" ] && [ -n "$CURRENT_EMAIL" ]; then
  echo "Git is already configured:"
  echo "  Name:  $CURRENT_NAME"
  echo "  Email: $CURRENT_EMAIL"
  echo
  read -rp "Do you want to change these settings? [y/N] " change
  if [[ ! $change =~ ^[Yy]$ ]]; then
    echo "Keeping existing Git configuration."
    exit 0
  fi
  echo
fi

# Prompt for user name
echo "Enter your full name (for Git commits):"
read -rp "Name: " git_name
while [ -z "$git_name" ]; do
  echo "Name cannot be empty."
  read -rp "Name: " git_name
done

# Prompt for user email
echo
echo "Enter your email address (for Git commits):"
read -rp "Email: " git_email
while [ -z "$git_email" ]; do
  echo "Email cannot be empty."
  read -rp "Email: " git_email
done

# Validate email format (basic check)
if [[ ! "$git_email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
  echo
  echo "Warning: Email format looks invalid."
  read -rp "Continue anyway? [y/N] " continue
  if [[ ! $continue =~ ^[Yy]$ ]]; then
    echo "Aborted. Please run this script again."
    exit 1
  fi
fi

# Confirm settings
echo
echo "Git will be configured with:"
echo "  Name:  $git_name"
echo "  Email: $git_email"
echo
read -rp "Is this correct? [Y/n] " confirm
if [[ $confirm =~ ^[Nn]$ ]]; then
  echo "Aborted. Please run this script again."
  exit 1
fi

# Apply configuration
git config --global user.name "$git_name"
git config --global user.email "$git_email"

echo
echo "Git configuration updated successfully!"
echo
echo "You can verify with:"
echo "  git config --global user.name"
echo "  git config --global user.email"
echo
echo "To change later, run:"
echo "  bash scripts/setup-git-user.sh"
