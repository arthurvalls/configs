#!/usr/bin/env bash
# Install IosevkaTerm Nerd Font (Mono + Propo variants) for the current user.
# Re-downloads from the nerd-fonts GitHub release — idempotent, safe to re-run.
set -euo pipefail

FONT_DIR="$HOME/.local/share/fonts/IosevkaTermNerdFont"
URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IosevkaTerm.zip"

if fc-list | grep -qi 'IosevkaTerm Nerd Font Mono'; then
  echo "IosevkaTerm Nerd Font already installed. Skipping."
  exit 0
fi

mkdir -p "$FONT_DIR"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Downloading IosevkaTerm Nerd Font..."
curl -fL --progress-bar -o "$tmp/IosevkaTerm.zip" "$URL"

echo "Extracting..."
# Only extract the 8 core variants — skip Propo and other width variants.
unzip -joq "$tmp/IosevkaTerm.zip" \
  'IosevkaTermNerdFont-Regular.ttf' \
  'IosevkaTermNerdFont-Italic.ttf' \
  'IosevkaTermNerdFont-Bold.ttf' \
  'IosevkaTermNerdFont-BoldItalic.ttf' \
  'IosevkaTermNerdFontMono-Regular.ttf' \
  'IosevkaTermNerdFontMono-Italic.ttf' \
  'IosevkaTermNerdFontMono-Bold.ttf' \
  'IosevkaTermNerdFontMono-BoldItalic.ttf' \
  -d "$FONT_DIR"

echo "Refreshing font cache..."
fc-cache -f "$FONT_DIR" >/dev/null

echo "Installed IosevkaTerm Nerd Font to $FONT_DIR"
