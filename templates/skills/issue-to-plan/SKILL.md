---
name: issue-to-plan
description: 'Converts a GitHub issue into a structured implementation plan. Use when starting work on a feature request, bug fix, or refactoring task. Produces a step-by-step plan with files to modify, tests to write, and acceptance criteria.'
---

# Issue to Implementation Plan

## When to Use

- Starting work on any GitHub issue
- Planning a feature before writing code
- Breaking down a complex task into steps

## Procedure

1. **Read the issue** carefully. Extract:
   - The core problem or requirement
   - Acceptance criteria (explicit or implied)
   - Any constraints or preferences mentioned
   - Related issues or PRs referenced

2. **Explore the codebase** to understand:
   - Project structure and architecture
   - Relevant existing code
   - Similar patterns already implemented
   - Test infrastructure and patterns

3. **Create the plan** as a checklist in this format:

```markdown
## Implementation Plan for #[issue-number]

### Summary

[One paragraph describing what needs to be done and why]

### Files to Modify

- [ ] `path/to/file.ext` — [what changes and why]
- [ ] `path/to/other.ext` — [what changes and why]

### Files to Create

- [ ] `path/to/new-file.ext` — [purpose]

### Steps

1. [ ] [First concrete step]
2. [ ] [Second step, depends on #1]
3. [ ] [Write tests for X]
4. [ ] [Update documentation]

### Tests Needed

- [ ] [Test case description]
- [ ] [Edge case description]

### Acceptance Criteria

- [ ] [Criterion from issue]
- [ ] [Inferred criterion]
- [ ] All existing tests pass
- [ ] New tests cover the changes
```

4. **Validate** the plan covers all requirements from the issue.
