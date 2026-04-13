# 🏗️ Architecture

How the toolkit's components fit together, and how data flows from your request to the final output.

## Component Hierarchy

The toolkit has four primary component types, layered from low-level rules to high-level personas:

```
┌─────────────────────────────────────────────────────────┐
│                      AGENTS                             │
│        Specialized personas that combine                │
│        prompts + skills + instructions                  │
├─────────────────────────────────────────────────────────┤
│                      SKILLS                             │
│        Multi-step procedures with templates             │
│        and decision trees                               │
├─────────────────────────────────────────────────────────┤
│                      PROMPTS                            │
│        Single-task entry points that                    │
│        trigger specific actions                         │
├─────────────────────────────────────────────────────────┤
│                   INSTRUCTIONS                          │
│        Auto-attached rules that enforce                 │
│        coding standards per file type                   │
├─────────────────────────────────────────────────────────┤
│              HOOKS · REFERENCES · WORKFLOWS             │
│  Guard actions · Provide checklists · Automate CI/CD    │
└─────────────────────────────────────────────────────────┘
```

### Instructions — The Foundation

Instructions are coding rules that auto-attach to files based on glob patterns. When you edit a `.ts` file, `typescript.instructions.md` activates automatically. You don't invoke them — they're always present when the file type matches.

```yaml
# typescript.instructions.md frontmatter
applyTo: '**/*.ts, **/*.tsx, **/*.mts, **/*.cts'
```

There are 25 instruction files covering TypeScript, Python, Go, Rust, Elixir, Ruby, Swift, Kotlin, Vue, React, CSS, Docker, GraphQL, YAML, testing, API design, git workflow, accessibility, database migrations, monorepo conventions, and writing style.

On-demand instructions use a `description` field instead of `applyTo`. You reference these explicitly with `#instruction-name` in chat.

### Prompts — Single-Task Entry Points

Prompts handle one task. You invoke them from the `/` slash menu in VS Code or by typing the command. Each prompt has a focused scope: scaffold a component, write tests, debug an error.

```yaml
# write-tests.prompt.md frontmatter
description: 'Generate tests for the selected code'
agent: 'agent'
tools: ['read', 'edit', 'search']
```

There are 29 prompts organized around the development lifecycle (explore, outline, develop, check, polish, launch) plus task-specific ones (create-workflow, analyze-deps, setup-ci).

### Skills — Multi-Step Procedures

Skills are structured workflows with multiple steps, templates, and decision points. A skill walks you through an entire procedure — not just one action. Skills live in their own folder with a `SKILL.md` file.

Example: the `code-review` skill has steps for correctness review, security scan, performance check, and feedback formatting. The `incremental-implementation` skill guides you through slicing work into thin vertical slices.

There are 36 skills across six domains: development, code quality, DevOps, mobile, planning, and communication.

### Agents — Specialized Personas

Agents combine instructions, prompts, and skills with a specialized persona. A `typescript-expert` agent knows TypeScript deeply. A `security-fixer` agent focuses on vulnerabilities. You assign agents to GitHub issues or invoke them in VS Code chat.

```
@bug-fixer Fix the race condition in the payment flow
@react-expert Review this component for accessibility issues
```

There are 45 agents in three categories:

| Category               | Count | Examples                                              |
| ---------------------- | ----- | ----------------------------------------------------- |
| General-purpose        | 9     | bug-fixer, test-writer, refactorer, security-fixer    |
| Technology-specialized | 34    | typescript-expert, python-expert, react-native-expert |
| Content-specialized    | 2     | seo-writer, marketing-expert                          |

## How Components Compose

Components don't work in isolation. They combine:

```
Agent (react-expert)
  ├── Uses instructions (react.instructions.md, typescript.instructions.md)
  ├── Invokes prompts (/write-tests, /scaffold-component)
  └── Follows skills (incremental-implementation, code-review)
```

**A prompt can invoke a skill.** The `/develop` prompt references the `incremental-implementation` skill to guide feature development step-by-step.

**An agent uses prompts and skills.** The `feature-implementer` agent can use `/explore` to define scope, `/outline` to break work into tasks, and `/develop` to implement each slice.

**Instructions apply automatically.** Regardless of which agent or prompt is active, `typescript.instructions.md` enforces TypeScript rules whenever you edit a `.ts` file.

## The Development Lifecycle

Every skill and prompt maps to one of six phases:

```
EXPLORE ──→ OUTLINE ──→ DEVELOP ──→ CHECK ──→ POLISH ──→ LAUNCH
  │            │           │          │          │          │
  │            │           │          │          │          │
  ▼            ▼           ▼          ▼          ▼          ▼
 Ideas       Tasks       Code       Debug     Refine     Ship
 Specs       Plans       Tests      Fix       Audit      Deploy
 Onboard     Breakdown   Implement  Guard     Optimize   Document
```

