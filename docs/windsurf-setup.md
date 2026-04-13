# Windsurf Setup

How to use the DX Toolkit with [Windsurf](https://codeium.com/windsurf) (Codeium).

## Quick Start

1. Copy the toolkit into your project (see [Installation](installation.md))
2. Create a `.windsurfrules` file in your project root

## Configuration

### Project Rules

Create `.windsurfrules` in your project root:

```markdown
# Project Rules

## Development Lifecycle

Follow the EXPLORE → OUTLINE → DEVELOP → CHECK → POLISH → LAUNCH lifecycle.
Skills for each phase are in .windsurf/skills/.

## Coding Conventions

[Copy relevant sections from templates/copilot-instructions.md]

## Key Skills

- Spec writing: .windsurf/skills/spec-driven-development/SKILL.md
- Planning: .windsurf/skills/planning-and-task-breakdown/SKILL.md
- Implementation: .windsurf/skills/incremental-implementation/SKILL.md
- Debugging: .windsurf/skills/debugging-and-error-recovery/SKILL.md
- Code review: .windsurf/skills/code-simplification/SKILL.md
- Shipping: .windsurf/skills/shipping-and-launch/SKILL.md
```

## What Windsurf Can Use

| DX Toolkit File                            | How to Use in Windsurf                            |
| ------------------------------------------ | ------------------------------------------------- |
| `templates/copilot-instructions.md`        | Copy key sections to `.windsurfrules`             |
| `templates/instructions/*.instructions.md` | Copy to `.windsurfrules` or reference in chat     |
| `templates/skills/*/SKILL.md`              | Reference in Cascade: "read .windsurf/skills/..." |
| `templates/references/*.md`                | Reference in Cascade for checklists               |

## Recommended Workflow

In Windsurf Cascade:

```
# Reference a skill
Read .windsurf/skills/incremental-implementation/SKILL.md and implement
the user auth feature following that process.

# Reference a checklist
Read .windsurf/references/security-checklist.md and review this code.

# Use the lifecycle
1. Read .windsurf/skills/spec-driven-development/SKILL.md — write a spec
2. Read .windsurf/skills/planning-and-task-breakdown/SKILL.md — plan tasks
3. Read .windsurf/skills/incremental-implementation/SKILL.md — implement task 1
```

## Tips

- **Cascade flows** — Windsurf's Cascade maintains context across steps, making skill chaining natural
- **Mention files** — Reference skill files directly in Cascade for structured workflows
- **Rules file** — Keep `.windsurfrules` concise — link to skills rather than duplicating content
- **Multi-file edits** — Cascade handles multi-file changes well; pair it with the incremental-implementation skill for structured development
