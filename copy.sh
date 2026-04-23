#!/usr/bin/env bash
# Copy live configs from $HOME into this repo.
# Idempotent. Run before committing, or use ./push.sh to do it in one step.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

copy_dir() {
  local src="$1" dst="$2"
  [[ -d "$src" ]] || { echo "skip: $src (missing)"; return; }
  mkdir -p "$dst"
  cp -r "$src"/. "$dst"/
}

copy_file() {
  local src="$1" dst="$2"
  [[ -e "$src" ]] || { echo "skip: $src (missing)"; return; }
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
}

copy_dir  "$CONFIG/nvim"       "$REPO/nvim"
copy_dir  "$CONFIG/kitty"      "$REPO/kitty"
copy_dir  "$CONFIG/alacritty"  "$REPO/alacritty"
copy_dir  "$CONFIG/fish"       "$REPO/fish"
copy_dir  "$CONFIG/git"        "$REPO/git"
copy_file "$CONFIG/ezsh/ezshrc.zsh" "$REPO/zsh/ezshrc.zsh"

copy_file "$HOME/.tmux.conf"   "$REPO/alacritty/.tmux.conf"
copy_file "$HOME/.bashrc"      "$REPO/bash/.bashrc"
copy_file "$HOME/.profile"     "$REPO/bash/.profile"
copy_file "$HOME/.ideavimrc"   "$REPO/ideavim/.ideavimrc"

echo "Configs copied to $REPO"
