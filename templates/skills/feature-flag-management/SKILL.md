---
name: feature-flag-management
description: 'Manage feature flag lifecycle: creation, rollout, monitoring, and cleanup. Covers percentage rollouts, user targeting, kill switches, and dead flag removal.'
---

# Feature Flag Management

## Overview

Feature flags decouple deployment from release. They let you ship code to production behind a toggle, roll out gradually to a percentage of users, and kill a feature instantly if something goes wrong. But flags have a dark side: left uncleaned, they become technical debt that makes code harder to read and reason about.

This skill covers the full flag lifecycle — from creation through rollout to cleanup. A flag that lives forever is a bug.

## When to Use

- Releasing a new feature gradually (percentage rollout)
- Protecting a risky change behind a kill switch
- Running A/B tests or experiments
- Enabling features for specific users, teams, or environments
- Performing trunk-based development and shipping incomplete work safely
- Auditing existing flags for staleness

**When NOT to use:** Simple environment-based configuration (dev/staging/prod settings). Those belong in config files, not feature flags.

## Process

### Step 1 — Define Flag Purpose

Every flag needs a clear reason to exist and a planned removal date.

**Flag brief:**

```markdown
Flag name: [kebab-case-name]
Type: [release | experiment | ops | permission]
Purpose: [One sentence — what this flag controls]
Owner: [Person or team responsible]
Created: [Date]
Expected removal: [Date — max 90 days for release flags]
Default value: [off/on]
```

**Flag types:**

| Type       | Purpose                          | Lifetime                       | Example                |
| ---------- | -------------------------------- | ------------------------------ | ---------------------- |
| Release    | Gate new features during rollout | Days to weeks                  | `new-checkout-flow`    |
| Experiment | A/B test or multivariate test    | Weeks to months                | `pricing-page-variant` |
| Ops        | Circuit breakers, kill switches  | Permanent (reviewed quarterly) | `disable-external-api` |
| Permission | User/team entitlements           | Permanent (reviewed quarterly) | `beta-access`          |

### Step 2 — Choose Flag Type and Targeting

Match the flag implementation to its purpose.

**Evaluation strategies:**

| Strategy         | When to Use                         | Example                               |
| ---------------- | ----------------------------------- | ------------------------------------- |
| Boolean (on/off) | Kill switches, simple feature gates | `isEnabled("new-nav")`                |
| Percentage       | Gradual rollout to users            | `10% → 25% → 50% → 100%`              |
| User targeting   | Beta users, internal testing        | `enabledFor(userId, ["beta-group"])`  |
| Environment      | Feature available only in staging   | `enabledInEnv("staging")`             |
| Multivariate     | A/B/C tests with multiple variants  | `variant("pricing", ["a", "b", "c"])` |

**Naming conventions:**

```
Format: [scope]-[feature]-[qualifier]

Good:
  checkout-new-payment-form
  search-elasticsearch-migration
  ops-disable-email-notifications
  exp-pricing-page-variant-b

Bad:
  flag1
  temp
  new_feature
  johns-test
```

### Step 3 — Implement the Toggle

Keep flag evaluation clean and centralized.

**Implementation rules:**

1. **Evaluate flags at the boundary** — check the flag in the controller/handler, not deep in business logic
2. **One code path per flag** — avoid nesting flags inside flags
3. **Use a single evaluation point** — don't check the same flag in multiple places
4. **Make the default safe** — if the flag service is down, the default should be the safe option (usually off for new features, on for kill switches)

**Code patterns:**

```
// GOOD — clean boundary check
function handleCheckout(request) {
  if (flags.isEnabled("new-checkout-flow", request.user)) {
    return newCheckoutFlow(request)
  }
  return legacyCheckoutFlow(request)
}

// BAD — flag deep in business logic
function calculateDiscount(cart) {
  for (item of cart.items) {
    if (flags.isEnabled("new-discount-rules")) {  // buried
      // ...
    }
  }
}

// BAD — same flag checked in multiple places
function renderPage() {
  if (flags.isEnabled("new-nav")) { renderNewNav() }
  // ... 200 lines later ...
  if (flags.isEnabled("new-nav")) { renderNewFooter() }
}
```

### Step 4 — Configure Rollout Plan

Define the rollout stages before turning the flag on.

**Rollout template:**

