# Cursor Setup

How to use the DX Toolkit with [Cursor](https://cursor.com).

## Quick Start

1. Copy the toolkit into your project (see [Installation](installation.md))
2. Cursor reads `.cursorrules` or `.cursor/rules` for project-wide context

## Configuration

### Project Rules

Create `.cursorrules` in your project root (or `.cursor/rules/*.md` for organized rules):

```markdown
# Project Rules

## Development Lifecycle

Follow the EXPLORE → OUTLINE → DEVELOP → CHECK → POLISH → LAUNCH lifecycle.
Skills for each phase are in .cursor/skills/.

## Coding Conventions

[Copy relevant sections from templates/copilot-instructions.md]

## Skills Available

When asked to define a feature, follow .cursor/skills/spec-driven-development/SKILL.md
When asked to plan, follow .cursor/skills/planning-and-task-breakdown/SKILL.md
When asked to build, follow .cursor/skills/incremental-implementation/SKILL.md
When asked to debug, follow .cursor/skills/debugging-and-error-recovery/SKILL.md
When asked to review, follow .cursor/skills/code-simplification/SKILL.md
When asked to ship, follow .cursor/skills/shipping-and-launch/SKILL.md
```

### Directory Rules (`.cursor/rules/`)

For more organized setups, create individual rule files:

```
.cursor/rules/
├── coding-style.md        # From templates/instructions/
├── testing.md             # From templates/instructions/testing.instructions.md
├── typescript.md          # From templates/instructions/typescript.instructions.md
└── lifecycle.md           # Lifecycle phase mappings
```

## What Cursor Can Use

| DX Toolkit File                            | How to Use in Cursor                          |
| ------------------------------------------ | --------------------------------------------- |
| `templates/copilot-instructions.md`        | Copy key sections to `.cursorrules`           |
| `templates/instructions/*.instructions.md` | Copy to `.cursor/rules/`                      |
| `templates/skills/*/SKILL.md`              | Reference in chat: "@file .cursor/skills/..." |
| `templates/references/*.md`                | Reference in chat for checklists              |

## Recommended Workflow

In Cursor Chat or Composer:

```
# Reference a skill directly
@file .cursor/skills/incremental-implementation/SKILL.md
Implement the user authentication feature following this skill's process.

# Reference a checklist
@file .cursor/references/security-checklist.md
Review this PR against the security checklist.

# Chain skills
@file .cursor/skills/spec-driven-development/SKILL.md
Write a spec for the notification system.
Then @file .cursor/skills/planning-and-task-breakdown/SKILL.md
Break the spec into tasks.
```

## Tips

- **Use @file liberally** — Cursor's file referencing lets you pull in any skill or reference
- **Composer mode** — For multi-file changes, use Composer with the incremental-implementation skill
- **Notepads** — Save frequently-used skill combinations as Cursor Notepads
- **Auto-rules** — Set up `.cursor/rules/` with glob patterns to auto-attach instructions by file type
