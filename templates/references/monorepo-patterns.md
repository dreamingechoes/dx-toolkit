# Monorepo Patterns Reference

Quick-reference for monorepo workspace strategies, dependency management, and CI optimization. Skills and prompts reference this checklist when needed.

## Workspace Tools Comparison

| Tool            | Language | Build Cache | Remote Cache | Task Runner | Plugin System               |
| --------------- | -------- | ----------- | ------------ | ----------- | --------------------------- |
| Turborepo       | JS/TS    | Yes         | Vercel       | Yes         | No                          |
| Nx              | Any      | Yes         | Nx Cloud     | Yes         | Yes (generators, executors) |
| pnpm workspaces | JS/TS    | No          | No           | No          | No                          |
| Yarn workspaces | JS/TS    | No          | No           | No          | No                          |
| Lerna           | JS/TS    | Via Nx      | Via Nx       | Via Nx      | No                          |
| Bazel           | Any      | Yes         | Yes          | Yes         | Yes (rules)                 |
| Pants           | Any      | Yes         | Yes          | Yes         | Yes (backends)              |
| Go workspaces   | Go       | Go cache    | No           | No          | No                          |
| Elixir umbrella | Elixir   | Mix cache   | No           | No          | No                          |

## Package Structure Patterns

### Standard Layout

```
apps/           → Deployable applications
packages/       → Shared libraries (internal)
tools/          → Build scripts, CLIs, generators
```

### By Domain

```
domains/
  ├── billing/
  │   ├── api/        → Billing service
  │   └── shared/     → Billing types/utils
  ├── users/
  │   ├── api/        → Users service
  │   └── shared/     → User types/utils
  └── shared/         → Cross-domain utilities
```

### By Layer

```
apps/web/             → Frontend
apps/api/             → Backend
packages/ui/          → Component library
packages/types/       → Shared TypeScript types
packages/config/      → Shared config (ESLint, TS, Prettier)
packages/utils/       → Shared utilities
```

## Dependency Rules

```
✅ apps/ → packages/         (apps import shared packages)
✅ packages/ → packages/     (packages can depend on other packages)
❌ packages/ → apps/         (shared code must not import app code)
❌ Circular dependencies     (A → B → A is forbidden)
```

## Build Caching Checklist

- [ ] Task `inputs` are defined (only files that affect the output)
- [ ] Task `outputs` are defined (build artifacts to cache)
- [ ] Dev tasks have `cache: false` and `persistent: true`
- [ ] Lint/typecheck tasks don't depend on build (runs faster)
- [ ] Remote cache is configured for CI (Vercel/Nx Cloud/custom)
- [ ] `.turbo/` or `.nx/` is in `.gitignore`
- [ ] Lock file is included in cache key

## Change Detection Patterns

### GitHub Actions with path filters

```yaml
- uses: dorny/paths-filter@v3
  with:
    filters: |
      web:
        - 'apps/web/**'
        - 'packages/ui/**'
        - 'packages/types/**'
```

### Turborepo filter

```bash
turbo run test --filter=...[origin/main]
```

### Nx affected

```bash
nx affected --target=test --base=origin/main
```

## Versioning Strategies

| Strategy          | When to Use                      | Tool                          |
| ----------------- | -------------------------------- | ----------------------------- |
| **Fixed**         | All packages share one version   | Lerna fixed mode              |
| **Independent**   | Packages version independently   | Lerna independent, Changesets |
| **No versioning** | Internal packages, not published | Most monorepos                |

## CI Optimization

- [ ] Install dependencies once, share across jobs (cache step)
- [ ] Use change detection to skip unaffected packages
- [ ] Run lint/typecheck in parallel with tests (no dependency)
- [ ] Enable remote caching for build artifacts
- [ ] Set `--concurrency` based on CI runner CPU count
- [ ] Use `--continue` to collect all failures, not just the first

## Common Mistakes

| Mistake                              | Fix                                            |
| ------------------------------------ | ---------------------------------------------- |
| All packages rebuild on every change | Define `inputs` for each task                  |
| Circular dependency between packages | Extract shared types to a third package        |
| Root `node_modules` is massive       | Use pnpm (strict hoisting) instead of npm/yarn |
| CI takes 30+ minutes                 | Enable remote caching + change detection       |
| Publishing fails with wrong versions | Use Changesets for automated versioning        |
| Deep imports (`@org/ui/src/Button`)  | Export only through package entry points       |
