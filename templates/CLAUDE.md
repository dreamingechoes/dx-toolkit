# CLAUDE.md — {{PROJECT_NAME}}

This file provides context for AI agents working with this repository.

## What This Repository Is

<!-- TODO: Replace this placeholder with a description of your project.
     Describe what it does, its architecture, key technologies, and how to run it. -->

{{PROJECT_NAME}}.

## Development Lifecycle

Skills and prompts are organized around a six-phase development lifecycle:

```
EXPLORE → OUTLINE → DEVELOP → CHECK → POLISH → LAUNCH
```

| Phase   | Slash Command | Skills                                                                                                                                                 |
| ------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| EXPLORE | `/explore`    | idea-refine, spec-driven-development, codebase-onboarding                                                                                              |
| OUTLINE | `/outline`    | planning-and-task-breakdown, issue-to-plan                                                                                                             |
| DEVELOP | `/develop`    | incremental-implementation, context-engineering, api-design, database-schema                                                                           |
| CHECK   | `/check`      | debugging-and-error-recovery, testing-strategy                                                                                                         |
| POLISH  | `/polish`     | code-simplification, performance-optimization, code-review, security-audit, accessibility-audit, refactoring-catalog                                   |
| LAUNCH  | `/launch`     | git-workflow-and-versioning, ci-cd-and-automation, documentation-and-adrs, shipping-and-launch, deployment-checklist, pr-description, humanize-writing |

## Repository Structure

<!-- TODO: Describe your project's directory structure here. Example:
```
src/
├── components/    UI components
├── lib/           Shared utilities
├── pages/         Route handlers
└── styles/        CSS / design tokens
config/            Configuration files
tests/             Test suites
```
-->

## File Conventions

- **Agents**: `{{CONFIG_DIR}}/agents/<name>.agent.md` — kebab-case, has `description` frontmatter
- **Skills**: `{{CONFIG_DIR}}/skills/<name>/SKILL.md` — folder name matches `name` frontmatter
- **Prompts**: `{{CONFIG_DIR}}/prompts/<name>.prompt.md` — has `description` frontmatter
- **Instructions**: `{{CONFIG_DIR}}/instructions/<name>.instructions.md` — `applyTo` for auto-attach or `description` for on-demand
- **References**: `{{CONFIG_DIR}}/references/<name>.md` — standalone checklists referenced by skills and prompts

## Code Conventions

<!-- TODO: Add your project's code conventions. Examples:
     - Language and framework specifics
     - Naming conventions
     - Testing requirements
     - Linting and formatting standards -->

## Writing Style

- Active voice, direct tone
- "You/we" not "one/the user"
- Specific over vague: "responds in <100ms" not "fast"
- Cut filler: "In order to" → "To"
- No AI phrases: avoid "leverage", "utilize", "it's important to note"

## When Editing This Repo

- One concern per file — don't combine testing instructions with API design
- Skills must be self-contained — all context in a single SKILL.md
- Prompts handle a single task — chain skills for multi-step workflows
- Always include `description` frontmatter for discoverability
