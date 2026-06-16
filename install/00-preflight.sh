#!/usr/bin/env bash
# 00-preflight — assert platform, acquire sudo, install base build deps.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/install/lib.sh"

step "Preflight"

if ! have apt-get; then
  err "This framework targets Debian/Ubuntu (apt-get not found)."
  exit 1
fi

if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  log "OS: ${PRETTY_NAME:-unknown}  (${ID:-?} ${VERSION_ID:-?})"
fi

if ! have curl; then
  apt_refresh
  as_root apt-get install -y curl
fi

if ! curl -fsS --max-time 6 https://github.com >/dev/null 2>&1; then
  warn "Cannot reach github.com — network installers may fail."
fi

if [[ -n "$SUDO" ]]; then
  log "Caching sudo credentials for this run..."
  run sudo -v
fi

# Base packages every later phase relies on.
apt_install ca-certificates curl wget gnupg git unzip build-essential pkg-config fontconfig

ok "Preflight complete"
