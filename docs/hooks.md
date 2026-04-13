# 🪝 Hooks

Hooks intercept Copilot's tool calls to run custom scripts — either before a tool executes (to block or validate) or after (to format or post-process). They act as automated quality gates without manual intervention.

**Location**: `templates/hooks/*.json` (configs) + `templates/hooks/scripts/` (scripts)

## How Hooks Work

```
Copilot decides to edit a file
  → PreToolUse hook fires (guard-protected-files)
    → Script checks if the file is protected
    → If protected: asks for confirmation before proceeding
    → If allowed: tool executes normally
  → PostToolUse hook fires (format-on-edit)
    → Script detects file type
    → Runs the appropriate formatter
    → File is saved with correct formatting
```

### Hook Anatomy

**Config file** (`.json`):

```json
{
  "hooks": [
    {
      "event": "PostToolUse",
      "tools": ["insert_edit_into_file", "replace_string_in_file"],
      "script": ".github/hooks/scripts/my-script.sh",
      "permissionDecision": "allow"
    }
  ]
}
```

**Event types**:

- `PreToolUse` — Runs before the tool. Can block execution.
- `PostToolUse` — Runs after the tool. Can post-process results.

**Permission decisions** (for `PreToolUse`):

- `"allow"` — Silently allow the tool to proceed
- `"deny"` — Silently block the tool
- `"ask"` — Prompt the user for confirmation

---

## Available Hooks

### 🎨 Format on Edit (`format-on-edit`)

**Event**: `PostToolUse` — runs after every file edit

**What it does**: Automatically formats files after Copilot edits them, using the appropriate formatter for each language.

**Supported formatters**:

| File Type                                                     | Formatter      | Fallback |
| ------------------------------------------------------------- | -------------- | -------- |
| `.ex`, `.exs`                                                 | `mix format`   | —        |
| `.ts`, `.tsx`, `.js`, `.jsx`, `.css`, `.scss`, `.json`, `.md` | `npx prettier` | —        |
| `.py`                                                         | `ruff format`  | `black`  |
| `.rs`                                                         | `rustfmt`      | —        |
| `.go`                                                         | `gofmt`        | —        |

**Config** (`.github/hooks/format-on-edit.json`):

```json
{
  "hooks": [
    {
      "event": "PostToolUse",
      "tools": ["insert_edit_into_file", "replace_string_in_file", "create_file"],
      "script": ".github/hooks/scripts/format-on-edit.sh",
      "permissionDecision": "allow"
    }
  ]
}
```

**Behavior**:

- Detects file extension from the tool's output
- Runs the matching formatter silently
- If the formatter isn't installed, skips gracefully (no error)
- Adds no latency for unrecognized file types

---

### 🔐 Guard Protected Files (`guard-protected-files`)

**Event**: `PreToolUse` — runs before any file edit

**What it does**: Prevents accidental edits to sensitive or auto-generated files by asking for confirmation.

**Protected patterns**:

| Pattern              | Examples                                                                                                    |
| -------------------- | ----------------------------------------------------------------------------------------------------------- |
| Lock files           | `package-lock.json`, `yarn.lock`, `mix.lock`, `Gemfile.lock`, `poetry.lock`, `pnpm-lock.yaml`, `Cargo.lock` |
| Environment files    | `.env`, `.env.local`, `.env.production`                                                                     |
| Secrets/certificates | `*.pem`, `*.key`, `*.cert`, `*.p12`                                                                         |

**Config** (`.github/hooks/guard-protected-files.json`):

```json
{
  "hooks": [
    {
      "event": "PreToolUse",
      "tools": ["insert_edit_into_file", "replace_string_in_file", "create_file"],
      "script": ".github/hooks/scripts/guard-protected-files.sh",
      "permissionDecision": "ask"
    }
  ]
}
```

**Behavior**:

- Checks the target file path against protected patterns
- If the file matches: returns `"ask"` to prompt for confirmation
- If the file is safe: returns `"allow"` silently
- Never blocks — always gives you the choice

---

### 🔍 Console Log Detector (`console-log-detector`)

**Event**: `PostToolUse` — runs after every file edit

**What it does**: Warns about debug statements left in files — `console.log`, `debugger`, `IO.inspect`, `binding.pry`, `fmt.Println`, `println!`, and more.

**Supported languages**:

| Language | Detected Patterns                            |
| -------- | -------------------------------------------- |
| JS/TS    | `console.log`, `console.debug`, `debugger`   |
| Python   | `print()`, `breakpoint()`, `pdb.set_trace()` |
| Elixir   | `IO.inspect`, `IEx.pry`, `dbg()`             |
| Ruby     | `puts`, `pp`, `binding.pry`, `byebug`        |
| Go       | `fmt.Println`, `fmt.Printf`                  |
| Rust     | `println!`, `dbg!`                           |

