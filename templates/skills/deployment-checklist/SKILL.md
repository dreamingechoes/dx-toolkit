---
name: deployment-checklist
description: 'Pre-deployment verification checklist. Use before deploying to staging or production. Covers code quality, security, performance, database migrations, feature flags, and rollback plans.'
---

# Deployment Checklist

## When to Use

- Before deploying a release to staging or production
- After completing a major feature branch
- When preparing a hotfix for production
- As a final verification before merging to main

## Procedure

1. **Verify the code**:
   - [ ] All tests pass locally and in CI
   - [ ] No compiler warnings or lint errors
   - [ ] Code reviewed and approved
   - [ ] PR merged with all checks green

2. **Check database changes**:
   - [ ] Migrations are reversible (rollback tested)
   - [ ] No destructive schema changes without a migration plan
   - [ ] Large data migrations are batched
   - [ ] Indexes created concurrently where applicable
   - [ ] Backward compatibility maintained (old code works with new schema)

3. **Verify security**:
   - [ ] No secrets in code or environment variable defaults
   - [ ] Dependencies scanned for vulnerabilities
   - [ ] Auth/authz tested for new endpoints
   - [ ] Input validation in place for new user-facing inputs
   - [ ] CSP headers updated if new external resources added

4. **Check performance**:
   - [ ] No N+1 queries introduced
   - [ ] New endpoints have appropriate caching
   - [ ] Large responses are paginated
   - [ ] Expensive operations are async/background
   - [ ] Load tested if high-traffic endpoint

5. **Prepare deployment**:
   - [ ] Feature flags configured (if applicable)
   - [ ] Environment variables set in staging/production
   - [ ] Third-party service changes deployed first (webhooks, API keys)
   - [ ] Monitoring dashboards updated (new metrics, alerts)
   - [ ] Runbook updated for new features

6. **Plan rollback**:
   - [ ] Rollback procedure documented
   - [ ] Database rollback tested
   - [ ] Feature flag kill switch available
   - [ ] Previous version tagged and deployable

7. **Post-deploy verification**:
   - [ ] Smoke test critical paths
   - [ ] Check error rates in monitoring
   - [ ] Verify logging is working
   - [ ] Confirm metrics are collecting
   - [ ] Test new features in production

## Produce the Report

```markdown
## Deployment Report: [Release Version/Name]

**Date**: [Date]
**Deployer**: [Name]
**Environment**: staging / production

### Changes Included

- [PR #1: description]
- [PR #2: description]

### Pre-Deploy Checks

- [x] Tests passing
- [x] Code reviewed
- [x] Migrations tested
- [ ] Load tested (N/A for this release)

### Rollback Plan

[Steps to rollback if issues arise]

### Post-Deploy Status

- [ ] Smoke test passed
- [ ] Error rates normal
- [ ] Monitoring confirmed
```
