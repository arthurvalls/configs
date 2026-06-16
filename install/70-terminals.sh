#!/usr/bin/env bash
# 70-terminals — Ghostty. (kitty: phase 60; wezterm: phase 10.)
# Ghostty has no official Ubuntu apt repo, so we use the community .deb builds
# from mkasberg/ghostty-ubuntu. Best-effort: a failure here is non-fatal.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/install/lib.sh"

step "Ghostty terminal"

if have ghostty; then
  ok "ghostty present"
  exit 0
fi

if [[ "$DRY_RUN" == "1" ]]; then
  log "[dry-run] would fetch latest ghostty-ubuntu .deb and install it"
  exit 0
fi

arch="$(dpkg --print-architecture)"
release_json="$(curl -fsSL https://api.github.com/repos/mkasberg/ghostty-ubuntu/releases/latest 2>/dev/null || true)"
url="$(printf '%s' "$release_json" \
  | grep -oE 'https://[^"]+\.deb' \
  | grep -E "_${arch}_|_${arch}\.deb" \
  | head -1)"
[[ -z "$url" ]] && url="$(printf '%s' "$release_json" | grep -oE 'https://[^"]+\.deb' | head -1)"

if [[ -z "$url" ]]; then
  warn "Could not resolve a ghostty .deb. Install manually from:"
  warn "  https://github.com/mkasberg/ghostty-ubuntu/releases"
  exit 0
fi

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
log "Downloading $(basename "$url")"
if curl -fsSL "$url" -o "$tmp/ghostty.deb"; then
  as_root apt-get install -y "$tmp/ghostty.deb" || warn "ghostty .deb failed to install (non-fatal)."
else
  warn "ghostty download failed (non-fatal)."
fi

ok "Terminals phase complete"
