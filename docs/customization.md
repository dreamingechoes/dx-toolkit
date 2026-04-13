# 🔧 Customization

This toolkit is designed to be forked and adapted. Every component can be modified, extended, or removed to fit your team's stack and conventions.

## Creating Custom Agents

**Location**: `.github/agents/<name>.agent.md`

### Template

```yaml
---
name: "my-agent"
description: "One-sentence description for discovery"
tools: ["read", "edit", "search", "execute", "github/*"]
---

You are an expert in [domain]. Your role is to [purpose].

## Workflow

1. Read the issue or user request
2. Analyze the codebase to understand context
3. Implement the solution
4. Verify correctness

## Constraints

- Always [rule 1]
- Never [rule 2]
- Prefer [approach A] over [approach B]
```

### Conventions

- **Filename**: kebab-case matching the `name` field → `my-agent.agent.md`
- **Tools**: Use the full set unless the agent specifically shouldn't write code (e.g., read-only reviewers use `["read", "search"]`)
- **Structure**: Workflow → Constraints. Keep the workflow sequential, constraints as rules.
- **Description**: Must be discoverable — describe what the agent does in one sentence

### Example: Framework-Specific Agent

```yaml
---
name: "remix-expert"
description: "Expert in Remix development. Applies loader/action patterns, nested routes, and Remix 3+ best practices."
tools: ["read", "edit", "search", "execute", "github/*"]
---

You are an expert in Remix development targeting Remix 3+ with React Router v7.

## Workflow

1. Understand the requirement
2. Explore existing route structure and conventions
3. Implement using Remix patterns (loaders, actions, nested routes)
4. Ensure proper error boundaries and loading states
5. Write or update tests

## Constraints

- Use `loader` for data fetching, `action` for mutations
- Prefer nested routes over flat routes
- Always add error boundaries to route modules
- Use `defer` for non-critical data
- Follow progressive enhancement — forms must work without JS
```

---

## Creating Custom Prompts

**Location**: `.github/prompts/<name>.prompt.md`

### Template

```yaml
---
description: "One-sentence description for the / menu"
agent: "agent"
tools: [read, edit, search, execute]
---

## Task

[What the prompt should do]

## Input

The user will provide: [expected input]

## Steps

1. [Step 1]
2. [Step 2]
3. [Step 3]

## Output

Produce: [expected output format]

## Rules

- [Rule 1]
- [Rule 2]
```

### Tips

- **One task per prompt**: Don't combine "write tests AND documentation" in one prompt
- **Be specific about output**: "Generate a TypeScript interface" is better than "Generate types"
- **Limit tools**: A read-only review prompt should use `tools: [read, search]` — not `edit`
- **Include model** (optional): `model: "claude-sonnet-4"` for tasks needing strong reasoning

---

## Creating Custom Instructions

**Location**: `.github/instructions/<name>.instructions.md`

### Auto-Attached (file-type rules)

```yaml
---
applyTo: '**/*.py'
---
## Python Conventions

- Use Python 3.12+ features
- Type hints on all public functions
- Use `pathlib` over `os.path`
- Prefer f-strings over `.format()`
- Use `match` statements for complex branching
```

### On-Demand (task-based rules)

```yaml
---
description: "GraphQL API design conventions"
---

## GraphQL Conventions

- Use Relay-style connections for pagination
- Prefix mutations with the resource: `createUser`, `updatePost`
- Always include `errors` in mutation responses
- Use input types for mutation arguments
```

### Tips

- **One concern per file**: Don't mix Python style with testing rules
- **Keep it short**: Instructions share context window space with your code
- **Use globs wisely**: `**/*.tsx` catches all TSX files; `src/components/**/*.tsx` limits scope
- **Avoid conflicts**: Two instructions with overlapping globs and contradictory rules cause unpredictable behavior

---

## Creating Custom Skills

**Location**: `.github/skills/<skill-name>/SKILL.md`

### Template

````yaml
---
name: "my-skill"
description: "What the skill does — one sentence"
---

## Context

[When and why to use this skill]

## Inputs

