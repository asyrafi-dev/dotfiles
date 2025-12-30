#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Nerd Fonts installer error on line $LINENO" >&2; exit 1' ERR

ASSUME_YES=${ASSUME_YES:-0}
DRY_RUN=${DRY_RUN:-0}

FONT_DIR="$HOME/.local/share/fonts"
TMP="/tmp/nerd-fonts-$$"

mkdir -p "$FONT_DIR" "$TMP"

declare -A FONTS=(
  ["Hack"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
  ["JetBrainsMono"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  ["FiraCode"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
  ["Meslo"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
  ["CascadiaCode"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
)

for NAME in "${!FONTS[@]}"; do
  echo "[nerd-fonts] Processing $NAME"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "DRY-RUN: would download ${FONTS[$NAME]} to $TMP/$NAME.zip and unzip to $FONT_DIR"
    continue
  fi
  wget -qO "$TMP/$NAME.zip" "${FONTS[$NAME]}"
  unzip -qo "$TMP/$NAME.zip" -d "$FONT_DIR"
done

if [ "$DRY_RUN" -eq 0 ]; then
  fc-cache -fv || true
  echo "Nerd Fonts installed."
  rm -rf "$TMP"
else
  echo "DRY-RUN: skipped fc-cache and cleanup"
fi
