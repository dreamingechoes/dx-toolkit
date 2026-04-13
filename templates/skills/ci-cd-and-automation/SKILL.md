---
name: ci-cd-and-automation
description: 'Shift Left quality gates, feature flag pipelines, and deployment automation. Use when setting up or modifying build and deploy pipelines, or when establishing quality gates for a project.'
---

# CI/CD and Automation

## Overview

Shift quality checks left — run them as early as possible in the development pipeline. CI catches bugs before they reach production. CD makes deployment boring and repeatable instead of a risky event.

## When to Use

- Setting up CI/CD for a new project
- Adding quality gates to an existing pipeline
- Debugging pipeline failures
- Planning a deployment strategy
- Implementing feature flags

**When NOT to use:** One-off manual deployments where automation cost exceeds benefit. But if you're deploying more than once a month, automate it.

## CI Pipeline Design

### The Quality Gate Pipeline

Every push runs these checks, in this order:

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│  Lint   │──→│  Type   │──→│  Test   │──→│  Build  │──→│ Security│
│         │   │  Check  │   │         │   │         │   │  Scan   │
└─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘
```

Fail early: linting is cheapest and catches the most common issues. Don't run expensive tests if linting fails.

### Pipeline Configuration

```yaml
# Minimum CI pipeline — GitHub Actions example
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
      - run: npm ci
      - run: npm run lint
      - run: npm run typecheck
      - run: npm test
      - run: npm run build
```

### Required Checks for PRs

Configure branch protection so PRs can't merge without:

- All CI checks passing
- At least one approval
- Up-to-date with `main`

## CD Pipeline Design

### Deployment Strategy

| Strategy                 | Risk     | Best For                       |
| ------------------------ | -------- | ------------------------------ |
| Direct deploy            | High     | Small projects, internal tools |
| Blue/green               | Low      | Stateless services             |
| Canary (1% → 10% → 100%) | Very low | High-traffic user-facing apps  |
| Feature flags            | Very low | Gradual rollout, A/B testing   |

### Feature Flags

Use feature flags to decouple deployment from release:

```typescript
// Deployment: code is in production
// Release: feature is visible to users
if (featureFlags.isEnabled('new-checkout', { userId })) {
  return <NewCheckout />;
}
return <OldCheckout />;
```

Feature flag lifecycle:

1. **Create** — disabled by default
2. **Test** — enable for internal users / staging
3. **Rollout** — enable for percentage of users
4. **Full release** — enable for all users
5. **Clean up** — remove the flag and old code path

## Shift Left Principles

Move checks earlier in the pipeline to reduce feedback time:

```
Local (fastest):  Linting, formatting, type checking
Pre-commit:       Hooks that run lint + format
CI (minutes):     Tests, build, security scan
Staging (hours):  Integration tests, smoke tests
Production:       Monitoring, alerting, feature flags
```

Tools for local checks:

- **Pre-commit hooks** — `lint-staged` + `husky` (JS/TS), `pre-commit` (Python), `mix format --check-formatted` (Elixir)
- **Editor integration** — ESLint, Prettier, TypeScript in VS Code

## Pipeline Anti-Patterns

| Anti-Pattern                  | Fix                                                                                |
| ----------------------------- | ---------------------------------------------------------------------------------- |
| Tests take > 15 minutes       | Parallelize. Cache dependencies. Use test impact analysis.                         |
| Flaky tests block deploys     | Quarantine flaky tests. Fix or delete within 48 hours.                             |
| No caching                    | Cache `node_modules`, build artifacts, Docker layers.                              |
| Deploying from local machines | All deployments go through CI/CD. No exceptions.                                   |
| Manual approval gates         | Automate everything except production deploy approval.                             |
| No rollback plan              | Every deploy must have a documented rollback. If you can't undo it, don't ship it. |

## Common Rationalizations

| Rationalization                       | Reality                                                                                                             |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| "CI is too slow"                      | Slow CI means your pipeline needs optimization — caching, parallelism, or pruning. Don't skip CI because it's slow. |
| "We'll add CI later"                  | Later never comes. Set up CI on day 1, even if it's just lint + test.                                               |
| "Feature flags add complexity"        | Less complexity than rollback procedures. Flags are the simplest way to deploy safely.                              |
| "We don't need staging"               | You need at least one environment that isn't production. Even a local Docker Compose counts.                        |
| "I'll just deploy manually this once" | Manual deployments accumulate tribal knowledge and aren't reproducible.                                             |

## Red Flags

- PRs merged without CI checks passing
- Deployments from local machines
- No rollback procedure documented
- Feature flags that live forever (clean up after full rollout)
- Flaky tests ignored instead of fixed
- CI pipeline takes > 20 minutes (optimize it)
- Secrets hardcoded in pipeline configuration

## Verification

When setting up or modifying CI/CD:

- [ ] Every push triggers quality checks (lint, typecheck, test, build)
- [ ] PRs can't merge without passing checks
- [ ] Dependencies are cached between runs
- [ ] Deployment is automated (no manual steps)
- [ ] Rollback procedure exists and is documented
- [ ] Feature flags are used for incomplete features
- [ ] Pipeline completes in < 15 minutes
- [ ] Secrets are stored in CI/CD variables, not in code
