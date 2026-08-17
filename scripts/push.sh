#!/usr/bin/env bash
# scripts/push.sh — empurra o trabalho: commits, tags e o neoplugin.zip na Release.
#
# É o CAMINHO DE CONTORNO de quando o CI não pode publicar (cota de Actions esgotada,
# pagamento recusado, GitHub Actions fora). No dia a dia quem empacota e publica é o CI
# (.github/workflows/release-zip.yml) — este script faz o MESMO trabalho, na sua máquina.
#
# Uso:  ./scripts/push.sh
#
# Ordem: git push → git push --tags → zip → publicar/atualizar a Release.
# As checagens caras (gh autenticado, árvore limpa, tag existente) rodam ANTES de qualquer
# empurrão, para o script falhar sem ter deixado meio trabalho no ar.
#
# Pré-requisito: `gh` autenticado com permissão de escrita no repo
#   gh auth login
set -euo pipefail

RAIZ="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
ZIP="neoplugin.zip"

log()  { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
ok()   { printf '    \033[0;32m✓\033[0m %s\n' "$*"; }
die()  { printf '\n\033[0;31m!! %s\033[0m\n' "$*" >&2; exit 1; }

TAG_VERSAO="$(cat "$RAIZ/VERSION" 2>/dev/null)" && [[ -n "$TAG_VERSAO" ]] \
  || die "VERSION ausente em $RAIZ"
TAG="v${TAG_VERSAO}"

# --- 0. checagens, todas antes de empurrar qualquer coisa --------------------

# Árvore suja = o zip não corresponderia à tag. O commit.sh é quem fecha uma versão;
# este script só a publica.
[[ -z "$(git -C "$RAIZ" status --porcelain)" ]] \
  || die "há mudanças não commitadas — feche a versão com ./scripts/commit.sh antes de publicar"

# A tag precisa existir: é ela que nomeia a Release, e é dela que o link
# /releases/latest/download/neoplugin.zip depende.
git -C "$RAIZ" rev-parse "$TAG" >/dev/null 2>&1 \
  || die "a tag ${TAG} não existe — o commit.sh a cria junto do commit de release"

command -v gh >/dev/null 2>&1 || die "o gh (GitHub CLI) não está instalado — https://cli.github.com"
command -v zip >/dev/null 2>&1 || die "o zip não está instalado (apt install zip / brew install zip)"

# Verificação REAL de credencial: uma consulta ao repo, não um grep em arquivo de config.
log "conferindo credencial do GitHub"
gh repo view --json name >/dev/null 2>&1 || die \
"sem acesso ao repositório pelo gh.
    Autentique com:
        gh auth login"
ok "credencial ok"

# --- 1. git -----------------------------------------------------------------
log "git push"
git -C "$RAIZ" push
log "git push --tags"
git -C "$RAIZ" push --tags

# --- 2. o zip ---------------------------------------------------------------
# MESMA disposição do CI: os arquivos do plugin na RAIZ do zip (.claude-plugin/, skills/,
# .mcp.json, READMEs, LICENSE, VERSION), sem o cruft do repositório. Divergir daqui muda o
# que o assinante instala — é por isso que a lista de exclusão é a mesma do workflow.
log "empacotando ${ZIP}"
cd "$RAIZ"
rm -f "$ZIP"
zip -r "$ZIP" . -x '.git/*' '.github/*' 'scripts/*' "$ZIP" >/dev/null \
  || die "falha ao empacotar — nada foi publicado"
ok "$(du -h "$ZIP" | cut -f1) em ${ZIP}"

# O zip é descartável: ele é o artefato da Release, não do repositório. Sai daqui mesmo se
# a publicação falhar, para não virar arquivo solto que o próximo `git status` acusa.
trap 'rm -f "$RAIZ/$ZIP"' EXIT

# --- 3. a Release -----------------------------------------------------------
# Idempotente como o CI: existe → só troca o asset; não existe → cria. Um `--clobber` a
# menos aqui e a Release ficaria com o zip da versão anterior, sem erro nenhum.
log "publicando a Release ${TAG}"
if gh release view "$TAG" >/dev/null 2>&1; then
  gh release upload "$TAG" "$ZIP" --clobber || die "não consegui atualizar o asset da ${TAG}"
  ok "asset da ${TAG} atualizado"
else
  gh release create "$TAG" "$ZIP" \
    --title "$TAG" \
    --notes "NeoPlugin ${TAG} — instale via Claude → Customize → Plugins → Add → Upload plugin." \
    || die "não consegui criar a Release ${TAG}"
  ok "Release ${TAG} criada"
fi

log "pronto"
ok "https://github.com/neogoapp/NeoPlugin/releases/latest/download/${ZIP}"
