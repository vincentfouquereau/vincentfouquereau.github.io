#!/usr/bin/env bash
#
# Déploiement de fouquereau.com sur GitHub Pages.
#
# Source   : ~/Projects/fouquereau-site/ (ce dépôt)
# Cible    : https://github.com/vincentfouquereau/vincentfouquereau.github.io (branche main)
# Domaine  : www.fouquereau.com (fichier CNAME conservé côté déploiement)
#
# Authentification (une des deux) :
#   - secret-tool lookup account vincentfouquereau service github.com
#   - variable d'environnement GH_TOKEN (PAT fine-grained, Contents: read/write)
#
# Usage : ./deploy.sh "message de commit"
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
REPO="https://github.com/vincentfouquereau/vincentfouquereau.github.io"
WORK="/tmp/fq-deploy"
MSG="${1:-Mise à jour du site}"

command -v git >/dev/null || { echo "git est requis"; exit 1; }

# --- Token (ordre : GH_TOKEN, ~/.gh_token, ~/gh_token, trousseau) ---
TOKEN="${GH_TOKEN:-}"
for f in "$HOME/.gh_token" "$HOME/gh_token"; do
  if [ -z "$TOKEN" ] && [ -f "$f" ]; then
    TOKEN="$(tr -d '[:space:]' < "$f")"
  fi
done
if [ -z "$TOKEN" ] && command -v secret-tool >/dev/null 2>&1; then
  TOKEN="$(secret-tool lookup account vincentfouquereau service github.com || true)"
fi
if [ -z "$TOKEN" ]; then
  echo "Erreur : aucun token. Exportez GH_TOKEN, créez ~/.gh_token, ou configurez secret-tool." >&2
  exit 1
fi

# --- Clone propre du dépôt de déploiement ---
rm -rf "$WORK"
git clone -q "$REPO" "$WORK"

# --- Synchronisation de la source (préserve CNAME et .git du dépôt cible) ---
if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete --exclude='.git/' --exclude='CNAME' "$SRC/" "$WORK/"
else
  echo "rsync absent : synchronisation simple via cp (CNAME non touché)."
  find "$WORK" -mindepth 1 -maxdepth 1 ! -name '.git' ! -name 'CNAME' -exec rm -rf {} +
  (cd "$SRC" && tar --exclude='./.git' -cf - .) | (cd "$WORK" && tar -xf -)
fi

# --- Commit ---
cd "$WORK"
git status --short
git config user.name "Vincent Fouquereau"
git config user.email "vincent@fouquereau.com"
git add -A
if git diff --cached --quiet; then
  echo "Aucun changement à déployer."
  exit 0
fi
git commit -q -m "$MSG"

# --- Push avec le token en écriture (ignore la config globale) ---
AUTH="AUTHORIZATION: Basic $(printf 'vincentfouquereau:%s' "$TOKEN" | base64 -w0)"
GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null \
  git -c http.https://github.com/.extraheader="$AUTH" push -q origin main

echo "Poussé. GitHub Pages reconstruit en ~45 s."
sleep 45
curl -sL https://www.fouquereau.com/ | grep -q 'lang-switch' \
  && echo "Vérification OK : www.fouquereau.com est à jour." \
  || echo "Attention : le contenu attendu n'a pas été détecté (réessayer dans 30 s)."
