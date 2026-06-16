#!/usr/bin/env bash
# 30-rust — install rustup (if absent), then the crates in manifest/cargo.txt.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/install/lib.sh"

step "Rust toolchain + crates"

if ! have rustc && [[ ! -x "$HOME/.cargo/bin/rustc" ]]; then
  if [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] would install rustup"
  else
    log "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path
  fi
fi

# shellcheck disable=SC1091
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

if ! have cargo; then
  warn "cargo unavailable — skipping crates."
  exit 0
fi

mapfile -t crates < <(read_manifest cargo.txt)
for c in "${crates[@]}"; do
  if cargo install --list 2>/dev/null | grep -q "^$c "; then
    ok "cargo: $c present"
  else
    log "cargo install $c"
    run cargo install "$c"
  fi
done

ok "Rust phase complete"
