# Claude Code Setup

How to use the DX Toolkit with [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Quick Start

1. Copy the toolkit into your project (see [Installation](installation.md))
2. Claude Code automatically reads `CLAUDE.md` from the project root

That's it. Claude Code discovers the toolkit through `CLAUDE.md`, which maps the full repository structure, lifecycle phases, and conventions.

## What Claude Code Uses

| File                                       | How Claude Code Uses It                                       |
| ------------------------------------------ | ------------------------------------------------------------- |
| `CLAUDE.md`                                | Primary entry point — project context, structure, conventions |
| `AGENTS.md`                                | Agent discovery and capabilities                              |
| `templates/skills/*/SKILL.md`              | Multi-step procedures invoked during tasks                    |
| `templates/references/*.md`                | Checklists referenced during reviews and audits               |
| `templates/instructions/*.instructions.md` | Coding rules (read manually, not auto-attached)               |

## Recommended Workflow

Use the lifecycle slash commands as task prompts:

```
# Define a feature
"Read .claude/skills/spec-driven-development/SKILL.md and write a spec for [feature]"

# Plan the work
"Read .claude/skills/planning-and-task-breakdown/SKILL.md and break this spec into tasks"

# Build incrementally
"Read .claude/skills/incremental-implementation/SKILL.md and implement Task 1"

# Debug issues
"Read .claude/skills/debugging-and-error-recovery/SKILL.md and fix this error: [error]"

# Review code
"Read .claude/skills/code-simplification/SKILL.md and review src/"

# Ship it
"Read .claude/skills/shipping-and-launch/SKILL.md and prepare for deployment"
```

## Tips

- **Feed context explicitly** — Claude Code reads files when asked. Point it to the right skill: "Follow the process in `.claude/skills/incremental-implementation/SKILL.md`"
- **Use CLAUDE.md for project rules** — Add project-specific conventions to your project's `CLAUDE.md`. The toolkit's `CLAUDE.md` provides the template.
- **Reference checklists** — For reviews, point Claude to `.claude/references/security-checklist.md` or similar
- **Chain skills** — "First use the spec skill, then the planning skill, then implement"

## Customization

To adapt the toolkit for Claude Code in your project:

1. Copy `CLAUDE.md` to your project root
2. Edit it to include your project-specific context (tech stack, conventions, architecture)
3. Keep the lifecycle structure — it helps Claude Code navigate the skills
4. Add project-specific rules under a new "## Project Rules" section
