#!/usr/bin/env bash
set -euo pipefail

TARGET_VERSION="v3.75.1"

echo "Cloning trufflehog $TARGET_VERSION as benchmark target..."
rm -rf trufflehog-testdata
git clone --depth 1 --branch "$TARGET_VERSION" \
  https://github.com/trufflesecurity/trufflehog.git trufflehog-testdata

# Keep .git so the filesystem scan includes git object files, matching
# the timing profile of the original workflow.
echo "Cloned $(find trufflehog-testdata -type f | wc -l) files ($(du -sh trufflehog-testdata | cut -f1))"
