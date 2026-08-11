#!/usr/bin/env bash
# Sets up Quartz 5 in this folder and installs the pre-built garden scaffold.
# Run once:  bash setup.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

TMP=".quartz-clone-tmp"
SCAFFOLD="_scaffold"

info() { printf "\n\033[1;32m==>\033[0m %s\n" "$1"; }
warn() { printf "\n\033[1;33m!!\033[0m %s\n" "$1"; }
die()  { printf "\n\033[1;31mxx\033[0m %s\n" "$1" >&2; exit 1; }

# ---------------------------------------------------------------- prereqs ----
command -v git  >/dev/null || die "git not found. Install Xcode Command Line Tools: xcode-select --install"
command -v node >/dev/null || die "node not found. Install Node 22+ from https://nodejs.org"

NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]')"
[ "$NODE_MAJOR" -ge 22 ] || die "Quartz 5 needs Node 22 or newer. You have $(node -v)."

[ -d "$SCAFFOLD" ] || die "Missing $SCAFFOLD/ — run this script from the Digital Garden folder."

# ---------------------------------------------------------------- baseUrl ----
BASE_URL="${1:-}"
if [ -z "$BASE_URL" ]; then
  echo
  echo "What URL will the garden live at? (no https://, no trailing slash)"
  echo "Cloudflare Pages gives you <project>.pages.dev — you can change this later"
  echo "in quartz.config.yaml. Press Enter to accept the default."
  read -r -p "baseUrl [hjc-garden.pages.dev]: " BASE_URL || true
  BASE_URL="${BASE_URL:-hjc-garden.pages.dev}"
fi
BASE_URL="$(printf '%s' "$BASE_URL" | sed -e 's#^https\?://##' -e 's#/*$##')"
info "Using baseUrl: $BASE_URL"

# ------------------------------------------------------------------ clone ----
if [ -d ".git" ]; then
  warn "A git repo already exists here — skipping clone."
else
  info "Cloning Quartz…"
  rm -rf "$TMP"
  git clone --depth 1 https://github.com/jackyzha0/quartz.git "$TMP"

  # Prefer the v5 branch if it exists and isn't already the default.
  ( cd "$TMP"
    if ! grep -q '"version": *"5' package.json 2>/dev/null; then
      git remote set-branches origin '*' >/dev/null 2>&1 || true
      git fetch --depth 1 origin v5 >/dev/null 2>&1 && git checkout -q -B v5 origin/v5 || true
    fi )

  info "Moving Quartz into place…"
  shopt -s dotglob nullglob
  for f in "$TMP"/*; do
    name="$(basename "$f")"
    case "$name" in . | ..) continue ;; esac
    rm -rf "./$name"
    mv "$f" "./$name"
  done
  shopt -u dotglob nullglob
  rm -rf "$TMP"
fi

# --------------------------------------------------------------- install -----
info "Installing dependencies (this takes a minute)…"
npm i

info "Initializing Quartz with the Obsidian template…"
npx quartz create --template obsidian --strategy new --baseUrl "$BASE_URL"

# -------------------------------------------------------------- scaffold -----
info "Installing the garden content scaffold…"
rm -rf content
cp -R "$SCAFFOLD/content" content
mkdir -p scripts
cp "$SCAFFOLD/scripts/apply-garden-config.mjs" scripts/apply-garden-config.mjs

info "Applying garden configuration…"
node scripts/apply-garden-config.mjs "$BASE_URL"

info "Installing plugins referenced by the config…"
npx quartz plugin install --from-config || npx quartz plugin install --latest

# ----------------------------------------------------------------- build -----
info "Running a test build…"
npx quartz build

rm -rf "$SCAFFOLD"

cat <<EOF

──────────────────────────────────────────────────────────────
  Your digital garden is ready.

  Preview it:      npx quartz build --serve
                   then open http://localhost:8080

  Write in it:     open Obsidian → "Open folder as vault"
                   → choose:  $ROOT/content

  Publish it:      see START-HERE.md for the GitHub +
                   Cloudflare Pages steps.
──────────────────────────────────────────────────────────────

EOF
