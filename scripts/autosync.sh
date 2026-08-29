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

# A stale index.lock (left behind by a crashed/interrupted git command — this
# has happened at least once and silently blocked every run for days, since
# git's error only ever reached this script's own log as "git add failed"
# with no detail) wedges every future run the same way. Our own mkdir-based
# LOCK above already rules out a *concurrent autosync.sh*; a lock older than
# one run interval is not a git command that's merely slow, it's abandoned.
# Confirm no git process is actually alive before touching it.
GIT_LOCK="$REPO/.git/index.lock"
if [ -e "$GIT_LOCK" ]; then
  LOCK_AGE=$(( $(date +%s) - $(stat -f %m "$GIT_LOCK" 2>/dev/null || echo 0) ))
  if [ "$LOCK_AGE" -gt 120 ] && ! pgrep -f "git.*Digital Garden" >/dev/null 2>&1; then
    rm -f "$GIT_LOCK"
    log "WARN: removed stale .git/index.lock (age ${LOCK_AGE}s, no live git process)"
  fi
fi

# Nothing staged or unstaged under content/ means nothing to publish. Note that
# content/private/ is gitignored, so edits there never trigger a sync — which is
# the point of that folder.
if [ -z "$(git status --porcelain -- content/)" ]; then
  exit 0
fi

FILES=$(git status --porcelain -- content/ | wc -l | tr -d ' ')
log "detected $FILES changed file(s) under content/"

ADD_ERR=$(git add -- content/ 2>&1) || { log "ERROR: git add failed: $ADD_ERR"; exit 1; }

if git diff --cached --quiet; then
  log "nothing staged after add; skipping"
  exit 0
fi

SUMMARY=$(git diff --cached --name-only | sed 's|^content/||' | head -3 | paste -sd', ' -)
[ "$FILES" -gt 3 ] && SUMMARY="$SUMMARY and $((FILES - 3)) more"

COMMIT_ERR=$(git commit -q -m "notes: $SUMMARY" 2>&1) || { log "ERROR: commit failed: $COMMIT_ERR"; exit 1; }
log "committed: $SUMMARY"

# Push failures are usually transient (offline, laptop asleep). Leave the commit
# in place; the next run pushes it along with whatever else accumulated.
if git push -q origin main 2>>"$LOG"; then
  log "pushed — Cloudflare will rebuild in ~2 min"
else
  log "WARN: push failed, commit is local; will retry next run"
  exit 1
fi
