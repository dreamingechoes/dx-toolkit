# Setup a Monorepo

Configure a monorepo from scratch with the DX Toolkit, Turborepo or Nx, and scoped agents.

## Prerequisites

- **Node.js** 18+ and **pnpm** (recommended for monorepos — `npm install -g pnpm`)
- **Git** repository initialized
- **GitHub Copilot** in VS Code (or Claude Code / Cursor)

## Choosing Your Tool: Turborepo vs Nx

Pick one before you start.

| Feature                | Turborepo                              | Nx                                              |
| ---------------------- | -------------------------------------- | ----------------------------------------------- |
| Setup complexity       | Minimal — drop in `turbo.json`         | More config — `nx.json`, project graph          |
| Build caching          | Local + Vercel Remote Cache            | Local + Nx Cloud                                |
| Task orchestration     | `pipeline` in `turbo.json`             | `targetDefaults` in `nx.json`                   |
| Change detection       | `--filter=...[origin/main]`            | `nx affected` with project graph                |
| Module boundaries      | No built-in enforcement                | `@nx/enforce-module-boundaries` lint rule       |
| Generators/scaffolding | None built-in                          | Built-in generators for common frameworks       |
| Best for               | Small-medium repos, simple task graphs | Large repos, strict boundaries, mixed languages |

**Pick Turborepo** if you want minimal config and your repo has <20 packages.
**Pick Nx** if you need strict module boundaries, generators, or have 20+ packages.

## Step 1: Create the Monorepo Structure

### Option A: Turborepo

```bash
pnpm dlx create-turbo@latest my-monorepo
cd my-monorepo
```

Or set up manually in an existing repo:

```bash
mkdir -p apps packages
pnpm init

# Create pnpm workspace file
cat > pnpm-workspace.yaml << 'EOF'
packages:
  - "apps/*"
  - "packages/*"
EOF

pnpm add -Dw turbo
```

Create `turbo.json`:

```json
{
  "$schema": "https://turbo.build/schema.json",
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**"]
    },
    "test": {
      "dependsOn": ["build"]
    },
    "lint": {},
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

### Option B: Nx

```bash
pnpm dlx create-nx-workspace@latest my-monorepo --preset=ts
cd my-monorepo
```

Or add Nx to an existing repo:

```bash
pnpm dlx nx@latest init
```

## Step 2: Install the Toolkit

```bash
git clone https://github.com/dreamingechoes/dx-toolkit.git /tmp/dx-toolkit
/tmp/dx-toolkit/scripts/bootstrap.sh .
```

### Question 1: AI coding tool

Pick your editor.

### Question 2: Project type

Select **Full-stack (multiple technologies)** — this gives you the broadest agent coverage since monorepos typically contain multiple project types.

This installs:

- `typescript-expert`, `react-expert`, `nextjs-expert`, `frontend-expert`, `backend-expert`, `web-development-expert`, `design-systems-expert`, `tdd-expert`, plus all 9 general-purpose agents
- TypeScript, React, and CSS instructions

### Question 3: Extras

Select:

- **Docker / Containers** — most monorepos containerize services
- **CI/CD Workflows** — you'll want the monorepo change detector
- **GitHub Templates** — shared issue and PR templates

### Install and commit

```bash
git add .github/ CLAUDE.md AGENTS.md
git commit -m "chore: install dx-toolkit for monorepo"
```

## Step 3: Add the Monorepo-Specific Workflow

The toolkit includes a **monorepo-change-detector** workflow that detects which packages changed in a PR and runs only affected tests.

```bash
cp /tmp/dx-toolkit/templates/workflows/monorepo-change-detector.yml .github/workflows/
```

This workflow:

1. Detects which directories changed in the PR
2. Maps changes to packages
3. Runs tests only for affected packages
4. Comments on the PR with what was tested

## Step 4: Configure Per-Package Instructions

In a monorepo, different packages use different technologies. The toolkit's instruction files use `applyTo` globs, so they scope automatically.

The default instructions already handle this:

- `typescript.instructions.md` → `**/*.ts`, `**/*.tsx` (all TS files everywhere)
- `react.instructions.md` → `**/*.tsx`, `**/*.jsx` (frontend packages)
- `css.instructions.md` → `**/*.css`, `**/*.scss` (styling)

For package-specific rules, create scoped instruction files:

```markdown
---
description: 'API package conventions. Applies to the REST API service.'
applyTo: 'apps/api/**/*.ts'
---

# API Package Rules

