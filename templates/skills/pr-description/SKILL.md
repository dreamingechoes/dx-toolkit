---
name: pr-description
description: 'Generates a well-structured PR description from the current changes. Use after implementing changes and before creating a pull request. Analyzes the diff and creates a comprehensive description.'
---

# PR Description Generator

## When to Use

- After completing implementation, before creating a PR
- When asked to describe changes for a pull request
- When summarizing what was done for an issue

## Procedure

1. **Analyze the changes**: Review all modified/created/deleted files to understand:
   - What was changed
   - Why it was changed (reference the issue)
   - How it was changed (approach taken)

2. **Generate the PR description** using this template:

```markdown
## What

[Brief description of what this PR does — 1-2 sentences]

Closes #[issue-number]

## Why

[Why this change is needed — reference the issue context]

## How

[Technical approach taken — key decisions and tradeoffs]

### Changes

- **[file/module]**: [what changed and why]
- **[file/module]**: [what changed and why]

## Testing

- [ ] Existing tests pass
- [ ] New tests added for [describe]
- [ ] Manual testing done for [if applicable]

## Screenshots

[If UI changes, include before/after]

## Notes for Reviewers

[Any context that helps review: areas of uncertainty, alternative approaches considered, things to look out for]
```

3. **Quality checks**:
   - Every change is explained
   - The "Why" connects to the issue
   - Testing section is accurate
   - No implementation details are missing
