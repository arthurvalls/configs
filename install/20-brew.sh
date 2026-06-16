#!/usr/bin/env bash
# 20-brew — install Homebrew (Linuxbrew) if absent, then manifest/brew.txt.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/install/lib.sh"

step "Homebrew (Linuxbrew) formulae"

if ! have brew; then
  if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] would install Homebrew"
  else
    log "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && \
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

if ! have brew; then
  warn "brew unavailable — skipping brew formulae."
  exit 0
fi

mapfile -t formulae < <(read_manifest brew.txt)
for f in "${formulae[@]}"; do
  if brew list --formula "$f" >/dev/null 2>&1; then
    ok "brew: $f present"
  elif have "$f"; then
    ok "$f already on PATH (not via brew) — skipping"
  else
    log "brew install $f"
    run brew install "$f"
  fi
done

ok "Brew phase complete"
