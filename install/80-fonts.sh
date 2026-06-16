#!/usr/bin/env bash
# 80-fonts — install the fonts bundled in this repo (no downloads).
# The primary terminal font is "Iosevka Custom" (iosevka-custom/*.ttf); fonts/
# holds extra patched fallbacks (e.g. JetBrainsMono Nerd Font).
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/install/lib.sh"

step "Fonts (bundled — Iosevka Custom + fallbacks)"

FONTS_DIR="$HOME/.local/share/fonts"
run mkdir -p "$FONTS_DIR"

if compgen -G "$REPO_DIR/iosevka-custom/*.ttf" >/dev/null; then
  run mkdir -p "$FONTS_DIR/IosevkaCustom"
  run_sh "cp -f '$REPO_DIR'/iosevka-custom/*.ttf '$FONTS_DIR/IosevkaCustom'/"
  ok "installed Iosevka Custom"
else
  warn "no iosevka-custom/*.ttf in repo"
fi

if compgen -G "$REPO_DIR/fonts/*.ttf" >/dev/null; then
  run_sh "cp -f '$REPO_DIR'/fonts/*.ttf '$FONTS_DIR'/"
  ok "installed bundled fallback fonts"
fi

run fc-cache -f "$FONTS_DIR"
ok "Fonts phase complete"
