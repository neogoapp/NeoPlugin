#!/usr/bin/env bash
# scripts/commit.sh — commit with automatic version bump
#
# Usage:
#   ./scripts/commit.sh fix    "what the fix does"
#   ./scripts/commit.sh feat   "what the feature does"
#   ./scripts/commit.sh major  "what the major release does"
#   ./scripts/commit.sh docs   "description" (patch bump)
#   ./scripts/commit.sh chore  "description" (patch bump)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION_FILE="${REPO_DIR}/VERSION"

usage() {
  echo "Usage: $0 <fix|feat|major|docs|chore> <message>"
  exit 1
}

[[ $# -lt 2 ]] && usage

TYPE="$1"
MSG="$2"

# Read the current version
VERSION=$(cat "$VERSION_FILE")
MAJOR=$(echo "$VERSION" | cut -d. -f1)
MINOR=$(echo "$VERSION" | cut -d. -f2)
PATCH=$(echo "$VERSION" | cut -d. -f3)

case "$TYPE" in
  fix|security|debug)
    PATCH=$((PATCH + 1))
    PREFIX="fix"
    ;;
  feat|refactor)
    MINOR=$((MINOR + 1))
    PATCH=0
    PREFIX="$TYPE"
    ;;
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    PREFIX="feat"
    ;;
  docs|chore)
    PATCH=$((PATCH + 1))
    PREFIX="$TYPE"
    ;;
  *)
    echo "Unknown type: '$TYPE'. Use: fix|feat|major|docs|chore"
    exit 1
    ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
echo "$NEW_VERSION" > "$VERSION_FILE"

# Keep the plugin manifest version in sync
PLUGIN_JSON="${REPO_DIR}/.claude-plugin/plugin.json"
sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"${NEW_VERSION}\"/" "$PLUGIN_JSON"

git -C "$REPO_DIR" add "$VERSION_FILE" "$PLUGIN_JSON"
COMMIT_MSG="${PREFIX}(v${NEW_VERSION}): ${MSG}"

git -C "$REPO_DIR" commit -m "$COMMIT_MSG"

# Create the annotated tag
git -C "$REPO_DIR" tag -a "v${NEW_VERSION}" HEAD -m "Release v${NEW_VERSION}"
echo "Tag created: v${NEW_VERSION}"

echo "Commit: ${COMMIT_MSG}"
