#!/usr/bin/env bash
set -euo pipefail

PREV_TAG=$(cat .peak-previous-tag 2>/dev/null | tr -d '[:space:]')

if [ -z "$PREV_TAG" ]; then
  echo "No previous tag in .peak-previous-tag — fetching from remote..."
  git fetch --tags --quiet
  PREV_TAG=$(git tag -l --sort=-v:refname | head -n 1 | tr -d '[:space:]')
  echo "$PREV_TAG" > .peak-previous-tag
fi

if [ -z "$PREV_TAG" ]; then
  echo "ERROR: no release tags found in this repository"
  exit 1
fi

echo "Building previous binary from $PREV_TAG..."

TMP=$(mktemp -d)
git archive "$PREV_TAG" | tar -x -C "$TMP"
cd "$TMP"
go build -o "${GITHUB_WORKSPACE:-$OLDPWD}/previous" .

echo "Built: $(ls -lh "${GITHUB_WORKSPACE:-$OLDPWD}/previous" | awk '{print $5}')"
