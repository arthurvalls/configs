#!/usr/bin/env bash
# lib.sh — small shared helpers for install.sh (logging, a dry-run-aware
# command runner, idempotent apt install, and a yes/no prompt).
# Sourced by install.sh; not meant to be run on its own.

# Flags come in from install.sh via the environment; default to "off".
DRY_RUN="${DRY_RUN:-0}"
ASSUME_YES="${ASSUME_YES:-0}"

# --- pretty logging (colours only when writing to a real terminal) ---
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
step() { printf '\n%s\n' "${_c_bold}${_c_green}==> $*${_c_reset}"; }

# --- command helpers ---
have() { command -v "$1" >/dev/null 2>&1; }

# run CMD...  — execute it, or just print it under --dry-run.
run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '   %s[dry-run]%s %s\n' "$_c_yellow" "$_c_reset" "$*"
    return 0
  fi
  "$@"
}

# run_sh 'snippet'  — same, but for snippets that need pipes/redirection.
run_sh() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '   %s[dry-run]%s sh -c %q\n' "$_c_yellow" "$_c_reset" "$1"
    return 0
  fi
  bash -c "$1"
}

# sudo wrapper (a no-op when you're already root).
SUDO=""
if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then SUDO="sudo"; fi
as_root() { run $SUDO "$@"; }

# --- apt helpers ---
pkg_installed() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q 'install ok installed'; }

# apt_install PKG...  — installs only the packages that are missing.
apt_install() {
  local want=() p
  for p in "$@"; do pkg_installed "$p" || want+=("$p"); done
  if [[ ${#want[@]} -eq 0 ]]; then ok "already installed: $*"; return 0; fi
  as_root apt-get update -y
  log "installing: ${want[*]}"
  as_root apt-get install -y --no-install-recommends "${want[@]}"
}

# confirm 'question?'  — yes/no prompt, auto-yes under --yes.
confirm() {
  [[ "$ASSUME_YES" == "1" ]] && return 0
  local ans; read -r -p "$1 [y/N] " ans
  [[ "$ans" =~ ^[Yy]$ ]]
}
