#!/usr/bin/env bash
set -euo pipefail
OWNER_REPO="${1:?Usage: $0 owner/repo tag}"
TAG="${2:?Usage: $0 owner/repo tag}"
REF_TYPE=$(gh api "repos/${OWNER_REPO}/git/ref/tags/${TAG}" --jq '.object.type' 2>/dev/null || echo "")
if [ "$REF_TYPE" = "tag" ]; then
  SHA=$(gh api "repos/${OWNER_REPO}/git/tags/${TAG}" --jq '.object.sha' 2>/dev/null || \
        gh api "repos/${OWNER_REPO}/git/ref/tags/${TAG}^{}/" --jq '.object.sha')
else
  SHA=$(gh api "repos/${OWNER_REPO}/git/ref/tags/${TAG}" --jq '.object.sha')
fi
echo "${SHA}  # ${TAG}"
