---
description: 'Set up a CI/CD pipeline for the detected project type. Generates GitHub Actions workflows with build, test, lint, and deploy stages.'
agent: 'agent'
---

Set up a CI/CD pipeline for this project.

## Procedure

1. **Detect project type**: Language, framework, package manager, test runner, build tool
2. **Generate CI workflow** (`.github/workflows/ci.yml`):
   - Install dependencies with caching
   - Run linter
   - Run type checker (if applicable)
   - Run tests with coverage
   - Build the project
3. **Generate CD workflow** (`.github/workflows/deploy.yml`) if deployment target is specified:
   - Deploy to staging on push to main
   - Deploy to production on release
   - Include health check after deployment
4. **Add quality gates**: Fail on lint errors, type errors, test failures, coverage drops

## Rules

- Use `--frozen-lockfile` or equivalent for reproducible installs
- Cache dependencies aggressively (node_modules, pip cache, cargo registry)
- Pin all action versions to specific SHAs or tags
- Add `timeout-minutes` to every job
- Add `concurrency` to prevent duplicate runs
- Use matrix strategy for multi-version testing if relevant