```markdown
## Rollout Plan: [flag-name]

### Stages

| Stage             | Percentage    | Target Group | Duration    | Success Criteria            |
| ----------------- | ------------- | ------------ | ----------- | --------------------------- |
| 1 — Internal      | 0% + internal | Team members | 2 days      | No errors in logs           |
| 2 — Canary        | 5%            | Random users | 3 days      | Error rate < 0.1%           |
| 3 — Early rollout | 25%           | Random users | 3 days      | No regression in metrics    |
| 4 — Broad rollout | 50%           | Random users | 3 days      | Performance within baseline |
| 5 — Full rollout  | 100%          | All users    | 1 week      | All metrics stable          |
| 6 — Cleanup       | Remove flag   | N/A          | Next sprint | Flag code removed           |

### Rollback Trigger

Kill the flag immediately if:

- Error rate increases > 2x baseline
- P95 response time increases > 50%
- User-reported issues spike

### Monitoring

- Dashboard: [link]
- Alert channel: [channel]
- On-call: [person]
```

### Step 5 — Monitor Flag Impact

Track metrics during rollout to detect problems early.

**Monitoring checklist:**

- [ ] Error rate segmented by flag state (on vs off)
- [ ] Response time segmented by flag state
- [ ] Business metrics segmented by flag state (conversion, engagement)
- [ ] Flag evaluation count (detect unexpected evaluation patterns)
- [ ] Alerts configured for anomalies during rollout

**Flag dashboard should show:**

| Metric          | Flag On | Flag Off | Delta |
| --------------- | ------- | -------- | ----- |
| Error rate      |         |          |       |
| P95 latency     |         |          |       |
| Conversion rate |         |          |       |
| Feature usage   |         |          |       |

### Step 6 — Clean Up Dead Flags

This is the most important step and the one most teams skip.

**Staleness rules:**

| Flag Type  | Stale After                | Action                                   |
| ---------- | -------------------------- | ---------------------------------------- |
| Release    | 100% rollout for > 2 weeks | Remove flag, keep new code path          |
| Experiment | Experiment concluded       | Remove flag, keep winning variant        |
| Ops        | Not toggled in 6 months    | Review — remove or document why it stays |
| Permission | Review quarterly           | Remove unused permissions                |

**Cleanup process:**

1. Search codebase for the flag name
2. Remove all conditional branches — keep only the winning/default path
3. Remove flag from the flag service configuration
4. Remove associated tests that tested both paths
5. Add tests for the now-permanent behavior if missing
6. Delete the flag definition from the flag service

**Stale flag detection automation:**

```
Weekly scan:
  - List all flags with type "release" that are 100% enabled
  - If enabled > 14 days → create cleanup ticket
  - If enabled > 30 days → escalate to team lead
  - If enabled > 90 days → mark as tech debt, add to sprint
```

## Common Rationalizations

| Rationalization                      | Reality                                                                                                 |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------- |
| "We might need to turn it off later" | If the feature has been at 100% for weeks with no issues, you won't turn it off. Remove the flag.       |
| "Cleanup is low priority"            | Flag debt compounds. 50 stale flags make every code path harder to understand.                          |
| "We'll clean it up next sprint"      | Schedule cleanup as part of the rollout plan, not as a separate task that gets deprioritized.           |
| "Let's add a flag just in case"      | Flags add complexity. Only add them when you have a specific rollout or rollback need.                  |
| "It's just an if statement"          | It's an if statement that splits every code path, doubles testing surface, and confuses new developers. |

## Red Flags

- Flags with no owner or creation date
- Release flags that have been at 100% for over a month
- Nested flag checks (flag inside a flag)
- Flag evaluated in more than 3 locations in the codebase
- No monitoring during rollout — the flag was just flipped to 100%
- Flag names that don't describe what they control
- No documented rollback criteria
- Flags used for permanent configuration (use config instead)

## Verification

- [ ] Every flag has a documented purpose, owner, and expected removal date
- [ ] Flag naming follows the project convention
- [ ] Rollout plan is defined with stages and success criteria
- [ ] Monitoring is configured to compare flag-on vs flag-off metrics
- [ ] Rollback trigger criteria are documented
- [ ] Stale flag detection is automated (scan or alert)
- [ ] Cleanup is included in the rollout plan as a final stage
- [ ] No flags are nested inside other flags
