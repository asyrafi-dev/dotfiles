#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Nerd Fonts installer error on line $LINENO" >&2; exit 1' ERR

FONT_DIR="$HOME/.local/share/fonts"
TMP="/tmp/nerd-fonts"

mkdir -p "$FONT_DIR" "$TMP"

declare -A FONTS=(
  ["Hack"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
  ["JetBrainsMono"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  ["FiraCode"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
  ["Meslo"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
  ["CascadiaCode"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
)

for NAME in "${!FONTS[@]}"; do
  if [ -f "$FONT_DIR/$NAME" ]; then
    echo "Font $NAME seems already installed; skipping."; continue
  fi
  wget -qO "$TMP/$NAME.zip" "${FONTS[$NAME]}"
  unzip -qo "$TMP/$NAME.zip" -d "$FONT_DIR"
done

fc-cache -fv
echo "Nerd Fonts installed."
