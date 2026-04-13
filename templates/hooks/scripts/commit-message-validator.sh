#!/usr/bin/env bash
# commit-message-validator.sh — Validate Conventional Commits format
# Runs as a PreToolUse hook before git commit operations
#
# This hook receives JSON on stdin from the PreToolUse event.
# It extracts the commit message and validates it against Conventional Commits spec.

set -euo pipefail

# Read the PreToolUse event from stdin
INPUT=$(cat)

# Check if this is a git commit operation
TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"tool_name"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)

# Only validate on git commit operations
if [[ "$TOOL_NAME" != *"commit"* && "$TOOL_NAME" != *"git"* ]]; then
  exit 0
fi

# Extract the commit message
COMMIT_MSG=$(echo "$INPUT" | grep -o '"message"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"message"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)

if [[ -z "$COMMIT_MSG" ]]; then
  exit 0
fi

# Conventional Commits pattern: type(optional-scope): description
# Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
PATTERN='^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-zA-Z0-9_-]+\))?(!)?: .{1,}'

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
  echo "⚠️  Commit message does not follow Conventional Commits format."
  echo ""
  echo "Expected: <type>(<optional-scope>): <description>"
  echo ""
  echo "Valid types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert"
  echo ""
  echo "Examples:"
  echo "  feat(auth): add OAuth2 login support"
  echo "  fix: resolve null pointer in user service"
  echo "  docs(readme): update installation instructions"
  echo "  feat!: drop support for Node 16"
  echo ""
  echo "Your message: $COMMIT_MSG"
  exit 1
fi

exit 0
