---
description: 'Polish code for correctness, simplicity, security, and performance — provide actionable feedback.'
agent: 'agent'
tools: ['read', 'search']
---

Review the provided code or diff for quality, correctness, and maintainability.

## Procedure

1. **Understand context** — Before reviewing:
   - What is this code supposed to do?
   - What spec or task does it implement?
   - Read surrounding code for conventions and patterns

2. **Check correctness**:
   - Does the code do what it claims?
   - Are edge cases handled (null, empty, overflow, concurrent access)?
   - Are error paths handled appropriately?
   - Do tests cover the critical paths?

3. **Check simplicity**:
   - Could this be simpler while still being correct?
   - Are there unnecessary abstractions or indirection?
   - Is there dead code or unused imports?
   - Are functions focused (single responsibility)?
   - Would a future reader understand this without the PR description?

4. **Check security** (reference `.github/references/security-checklist.md`):
   - Input validation on external data?
   - SQL injection, XSS, or command injection risks?
   - Secrets or credentials in code?
   - Proper authorization checks?

5. **Check performance** (only if relevant):
   - N+1 queries?
   - Unnecessary re-renders or re-computations?
   - Missing indexes for new queries?
   - Unbounded data fetching?

6. **Provide feedback** using this format:

```markdown
## Review Summary

[1-2 sentence overall assessment]

## Must Fix

- **[File:Line]**: [Issue]. [Suggestion].

## Should Fix

- **[File:Line]**: [Issue]. [Suggestion].

## Nits

- **[File:Line]**: [Minor suggestion].

## What's Good

- [Positive callout — always include at least one]
```

## Skills Referenced

- `.github/skills/code-simplification/SKILL.md`
- `.github/skills/code-review/SKILL.md`
- `.github/skills/performance-optimization/SKILL.md`

## References

- `.github/references/security-checklist.md`
- `.github/references/performance-checklist.md`

## Output

Structured review with categorized feedback (must fix / should fix / nits / good).
