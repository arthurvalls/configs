#!/usr/bin/env bash
# Stage live configs into the repo, then commit and push.
# Usage: ./push.sh "commit message"
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <commit message>" >&2
  exit 1
fi

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO"

./copy.sh

if git diff --quiet && git diff --cached --quiet && [[ -z "$(git status --porcelain)" ]]; then
  echo "Nothing to commit."
  exit 0
fi

git add -A
git status --short
git commit -m "$1"
git push
