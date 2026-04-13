---
description: 'Generate a conventional commit message from staged changes or a diff. Follows the Conventional Commits specification with proper type, scope, and description.'
agent: 'agent'
tools: [read, search, execute]
---

Generate a conventional commit message for the current changes.

## Procedure

1. **Analyze the diff** — understand what changed and why
2. **Determine the commit type**:
   - `feat` — new feature (MINOR version bump)
   - `fix` — bug fix (PATCH version bump)
   - `docs` — documentation only
   - `style` — formatting, no code change
   - `refactor` — code change that neither fixes a bug nor adds a feature
   - `perf` — performance improvement
   - `test` — adding or fixing tests
   - `build` — build system or dependencies
   - `ci` — CI/CD configuration
   - `chore` — maintenance tasks
3. **Identify the scope** — the module, component, or area affected
4. **Write the message** following the format below

## Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

## Rules

- Description: imperative mood, lowercase, no period, max 72 chars
- Body: explain **what** and **why**, not **how** (the diff shows how)
- Breaking changes: add `!` after type/scope AND `BREAKING CHANGE:` in footer
- Reference issues: `Closes #123` or `Refs #456` in footer

## Examples

```
feat(auth): add OAuth2 login with GitHub provider

Implement GitHub OAuth2 flow using the existing auth module.
Includes token refresh and session management.

Closes #42

---

fix(api): prevent null pointer on missing user profile

The /users/:id endpoint crashed when the profile relation
was not loaded. Now uses optional chaining with a fallback.

Fixes #87

---

refactor(db)!: migrate from UUID v4 to v7 for all primary keys

BREAKING CHANGE: All existing UUIDs remain valid but new records
use v7 format. Migration included.
```

## Output

A single commit message ready to use. If the changes are large and should be multiple commits, suggest how to split them.
