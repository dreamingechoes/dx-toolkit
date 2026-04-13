#!/usr/bin/env bash
# guard-protected-files.sh — Require confirmation before editing protected files
# Prevents the agent from modifying lockfiles, CI configs, and other
# sensitive files without explicit user approval.

set -euo pipefail

INPUT=$(cat)

# Extract the file path from the tool input
FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# List of protected file patterns
PROTECTED_PATTERNS=(
  "package-lock.json"
  "yarn.lock"
  "pnpm-lock.yaml"
  "mix.lock"
  "Gemfile.lock"
  "poetry.lock"
  ".env"
  ".env.local"
  ".env.production"
  "*.pem"
  "*.key"
)

FILENAME=$(basename "$FILE_PATH")

for PATTERN in "${PROTECTED_PATTERNS[@]}"; do
  case "$FILENAME" in
    $PATTERN)
      # Request user confirmation via the hook output
      cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "This file ($FILENAME) is protected. Please confirm you want the agent to modify it."
  }
}
EOF
      exit 0
      ;;
  esac
done

exit 0