**Config** (`.github/hooks/console-log-detector.json`):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "type": "command",
        "command": ".github/hooks/scripts/console-log-detector.sh",
        "timeout": 5,
        "description": "Warn about debug statements left in edited files"
      }
    ]
  }
}
```

---

### 📝 TODO Tracker (`todo-tracker`)

**Event**: `PostToolUse` — runs after every file edit

**What it does**: Flags `TODO`, `FIXME`, `HACK`, and `XXX` comments that don't reference an issue number. Encourages linking TODOs to issues so they're trackable.

**Config** (`.github/hooks/todo-tracker.json`):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "type": "command",
        "command": ".github/hooks/scripts/todo-tracker.sh",
        "timeout": 5,
        "description": "Flag TODOs without issue links"
      }
    ]
  }
}
```

**Behavior**:

- Scans source files for TODO/FIXME/HACK/XXX comments
- Ignores TODOs that reference issues: `TODO(#123): description`
- Skips markdown, JSON, YAML, and other non-source files
- Shows up to 5 unlinked TODOs per edit

---

### 📏 File Size Limiter (`file-size-limiter`)

**Event**: `PostToolUse` — runs after every file edit

**What it does**: Warns when a file exceeds 500 lines, encouraging modular code. The threshold is configurable via the `DX_MAX_FILE_LINES` environment variable.

**Config** (`.github/hooks/file-size-limiter.json`):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "type": "command",
        "command": ".github/hooks/scripts/file-size-limiter.sh",
        "timeout": 5,
        "description": "Warn when files exceed line threshold"
      }
    ]
  }
}
```

**Behavior**:

- Default threshold: 500 lines
- Override: `export DX_MAX_FILE_LINES=800`
- Skips binary, minified, and lock files

---

### 🧪 Test Companion Reminder (`test-companion-reminder`)

**Event**: `PostToolUse` — runs after file creation

**What it does**: Checks if a corresponding test file exists when a new source file is created. If not, reminds you to add tests.

**Config** (`.github/hooks/test-companion-reminder.json`):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "type": "command",
        "command": ".github/hooks/scripts/test-companion-reminder.sh",
        "timeout": 5,
        "description": "Remind to create tests for new source files"
      }
    ]
  }
}
```

**Behavior**:

- Checks for `*.test.*`, `*.spec.*`, `*_test.*` in the same directory, `__tests__/`, and `test/`
- Skips when the file being created IS a test file
- Skips non-source files (markdown, JSON, YAML, CSS, etc.)

---

### ⚙️ Config Protector (`config-protector`)

**Event**: `PreToolUse` — runs before file edits

**What it does**: Asks for confirmation before modifying linter, formatter, or build config files. Agents sometimes "fix" lint errors by weakening the rules — this hook catches that.

**Protected files**: `.eslintrc*`, `.prettierrc*`, `tsconfig*.json`, `.rubocop.yml`, `.credo.exs`, `pyproject.toml`, `.golangci.yml`, `rustfmt.toml`, `biome.json`, and more.

**Config** (`.github/hooks/config-protector.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "type": "command",
        "command": ".github/hooks/scripts/config-protector.sh",
        "timeout": 5,
        "description": "Require confirmation before modifying linter/formatter configs"
      }
    ]
  }
}
```

---

### 📦 Large Dependency Guard (`large-dependency-guard`)

**Event**: `PreToolUse` — runs before file edits

**What it does**: Asks for confirmation before modifying package manifest files (`package.json`, `Gemfile`, `mix.exs`, `Cargo.toml`, `go.mod`, etc.). Every dependency adds to bundle size, attack surface, and maintenance burden.

**Config** (`.github/hooks/large-dependency-guard.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "type": "command",
        "command": ".github/hooks/scripts/large-dependency-guard.sh",
        "timeout": 5,
        "description": "Require confirmation before adding dependencies"
      }
    ]
  }
}
```

---

## Creating Custom Hooks

### Step 1: Create the Script

```bash
#!/bin/bash
# .github/hooks/scripts/my-hook.sh

# Hook scripts receive context via environment variables:
# - Tool name and arguments are available in the hook context

# Your logic here
echo "allow"  # or "deny" or "ask"
```

Make it executable:

```bash
chmod +x .github/hooks/scripts/my-hook.sh
```

### Step 2: Create the Config

```json
{
  "hooks": [
    {
      "event": "PreToolUse",
      "tools": ["insert_edit_into_file"],
      "script": ".github/hooks/scripts/my-hook.sh",
      "permissionDecision": "ask"
    }
  ]
}
```

### Step 3: Test

Edit a file that should trigger the hook and verify the behavior.

---

## Hook Recipes

Ready-to-copy recipes for common use cases. Each recipe includes the config file and script.

### Auto-Lint After Edits

Run ESLint (or your linter) after every file edit to catch issues immediately:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "type": "command",
        "command": ".github/hooks/scripts/auto-lint.sh",
        "timeout": 15,
        "description": "Run linter after file edits"
      }
    ]
  }
}
```

```bash
#!/usr/bin/env bash
set -euo pipefail
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)
[[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]] && exit 0

