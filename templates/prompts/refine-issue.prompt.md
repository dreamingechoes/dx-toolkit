---
description: 'Refine a vague or incomplete GitHub issue into a well-structured, actionable issue.'
agent: 'copilot'
---

Take the issue (pasted below or referenced by number) and rewrite it into a clear, actionable format.

## Procedure

1. Read the original issue text
2. Identify what's missing: reproduction steps? expected behavior? acceptance criteria? context?
3. Infer what you can from the text — don't invent requirements, but fill obvious gaps
4. Rewrite using the structure below
5. Flag anything that still needs clarification from the author

## Output

Use this structure for the refined issue:

```markdown
## Summary

One or two sentences explaining the problem or feature request.

## Context

Why this matters. What user pain or technical debt does it address?

## Current Behavior (bugs only)

What happens now — be specific.

## Expected Behavior

What should happen instead.

## Steps to Reproduce (bugs only)

1. Step one
2. Step two
3. Observe: [specific thing that's wrong]

## Acceptance Criteria

- [ ] Criterion 1 — specific, testable
- [ ] Criterion 2
- [ ] Tests pass

## Notes

Any constraints, related issues, or open questions.
If anything is unclear from the original, note it here:

- ⚠️ "Unclear: [thing that needs the author's input]"
```

Remove sections that don't apply (e.g., skip "Steps to Reproduce" for feature requests).
