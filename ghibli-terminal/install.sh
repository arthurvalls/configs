#!/usr/bin/env bash
# install.sh — one command to set up a cozy terminal 🌱
#
# Installs kitty + fish + starship, the JetBrains Mono Nerd Font, and a
# Studio-Ghibli "Totoro" colour theme, then copies the configs into your
# home folder. Everything here is safe to run again — it skips whatever is
# already installed and backs up any config it would overwrite.
#
# Made for Debian / Ubuntu.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"

usage() {
  cat <<'EOF'
cozy terminal setup 🌱

Usage:
  ./install.sh            install everything (safe to re-run)
  ./install.sh --dry-run  show what it *would* do, change nothing
  ./install.sh --yes      don't ask any questions
  ./install.sh --help     show this message
EOF
}

# --- read the options ---
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=1 ;;
    --yes|-y)     ASSUME_YES=1 ;;
    -h|--help)    usage; exit 0 ;;
    *) err "unknown option: $arg"; usage; exit 1 ;;
  esac
done
export DRY_RUN ASSUME_YES

cat <<'EOF'

   🌱  cozy terminal setup
   ─────────────────────────────────────────
   kitty · fish · starship · JetBrains Mono · Totoro theme

EOF
[[ "$DRY_RUN" == "1" ]] && warn "DRY RUN — nothing will actually change."

# --- 1. make sure this is a system we know how to set up ------------------
step "Checking your system"
if ! have apt-get; then
  err "This installer is built for Debian/Ubuntu (it needs 'apt'). Sorry!"
  exit 1
fi
if [[ "${EUID:-$(id -u)}" -ne 0 ]] && ! have sudo; then
  err "This needs 'sudo' (or root) to install programs."
  exit 1
fi
ok "Debian/Ubuntu detected"

# --- 2. the programs ------------------------------------------------------
step "Installing programs (this may ask for your password)"
apt_install kitty fish fontconfig unzip curl ca-certificates fonts-noto-color-emoji

# --- 3. the font ----------------------------------------------------------
step "Installing the JetBrains Mono Nerd Font"
FONTS_DIR="$HOME/.local/share/fonts"
if fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font"; then
  ok "font already installed"
else
  run mkdir -p "$FONTS_DIR/JetBrainsMonoNerdFont"
  font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  tmp_zip="$(mktemp -u)".zip
  if run_sh "curl -fsSL '$font_url' -o '$tmp_zip'" \
     && run_sh "unzip -o -q '$tmp_zip' -d '$FONTS_DIR/JetBrainsMonoNerdFont'"; then
    run fc-cache -f "$FONTS_DIR" >/dev/null
    run_sh "rm -f '$tmp_zip'"
    ok "installed JetBrains Mono Nerd Font"
  else
    err "font download failed — check your internet connection and re-run"
  fi
fi

# --- 4. the prompt --------------------------------------------------------
step "Installing starship (the pretty prompt)"
if have starship; then
  ok "starship already installed"
else
  run mkdir -p "$HOME/.local/bin"
  run_sh "curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir '$HOME/.local/bin'"
fi

# --- 5. the configs -------------------------------------------------------
step "Copying your configs into place"

# backup_and_copy SRC DEST — copies SRC to DEST, saving any existing DEST first.
backup_and_copy() {
  local src="$1" dest="$2"
  run mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" ]] && ! cmp -s "$src" "$dest" 2>/dev/null; then
    run cp -f "$dest" "$dest.bak.$(date +%Y%m%d%H%M%S)"
    warn "saved your old file as $(basename "$dest").bak.*"
  fi
  run cp -f "$src" "$dest"
  ok "→ $dest"
}

backup_and_copy "$HERE/kitty/kitty.conf"       "$HOME/.config/kitty/kitty.conf"
backup_and_copy "$HERE/kitty/totoro.conf"      "$HOME/.config/kitty/totoro.conf"
backup_and_copy "$HERE/kitty/totoro-bg.jpg"    "$HOME/.config/kitty/totoro-bg.jpg"
backup_and_copy "$HERE/starship/starship.toml" "$HOME/.config/starship.toml"
backup_and_copy "$HERE/fish/config.fish"       "$HOME/.config/fish/config.fish"

run mkdir -p "$HOME/Pictures"
run cp -f "$HERE/wallpaper/totoro.jpg" "$HOME/Pictures/totoro.jpg"
ok "→ $HOME/Pictures/totoro.jpg (set it as your desktop wallpaper if you like)"

# --- 6. make fish the default shell --------------------------------------
step "Your everyday shell"
fish_path="$(command -v fish || true)"
if [[ -z "$fish_path" ]]; then
  warn "fish isn't installed, skipping shell setup"
elif [[ "${SHELL:-}" == "$fish_path" ]]; then
  ok "fish is already your default shell"
elif confirm "Make fish your default shell everywhere? (kitty already uses it)"; then
  # chsh refuses shells that aren't listed in /etc/shells — add it if missing.
  if ! grep -qxF "$fish_path" /etc/shells 2>/dev/null; then
    run_sh "printf '%s\n' '$fish_path' | ${SUDO:+sudo }tee -a /etc/shells >/dev/null"
  fi
  if run chsh -s "$fish_path"; then
    ok "default shell set to fish — it starts next time you log in"
  else
    warn "couldn't switch automatically. Run this yourself:  chsh -s $fish_path"
  fi
else
  log "keeping your current shell — that's fine"
fi

# --- done -----------------------------------------------------------------
step "All done 🌱"
cat <<EOF

  Open ${_c_bold}kitty${_c_reset} — it opens fish + starship for you automatically,
  with a dimmed Totoro behind your text.
  ${_c_yellow}If kitty was already open, fully quit and reopen it.${_c_reset}

  • Your Totoro wallpaper:  ~/Pictures/totoro.jpg
  • Change the colours in:  ~/.config/kitty/totoro.conf  (saves apply instantly)
  • Change text size with:  Ctrl +  /  Ctrl -

  enjoy! 🍃

EOF