- All endpoints must return typed response objects
- Use Zod for request validation
- Every route needs integration tests in `__tests__/`
```

Save this as `.github/instructions/api-package.instructions.md`.

You can create one per package or per package category:

```
.github/instructions/
├── typescript.instructions.md      # Global TS rules
├── react.instructions.md           # All frontend packages
├── api-package.instructions.md     # apps/api/**
├── shared-ui.instructions.md       # packages/ui/**
└── database.instructions.md        # packages/database/**
```

## Step 5: Scope Agents Per Package

When working in a specific package, tell the agent which context you're in:

```
@nextjs-expert I'm working in apps/web — the Next.js frontend.
Add a new dashboard page with user stats.
```

```
@backend-expert I'm working in apps/api — the Express API.
Add a GET /api/users/stats endpoint.
```

```
@design-systems-expert I'm working in packages/ui — our shared
component library. Add a StatsCard component.
```

The agents read the package's `package.json`, directory structure, and existing code to follow local conventions.

For cross-cutting changes, use the `monorepo-expert`:

```
@monorepo-expert I need to add a new shared package for email templates
that both apps/web and apps/api depend on. Set up the package with
proper workspace dependencies.
```

The `monorepo-expert` handles:

- Creating the package structure (`packages/email-templates/`)
- Setting up `package.json` with correct workspace protocol deps
- Updating `turbo.json` or `nx.json` task configuration
- Adding the dependency in consuming packages

## Step 6: Add New Packages

When you add packages to the monorepo, follow this pattern:

### 1. Create the package

```
@monorepo-expert Create a new shared package called @myorg/validators
in packages/validators. It should export Zod schemas used by both
the API and the web app.
```

### 2. Wire up dependencies

```bash
# From the consuming package
cd apps/api
pnpm add @myorg/validators@workspace:*

cd ../web
pnpm add @myorg/validators@workspace:*
```

### 3. Update the build pipeline

For Turborepo, the `^build` dependency in `turbo.json` handles this automatically — packages build before apps that depend on them.

For Nx, the project graph detects dependencies from `package.json` imports.

### 4. Add scoped instructions (if needed)

If the new package has specific conventions, create `.github/instructions/validators-package.instructions.md` with an `applyTo: 'packages/validators/**'` glob.

## Step 7: CI/CD for Monorepos

### Change detection workflow

The `monorepo-change-detector.yml` workflow runs first and outputs which packages changed. Other workflows consume this output.

### Per-package CI

Create a workflow that runs tests only for changed packages:

```yaml
# .github/workflows/ci.yml
name: CI

on:
  pull_request:

jobs:
  detect-changes:
    runs-on: ubuntu-latest
    outputs:
      packages: ${{ steps.filter.outputs.changes }}
    steps:
      - uses: actions/checkout@v4
      - uses: dorny/paths-filter@v3
        id: filter
        with:
          filters: |
            web: 'apps/web/**'
            api: 'apps/api/**'
            ui: 'packages/ui/**'

  test:
    needs: detect-changes
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm turbo run test --filter=...[origin/main]
```

### Recommended workflows

Copy these workflows for a solid monorepo pipeline:

```bash
cp templates/workflows/pr-size-checker.yml .github/workflows/
cp templates/workflows/pr-code-reviewer.yml .github/workflows/
cp templates/workflows/conventional-commit-checker.yml .github/workflows/
cp templates/workflows/monorepo-change-detector.yml .github/workflows/
cp templates/workflows/security-scanner.yml .github/workflows/
cp templates/workflows/dependency-update-checker.yml .github/workflows/
```

Commit and push:

```bash
git add .github/workflows/
git commit -m "ci: add monorepo CI and toolkit quality workflows"
git push
```

## What's Installed (Quick Reference)

| Component                  | Purpose                                                         |
| -------------------------- | --------------------------------------------------------------- |
| `monorepo-expert`          | Workspace tooling, boundaries, change detection                 |
| `typescript-expert`        | TypeScript across all packages                                  |
| `nextjs-expert`            | Next.js apps in the monorepo                                    |
| `backend-expert`           | API services                                                    |
| `design-systems-expert`    | Shared UI component packages                                    |
| `monorepo.instructions.md` | Auto-attaches to `turbo.json`, `nx.json`, `pnpm-workspace.yaml` |
| `monorepo-change-detector` | CI workflow for affected-package testing                        |
| `monorepo-setup`           | Skill for configuring workspace tooling                         |

## Troubleshooting

**Turborepo not caching?** Check that `outputs` in `turbo.json` match what your build actually produces. Run `turbo run build --dry` to see the task graph.

**Nx "project graph" errors?** Run `nx graph` to visualize dependencies. Circular dependencies between packages break the graph.

**Agents confused by multiple packages?** Be explicit about which package you're working in. Start messages with "I'm in `apps/web`" or "Working on `packages/ui`".

**Change detection missing a package?** Add the package path to the `paths-filter` configuration in your CI workflow.
