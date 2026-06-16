#!/usr/bin/env bash
# 90-dotfiles — copy the repo's configs into $HOME via the existing load.sh.
# Runs before 99-shell so that fish/fish_plugins is in place for fisher.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/install/lib.sh"

step "Dotfiles (repo -> \$HOME)"

if [[ ! -x "$REPO_DIR/load.sh" ]]; then
  warn "load.sh missing or not executable — skipping."
  exit 0
fi

if [[ "$DRY_RUN" == "1" ]]; then
  log "[dry-run] would run ./load.sh"
else
  bash "$REPO_DIR/load.sh"
fi

ok "Dotfiles phase complete"
