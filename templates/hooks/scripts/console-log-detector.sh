#!/usr/bin/env bash
# console-log-detector.sh — Warn about debug statements after edits
# Runs as a PostToolUse hook after file edit/create operations
#
# Detects console.log, debugger, binding.pry, IEx.pry, print() debug
# statements and similar patterns that shouldn't ship to production.

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)

if [[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]]; then
  exit 0
fi

EXTENSION="${FILE_PATH##*.}"
FILENAME=$(basename "$FILE_PATH")
FOUND=false
WARNINGS=""

case "$EXTENSION" in
  ts|tsx|js|jsx|mts|cts)
    # JavaScript/TypeScript: console.log, console.debug, debugger
    if grep -nE '^\s*(console\.(log|debug|warn|info|trace|dir)\(|debugger\b)' "$FILE_PATH" 2>/dev/null; then
      WARNINGS="console.log/debugger statements"
      FOUND=true
    fi
    ;;
  py)
    # Python: print(), breakpoint(), pdb
    if grep -nE '^\s*(print\(|breakpoint\(\)|import pdb|pdb\.set_trace\(\))' "$FILE_PATH" 2>/dev/null; then
      WARNINGS="print()/breakpoint() statements"
      FOUND=true
    fi
    ;;
  ex|exs)
    # Elixir: IO.inspect, IEx.pry, dbg()
    if grep -nE '^\s*(IO\.inspect|IEx\.pry|dbg\()' "$FILE_PATH" 2>/dev/null; then
      WARNINGS="IO.inspect/IEx.pry/dbg() statements"
      FOUND=true
    fi
    ;;
  rb)
    # Ruby: puts, pp, binding.pry, byebug
    if grep -nE '^\s*(puts |pp |binding\.(pry|irb)|byebug\b)' "$FILE_PATH" 2>/dev/null; then
      WARNINGS="puts/binding.pry statements"
      FOUND=true
    fi
    ;;
  go)
    # Go: fmt.Println used for debugging
    if grep -nE '^\s*fmt\.(Println|Printf|Print)\(' "$FILE_PATH" 2>/dev/null; then
      WARNINGS="fmt.Println debug statements"
      FOUND=true
    fi
    ;;
  rs)
    # Rust: println!, dbg!
    if grep -nE '^\s*(println!|dbg!)\(' "$FILE_PATH" 2>/dev/null; then
      WARNINGS="println!/dbg! macros"
      FOUND=true
    fi
    ;;
esac

if [[ "$FOUND" == "true" ]]; then
  echo ""
  echo "⚠️  Debug statements detected in $FILENAME: $WARNINGS"
  echo "   Remove before committing or mark with // KEEP if intentional."
fi

exit 0
