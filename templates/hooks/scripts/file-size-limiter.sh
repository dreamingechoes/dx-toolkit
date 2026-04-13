#!/usr/bin/env bash
# file-size-limiter.sh — Warn when files exceed a line threshold
# Runs as a PostToolUse hook after file edit/create operations
#
# Encourages modular code by flagging files that grow beyond 500 lines.
# Posts a warning — does not block.

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)

if [[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]]; then
  exit 0
fi

FILENAME=$(basename "$FILE_PATH")

# Skip non-source files and generated files
case "$FILENAME" in
  *.lock|*.min.js|*.min.css|*.map|*.svg|*.png|*.jpg|*.gif|*.ico|*.woff*|*.ttf|*.eot)
    exit 0
    ;;
esac

MAX_LINES=${DX_MAX_FILE_LINES:-500}
LINE_COUNT=$(wc -l < "$FILE_PATH" | tr -d ' ')

if [[ "$LINE_COUNT" -gt "$MAX_LINES" ]]; then
  echo ""
  echo "📏 $FILENAME is $LINE_COUNT lines (threshold: $MAX_LINES)."
  echo "   Consider splitting into smaller, focused modules."
  echo "   Override threshold: export DX_MAX_FILE_LINES=800"
fi

exit 0
