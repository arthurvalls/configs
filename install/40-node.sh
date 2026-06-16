#!/usr/bin/env bash
# 40-node — install nvm (to ~/.local/share/nvm, matching this machine), a Node
# LTS, enable corepack (pnpm/yarn), then the globals in manifest/npm.txt.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/install/lib.sh"

step "Node.js (nvm) + global npm packages"

export NVM_DIR="${NVM_DIR:-$HOME/.local/share/nvm}"

if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  if [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] would install nvm into $NVM_DIR"
  else
    log "Installing nvm into $NVM_DIR..."
    mkdir -p "$NVM_DIR"
    PROFILE=/dev/null bash -c \
      "curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash"
  fi
fi

if [[ "$DRY_RUN" == "1" ]]; then
  log "[dry-run] would: nvm install --lts; corepack enable; npm -g install manifest/npm.txt"
  ok "Node phase complete (dry-run)"
  exit 0
fi

if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  warn "nvm not found — skipping Node."
  exit 0
fi

# shellcheck disable=SC1091
\. "$NVM_DIR/nvm.sh"

if ! nvm ls --no-colors 2>/dev/null | grep -qE 'v[0-9]+\.'; then
  log "Installing Node LTS..."
  nvm install --lts
  nvm alias default 'lts/*'
else
  ok "a Node version is already installed"
fi

nvm use --lts >/dev/null 2>&1 || nvm use default >/dev/null 2>&1 || true

# pnpm + yarn via corepack (as on this machine).
if have corepack; then
  corepack enable >/dev/null 2>&1 || true
fi

mapfile -t pkgs < <(read_manifest npm.txt)
if [[ ${#pkgs[@]} -gt 0 ]] && have npm; then
  log "npm -g install: ${pkgs[*]}"
  npm install -g "${pkgs[@]}"
fi

ok "Node phase complete"
