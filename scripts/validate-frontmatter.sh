#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# Validate frontmatter in agents, skills, prompts, and
# instruction files. Checks that required fields are present.
# ──────────────────────────────────────────────────────────────

set -euo pipefail

errors=0

# ── Helpers ───────────────────────────────────────────────────

has_frontmatter() {
  head -1 "$1" | grep -q '^---$'
}

frontmatter_has_field() {
  local file="$1"
  local field="$2"
  # Extract frontmatter (between first and second ---) and check for field
  awk '/^---$/{n++; next} n==1{print}' "$file" | grep -q "^${field}:"
}

report_missing() {
  local file="$1"
  local field="$2"
  echo "❌ Missing '$field' in frontmatter: $file"
  errors=$((errors + 1))
}

# ── Agents (.agent.md) ───────────────────────────────────────

echo "Checking agents..."
for file in templates/agents/*.agent.md; do
  [ -f "$file" ] || continue

  if ! has_frontmatter "$file"; then
    echo "❌ Missing frontmatter: $file"
    errors=$((errors + 1))
    continue
  fi

  frontmatter_has_field "$file" "name" || report_missing "$file" "name"
  frontmatter_has_field "$file" "description" || report_missing "$file" "description"
done

# ── Skills (SKILL.md) ────────────────────────────────────────

echo "Checking skills..."
for file in templates/skills/*/SKILL.md; do
  [ -f "$file" ] || continue

  if ! has_frontmatter "$file"; then
    echo "❌ Missing frontmatter: $file"
    errors=$((errors + 1))
    continue
  fi

  frontmatter_has_field "$file" "name" || report_missing "$file" "name"
  frontmatter_has_field "$file" "description" || report_missing "$file" "description"
done

# ── Prompts (.prompt.md) ─────────────────────────────────────

echo "Checking prompts..."
for file in templates/prompts/*.prompt.md; do
  [ -f "$file" ] || continue

  if ! has_frontmatter "$file"; then
    echo "❌ Missing frontmatter: $file"
    errors=$((errors + 1))
    continue
  fi

  frontmatter_has_field "$file" "description" || report_missing "$file" "description"
done

# ── Instructions (.instructions.md) ──────────────────────────

echo "Checking instructions..."
for file in templates/instructions/*.instructions.md; do
  [ -f "$file" ] || continue

  if ! has_frontmatter "$file"; then
    echo "❌ Missing frontmatter: $file"
    errors=$((errors + 1))
    continue
  fi

  has_apply_to=false
  has_description=false
  frontmatter_has_field "$file" "applyTo" && has_apply_to=true
  frontmatter_has_field "$file" "description" && has_description=true

  if [ "$has_apply_to" = false ] && [ "$has_description" = false ]; then
    echo "❌ Missing 'applyTo' or 'description' in frontmatter: $file"
    errors=$((errors + 1))
  fi
done

# ── Results ───────────────────────────────────────────────────

echo ""
if [ "$errors" -gt 0 ]; then
  echo "::error::Found $errors frontmatter validation error(s)"
  exit 1
fi
echo "✅ All frontmatter is valid"
