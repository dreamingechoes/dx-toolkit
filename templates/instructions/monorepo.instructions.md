---
description: 'Monorepo workspace conventions. Auto-attached when editing workspace config files. Covers dependency boundaries, package structure, build orchestration, and change detection.'
applyTo: '**/turbo.json, **/nx.json, **/pnpm-workspace.yaml, **/lerna.json'
---

# Monorepo Conventions

## Workspace Structure

- Organize into `apps/` (deployables), `packages/` (shared libraries), `tools/` (internal scripts)
- Each package has its own manifest (`package.json`, `mix.exs`, `pyproject.toml`, `go.mod`)
- Every package has a `README.md` explaining its purpose and public API

## Dependency Boundaries

- Apps depend on packages — never the reverse
- Packages export through a single entry point (barrel/index file)
- Never import from another package's internal files
- Use workspace protocol for internal deps: `"workspace:*"` or `"workspace:^"`
- Run `syncpack` or similar to keep dependency versions consistent across packages

## Build Orchestration

- Define task pipelines: libraries build before apps that consume them
- Configure cache inputs/outputs for each task to avoid unnecessary rebuilds
- Enable remote caching for team environments (Vercel Remote Cache, Nx Cloud)
- Keep pipelines additive — adding a package should not slow down unrelated builds

## Change Detection

- CI should detect changed packages and run only affected tasks
- Use `--filter=...[origin/main]` (Turborepo) or `nx affected` (Nx) for scoped runs
- Tag releases per package when publishing independently

## Versioning

- Use independent versioning when packages have different consumers
- Use fixed versioning when all packages ship together
- Changesets (`@changesets/cli`) works well for version management in JS/TS monorepos
