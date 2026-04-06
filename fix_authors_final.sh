#!/usr/bin/env bash
set -euo pipefail

export FILTER_BRANCH_SQUELCH_WARNING=1

cd "$(git rev-parse --show-toplevel)"

echo "Rewriting commit history with author: Aditya Prakash..."

git filter-branch -f --env-filter '
  if [ "$GIT_AUTHOR_NAME" = "DevOps Student" ] || [ -z "$GIT_AUTHOR_NAME" ]; then
    export GIT_AUTHOR_NAME="Aditya Prakash"
    export GIT_AUTHOR_EMAIL="adityaprakash.bih@gmail.com"
    export GIT_COMMITTER_NAME="Aditya Prakash"
    export GIT_COMMITTER_EMAIL="adityaprakash.bih@gmail.com"
  fi
' -- --all

echo "Author rewrite complete!"
git log --format="%h %an %s" -10
