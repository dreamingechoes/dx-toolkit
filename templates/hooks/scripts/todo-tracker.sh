#!/usr/bin/env bash
# todo-tracker.sh — Flag new TODO/FIXME/HACK comments without issue links
# Runs as a PostToolUse hook after file edit/create operations
#
# Warns when TODO/FIXME/HACK comments are added without referencing
# an issue number (e.g., TODO(#123): ...).

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)

if [[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]]; then
  exit 0
fi

FILENAME=$(basename "$FILE_PATH")

# Skip non-source files
case "$FILENAME" in
  *.md|*.txt|*.json|*.yml|*.yaml|*.lock|*.toml)
    exit 0
    ;;
esac

# Find TODOs/FIXMEs without issue references
# Matches: TODO, FIXME, HACK, XXX — but not ones with (#123) or (#issue-number)
UNLINKED=$(grep -nEi '(TODO|FIXME|HACK|XXX)(\([^#)]*\))?[[:space:]]*:' "$FILE_PATH" 2>/dev/null | grep -viE '(TODO|FIXME|HACK|XXX)\(#[0-9]+' || true)

if [[ -n "$UNLINKED" ]]; then
  COUNT=$(echo "$UNLINKED" | wc -l | tr -d ' ')
  echo ""
  echo "📝 Found $COUNT TODO/FIXME comment(s) in $FILENAME without issue links:"
  echo "$UNLINKED" | head -5
  echo ""
  echo "   Tip: Link TODOs to issues → TODO(#123): description"
  echo "   This makes them trackable and prevents them from going stale."
fi

exit 0
