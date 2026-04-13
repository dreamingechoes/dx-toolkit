---
name: monorepo-setup
description: 'Configure a monorepo workspace from scratch or migrate an existing project. Covers tool selection (Turborepo, Nx, pnpm workspaces, Lerna), package structure, dependency boundaries, build caching, and CI change detection.'
---

# Monorepo Setup

## Overview

Set up a monorepo that scales — clean package boundaries, fast builds through caching, and CI that only tests what changed. This skill works with any workspace tool and any language ecosystem.

## When to Use

- Starting a new project that will have multiple packages or apps
- Migrating separate repos into a single monorepo
- Adding workspace tooling to an existing repo with multiple projects
- Restructuring a monorepo that has grown unwieldy

**When NOT to use:** Single-package projects with no plans to add more. A monorepo adds overhead — don't pay it until you need it.

## Process

### Step 1 — Assess the Situation

Before choosing tools, understand what you're working with:

- **How many packages/apps?** 2-5 is common starting point, 50+ is enterprise scale
- **What languages/runtimes?** JS/TS, Elixir, Python, Go, mixed?
- **Who deploys what?** Same team deploys everything, or different teams own different packages?
- **Publishing to registries?** Are packages published to npm/hex/PyPI, or internal only?
- **CI requirements:** GitHub Actions, GitLab CI, Jenkins, CircleCI?

### Step 2 — Choose Your Workspace Tool

| Tool                | Best For                                    | Language | Remote Cache         |
| ------------------- | ------------------------------------------- | -------- | -------------------- |
| **Turborepo**       | JS/TS projects, simple setup                | JS/TS    | Vercel (free tier)   |
| **Nx**              | Large repos, plugin ecosystem, any language | Any      | Nx Cloud (free tier) |
| **pnpm workspaces** | Lightweight, no build orchestration needed  | JS/TS    | No                   |
| **Yarn workspaces** | Existing Yarn projects                      | JS/TS    | No                   |
| **Lerna**           | Publishing multiple npm packages            | JS/TS    | Via Nx               |
| **Elixir umbrella** | Elixir/Phoenix multi-app projects           | Elixir   | No                   |
| **Go workspaces**   | Multi-module Go projects                    | Go       | No                   |
| **Pants/Bazel**     | Polyglot enterprise repos (100+ packages)   | Any      | Yes                  |

**Decision guide:**

- JS/TS with < 20 packages → **Turborepo**
- JS/TS with > 20 packages or complex graph → **Nx**
- Elixir → **Umbrella project**
- Go → **Go workspaces**
- Polyglot or enterprise → **Nx** or **Bazel**

### Step 3 — Define Package Structure

```
my-monorepo/
├── apps/                    # Deployable applications
│   ├── web/                 # Frontend app
│   ├── api/                 # Backend API
│   └── mobile/              # Mobile app
├── packages/                # Shared libraries
│   ├── ui/                  # Shared UI components
│   ├── utils/               # Shared utilities
│   ├── config/              # Shared configs (ESLint, TS, etc.)
│   └── types/               # Shared type definitions
├── tools/                   # Internal scripts and tooling
│   └── cli/                 # Project-specific CLI
├── turbo.json               # Build orchestration (Turborepo)
├── pnpm-workspace.yaml      # Workspace definition (pnpm)
├── package.json             # Root manifest
└── .github/workflows/       # CI with change detection
```

**Rules:**

- `apps/` contains things that get deployed (web servers, CLIs, mobile apps)
- `packages/` contains things that get imported (libraries, configs, types)
- `tools/` contains internal scripts that help development
- Every directory in `apps/` and `packages/` is an independent package with its own manifest

### Step 4 — Configure Build Orchestration

**Turborepo example** (`turbo.json`):

```json
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "inputs": ["src/**", "package.json", "tsconfig.json"],
      "outputs": ["dist/**", ".next/**"]
    },
    "test": {
      "dependsOn": ["^build"],
      "inputs": ["src/**", "test/**", "package.json"]
    },
    "lint": {
      "inputs": ["src/**", ".eslintrc*", "package.json"]
    },
    "typecheck": {
      "dependsOn": ["^build"],
      "inputs": ["src/**", "tsconfig.json", "package.json"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

**Key concepts:**

- `^build` means "build my dependencies first"
- `inputs` defines what files invalidate the cache
- `outputs` defines what gets cached
- `persistent: true` for long-running dev servers

### Step 5 — Set Up CI with Change Detection

**GitHub Actions example:**

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  changes:
    runs-on: ubuntu-latest
    outputs:
      packages: ${{ steps.filter.outputs.changes }}
    steps:
      - uses: actions/checkout@v5
      - uses: dorny/paths-filter@v3
        id: filter
        with:
          filters: |
            web:
              - 'apps/web/**'
              - 'packages/**'
            api:
              - 'apps/api/**'
              - 'packages/**'

  build:
    needs: changes
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v5
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: pnpm
      - run: pnpm install --frozen-lockfile
      - run: pnpm turbo run lint typecheck test build --filter=...[origin/main]
```

### Step 6 — Enforce Dependency Boundaries

- Configure `depcheck` or Nx module boundaries to prevent invalid imports
- Shared packages export only through their entry point — no deep imports
- Add a CI check that fails on circular or invalid dependencies
- Document allowed dependency directions in the root README

### Step 7 — Verify Setup

- [ ] `turbo run build` (or equivalent) completes successfully
- [ ] Change detection works: modify one package, only that package rebuilds
- [ ] Caching works: second build is near-instant
- [ ] No circular dependencies between packages
- [ ] Each package has a README explaining its purpose
- [ ] CI runs affected tasks only on PRs

## Common Rationalizations

| Rationalization                  | Reality                                                                                     |
| -------------------------------- | ------------------------------------------------------------------------------------------- |
| "We don't need a monorepo yet"   | If you have shared code between repos, you already need one — you're just syncing manually. |
| "We'll split into microservices" | Monorepo ≠ monolith. You can deploy independently from a monorepo.                          |
| "Monorepos are slow"             | Only without caching. Properly configured, builds are faster because of shared caches.      |
| "Too complex to set up"          | Turborepo takes 10 minutes to set up. The cost of NOT using one compounds over time.        |

## Red Flags

- Packages importing from another package's `src/` directory instead of its public API
- All packages rebuilding on every change (missing change detection)
- Circular dependencies between packages
- Root `node_modules` exceeding 1GB (review shared vs per-package deps)
- More than 3 levels of package nesting

## Verification

- [ ] Workspace tool is configured and `install` resolves all dependencies
- [ ] Build orchestration runs tasks in correct topological order
- [ ] Caching is enabled (local and optionally remote)
- [ ] CI detects changed packages and runs only affected tasks
- [ ] Dependency boundaries are documented and enforced
- [ ] Each package has its own README with purpose and public API
