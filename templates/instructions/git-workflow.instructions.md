---
description: 'Git workflow standards. Use when creating commits, branches, PRs, or managing releases. Covers Conventional Commits, branching strategy, and PR best practices.'
---

# Git Workflow Standards

## Branch Naming

- `feat/<description>` — new features
- `fix/<description>` — bug fixes
- `refactor/<description>` — code improvements
- `docs/<description>` — documentation changes
- `chore/<description>` — maintenance tasks
- Use kebab-case: `feat/add-user-auth`, not `feat/addUserAuth`
- Include issue number when applicable: `fix/123-null-pointer`

## Conventional Commits

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`
**Breaking changes**: `feat(api)!: remove v1 endpoints` + `BREAKING CHANGE:` in footer

## Commit Guidelines

- Atomic commits — one logical change per commit
- Imperative mood: "add feature" not "added feature"
- Max 72 chars for subject line
- Body explains **what** and **why**, not **how**
- Reference issues in footer: `Closes #123`

## PR Best Practices

- One concern per PR — don't mix refactoring with features
- Keep PRs small (< 500 lines changed)
- Write a clear description (what, why, how)
- Self-review before requesting reviews
- Use draft PRs for work-in-progress
- Squash merge for clean history, merge commit for preserving context

## Release Strategy

- Tag releases with semver: `v1.2.3`
- Use Conventional Commits for automatic versioning
- Generate changelogs from commit history
- Never force push to main/release branches