The user provides:
- **Required**: [what's needed]
- **Optional**: [what's helpful]

## Procedure

### Step 1: [Name]
[Detailed instructions for this step]

### Step 2: [Name]
[Detailed instructions for this step]

### Step 3: [Name]
[Detailed instructions for this step]

## Output Template

```markdown
# [Title]

## Section 1
[template]

## Section 2
[template]
`` `
````

### Tips

- **Self-contained**: Include all context in the SKILL.md — don't reference external files
- **Structured procedure**: Number every step so the agent can follow them in order
- **Output template**: Include a literal template so output is consistent across invocations
- **Test it**: Invoke the skill with different inputs to verify it handles edge cases

---

## Creating Custom Hooks

**Location**: `.github/hooks/<name>.json` + `.github/hooks/scripts/<name>.sh`

### Template

**Config** (`.github/hooks/my-hook.json`):

```json
{
  "hooks": [
    {
      "event": "PostToolUse",
      "tools": ["insert_edit_into_file", "replace_string_in_file"],
      "script": ".github/hooks/scripts/my-hook.sh",
      "permissionDecision": "allow"
    }
  ]
}
```

**Script** (`.github/hooks/scripts/my-hook.sh`):

```bash
#!/bin/bash
set -euo pipefail

# Your logic here
# For PreToolUse: echo "allow", "deny", or "ask"
# For PostToolUse: run formatting, linting, etc.

echo "allow"
```

```bash
chmod +x .github/hooks/scripts/my-hook.sh
```

### Tips

- **Keep scripts fast**: They run on every matching tool call — under 1 second is ideal
- **Fail open**: Default to `echo "allow"` if your check encounters an error
- **Scope narrowly**: Use the `tools` array to limit which tool calls trigger the hook
- **Test locally**: `bash .github/hooks/scripts/my-hook.sh` before relying on it

---

## Modifying copilot-instructions.md

The workspace instructions file (`.github/copilot-instructions.md`) provides global context for every Copilot interaction. Customize it for your project:

```markdown
# Project Instructions for GitHub Copilot

## About This Project

This is [project name] — [one-sentence description].

## Tech Stack

- **Language**: [e.g., TypeScript 5.7+]
- **Framework**: [e.g., Next.js 15 with App Router]
- **Database**: [e.g., PostgreSQL 17 with Prisma]
- **Testing**: [e.g., Vitest + Playwright]

## Code Conventions

- [Convention 1]
- [Convention 2]

## Architecture

- [Pattern, e.g., feature-based folder structure]
- [Data flow, e.g., Server Components → Server Actions → Database]

## Common Commands

- `npm run dev` — Start development server
- `npm run test` — Run tests
- `npm run build` — Production build
```

---

## Removing Unused Components

### By Technology Stack

If your project only uses TypeScript/React:

```bash
# Remove Elixir/Phoenix agents
rm .github/agents/elixir-expert.agent.md
rm .github/agents/phoenix-expert.agent.md

# Remove Elixir instruction
rm .github/instructions/elixir.instructions.md

# Remove migration instruction (if not using SQL migrations)
rm .github/instructions/migrations.instructions.md
```

### By Feature

If you don't need issue management workflows:

```bash
rm .github/workflows/duplicate-issue-detector.yml  # or just the caller
rm .github/workflows/stale-issue-manager.yml
rm .github/workflows/issue-quality-enhancer.yml
```

### Minimal Setup

For the absolute minimum useful configuration:

```
.github/
├── copilot-instructions.md          # Project context
├── instructions/
│   └── [your-language].instructions.md
├── prompts/
│   ├── write-tests.prompt.md
│   └── commit-message.prompt.md
└── agents/
    └── [your-framework]-expert.agent.md
```

---

## Best Practices

1. **Start minimal, grow gradually**: Don't install everything at once — add components as you need them
2. **Version your customizations**: Commit all `.github/` changes so the team shares the same setup
3. **Review monthly**: Check if instructions and prompts are still relevant to your current practices
4. **Team alignment**: Discuss conventions before encoding them in instructions — they affect everyone
5. **Test with real work**: Use each new component on actual tasks before committing to it
