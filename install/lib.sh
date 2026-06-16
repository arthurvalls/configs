#!/usr/bin/env bash
# install/lib.sh — shared helpers for the bootstrap framework.
#
# Sourced by bootstrap.sh and by every install/*.sh phase. Not meant to be run
# directly. Provides logging, a dry-run-aware command runner, idempotent apt /
# brew helpers, and apt-repository plumbing.

# --- repo root -------------------------------------------------------------
if [[ -z "${REPO_DIR:-}" ]]; then
  REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi
export REPO_DIR

# --- flags (inherited from bootstrap.sh via env; safe defaults otherwise) ---
DRY_RUN="${DRY_RUN:-0}"
ASSUME_YES="${ASSUME_YES:-0}"
SCOPE="${SCOPE:-dev}"

# --- logging ---------------------------------------------------------------
if [[ -t 1 ]]; then
  _c_reset=$'\e[0m'; _c_blue=$'\e[34m'; _c_green=$'\e[32m'
  _c_yellow=$'\e[33m'; _c_red=$'\e[31m'; _c_bold=$'\e[1m'
else
  _c_reset=''; _c_blue=''; _c_green=''; _c_yellow=''; _c_red=''; _c_bold=''
fi
log()  { printf '%s\n' "${_c_blue}::${_c_reset} $*"; }
ok()   { printf '%s\n' "${_c_green}✓${_c_reset} $*"; }
warn() { printf '%s\n' "${_c_yellow}!${_c_reset} $*" >&2; }
err()  { printf '%s\n' "${_c_red}✗${_c_reset} $*" >&2; }
step() { printf '\n%s\n' "${_c_bold}${_c_blue}==> $*${_c_reset}"; }

# --- command helpers -------------------------------------------------------
have() { command -v "$1" >/dev/null 2>&1; }

# run CMD...  — execute, or just print under --dry-run.
run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '   %s[dry-run]%s %s\n' "$_c_yellow" "$_c_reset" "$*"
    return 0
  fi
  "$@"
}

# run_sh 'snippet'  — same, for snippets that need pipes/redirection.
run_sh() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '   %s[dry-run]%s sh -c %q\n' "$_c_yellow" "$_c_reset" "$1"
    return 0
  fi
  bash -c "$1"
}

# sudo wrapper (no-op when already root).
SUDO=""
if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then SUDO="sudo"; fi
as_root() { run $SUDO "$@"; }

# --- apt helpers -----------------------------------------------------------
_APT_UPDATED=0
apt_refresh()       { [[ "$_APT_UPDATED" == "1" ]] && return 0; as_root apt-get update -y; _APT_UPDATED=1; }
apt_refresh_force() { as_root apt-get update -y; _APT_UPDATED=1; }

# pkg_installed NAME
pkg_installed() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q 'install ok installed'; }

# apt_install PKG...  — installs only the packages that are missing.
apt_install() {
  local want=() p
  for p in "$@"; do pkg_installed "$p" || want+=("$p"); done
  if [[ ${#want[@]} -eq 0 ]]; then ok "apt: '$*' already present"; return 0; fi
  apt_refresh
  log "apt install: ${want[*]}"
  as_root apt-get install -y --no-install-recommends "${want[@]}"
}

# add_keyring URL DEST [armored|binary]  — fetch an apt signing key (idempotent).
add_keyring() {
  local url="$1" dest="$2" mode="${3:-armored}"
  [[ -f "$dest" ]] && { ok "keyring exists: $dest"; return 0; }
  as_root install -m 0755 -d "$(dirname "$dest")"
  if [[ "$mode" == "binary" ]]; then
    run_sh "curl -fsSL '$url' | ${SUDO:+sudo }tee '$dest' >/dev/null"
  else
    run_sh "curl -fsSL '$url' | ${SUDO:+sudo }gpg --dearmor -o '$dest'"
  fi
  as_root chmod a+r "$dest"
}

# add_apt_source NAME 'deb-line'  — write /etc/apt/sources.list.d/NAME.list.
add_apt_source() {
  local name="$1" content="$2" file="/etc/apt/sources.list.d/$1.list"
  if [[ -f "$file" ]] && grep -qF "$content" "$file" 2>/dev/null; then
    ok "apt source exists: $name"; return 0
  fi
  log "add apt source: $name"
  run_sh "printf '%s\n' '$content' | ${SUDO:+sudo }tee '$file' >/dev/null"
  _APT_UPDATED=0
}

# read_manifest FILE  — print non-empty, non-comment entries from manifest/FILE.
read_manifest() {
  local f="$REPO_DIR/install/manifest/$1"
  [[ -f "$f" ]] || { warn "manifest missing: $f"; return 0; }
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' "$f" | grep -v '^[[:space:]]*$' || true
}

# confirm 'prompt?'  — yes/no, auto-yes under --yes.
confirm() {
  [[ "$ASSUME_YES" == "1" ]] && return 0
  local ans; read -r -p "$1 [y/N] " ans
  [[ "$ans" =~ ^[Yy]$ ]]
}
