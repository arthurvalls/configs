#!/usr/bin/env bash
# bootstrap.sh — set up a fresh Ubuntu/Debian machine from this repo.
#
# Installs the tools that back these dotfiles (shell, terminals, editor, CLI
# utils and — by default — dev toolchains), then copies the configs into $HOME
# via load.sh. Every phase is idempotent: re-running is safe and skips whatever
# is already present.
#
# Usage:
#   ./bootstrap.sh                      # full install (terminal env + dev toolchains)
#   ./bootstrap.sh --scope=terminal     # shell/editor/terminal only, no dev toolchains
#   ./bootstrap.sh --dry-run            # print what would happen, change nothing
#   ./bootstrap.sh --only=10-apt,30-rust
#   ./bootstrap.sh --skip=70-terminals
#   ./bootstrap.sh --yes                # don't prompt
#
# Phases live in install/NN-name.sh and run in numeric order.
set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export REPO_DIR

SCOPE="dev"; DRY_RUN="0"; ASSUME_YES="0"; ONLY=""; SKIP=""; STRICT="0"

usage() { sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --scope=*)  SCOPE="${1#*=}" ;;
    --scope)    SCOPE="${2:?}"; shift ;;
    --dry-run|-n) DRY_RUN="1" ;;
    --yes|-y)   ASSUME_YES="1" ;;
    --only=*)   ONLY="${1#*=}" ;;
    --skip=*)   SKIP="${1#*=}" ;;
    --strict)   STRICT="1" ;;
    -h|--help)  usage; exit 0 ;;
    *) echo "unknown argument: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

case "$SCOPE" in terminal|dev) ;; *) echo "invalid --scope: $SCOPE (use terminal|dev)" >&2; exit 1 ;; esac

export SCOPE DRY_RUN ASSUME_YES
# shellcheck source=install/lib.sh
source "$REPO_DIR/install/lib.sh"

# Ordered phase list. DEV_ONLY phases are skipped when --scope=terminal.
ALL=(00-preflight 10-apt 20-brew 30-rust 40-node 50-langtools 60-cli-extras 70-terminals 80-fonts 90-dotfiles 99-shell)
DEV_ONLY=" 30-rust 40-node 50-langtools "

selected=()
for ph in "${ALL[@]}"; do
  [[ "$SCOPE" == "terminal" && "$DEV_ONLY" == *" $ph "* ]] && continue
  [[ -n "$ONLY" && ",$ONLY," != *",$ph,"* ]] && continue
  [[ -n "$SKIP" && ",$SKIP," == *",$ph,"* ]] && continue
  selected+=("$ph")
done

step "Bootstrap — scope=$SCOPE  dry-run=$DRY_RUN"
log "Phases: ${selected[*]:-<none>}"
[[ "$DRY_RUN" == "1" ]] && warn "DRY RUN — no changes will be made."

failed=()
for ph in "${selected[@]}"; do
  script="$REPO_DIR/install/$ph.sh"
  [[ -f "$script" ]] || { warn "missing phase script: $script"; continue; }
  if ! bash "$script"; then
    code=$?
    err "phase $ph failed (exit $code)"
    failed+=("$ph")
    if [[ "$ph" == "00-preflight" || "$STRICT" == "1" ]]; then
      err "aborting (preflight or --strict)."; exit "$code"
    fi
  fi
done

step "Summary"
if [[ ${#failed[@]} -eq 0 ]]; then
  ok "All ${#selected[@]} phase(s) completed."
else
  err "Failed phase(s): ${failed[*]}"
fi

cat <<'EOF'

Manual follow-ups:
  • Restart your shell (or log out/in) so fish, PATH and the docker group apply.
  • Run `nvim` once — lazy.nvim bootstraps plugins on first launch.
  • In your terminal, set the font to "Iosevka Custom" if needed.
EOF

[[ ${#failed[@]} -eq 0 ]]
