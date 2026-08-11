#!/usr/bin/env bash
# Commits and pushes changes under content/ so the published site follows what
# you write, without touching git yourself.
#
# Editor-agnostic on purpose: obsidian-git can't drive this repo, because it
# assumes the git repo sits *inside* the vault, and here the vault (content/)
# sits inside the repo. Syncing at the git level sidesteps that entirely and
# works the same whether you wrote the note in Obsidian, on GitHub, or in vim.
#
# Run by hand, or on a timer via the LaunchAgent in scripts/autosync.plist.
# Logs to ~/Library/Logs/garden-autosync.log.

set -uo pipefail

REPO="$HOME/Digital Garden"
LOG="$HOME/Library/Logs/garden-autosync.log"
LOCK="/tmp/garden-autosync.lock"

log() { printf '%s  %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >>"$LOG"; }

mkdir -p "$(dirname "$LOG")"

# Never let two runs overlap — a slow push must not race the next tick.
if ! mkdir "$LOCK" 2>/dev/null; then
  exit 0
fi
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

cd "$REPO" || { log "ERROR: $REPO not found"; exit 1; }

# Nothing staged or unstaged under content/ means nothing to publish. Note that
# content/private/ is gitignored, so edits there never trigger a sync — which is
# the point of that folder.
if [ -z "$(git status --porcelain -- content/)" ]; then
  exit 0
fi

FILES=$(git status --porcelain -- content/ | wc -l | tr -d ' ')
log "detected $FILES changed file(s) under content/"

git add -- content/ || { log "ERROR: git add failed"; exit 1; }

if git diff --cached --quiet; then
  log "nothing staged after add; skipping"
  exit 0
fi

SUMMARY=$(git diff --cached --name-only | sed 's|^content/||' | head -3 | paste -sd', ' -)
[ "$FILES" -gt 3 ] && SUMMARY="$SUMMARY and $((FILES - 3)) more"

if ! git commit -q -m "notes: $SUMMARY"; then
  log "ERROR: commit failed"
  exit 1
fi
log "committed: $SUMMARY"

# Push failures are usually transient (offline, laptop asleep). Leave the commit
# in place; the next run pushes it along with whatever else accumulated.
if git push -q origin main 2>>"$LOG"; then
  log "pushed — Cloudflare will rebuild in ~2 min"
else
  log "WARN: push failed, commit is local; will retry next run"
  exit 1
fi
