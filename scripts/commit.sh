#!/usr/bin/env bash
# scripts/commit.sh — commit com bump automático de versão
#
# Uso:
#   ./scripts/commit.sh fix    "descrição do fix"
#   ./scripts/commit.sh feat   "descrição da feature"
#   ./scripts/commit.sh major  "descrição da major release"
#   ./scripts/commit.sh docs   "descrição" (bump patch)
#   ./scripts/commit.sh chore  "descrição" (bump patch)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION_FILE="${REPO_DIR}/VERSION"

usage() {
  echo "Uso: $0 <fix|feat|major|docs|chore> <mensagem>"
  exit 1
}

[[ $# -lt 2 ]] && usage

TYPE="$1"
MSG="$2"

# Ler versão atual
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
    echo "Tipo desconhecido: '$TYPE'. Use: fix|feat|major|docs|chore"
    exit 1
    ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
echo "$NEW_VERSION" > "$VERSION_FILE"

# Manter versão do manifesto do plugin em sincronia
PLUGIN_JSON="${REPO_DIR}/.claude-plugin/plugin.json"
sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"${NEW_VERSION}\"/" "$PLUGIN_JSON"

git -C "$REPO_DIR" add "$VERSION_FILE" "$PLUGIN_JSON"
COMMIT_MSG="${PREFIX}(v${NEW_VERSION}): ${MSG}"

git -C "$REPO_DIR" commit -m "$COMMIT_MSG"

# Criar tag anotada
git -C "$REPO_DIR" tag -a "v${NEW_VERSION}" HEAD -m "Release v${NEW_VERSION}"
echo "Tag criada: v${NEW_VERSION}"

echo "Commit: ${COMMIT_MSG}"
