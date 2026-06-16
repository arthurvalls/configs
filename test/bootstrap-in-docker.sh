#!/usr/bin/env bash
# test/bootstrap-in-docker.sh — prove the fresh-machine path inside a clean
# ubuntu:24.04 container. By default runs a --dry-run of the terminal scope
# (fast, no real installs). Pass REAL=1 to do an actual install in the container.
#
#   ./test/bootstrap-in-docker.sh                 # dry-run, scope=terminal
#   SCOPE=dev ./test/bootstrap-in-docker.sh        # dry-run, scope=dev
#   REAL=1 ./test/bootstrap-in-docker.sh           # real install (slow)
#
# Requires: docker.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="ubuntu:24.04"
SCOPE="${SCOPE:-terminal}"
REAL="${REAL:-0}"

command -v docker >/dev/null || { echo "docker not found" >&2; exit 1; }

if [[ "$REAL" == "1" ]]; then
  flags="--scope=$SCOPE --yes"
  echo ":: REAL install in $IMAGE (scope=$SCOPE) — this is slow."
else
  flags="--scope=$SCOPE --dry-run --yes"
  echo ":: dry-run in $IMAGE (scope=$SCOPE)"
fi

docker run --rm -t \
  -v "$REPO_DIR":/configs:ro \
  -e DEBIAN_FRONTEND=noninteractive \
  "$IMAGE" bash -c '
    set -e
    apt-get update -y >/dev/null 2>&1 || true
    apt-get install -y sudo curl ca-certificates >/dev/null 2>&1 || true
    # run as a non-root user named tester (mirrors a real workstation account)
    useradd -m -s /bin/bash tester
    echo "tester ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/tester
    cp -r /configs /home/tester/configs
    chown -R tester:tester /home/tester/configs
    su - tester -c "cd ~/configs && ./bootstrap.sh '"$flags"'"
  '
