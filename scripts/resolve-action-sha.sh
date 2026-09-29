#!/usr/bin/env bash
set -euo pipefail
OWNER_REPO="${1:?Usage: $0 owner/repo tag}"
TAG="${2:?Usage: $0 owner/repo tag}"
REF_TYPE=$(gh api "repos/${OWNER_REPO}/git/ref/tags/${TAG}" --jq '.object.type')
if [ "$REF_TYPE" = "tag" ]; then
  TAG_OBJ_SHA=$(gh api "repos/${OWNER_REPO}/git/ref/tags/${TAG}" --jq '.object.sha')
  SHA=$(gh api "repos/${OWNER_REPO}/git/tags/${TAG_OBJ_SHA}" --jq '.object.sha')
else
  SHA=$(gh api "repos/${OWNER_REPO}/git/ref/tags/${TAG}" --jq '.object.sha')
fi
echo "${SHA}  # ${TAG}"
