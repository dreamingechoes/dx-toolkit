#!/usr/bin/env bash
# format-on-edit.sh — Auto-format files after agent edits
# Detects the file type and runs the appropriate formatter
#
# This hook receives JSON on stdin from the PostToolUse event.
# It extracts the file path and runs the project's formatter.

set -euo pipefail

# Read the PostToolUse event from stdin
INPUT=$(cat)

# Extract the file path from the tool input (edit operations)
FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)

if [[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]]; then
  exit 0
fi

EXTENSION="${FILE_PATH##*.}"

case "$EXTENSION" in
  ex|exs)
    if command -v mix &>/dev/null && [[ -f "mix.exs" ]]; then
      mix format "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  ts|tsx|js|jsx|mts|cts|json|css|scss|md|yaml|yml)
    if command -v npx &>/dev/null; then
      if [[ -f ".prettierrc" || -f ".prettierrc.json" || -f ".prettierrc.js" || -f "prettier.config.js" ]]; then
        npx prettier --write "$FILE_PATH" 2>/dev/null || true
      fi
    fi
    ;;
  py)
    if command -v ruff &>/dev/null; then
      ruff format "$FILE_PATH" 2>/dev/null || true
    elif command -v black &>/dev/null; then
      black --quiet "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  rs)
    if command -v rustfmt &>/dev/null; then
      rustfmt "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  go)
    if command -v gofmt &>/dev/null; then
      gofmt -w "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
esac

exit 0
