---
name: shipping-and-launch
description: 'Pre-launch checklists, feature flag lifecycle, staged rollouts, rollback procedures, and monitoring setup. Use when preparing to deploy to production, especially for major releases or user-facing changes.'
---

# Shipping and Launch

## Overview

Shipping is a deliberate process, not a prayer. This skill covers everything between "code is reviewed" and "users are using it safely" — pre-launch verification, rollout strategy, monitoring, and rollback planning. The goal: make shipping boring.

## When to Use

- Preparing to deploy to production
- Launching a new feature to users
- Deploying database migrations
- Releasing a major version
- Any change that could affect users if it goes wrong

**When NOT to use:** Internal tooling deployments with no user impact and easy rollback.

## Pre-Launch Checklist

Run through every item before deploying. Skip nothing.

### Code Quality

- [ ] All CI checks pass (lint, typecheck, test, build)
- [ ] Code has been reviewed and approved
- [ ] No `TODO` or `FIXME` comments related to this feature
- [ ] No debug logging or `console.log` left in production code

### Database

- [ ] Migrations are reversible
- [ ] Migrations run in < 30 seconds (or use online DDL)
- [ ] Backward compatible — old code works with new schema during deploy
- [ ] Data backfill tested on a copy of production data

### Security

- [ ] No secrets in code or config files
- [ ] User input is validated and sanitized
- [ ] Auth and authorization checks are in place
- [ ] CORS, rate limiting, and headers configured

### Performance

- [ ] Load tested at expected traffic levels
- [ ] No N+1 queries introduced
- [ ] Database queries have appropriate indexes
- [ ] Bundle size within targets (frontend)

### Feature Flags

- [ ] New features behind flags, disabled by default
- [ ] Flag configuration tested (on/off/percentage)
- [ ] Old code path still works when flag is off

### Monitoring

- [ ] Error tracking configured (Sentry, Bugsnag, etc.)
- [ ] Key metrics dashboarded (response time, error rate, throughput)
- [ ] Alerts set for critical thresholds
- [ ] Log queries prepared for common failure scenarios

### Communication

- [ ] Team notified of deployment window
- [ ] Changelog or release notes drafted
- [ ] Support team briefed on new features (if user-facing)
- [ ] Rollback plan documented and shared

## Rollout Strategy

### Staged Rollout

Don't go from 0% to 100%. Roll out gradually:

```
Stage 1: Internal team (dogfooding)
  → Monitor for 1 hour. Any errors? Fix before continuing.

Stage 2: 5% of users
  → Monitor for 4 hours. Compare metrics to baseline.

Stage 3: 25% of users
  → Monitor for 24 hours. Check error rates, performance.

Stage 4: 100% of users
  → Monitor for 48 hours. Clean up feature flags.
```

At any stage, if metrics degrade: **stop and investigate**. Don't push forward hoping it resolves.

### Rollback Plan

Every deployment needs a documented rollback:

```
ROLLBACK PLAN:
Trigger: [What conditions trigger a rollback — error rate > X%, p99 > Yms]
Action: [Exact steps to rollback]
  1. Disable feature flag [name] via [tool]
  2. If DB migration: run rollback migration [command]
  3. If code deploy: revert to [commit SHA] and redeploy
Owner: [Who can trigger the rollback]
Tested: [When was the rollback last tested? Never is not acceptable.]
```

### The Five-Minute Rule

After deployment, actively monitor for five minutes:

- Watch error tracking for new exceptions
- Check key metrics dashboards
- Verify the feature works in production (not just staging)
- Check logs for unexpected warnings

If anything looks wrong in the first five minutes, rollback immediately. Don't debug in production under time pressure.

## Post-Launch

### The 48-Hour Watch

For the first 48 hours after launch:

- Check error rates morning and afternoon
- Compare performance metrics to pre-launch baseline
- Watch for user-reported issues
- Keep rollback ready

### Feature Flag Cleanup

After successful launch (stable for 1+ week):

1. Remove the feature flag from code
2. Remove the old code path
3. Update documentation
4. Delete the flag from the flag management system

Don't skip cleanup. Stale flags accumulate as tech debt and make the code harder to understand.

## Common Rationalizations

| Rationalization                                     | Reality                                                                                                 |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| "It passed all tests, it's fine"                    | Tests don't cover production traffic patterns, data scale, or integration quirks. Monitor after deploy. |
| "We'll roll back if there's a problem"              | You'll roll back faster if you've documented and tested the rollback procedure.                         |
| "This is a small change, no need for the checklist" | Small changes cause outages too. The checklist takes 5 minutes. The outage takes hours.                 |
| "We don't need feature flags for this"              | Any user-facing change benefits from gradual rollout. Feature flags are the cheapest insurance.         |
| "I'll clean up the feature flag next sprint"        | Feature flag cleanup never graduates from "next sprint." Schedule it within 1 week of full rollout.     |

## Red Flags

- Deploying Friday afternoon
- No rollback plan documented
- "We'll monitor it" with no dashboards or alerts configured
- Feature flags left in code months after full rollout
- Going from 0% to 100% without staged rollout
- Deploying during peak traffic hours without reason
- No post-deploy verification ("it deployed, so it works")

## Verification

Before shipping:

- [ ] Pre-launch checklist completed — no items skipped
- [ ] Rollback plan documented with trigger conditions and exact steps
- [ ] Monitoring and alerts configured before deploy (not after)
- [ ] Staged rollout plan defined with go/no-go criteria per stage
- [ ] Communication sent to relevant teams
- [ ] Feature flags configured and tested

After shipping:

- [ ] Five-minute active monitoring completed
- [ ] No new errors in error tracking
- [ ] Key metrics match pre-launch baseline
- [ ] Feature flag cleanup scheduled
