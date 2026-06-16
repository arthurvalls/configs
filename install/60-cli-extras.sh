#!/usr/bin/env bash
# 60-cli-extras — tools best installed from their own installers:
# starship (-> /usr/local/bin) and kitty (-> ~/.local/kitty.app).
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/install/lib.sh"

step "CLI extras (starship, kitty)"

# starship prompt
if ! have starship; then
  log "Installing starship..."
  run_sh "curl -fsSL https://starship.rs/install.sh | ${SUDO:+sudo }sh -s -- -y"
else
  ok "starship present"
fi

# kitty terminal (official installer -> ~/.local/kitty.app, symlinked into ~/.local/bin)
if ! have kitty && [[ ! -x "$HOME/.local/kitty.app/bin/kitty" ]]; then
  log "Installing kitty..."
  run_sh "curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n"
  run mkdir -p "$HOME/.local/bin"
  run ln -sf "$HOME/.local/kitty.app/bin/kitty"  "$HOME/.local/bin/kitty"
  run ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"
else
  ok "kitty present"
fi

ok "CLI extras phase complete"
