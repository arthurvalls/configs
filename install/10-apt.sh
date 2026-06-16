#!/usr/bin/env bash
# 10-apt — add 3rd-party apt repos, then install everything in manifest/apt.txt.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/install/lib.sh"

step "APT repositories + packages"

added_repo=0

# neovim (unstable PPA) — gives nvim 0.11+/0.12, matching this machine.
if ! have nvim; then
  apt_install software-properties-common
  if ! grep -rqs 'neovim-ppa/unstable' /etc/apt/sources.list.d/ 2>/dev/null; then
    log "adding ppa:neovim-ppa/unstable"
    as_root add-apt-repository -y ppa:neovim-ppa/unstable
    added_repo=1
  fi
else
  ok "neovim present"
fi

# wezterm (maintainer's Fury repo).
if ! have wezterm; then
  add_keyring "https://apt.fury.io/wez/gpg.key" "/etc/apt/keyrings/wezterm-fury.gpg"
  add_apt_source "wezterm" "deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *"
  added_repo=1
else
  ok "wezterm present"
fi

# GitHub CLI (official repo). Its keyring ships already-dearmored -> binary mode.
if ! have gh; then
  add_keyring "https://cli.github.com/packages/githubcli-archive-keyring.gpg" \
              "/etc/apt/keyrings/githubcli-archive-keyring.gpg" binary
  add_apt_source "github-cli" \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main"
  added_repo=1
else
  ok "gh present"
fi

[[ "$added_repo" == "1" ]] && apt_refresh_force

mapfile -t pkgs < <(read_manifest apt.txt)
[[ ${#pkgs[@]} -gt 0 ]] && apt_install "${pkgs[@]}"

# fd-find installs its binary as `fdfind`; expose `fd` like the live machine.
if have fdfind && ! have fd; then
  run mkdir -p "$HOME/.local/bin"
  run ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  ok "linked fd -> fdfind"
fi

ok "APT phase complete"
