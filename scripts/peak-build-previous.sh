#!/usr/bin/env bash
set -euo pipefail

PREV_TAG=$(cat .peak-previous-tag)
echo "Building previous binary from $PREV_TAG..."

TMP=$(mktemp -d)
# Extract source at the tag without changing the working tree.
git archive "$PREV_TAG" | tar -x -C "$TMP"
cd "$TMP"
go build -o "$GITHUB_WORKSPACE/previous" .

echo "Built: $(ls -lh "$GITHUB_WORKSPACE/previous" | awk '{print $5}')"
