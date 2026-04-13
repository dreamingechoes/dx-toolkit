#!/usr/bin/env bash
# config-protector.sh — Block modifications to linter/formatter configs
# Runs as a PreToolUse hook before file edit operations
#
# Agents sometimes "fix" lint errors by weakening the rules instead of
# fixing the code. This hook asks for confirmation before modifying
# any linter, formatter, or build config files.

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

FILENAME=$(basename "$FILE_PATH")

# Protected config files — linters, formatters, build tools, CI
PROTECTED=false
case "$FILENAME" in
  .eslintrc*|eslint.config.*|.eslintignore)
    PROTECTED=true ;;
  .prettierrc*|prettier.config.*|.prettierignore)
    PROTECTED=true ;;
  tsconfig*.json|jsconfig*.json)
    PROTECTED=true ;;
  .stylelintrc*|stylelint.config.*)
    PROTECTED=true ;;
  .rubocop.yml|.rubocop_todo.yml)
    PROTECTED=true ;;
  .credo.exs|.formatter.exs)
    PROTECTED=true ;;
  pyproject.toml|setup.cfg|.flake8|.pylintrc|ruff.toml)
    PROTECTED=true ;;
  .golangci.yml|.golangci.yaml)
    PROTECTED=true ;;
  rustfmt.toml|clippy.toml|.clippy.toml)
    PROTECTED=true ;;
  biome.json|biome.jsonc)
    PROTECTED=true ;;
esac

if [[ "$PROTECTED" == "true" ]]; then
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "⚙️  $FILENAME is a linter/formatter config. Fix the code, not the rules. Only modify if you're intentionally changing project standards."
  }
}
EOF
fi

exit 0
