---
name: git-workflow-and-versioning
description: 'Trunk-based development with atomic commits, Conventional Commits, and semantic versioning. Use when making any code change — this skill applies to every commit, branch, and merge.'
---

# Git Workflow and Versioning

## Overview

Every change flows through git. This skill defines how to commit, branch, and version code so that history is readable, deployable, and revertable. Follows trunk-based development with short-lived feature branches and Conventional Commits.

## When to Use

- Always. Every code change goes through git.

## Commit Standards

### Atomic Commits

Each commit does one thing. If it can't be described in one line, split it.

```
GOOD:
  feat(auth): add password reset endpoint
  test(auth): add password reset tests
  docs(auth): document password reset flow

BAD:
  feat(auth): add password reset with tests and docs and also fix that login bug
```

### Conventional Commits

Format: `type(scope): description`

| Type       | When to use                                  |
| ---------- | -------------------------------------------- |
| `feat`     | New feature for the user                     |
| `fix`      | Bug fix for the user                         |
| `docs`     | Documentation only                           |
| `style`    | Formatting, semicolons (no code change)      |
| `refactor` | Restructuring code without changing behavior |
| `perf`     | Performance improvement                      |
| `test`     | Adding or fixing tests                       |
| `build`    | Build system or dependencies                 |
| `ci`       | CI configuration                             |
| `chore`    | Maintenance tasks                            |

Rules:

- Type is required. Scope is recommended.
- Description starts with lowercase, no period at the end.
- Body explains **why**, not **what** (the diff shows what).
- Footer references issues: `Closes #42`

```
feat(tasks): add bulk delete endpoint

Allow users to delete multiple tasks in a single request.
Validates ownership for each task before deletion.

Closes #127
```

### Change Sizing

Target ~100 lines of changed code per commit. This isn't a hard rule, but a signal:

| Size   | Lines   | Review Time     | Risk      |
| ------ | ------- | --------------- | --------- |
| Small  | < 100   | Minutes         | Low       |
| Medium | 100-300 | Hours           | Medium    |
| Large  | 300-500 | Half-day        | High      |
| XL     | 500+    | **Split this.** | Very high |

### Commits as Save Points

Commit early and often. Each commit is a save point you can return to. Don't wait until a feature is "done" — commit each working increment (see `incremental-implementation`).

## Branching Strategy

### Trunk-Based Development

- `main` is always deployable
- Feature branches are short-lived (< 2 days)
- Branch names: `type/short-description` — e.g., `feat/bulk-delete`, `fix/login-redirect`

```
main ─────●────●────●────●────●────●─────
           \       /      \       /
            feat/x        fix/y
```

### Branch Rules

- Branch from `main`
- Rebase on `main` before merging (keeps history linear)
- Delete the branch after merge
- Never push directly to `main`

## Pull Requests

### PR Size

Keep PRs small. A PR should take < 30 minutes to review. If it takes longer, break it up.

### PR Description

Follow the repository's PR template. At minimum:

- **What** changed
- **Why** it changed
- **How** to test it
- Reference the issue: `Closes #N`

### Review Turnaround

Review PRs within 24 hours. Blocked PRs block the team.

## Semantic Versioning

`MAJOR.MINOR.PATCH`

| Bump  | When                                                           |
| ----- | -------------------------------------------------------------- |
| MAJOR | Breaking changes — API contract changes, removed functionality |
| MINOR | New features, backward-compatible additions                    |
| PATCH | Bug fixes, backward-compatible corrections                     |

Use `feat:` commits for MINOR bumps, `fix:` for PATCH, and `feat!:` or `BREAKING CHANGE:` footer for MAJOR.

## Common Rationalizations

| Rationalization                                           | Reality                                                                                                        |
| --------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| "I'll clean up the commits later with interactive rebase" | You won't. Write clean commits as you go. It takes the same effort.                                            |
| "This change is too small for its own commit"             | Small commits are free and easy to revert. Large commits are expensive to debug.                               |
| "The branch will only take a few days"                    | Long-lived branches cause merge conflicts and integration pain. Break into smaller PRs.                        |
| "Nobody reads commit messages"                            | Commit messages are how you find out when and why something changed. `git blame` is useless with bad messages. |
| "I'll squash everything at merge"                         | Squash merges lose the incremental history. Each commit should be atomic and meaningful.                       |

## Red Flags

- Commit messages like "fix", "wip", "stuff", "update"
- Branches alive longer than 3 days
- PR with 500+ lines of changes
- Direct pushes to `main`
- Merge conflicts that require rewriting code
- Multiple unrelated changes in one PR
- No issue reference in the PR

## Verification

For every change:

- [ ] Commits follow Conventional Commits format
- [ ] Each commit does one thing
- [ ] The PR is scoped to one concern
- [ ] The PR references an issue
- [ ] The branch is short-lived (< 2 days)
- [ ] The PR is reviewable in < 30 minutes
- [ ] `main` is still deployable after merge
