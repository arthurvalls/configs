#!/usr/bin/env bash
# Restore configs from this repo into $HOME. Safe on a fresh machine.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

load_dir() {
  local src="$1" dst="$2"
  [[ -d "$src" ]] || { echo "skip: $src (missing)"; return; }
  mkdir -p "$dst"
  cp -r "$src"/. "$dst"/
}

load_file() {
  local src="$1" dst="$2"
  [[ -e "$src" ]] || { echo "skip: $src (missing)"; return; }
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
}

load_dir  "$REPO/nvim"               "$CONFIG/nvim"
load_dir  "$REPO/kitty"              "$CONFIG/kitty"
load_dir  "$REPO/alacritty"          "$CONFIG/alacritty"
load_dir  "$REPO/fish"               "$CONFIG/fish"
load_dir  "$REPO/git"                "$CONFIG/git"
load_file "$REPO/zsh/ezshrc.zsh"     "$CONFIG/ezsh/ezshrc.zsh"

load_file "$REPO/alacritty/.tmux.conf" "$HOME/.tmux.conf"
load_file "$REPO/bash/.bashrc"         "$HOME/.bashrc"
load_file "$REPO/bash/.profile"        "$HOME/.profile"
load_file "$REPO/ideavim/.ideavimrc"   "$HOME/.ideavimrc"

# Install IosevkaTerm Nerd Font (per-user, idempotent).
if [[ -x "$REPO/install-iosevka-term.sh" ]]; then
  "$REPO/install-iosevka-term.sh"
fi

# Refresh font cache for the user fonts dir.
fc-cache -f "$HOME/.local/share/fonts" >/dev/null 2>&1 || true

echo "Configs loaded into $HOME"
