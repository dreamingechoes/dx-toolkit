# 📦 Monorepo Guide

How to set up and use the toolkit in monorepo projects.

## Supported Strategies

The toolkit works with all major monorepo tools:

| Tool                                                                                                       | Config File                       | Language Ecosystem                 |
| ---------------------------------------------------------------------------------------------------------- | --------------------------------- | ---------------------------------- |
| [Turborepo](https://turbo.build/repo)                                                                      | `turbo.json`                      | JavaScript/TypeScript              |
| [Nx](https://nx.dev)                                                                                       | `nx.json`                         | JavaScript/TypeScript (+ polyglot) |
| [pnpm workspaces](https://pnpm.io/workspaces)                                                              | `pnpm-workspace.yaml`             | JavaScript/TypeScript              |
| [Yarn workspaces](https://yarnpkg.com/features/workspaces)                                                 | `package.json` (workspaces field) | JavaScript/TypeScript              |
| [Lerna](https://lerna.js.org)                                                                              | `lerna.json`                      | JavaScript/TypeScript              |
| [Elixir umbrella](https://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-projects.html) | `mix.exs` (umbrella)              | Elixir                             |
| [Go workspaces](https://go.dev/blog/get-familiar-with-workspaces)                                          | `go.work`                         | Go                                 |
| [Cargo workspaces](https://doc.rust-lang.org/cargo/reference/workspaces.html)                              | `Cargo.toml` (workspace)          | Rust                               |

## Setting Up the Toolkit

### Step 1: Copy Files

Copy the toolkit's `.github/` directory to your monorepo root — the same place your `turbo.json` or `nx.json` lives.

```bash
cp -r dx-toolkit/.github/ your-monorepo/.github/
```

### Step 2: Enable Monorepo Instruction

The `monorepo.instructions.md` instruction auto-attaches when you edit monorepo config files:

```yaml
applyTo: '**/turbo.json, **/nx.json, **/pnpm-workspace.yaml, **/lerna.json'
```

This gives the AI context about workspace conventions, dependency boundaries, and change detection whenever you touch workspace config.

### Step 3: Use the Monorepo Agent

The `monorepo-expert` agent knows Turborepo, Nx, Lerna, pnpm workspaces, and Elixir umbrella projects. Use it for:

- Setting up workspace structure
- Configuring build pipelines and caching
- Resolving dependency conflicts between packages
- Setting up change detection for CI

```
@monorepo-expert Set up Turborepo caching for our build and test tasks
```

## Scoping Agents Per Package

In a monorepo with packages in different languages (e.g., a Next.js frontend + Python API), you want different agents for different packages.

### Approach 1: Direct Agent Selection

Tell the agent which package you're working on:

```
@typescript-expert Review the code in packages/web/
@python-expert Fix the auth bug in services/api/
```

### Approach 2: Package-Specific Instructions

Create a `copilot-instructions.md` in each package with package-specific context:

```
your-monorepo/
├── .github/
│   └── copilot-instructions.md          # Repo-wide rules
├── packages/
│   ├── web/
│   │   └── .github/
│   │       └── copilot-instructions.md  # Next.js-specific rules
│   └── api/
│       └── .github/
│           └── copilot-instructions.md  # Python API rules
```

Example for `packages/web/.github/copilot-instructions.md`:

```markdown
This is the web frontend package. It uses Next.js 15, React 19, and Tailwind CSS v4.
Run `pnpm --filter web dev` to start the dev server.
Run `pnpm --filter web test` to run tests.
```

### Approach 3: Instruction applyTo Globs

The instruction `applyTo` globs work with monorepo paths:

```yaml
# Already handled — typescript.instructions.md applies to **/*.ts
# which matches packages/web/src/components/Button.tsx
```

For package-specific rules, create custom instruction files:

```yaml
# .github/instructions/web-package.instructions.md
applyTo: 'packages/web/**/*.tsx'
description: 'Rules specific to the web frontend package'
```

## Change Detection

### The Monorepo Change Detector Workflow

The `monorepo-change-detector.yml` workflow detects which packages changed in a PR and runs only the affected tests. Copy the workflow to your repo:

```bash
cp dx-toolkit/templates/workflows/monorepo-change-detector.yml .github/workflows/
```

This workflow:

1. Compares the PR branch against the base branch
2. Identifies which packages have file changes
3. Outputs a list of affected packages
4. Downstream jobs use this list to run only relevant builds and tests

### Manual Change Detection

If you're using Turborepo or Nx, they have built-in change detection:

```bash
# Turborepo — run only affected packages
turbo run build --filter=...[origin/main]

# Nx — run only affected projects
nx affected --target=build --base=origin/main
```

## The Monorepo Setup Skill

For a guided walkthrough, use the `monorepo-setup` skill. Invoke it through the `/setup-monorepo` prompt:

```
/setup-monorepo
```

The skill walks you through:

1. **Choose a tool** — Turborepo vs Nx vs pnpm workspaces vs Lerna (with trade-off analysis)
2. **Define your packages** — apps, shared libraries, configs
3. **Configure build pipeline** — task dependencies, caching, parallelism
4. **Set up dependency boundaries** — which packages can import from which
5. **Configure CI** — change detection, affected-only builds, caching in CI
6. **Add the toolkit** — agents, instructions, and workflows for your monorepo

## Example: Next.js + API Monorepo

Here's a complete walkthrough for setting up a monorepo with a Next.js frontend and a Node.js API.

### Structure

```
my-project/
├── .github/
│   ├── agents/          # From dx-toolkit
│   ├── instructions/    # From dx-toolkit
│   ├── prompts/         # From dx-toolkit
│   ├── skills/          # From dx-toolkit
│   └── workflows/
│       └── monorepo-change-detector.yml
├── apps/
│   ├── web/             # Next.js frontend
│   │   ├── src/
│   │   └── package.json
│   └── api/             # Node.js API
│       ├── src/
│       └── package.json
├── packages/
│   └── shared/          # Shared types and utilities
│       ├── src/
│       └── package.json
├── turbo.json
├── pnpm-workspace.yaml
└── package.json
```

### 1. Initialize the Workspace

```bash
mkdir my-project && cd my-project
pnpm init
```

Create `pnpm-workspace.yaml`:

```yaml
packages:
  - 'apps/*'
  - 'packages/*'
```

### 2. Add Turborepo

```bash
pnpm add -D turbo -w
```

Create `turbo.json`:

```json
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "dist/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "test": {
      "dependsOn": ["^build"]
    },
    "lint": {}
  }
}
```

### 3. Create the Apps

```bash
# Next.js frontend
cd apps && pnpx create-next-app@latest web --typescript --tailwind --app
# Node.js API
mkdir api && cd api && pnpm init
```

### 4. Copy the Toolkit

```bash
# From the monorepo root
cp -r dx-toolkit/.github/ .github/
cp dx-toolkit/templates/workflows/monorepo-change-detector.yml .github/workflows/
```

### 5. Use Agents for Each Package

```
# Working on the frontend
@nextjs-expert Add server-side auth to the web app

# Working on the API
@typescript-expert Set up Express routes in the API package

# Working on the monorepo config
@monorepo-expert Configure shared TypeScript config across packages
```

### 6. Run Affected-Only CI

The change detector workflow automatically identifies which packages changed in a PR. Your CI only builds and tests what's affected:

```yaml
# In your CI workflow
jobs:
  detect:
    uses: ./.github/workflows/monorepo-change-detector.yml

  test-web:
    needs: detect
    if: contains(needs.detect.outputs.affected, 'web')
    # ... run web tests

  test-api:
    needs: detect
    if: contains(needs.detect.outputs.affected, 'api')
    # ... run API tests
```

## Tips

- **Keep the toolkit at the root.** The `.github/` directory belongs at the monorepo root, not inside individual packages.
- **Use `applyTo` globs** to scope rules to specific packages when needed.
- **One `copilot-instructions.md` per package** if packages have very different conventions.
- **The `monorepo-expert` agent** is your go-to for workspace-level questions. Use language-specific agents for code inside packages.
- **Don't over-scope.** Most instructions (TypeScript, testing, git workflow) apply equally across all packages. Only create package-specific rules when packages genuinely differ.
