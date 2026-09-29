#!/usr/bin/env bash
set -euo pipefail
OWNER_REPO="${1:?Usage: $0 owner/repo tag}"
TAG="${2:?Usage: $0 owner/repo tag}"
REF_TYPE=$(gh api "repos/${OWNER_REPO}/git/ref/tags/${TAG}" --jq '.object.type')
if [ "$REF_TYPE" = "tag" ]; then
  # Annotated tag: dereference the tag object to the commit it points to.
  TAG_OBJ_SHA=$(gh api "repos/${OWNER_REPO}/git/ref/tags/${TAG}" --jq '.object.sha')
  SHA=$(gh api "repos/${OWNER_REPO}/git/tags/${TAG_OBJ_SHA}" --jq '.object.sha')
else
  # Lightweight tag: the ref already points at the commit.
  SHA=$(gh api "repos/${OWNER_REPO}/git/ref/tags/${TAG}" --jq '.object.sha')
fi
echo "${SHA}  # ${TAG}"