| Phase   | Slash Command | Skills                                                                                                                                                 | What Happens                                        |
| ------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------- |
| EXPLORE | `/explore`    | idea-refine, spec-driven-development, codebase-onboarding                                                                                              | Explore ideas, write specs, understand the codebase |
| OUTLINE | `/outline`    | planning-and-task-breakdown, issue-to-plan                                                                                                             | Break specs into ordered, verifiable tasks          |
| DEVELOP | `/develop`    | incremental-implementation, context-engineering, api-design, database-schema                                                                           | Build in thin vertical slices                       |
| CHECK   | `/check`      | debugging-and-error-recovery, testing-strategy                                                                                                         | Find and fix bugs, write regression tests           |
| POLISH  | `/polish`     | code-simplification, performance-optimization, code-review, security-audit, accessibility-audit, refactoring-catalog                                   | Simplify, optimize, audit                           |
| LAUNCH  | `/launch`     | git-workflow-and-versioning, ci-cd-and-automation, documentation-and-adrs, shipping-and-launch, deployment-checklist, pr-description, humanize-writing | Version, document, deploy                           |

You can use any phase independently. You don't have to follow the full sequence — jump to `/check` when a bug shows up, or start with `/develop` when the plan is already clear.

## Supporting Components

### Hooks

Hooks guard actions before or after tool use. They run automatically when certain conditions are met.

- **format-on-edit** — Formats files after edits (PostToolUse)
- **guard-protected-files** — Prevents edits to critical files (PreToolUse)
- **commit-message-validator** — Validates Conventional Commits format before committing (PreToolUse)
- **secret-scanner** — Scans staged content for API keys and tokens before committing (PreToolUse)

Hook configs live in `templates/hooks/*.json`, scripts in `templates/hooks/scripts/`.

### References

References are standalone checklists that skills and prompts pull from. They provide structured criteria without prescribing a workflow.

| Reference               | What It Covers                                         |
| ----------------------- | ------------------------------------------------------ |
| testing-patterns        | Test structure, assertion patterns, fixture management |
| security-checklist      | OWASP Top 10, input validation, auth patterns          |
| performance-checklist   | Core Web Vitals, bundle size, query optimization       |
| accessibility-checklist | WCAG 2.2 AA requirements                               |
| monorepo-patterns       | Workspace strategies, dependency boundaries            |
| architecture-patterns   | Monolith vs microservices, scaling patterns            |
| mobile-checklist        | App store quality, offline support, deep linking       |
| api-patterns            | REST/GraphQL patterns, versioning, pagination          |
| error-handling-patterns | Error handling by language, retry strategies           |
| observability-checklist | Logging, metrics, tracing, SLI/SLO                     |

### Workflows

25 GitHub Actions workflows automate CI/CD tasks: code review, issue triage, labeling, security scanning, dependency checking, changelog generation, and more.

Each workflow is self-contained — copy it from `templates/workflows/` directly to your repo's `.github/workflows/`.

## Data Flow

Here's what happens when you type a request:

```
  You: "@react-expert Add dark mode toggle to the settings page"
   │
   ▼
  ┌─────────────────────────────┐
  │  Agent: react-expert        │  Agent persona activates
  │  (specialized knowledge)    │
  └──────────┬──────────────────┘
             │
             ▼
  ┌─────────────────────────────┐
  │  Instructions auto-attach   │  react.instructions.md
  │  (coding rules enforced)    │  typescript.instructions.md
  └──────────┬──────────────────┘  css.instructions.md
             │
             ▼
  ┌─────────────────────────────┐
  │  Skill: incremental-        │  Multi-step procedure
  │  implementation             │  guides the work
  └──────────┬──────────────────┘
             │
             ▼
  ┌─────────────────────────────┐
  │  Hooks guard actions        │  format-on-edit runs
  │  (pre/post tool use)        │  after each file edit
  └──────────┬──────────────────┘
             │
             ▼
  ┌─────────────────────────────┐
  │  Output: code changes       │  Files edited, tests
  │  with quality guarantees    │  written, PR ready
  └─────────────────────────────┘
```

1. **Agent activates** — The `react-expert` persona brings React-specific knowledge to the task.
2. **Instructions enforce rules** — As the agent reads and edits `.tsx` files, `react.instructions.md` and `typescript.instructions.md` auto-attach, enforcing coding standards.
3. **Skill provides procedure** — If the task is complex, the agent follows a skill (like `incremental-implementation`) to break work into verifiable slices.
4. **Hooks guard actions** — Before commits, hooks validate commit messages and scan for secrets. After edits, hooks format the code.
5. **Output ships** — The result is clean, tested code that follows your project's conventions.

## File Structure

```
.github/
├── agents/                   45 agent definitions (.agent.md)
├── skills/                   35 skill procedures (SKILL.md per folder)
├── prompts/                  29 task prompts (.prompt.md)
├── instructions/             25 coding rules (.instructions.md)
├── hooks/                    4 hook configs + scripts
├── references/               10 reference checklists
├── workflows/                25 standalone GitHub Actions
├── ISSUE_TEMPLATE/           Bug report + Feature request forms
├── PULL_REQUEST_TEMPLATE.md
└── copilot-instructions.md   Repository-wide Copilot config
docs/                         Documentation
scripts/                      Bootstrap installer
```

## Design Principles

- **Copy what you need** — Every component is independent. Take the agents you want, skip the rest.
- **Convention over configuration** — Sensible defaults that work out of the box. Override when you need to.
- **Layered composition** — Instructions enforce rules, prompts trigger tasks, skills guide procedures, agents bring it all together.
- **AI-augmented, not AI-dependent** — The toolkit enhances your workflow. It doesn't replace your judgment.
