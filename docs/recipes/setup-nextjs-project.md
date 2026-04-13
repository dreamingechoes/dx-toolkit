# Setup a Next.js Project

Bootstrap a Next.js project with the DX Toolkit, then build your first feature using AI agents.

## Prerequisites

- **Node.js** 18+ (check with `node --version`)
- **pnpm** (recommended) or npm (`npm install -g pnpm`)
- **Git** repository initialized
- **GitHub Copilot** active in VS Code (or Claude Code / Cursor)

## Step 1: Create the Next.js Project

If you don't have a project yet, scaffold one:

```bash
pnpm create next-app@latest my-app --typescript --tailwind --eslint --app --src-dir
cd my-app
git init && git add -A && git commit -m "chore: scaffold next.js project"
```

If you already have a Next.js project, `cd` into it.

## Step 2: Run the Bootstrap Script

Clone or download the toolkit, then run the installer:

```bash
git clone https://github.com/dreamingechoes/dx-toolkit.git /tmp/dx-toolkit
/tmp/dx-toolkit/scripts/bootstrap.sh .
```

The interactive installer asks three questions:

### Question 1: AI coding tool

Pick your editor. If you're using VS Code with Copilot, select **GitHub Copilot (VS Code)**.

### Question 2: Project type

Select **Next.js (fullstack)**. This installs:

| Component    | What you get                                                                                                                                                                |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Agents       | `nextjs-expert`, `react-expert`, `typescript-expert`, `frontend-expert`, `backend-expert`, `web-development-expert`, `design-systems-expert`, plus 9 general-purpose agents |
| Instructions | `typescript.instructions.md`, `react.instructions.md`, `css.instructions.md` (auto-attach to matching files)                                                                |
| Skills       | All 33+ skills (language-agnostic)                                                                                                                                          |
| Prompts      | All 27+ prompts                                                                                                                                                             |

### Question 3: Extras

Pick what applies — common choices for Next.js:

- **Docker / Containers** — adds `docker-expert` agent and `docker.instructions.md`
- **PostgreSQL** — adds `postgresql-expert` agent
- **CI/CD Workflows** — adds GitHub Actions workflows
- **GitHub Templates** — adds issue forms and PR template

### Confirm and install

The script shows a summary. Type `y` to install. Files land in your `.github/` directory:

```
.github/
├── agents/          # 15-20 agent files
├── skills/          # 21 skill folders
├── prompts/         # 19 prompt files
├── instructions/    # 6-8 instruction files
├── hooks/           # Auto-format and guard hooks
├── references/      # Testing, security, performance, accessibility checklists
├── workflows/       # CI/CD workflows (if selected)
├── ISSUE_TEMPLATE/  # Bug report + feature request forms (if selected)
└── PULL_REQUEST_TEMPLATE.md
```

Commit the toolkit:

```bash
git add .github/ CLAUDE.md AGENTS.md
git commit -m "chore: install dx-toolkit for next.js project"
```

## Step 3: Verify the Setup

Open the project in VS Code. Check that agents load:

1. Open Copilot Chat (`Ctrl+L` / `Cmd+L`)
2. Type `@nextjs-expert what patterns does this project use?`
3. The agent should analyze your `next.config.ts`, `app/` directory, and dependencies

Check that instructions auto-attach:

1. Open any `.tsx` file
2. The `react.instructions.md` and `typescript.instructions.md` rules activate automatically
3. Copilot suggestions now follow your project's conventions

## Step 4: Build Your First Feature

Walk through the full lifecycle to add a feature — say, a dashboard page.

### 4a. Explore the idea

Use the `/explore` prompt to think through the feature:

```
/explore I need a dashboard page that shows user stats, recent activity,
and quick action buttons. The data comes from a PostgreSQL database.
```

This invokes the **idea-refine** skill. You'll get a structured proposal with scope, trade-offs, and open questions.

### 4b. Outline the implementation

Turn the idea into tasks:

```
/outline Create a dashboard page with: user stats cards (total users,
active today, revenue), recent activity feed, and quick action buttons
for common admin tasks.
```

The **planning-and-task-breakdown** skill produces an ordered task list with acceptance criteria and file-level changes.

### 4c. Develop each slice

Work through the tasks. For each one, use agents:

```
@feature-implementer Implement task 1: Create the dashboard route at
/app/dashboard/page.tsx with a basic layout using Server Components.
```

The `feature-implementer` agent reads the task, studies your codebase patterns, and writes the code. For Next.js-specific decisions, it defers to the `nextjs-expert`:

