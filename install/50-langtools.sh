#!/usr/bin/env bash
# 50-langtools — uv, bun, deno (official installers); OpenJDK 21 + Maven; Docker.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/install/lib.sh"

step "Language tools (uv, bun, deno, JDK, Maven, Docker)"

# uv -> ~/.local/bin
if ! have uv && [[ ! -x "$HOME/.local/bin/uv" ]]; then
  log "Installing uv..."
  run_sh "curl -fsSL https://astral.sh/uv/install.sh | sh"
else
  ok "uv present"
fi

# bun -> ~/.bun
if ! have bun && [[ ! -x "$HOME/.bun/bin/bun" ]]; then
  log "Installing bun..."
  run_sh "curl -fsSL https://bun.sh/install | bash"
else
  ok "bun present"
fi

# deno -> ~/.deno
if ! have deno && [[ ! -x "$HOME/.deno/bin/deno" ]]; then
  log "Installing deno..."
  run_sh "curl -fsSL https://deno.land/install.sh | sh"
else
  ok "deno present"
fi

# OpenJDK 21 + Maven (apt).
apt_install openjdk-21-jdk maven

# Docker (official repo).
if ! have docker; then
  add_keyring "https://download.docker.com/linux/ubuntu/gpg" "/etc/apt/keyrings/docker.asc" binary
  codename="$( (. /etc/os-release && echo "${VERSION_CODENAME:-stable}") )"
  add_apt_source "docker" \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${codename} stable"
  apt_refresh_force
  apt_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
  ok "docker present"
fi

# Add the invoking user to the docker group (so docker runs without sudo).
if have docker && ! id -nG "$USER" 2>/dev/null | tr ' ' '\n' | grep -qx docker; then
  as_root usermod -aG docker "$USER"
  warn "Added $USER to the 'docker' group — log out/in for it to take effect."
fi

ok "Langtools phase complete"
