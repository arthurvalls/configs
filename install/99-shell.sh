#!/usr/bin/env bash
# 99-shell — make fish the login shell, install fisher, sync fish_plugins.
# Depends on 90-dotfiles having placed ~/.config/fish/fish_plugins.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/install/lib.sh"

step "Fish shell + plugins"

if ! have fish; then
  warn "fish not installed — skipping shell setup."
  exit 0
fi
FISH_BIN="$(command -v fish)"

# Register fish as a valid login shell.
if ! grep -qxF "$FISH_BIN" /etc/shells 2>/dev/null; then
  log "registering $FISH_BIN in /etc/shells"
  run_sh "echo '$FISH_BIN' | ${SUDO:+sudo }tee -a /etc/shells >/dev/null"
fi

# Make it the default shell for this user.
if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$FISH_BIN" ]]; then
  log "setting fish as default shell for $USER"
  run chsh -s "$FISH_BIN"
else
  ok "fish already the default shell"
fi

# Install fisher (plugin manager).
if [[ ! -f "$HOME/.config/fish/functions/fisher.fish" ]]; then
  if [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] would install fisher"
  else
    log "installing fisher"
    fish -c "curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
  fi
else
  ok "fisher present"
fi

# Sync plugins declared in fish_plugins (placed by 90-dotfiles).
if [[ -f "$HOME/.config/fish/fish_plugins" ]]; then
  if [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] would run: fisher update"
  else
    log "syncing fisher plugins from fish_plugins"
    fish -c "fisher update" || warn "fisher update reported errors (non-fatal)."
  fi
else
  warn "no ~/.config/fish/fish_plugins — skipping plugin sync."
fi

ok "Shell phase complete"
