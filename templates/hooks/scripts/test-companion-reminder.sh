#!/usr/bin/env bash
# test-companion-reminder.sh — Remind to create tests for new source files
# Runs as a PostToolUse hook after file create operations
#
# When a new source file is created, checks if a corresponding test file
# exists. If not, reminds the developer to add tests.

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)

if [[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]]; then
  exit 0
fi

FILENAME=$(basename "$FILE_PATH")
DIRNAME=$(dirname "$FILE_PATH")
NAME_NO_EXT="${FILENAME%.*}"
EXTENSION="${FILENAME##*.}"

# Skip if this IS a test file
case "$FILENAME" in
  *.test.*|*.spec.*|*_test.*|*_spec.*|test_*.*|spec_*.*)
    exit 0
    ;;
esac

# Skip non-source files
case "$EXTENSION" in
  md|txt|json|yml|yaml|toml|lock|css|scss|svg|png|jpg|gif|ico|html|xml)
    exit 0
    ;;
esac

# Check for common test file locations
TEST_EXISTS=false

# Same directory patterns
for PATTERN in "${NAME_NO_EXT}.test.${EXTENSION}" "${NAME_NO_EXT}.spec.${EXTENSION}" "${NAME_NO_EXT}_test.${EXTENSION}" "test_${NAME_NO_EXT}.${EXTENSION}"; do
  if [[ -f "${DIRNAME}/${PATTERN}" ]]; then
    TEST_EXISTS=true
    break
  fi
done

# __tests__ directory
if [[ "$TEST_EXISTS" == "false" && -d "${DIRNAME}/__tests__" ]]; then
  for PATTERN in "${NAME_NO_EXT}.test.${EXTENSION}" "${NAME_NO_EXT}.spec.${EXTENSION}"; do
    if [[ -f "${DIRNAME}/__tests__/${PATTERN}" ]]; then
      TEST_EXISTS=true
      break
    fi
  done
fi

# test/ directory at same level
if [[ "$TEST_EXISTS" == "false" && -d "${DIRNAME}/test" ]]; then
  for PATTERN in "${NAME_NO_EXT}_test.${EXTENSION}" "test_${NAME_NO_EXT}.${EXTENSION}" "${NAME_NO_EXT}.test.${EXTENSION}"; do
    if [[ -f "${DIRNAME}/test/${PATTERN}" ]]; then
      TEST_EXISTS=true
      break
    fi
  done
fi

if [[ "$TEST_EXISTS" == "false" ]]; then
  echo ""
  echo "🧪 No test file found for $FILENAME"
  echo "   Consider adding tests — e.g., ${NAME_NO_EXT}.test.${EXTENSION}"
fi

exit 0
