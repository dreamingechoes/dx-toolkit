#!/usr/bin/env bash
# large-dependency-guard.sh — Require confirmation before adding dependencies
# Runs as a PreToolUse hook before edits to package manifest files
#
# Adding dependencies increases bundle size, attack surface, and maintenance
# burden. This hook asks for confirmation when modifying dependency manifests.

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

FILENAME=$(basename "$FILE_PATH")

PROTECTED=false
case "$FILENAME" in
  package.json)
    PROTECTED=true ;;
  Gemfile)
    PROTECTED=true ;;
  mix.exs)
    PROTECTED=true ;;
  Cargo.toml)
    PROTECTED=true ;;
  go.mod)
    PROTECTED=true ;;
  requirements.txt|pyproject.toml)
    PROTECTED=true ;;
  build.gradle|build.gradle.kts)
    PROTECTED=true ;;
  Podfile)
    PROTECTED=true ;;
esac

if [[ "$PROTECTED" == "true" ]]; then
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "📦 Adding or changing dependencies in $FILENAME. Confirm this is necessary — every dependency adds to bundle size, attack surface, and maintenance burden."
  }
}
EOF
fi

exit 0
