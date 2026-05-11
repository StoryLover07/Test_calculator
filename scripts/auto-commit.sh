#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

if [ -z "$(git status --porcelain)" ]; then
  echo "No changes to commit."
  exit 0
fi

if ! git config user.name >/dev/null || ! git config user.email >/dev/null; then
  echo "Git user.name and user.email must be configured before auto-commit can run."
  exit 1
fi

timestamp="$(date '+%Y-%m-%d %H:%M:%S %Z')"
branch="$(git branch --show-current)"

git add -A
git commit -m "Auto-commit: ${timestamp}"

if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
  git push
elif git remote get-url origin >/dev/null 2>&1; then
  git push -u origin "$branch"
else
  echo "Committed locally. Add a GitHub remote named origin to enable automatic pushes."
fi
