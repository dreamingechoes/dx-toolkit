#!/usr/bin/env bash
# secret-scanner.sh — Scan for hardcoded secrets before writing files
# Runs as a PreToolUse hook before file edit/create operations
#
# This hook receives JSON on stdin from the PreToolUse event.
# It scans the content being written for potential secrets.

set -euo pipefail

# Read the PreToolUse event from stdin
INPUT=$(cat)

# Extract the content being written (from edit or create operations)
CONTENT=$(echo "$INPUT" | grep -o '"content"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"content"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)
NEW_STRING=$(echo "$INPUT" | grep -o '"newString"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"newString"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)

TEXT_TO_SCAN="${CONTENT}${NEW_STRING}"

if [[ -z "$TEXT_TO_SCAN" ]]; then
  exit 0
fi

# Patterns that indicate hardcoded secrets
FOUND_SECRETS=false

# AWS Access Key ID (starts with AKIA)
if echo "$TEXT_TO_SCAN" | grep -qE 'AKIA[0-9A-Z]{16}'; then
  echo "🔐 Potential AWS Access Key ID detected"
  FOUND_SECRETS=true
fi

# AWS Secret Access Key (40 character base64)
if echo "$TEXT_TO_SCAN" | grep -qE '["\x27][A-Za-z0-9/+=]{40}["\x27]' | grep -qi 'aws\|secret\|key'; then
  echo "🔐 Potential AWS Secret Key detected"
  FOUND_SECRETS=true
fi

# Generic API keys (common patterns)
if echo "$TEXT_TO_SCAN" | grep -qEi '(api[_-]?key|api[_-]?secret|access[_-]?token|auth[_-]?token|secret[_-]?key)[[:space:]]*[=:][[:space:]]*["\x27][A-Za-z0-9_\-]{20,}["\x27]'; then
  echo "🔐 Potential API key or token detected"
  FOUND_SECRETS=true
fi

# Private keys
if echo "$TEXT_TO_SCAN" | grep -q 'BEGIN.*PRIVATE KEY'; then
  echo "🔐 Private key detected"
  FOUND_SECRETS=true
fi

# GitHub tokens
if echo "$TEXT_TO_SCAN" | grep -qE '(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9_]{36,}'; then
  echo "🔐 GitHub token detected"
  FOUND_SECRETS=true
fi

# Slack tokens
if echo "$TEXT_TO_SCAN" | grep -qE 'xox[bpors]-[A-Za-z0-9-]+'; then
  echo "🔐 Slack token detected"
  FOUND_SECRETS=true
fi

# Generic password assignments
if echo "$TEXT_TO_SCAN" | grep -qEi 'password[[:space:]]*[=:][[:space:]]*["\x27][^"\x27]{8,}["\x27]'; then
  echo "🔐 Hardcoded password detected"
  FOUND_SECRETS=true
fi

# JWT tokens
if echo "$TEXT_TO_SCAN" | grep -qE 'eyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]+'; then
  echo "🔐 JWT token detected"
  FOUND_SECRETS=true
fi

if [[ "$FOUND_SECRETS" == "true" ]]; then
  echo ""
  echo "⚠️  Potential secrets detected in the content being written."
  echo "Use environment variables or a secrets manager instead of hardcoding credentials."
  echo ""
  echo "Suggestions:"
  echo "  - Use process.env.API_KEY (Node.js)"
  echo "  - Use os.environ['API_KEY'] (Python)"
  echo "  - Use System.get_env(\"API_KEY\") (Elixir)"
  echo "  - Use os.Getenv(\"API_KEY\") (Go)"
  echo "  - Reference GitHub Secrets in workflows: \${{ secrets.API_KEY }}"
  exit 1
fi

exit 0
