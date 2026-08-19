#!/usr/bin/env bash
# scripts/push.sh — ships the work: commits, tags and neoplugin.zip on the Release.
#
# This is the FALLBACK PATH for when CI cannot publish (Actions quota exhausted, payment
# declined, GitHub Actions down). Day to day, packaging and publishing is CI's job
# (.github/workflows/release-zip.yml) — this script does the SAME work, on your machine.
#
# Usage:  ./scripts/push.sh
#
# Order: git push → git push of this version's tag → zip → publish/update the Release.
# The expensive checks (gh authenticated, clean tree, tag present) run BEFORE anything is
# pushed, so the script fails without leaving half the work out there.
#
# Requires: `gh` authenticated with write access to the repo
#   gh auth login
set -euo pipefail

ROOT="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
ZIP="neoplugin.zip"

log()  { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
ok()   { printf '    \033[0;32m✓\033[0m %s\n' "$*"; }
die()  { printf '\n\033[0;31m!! %s\033[0m\n' "$*" >&2; exit 1; }

TAG_VERSION="$(cat "$ROOT/VERSION" 2>/dev/null)" && [[ -n "$TAG_VERSION" ]] \
  || die "VERSION missing in $ROOT"
TAG="v${TAG_VERSION}"

# --- 0. checks, all of them before anything is pushed -----------------------

# A dirty tree means the zip would not match the tag. commit.sh is what closes a version;
# this script only publishes it.
[[ -z "$(git -C "$ROOT" status --porcelain)" ]] \
  || die "uncommitted changes — close the version with ./scripts/commit.sh before publishing"

# The tag has to exist: it names the Release, and the link
# /releases/latest/download/neoplugin.zip depende.
git -C "$ROOT" rev-parse "$TAG" >/dev/null 2>&1 \
  || die "tag ${TAG} does not exist — commit.sh creates it alongside the release commit"

command -v gh >/dev/null 2>&1 || die "gh (GitHub CLI) is not installed — https://cli.github.com"
command -v zip >/dev/null 2>&1 || die "zip is not installed (apt install zip / brew install zip)"

# A REAL credential check: a query against the repo, not a grep in a config file.
log "conferindo credencial do GitHub"
gh repo view --json name >/dev/null 2>&1 || die \
"no access to the repository through gh.
    Autentique com:
        gh auth login"
ok "credencial ok"

# --- 1. git -----------------------------------------------------------------
log "git push"
git -C "$ROOT" push
# ONLY this version's tag, not `--tags`.
#
# `--tags` pushes EVERY pending tag at once, and each one triggers a CI job. That is
# how the "Latest" label ended up on the wrong version on 2026-08-17: two tags went up
# together, the jobs ran in parallel, and the one for the LOWER version finished 5 seconds
# later. One tag per release, and each publication happens alone and in order.
log "git push da tag ${TAG}"
git -C "$ROOT" push origin "$TAG"

# --- 2. o zip ---------------------------------------------------------------
# SAME layout as CI: the plugin's files at the ROOT of the zip (.claude-plugin/, skills/,
# .mcp.json, READMEs, LICENSE, VERSION), without the repository cruft. Diverging here changes
# what the subscriber installs — which is why the exclusion list matches the workflow's.
log "empacotando ${ZIP}"
cd "$ROOT"
rm -f "$ZIP"
zip -r "$ZIP" . -x '.git/*' '.github/*' 'scripts/*' "$ZIP" >/dev/null \
  || die "packaging failed — nothing was published"
ok "$(du -h "$ZIP" | cut -f1) em ${ZIP}"

# The zip is disposable: it is the Release's artifact, not the repository's. It goes even if
# publishing fails, so it never becomes a stray file the next `git status` reports.
trap 'rm -f "$ROOT/$ZIP"' EXIT

# --- 3. a Release -----------------------------------------------------------
# Idempotent like CI: it exists → just swap the asset; it does not → create it. One missing
# `--clobber` here and the Release would keep the previous version's zip, with no error at all.
#
# `--latest` is EXPLICIT on both paths. Without it GitHub picks on its own, and it picks
# pela DATA: em 2026-08-17 duas tags foram empurradas juntas, os jobs do CI rodaram em
# parallel, and v1.13.1 finished 5 seconds after v1.14.0 — taking the "Latest" label despite
# being the lower version. The bill lands on the link
# /releases/latest/download/neoplugin.zip: the dashboard and the README start serving the
# WRONG plugin, with no error showing anywhere.
log "publishing Release ${TAG}"
if gh release view "$TAG" >/dev/null 2>&1; then
  gh release upload "$TAG" "$ZIP" --clobber || die "could not update the asset on ${TAG}"
  gh release edit "$TAG" --latest >/dev/null || die "could not mark ${TAG} as Latest"
  ok "asset on ${TAG} updated and marked Latest"
else
  gh release create "$TAG" "$ZIP" \
    --title "$TAG" \
    --latest \
    --notes "NeoPlugin ${TAG} — install via Claude → Customize → Plugins → Add → Upload plugin." \
    || die "could not create Release ${TAG}"
  ok "Release ${TAG} created and marked Latest"
fi

log "done"
ok "https://github.com/neogoapp/NeoPlugin/releases/latest/download/${ZIP}"
