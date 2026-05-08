#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${1:-$(pwd)}"
COMMIT_MESSAGE="${2:-chore: update repository}"

git_cmd() {
  git -c safe.directory="${REPO_ROOT}" -C "${REPO_ROOT}" "$@"
}

current_branch="$(git_cmd branch --show-current)"
if [ -z "${current_branch}" ]; then
  echo "unable to determine current branch" >&2
  exit 1
fi

git_cmd status --short
git_cmd add -A

if ! git_cmd diff --cached --quiet; then
  git_cmd commit -m "${COMMIT_MESSAGE}"
else
  echo "no staged changes to commit"
fi

git_cmd push origin "${current_branch}"
