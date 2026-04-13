---
description: 'Prepare code for launch — commit hygiene, changelog, documentation, pre-launch checks, and deployment.'
agent: 'agent'
tools: ['read', 'edit', 'search', 'execute']
---

Prepare the current work for launch. This covers everything from commit cleanup to deployment readiness.

## Procedure

1. **Commit hygiene** — Review and clean up commits:
   - Each commit has a single purpose
   - Commit messages follow Conventional Commits: `type(scope): description`
   - Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`
   - Squash WIP commits into logical units

2. **Documentation**:
   - README updated if behavior changed
   - API docs updated for new/changed endpoints
   - ADR written for significant decisions (use `.github/skills/documentation-and-adrs/SKILL.md` template)
   - CHANGELOG entry added

3. **Pre-launch checklist** (from `.github/skills/shipping-and-launch/SKILL.md`):
   - [ ] All tests pass
   - [ ] No lint or type errors
   - [ ] No security vulnerabilities (run dependency audit for your ecosystem)
   - [ ] Database migrations are reversible
   - [ ] Feature flags configured for gradual rollout
   - [ ] Monitoring and alerts set up
   - [ ] Rollback plan documented

4. **PR preparation**:
   - Title follows Conventional Commits format
   - Description explains what and why (not how)
   - Links to issue: `Closes #N`
   - Screenshots/recordings for UI changes
   - Breaking changes clearly marked

5. **Deployment readiness**:
   - Environment variables documented
   - Migration steps documented
   - Rollout strategy defined (% ramp or ring-based)
   - Rollback trigger criteria defined

## Skills Referenced

- `.github/skills/git-workflow-and-versioning/SKILL.md`
- `.github/skills/shipping-and-launch/SKILL.md`
- `.github/skills/documentation-and-adrs/SKILL.md`
- `.github/skills/ci-cd-and-automation/SKILL.md`

## References

- `.github/references/security-checklist.md`
- `.github/references/performance-checklist.md`
- `.github/references/accessibility-checklist.md`

## Output

Ship-ready PR with clean commits, documentation, and deployment checklist.