case "${FILE_PATH##*.}" in
  ts|tsx|js|jsx) npx eslint --fix "$FILE_PATH" 2>/dev/null || true ;;
  ex|exs) mix credo "$FILE_PATH" 2>/dev/null || true ;;
  py) ruff check --fix "$FILE_PATH" 2>/dev/null || true ;;
  rb) rubocop -A "$FILE_PATH" 2>/dev/null || true ;;
esac
exit 0
```

### Auto-Run Related Tests

Run tests for the file you just edited:

```bash
#!/usr/bin/env bash
set -euo pipefail
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)
[[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]] && exit 0

NAME_NO_EXT="${FILE_PATH%.*}"
EXT="${FILE_PATH##*.}"

# Check for co-located test file
for TEST in "${NAME_NO_EXT}.test.${EXT}" "${NAME_NO_EXT}.spec.${EXT}" "${NAME_NO_EXT}_test.${EXT}"; do
  if [[ -f "$TEST" ]]; then
    case "$EXT" in
      ts|tsx|js|jsx) npx vitest run "$TEST" --reporter=verbose 2>/dev/null || true ;;
      py) python -m pytest "$TEST" -v 2>/dev/null || true ;;
      ex|exs) mix test "$TEST" 2>/dev/null || true ;;
    esac
    break
  fi
done
exit 0
```

### Branch Protector

Block edits when on `main` or `production` branches:

```bash
#!/usr/bin/env bash
set -euo pipefail
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
case "$BRANCH" in
  main|master|production|staging)
    cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "You're on the $BRANCH branch. Create a feature branch first."
  }
}
EOF
    ;;
esac
exit 0
```

### Import Sorter

Sort imports after editing TypeScript files:

```bash
#!/usr/bin/env bash
set -euo pipefail
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)
[[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]] && exit 0

case "${FILE_PATH##*.}" in
  ts|tsx|js|jsx)
    if command -v npx &>/dev/null; then
      npx organize-imports-cli "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
esac
exit 0
```

---

## Hook Authoring Guide

### Input Format

Hook scripts receive JSON on stdin from the tool event. The shape depends on the event type:

```json
{
  "tool_name": "insert_edit_into_file",
  "tool_input": {
    "filePath": "/path/to/file.ts",
    "content": "..."
  }
}
```

Common fields to extract:

| Field       | Where to Find          | Use For                    |
| ----------- | ---------------------- | -------------------------- |
| `filePath`  | `tool_input.filePath`  | File being edited/created  |
| `content`   | `tool_input.content`   | New file content           |
| `newString` | `tool_input.newString` | Replacement text in edits  |
| `oldString` | `tool_input.oldString` | Text being replaced        |
| `command`   | `tool_input.command`   | Terminal command being run |
| `message`   | `tool_input.message`   | Commit message             |

### Output Format

**PostToolUse hooks**: Print warnings/info to stdout. Exit 0. Output is shown to the agent.

**PreToolUse hooks**: To request confirmation, print JSON:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "Explain why confirmation is needed"
  }
}
```

Permission decisions: `"allow"` (proceed silently), `"deny"` (block silently), `"ask"` (prompt user).

### Script Template

```bash
#!/usr/bin/env bash
# my-hook.sh — One-line description
set -euo pipefail

INPUT=$(cat)

# Extract file path (works for most edit/create tools)
FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//' || true)

if [[ -z "$FILE_PATH" ]]; then
  exit 0  # No file path — nothing to check
fi

# Your logic here

exit 0
```

### Testing Hooks

Test hooks locally by piping mock input:

```bash
echo '{"tool_name":"insert_edit_into_file","tool_input":{"filePath":"src/app.ts"}}' | bash .github/hooks/scripts/my-hook.sh
```

---

## Additional Hook Ideas

| Hook                 | Event       | Purpose                                                                 |
| -------------------- | ----------- | ----------------------------------------------------------------------- |
| **Auto-lint**        | PostToolUse | Run ESLint/Credo after edits                                            |
| **Test runner**      | PostToolUse | Auto-run related tests after code changes                               |
| **Import sorter**    | PostToolUse | Sort imports after editing source files                                 |
| **Schema guard**     | PreToolUse  | Prevent direct edits to generated files (GraphQL schema, Prisma client) |
| **Branch protector** | PreToolUse  | Block edits on specific branches (main, production)                     |

---

## Tips

- **Keep hooks fast**: They run on every matching tool call — keep scripts under 1 second
- **Fail open**: If your script errors, make sure the default is to allow (not block)
- **Test locally**: Run `bash .github/hooks/scripts/my-hook.sh` to verify before relying on it
- **Use `permissionDecision: "ask"`** for safety-critical hooks — never silently deny without good reason
- **Scope narrowly**: Use the `tools` array to limit which tool calls trigger the hook
