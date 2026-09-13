#!/usr/bin/env bash
set -euo pipefail

TARGET_VERSION="v3.75.1"

echo "Cloning trufflehog $TARGET_VERSION as benchmark target..."
rm -rf trufflehog-testdata
git clone --depth 1 --branch "$TARGET_VERSION" \
  https://github.com/trufflesecurity/trufflehog.git trufflehog-testdata

# Drop .git — we only need source files for the benchmark scan, not history.
# This keeps the Peak cache entry small.
rm -rf trufflehog-testdata/.git

echo "Cloned $(find trufflehog-testdata -type f | wc -l) files"