```
@nextjs-expert Should the dashboard use streaming with Suspense boundaries,
or load all data in the page component? We have 3 data sources.
```

The `nextjs-expert` recommends the pattern (likely Suspense boundaries for independent data), and you implement it.

### 4d. Check the work

Run the `/check` prompt if tests fail or behavior is unexpected:

```
/check The dashboard page shows a hydration error when quick action
buttons are clicked.
```

The **debugging-and-error-recovery** skill walks through: reproduce → localize → reduce → fix → guard. For a hydration error, the agent will identify the client/server boundary issue and suggest moving the interactive buttons into a `"use client"` component.

### 4e. Polish

Once the feature works, clean it up:

```
/polish Review the dashboard implementation for code quality,
performance, and accessibility.
```

This runs the **code-review**, **performance-optimization**, and **accessibility-audit** skills against your changes.

## Step 5: Set Up CI Workflows

If you selected "CI/CD Workflows" during bootstrap, workflows are already in `.github/workflows/`. If not, copy the ones you need from the toolkit:

### Essential pipeline (start here)

```bash
# From the dx-toolkit directory
cp templates/workflows/pr-size-checker.yml .github/workflows/
cp templates/workflows/pr-code-reviewer.yml .github/workflows/
cp templates/workflows/conventional-commit-checker.yml .github/workflows/
```

These run on every PR:

- **pr-size-checker** — flags PRs over 400 lines so you keep changes reviewable
- **pr-code-reviewer** — AI-powered code review using GitHub Copilot
- **conventional-commit-checker** — enforces Conventional Commits format on PR titles

### Security pipeline

```bash
cp templates/workflows/security-scanner.yml .github/workflows/
cp templates/workflows/license-compliance.yml .github/workflows/
```

### Documentation pipeline

```bash
cp templates/workflows/auto-changelog.yml .github/workflows/
cp templates/workflows/broken-link-checker.yml .github/workflows/
```

Each workflow is self-contained. You can customize the `MODEL` env variable in the workflow file (defaults to `claude-sonnet-4`) and adjust concurrency settings directly in the workflow file.

### Push and verify

```bash
git add .github/workflows/
git commit -m "ci: add PR quality and security workflows"
git push
```

Open a test PR to confirm the workflows trigger.

## Step 6: Day-to-Day Workflow

With the toolkit installed, your daily flow looks like:

1. **Pick an issue** — read it, then ask `@feature-implementer` to plan the implementation
2. **Develop in slices** — use `/develop` for each task, leaning on `@nextjs-expert` for framework-specific decisions
3. **Test** — use `@test-writer` to generate tests for new code
4. **Review** — run `/polish` before opening a PR
5. **PR** — use the `/pr-description` prompt to generate a clear PR description
6. **CI** — workflows auto-run on push. Fix any flagged issues.

## What's Installed (Quick Reference)

| Component                          | Files                                         | Purpose                                 |
| ---------------------------------- | --------------------------------------------- | --------------------------------------- |
| `nextjs-expert`                    | `.github/agents/nextjs-expert.agent.md`       | App Router, Server Components, caching  |
| `react-expert`                     | `.github/agents/react-expert.agent.md`        | Hooks, composition, state management    |
| `typescript-expert`                | `.github/agents/typescript-expert.agent.md`   | Type safety, patterns, generics         |
| `feature-implementer`              | `.github/agents/feature-implementer.agent.md` | End-to-end feature implementation       |
| `test-writer`                      | `.github/agents/test-writer.agent.md`         | Generate tests for existing code        |
| `security-fixer`                   | `.github/agents/security-fixer.agent.md`      | Find and fix security vulnerabilities   |
| `typescript.instructions.md`       | `.github/instructions/`                       | Auto-attaches to `**/*.ts`, `**/*.tsx`  |
| `react.instructions.md`            | `.github/instructions/`                       | Auto-attaches to `**/*.tsx`, `**/*.jsx` |
| `/explore`, `/outline`, `/develop` | `.github/prompts/`                            | Lifecycle prompts for structured work   |
| `incremental-implementation`       | `.github/skills/`                             | Build in thin vertical slices           |

## Troubleshooting

**Agent not responding?** Check that the `.github/agents/` directory exists and files have `.agent.md` extension.

**Instructions not auto-attaching?** The `applyTo` glob in the frontmatter must match the file you're editing. Open the instruction file and verify the pattern.

**Workflows not triggering?** Check that the workflow file is in `.github/workflows/` and the `on:` triggers match your events.
