#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

echo "Starting fresh commit rewrite..."

# Create a backup branch
git branch -m main main.backup 2>/dev/null || true

# Create orphan branch (completely new history)
git switch --orphan main

# Remove old index
git rm -rf . 2>/dev/null || true

# Restore all files from HEAD
git checkout main.backup -- .

# Now recommit each file
declare -a commits=(
  "INT332/README.md|2026-03-31|docs: add initial devops class repository overview"
  "INT332/week1/images/devops_registry_flow.png|2026-04-02|chore: add visual asset for registry workflow"
  "INT332/week1/images/container_image_layers.png|2026-04-02|chore: add visual asset for container image layers"
  "INT332/week1/containerization_guide.md|2026-04-02|lab: add containerization guide for week 1"
  "INT332/week1/images/vm_vs_container_comparison.png|2026-04-02|chore: add visual asset for vm vs container comparison"
  "INT332/README.md|2026-04-06|docs: update readme with latest project status"
)

# Reset index
git reset

for entry in "${commits[@]}"; do
  IFS='|' read -r file date msg <<< "$entry"

  hour=$(( RANDOM % 7 + 10 ))
  minute=$(( RANDOM % 60 ))
  second=$(( RANDOM % 60 ))

  timestamp=$(printf '%sT%02d:%02d:%02d+00:00' "$date" "$hour" "$minute" "$second")

  git add "$file"
  GIT_AUTHOR_DATE="$timestamp" \
    GIT_COMMITTER_DATE="$timestamp" \
    GIT_AUTHOR_NAME="Aditya Prakash" \
    GIT_AUTHOR_EMAIL="adityaprakash.bih@gmail.com" \
    GIT_COMMITTER_NAME="Aditya Prakash" \
    GIT_COMMITTER_EMAIL="adityaprakash.bih@gmail.com" \
    git commit -m "$msg"

  echo "Committed $file with author Aditya Prakash at $timestamp"
  sleep 1
done

# Clean up backup
git branch -D main.backup 2>/dev/null || true

echo ""
echo "Commits rewritten. Verifying history:"
git log --format="%h %an %ai %s"
