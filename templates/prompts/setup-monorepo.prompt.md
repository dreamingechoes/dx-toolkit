---
description: 'Set up a monorepo with workspace tooling, package structure, build caching, and CI change detection. Supports Turborepo, Nx, pnpm workspaces, and Lerna.'
agent: 'agent'
---

Set up a monorepo for this project using the `monorepo-setup` skill.

## Procedure

1. **Assess the project**: Identify existing packages/apps, languages, and deployment targets
2. **Choose workspace tool**: Recommend the best tool based on project size, language, and team needs
3. **Create the structure**: Set up `apps/`, `packages/`, `tools/` directories with proper manifests
4. **Configure build orchestration**: Set up `turbo.json` (or equivalent) with task dependencies and caching
5. **Set up CI**: Add change detection so PRs only test affected packages
6. **Add dependency boundaries**: Configure rules to prevent invalid imports between packages
7. **Verify**: Run full build, confirm caching works, confirm change detection works

## Output

- Workspace configuration file (`turbo.json`, `nx.json`, or equivalent)
- Package manifest for each app and shared package
- CI workflow with change detection
- Root README documenting the monorepo structure
