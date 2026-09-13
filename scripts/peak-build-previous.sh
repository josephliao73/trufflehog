#!/usr/bin/env bash
set -euo pipefail

PREV_TAG=$(cat .peak-previous-tag 2>/dev/null | tr -d '[:space:]')

if [ -z "$PREV_TAG" ]; then
  echo "No previous tag in .peak-previous-tag — querying upstream..."
  PREV_TAG=$(gh release list \
    --repo trufflesecurity/trufflehog \
    --limit 1 \
    --json tagName \
    --jq '.[0].tagName' \
    2>/dev/null | tr -d '[:space:]')
  echo "$PREV_TAG" > .peak-previous-tag
fi

if [ -z "$PREV_TAG" ]; then
  echo "ERROR: could not determine previous release tag (is gh authenticated?)"
  exit 1
fi

echo "Building previous binary from $PREV_TAG..."

TMP=$(mktemp -d)
git archive "$PREV_TAG" | tar -x -C "$TMP"
cd "$TMP"
go build -o "${GITHUB_WORKSPACE:-$OLDPWD}/previous" .

echo "Built: $(ls -lh "${GITHUB_WORKSPACE:-$OLDPWD}/previous" | awk '{print $5}')"
