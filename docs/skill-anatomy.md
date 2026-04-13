# Skill Anatomy

How to write, structure, and maintain skills in the DX Toolkit.

## What Is a Skill?

A skill is a multi-step procedure packaged as a single Markdown file. Unlike prompts (one-shot tasks) or instructions (passive rules), skills guide an AI agent through a structured process with multiple phases, producing detailed outputs.

Skills live at `templates/skills/<skill-name>/SKILL.md`.

## File Structure

```
templates/skills/
├── idea-refine/
│   └── SKILL.md
├── incremental-implementation/
│   └── SKILL.md
└── code-review/
    └── SKILL.md
```

Each skill gets its own folder. The folder name must match the `name` field in frontmatter.

## Anatomy of a SKILL.md

```markdown
---
name: 'skill-name'
description: 'One sentence — what this skill does. Used for discovery.'
---

# Skill Title

## Overview

2-3 sentences explaining the skill's purpose and approach.
What mental model or framework does it encode?

## When to Use This Skill

- Situation 1 where this skill applies
- Situation 2
- Situation 3

## Process

### Step 1: [Verb] [Thing]

What to do, why, and how. Include templates, examples,
or decision criteria.

### Step 2: [Verb] [Thing]

Next step with actionable instructions.

### Step 3: [Verb] [Thing]

...continue as needed.

## Common Rationalizations

| What You'll Hear               | Why It's Wrong                       |
| ------------------------------ | ------------------------------------ |
| "We can skip X because..."     | Explanation of why skipping is risky |
| "This is too simple to need Y" | Why even simple cases benefit        |

## Red Flags

Signs the skill is being applied incorrectly:

- Red flag 1
- Red flag 2
- Red flag 3

## Verification

How to confirm the skill was applied correctly:

- [ ] Checkpoint 1
- [ ] Checkpoint 2
- [ ] Checkpoint 3
```

## Required Sections

Every skill MUST have:

1. **Frontmatter** — `name` and `description`
2. **Overview** — What and why
3. **Process** — Step-by-step procedure (the core of the skill)
4. **Verification** — Checklist to confirm correct application

## Recommended Sections

These are strongly encouraged:

- **When to Use** — Helps agents and users select the right skill
- **Common Rationalizations** — Preempts shortcuts that undermine the skill
- **Red Flags** — Early warning that something is going wrong

## Writing Principles

### Be Specific, Not Vague

```markdown
# BAD

"Make sure the code is well-tested"

# GOOD

"Write a test that fails without the fix and passes with it.
If the bug was in error handling, add tests for adjacent error paths."
```

### Include Templates

Skills are most useful when they include fill-in-the-blank templates:

```markdown
## Spec Template

### Objective

One sentence: what we're building and why.

### Requirements

#### Must Have

- [Requirement with measurable criteria]
```

### Use Decision Criteria, Not Just Steps

```markdown
# BAD

"Decide how to split the work"

# GOOD

"Prefer vertical slices (schema + logic + API + test for one feature)
over horizontal layers (all schemas, then all logic, then all tests).
Each slice must compile and pass tests independently."
```

### Encode Judgment

The best skills capture expert judgment that's hard to Google:

```markdown
## Task Sizing Guide

| Size | Time      | Characteristics                             |
| ---- | --------- | ------------------------------------------- |
| S    | < 1 hour  | Single file, clear change, no dependencies  |
| M    | 1-4 hours | 2-3 files, minor decisions, may need tests  |
| L    | 4-8 hours | Multiple files, design decisions, new tests |
| XL   | > 8 hours | ⚠️ Split this into smaller tasks            |
```

## Naming Conventions

- Folder name: `kebab-case` (e.g., `incremental-implementation`)
- Must match the `name` field in frontmatter exactly
- Use descriptive, action-oriented names
- Avoid generic names like "best-practices" or "guidelines"

## Development Lifecycle Phases

Skills map to one of six lifecycle phases:

| Phase       | Purpose               | Example Skills                                   |
| ----------- | --------------------- | ------------------------------------------------ |
| **EXPLORE** | Clarify what to build | idea-refine, spec-driven-development             |
| **OUTLINE** | Break work into tasks | planning-and-task-breakdown                      |
| **DEVELOP** | Write code            | incremental-implementation, context-engineering  |
| **CHECK**   | Find and fix bugs     | debugging-and-error-recovery                     |
| **POLISH**  | Improve quality       | code-simplification, performance-optimization    |
| **LAUNCH**  | Deploy safely         | shipping-and-launch, git-workflow-and-versioning |

When creating a new skill, identify which phase it belongs to. This determines which slash command (`/explore`, `/outline`, `/develop`, `/check`, `/polish`, `/launch`) will reference it.

## Creating a New Skill

1. Create the folder: `templates/skills/your-skill-name/`
2. Create `SKILL.md` with frontmatter matching the folder name
3. Write the process steps with templates and decision criteria
4. Add common rationalizations and red flags
5. Include a verification checklist
6. Reference the skill from the appropriate slash command prompt
7. Update `docs/skills.md` with the new skill documentation
