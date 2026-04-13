---
description: 'Development mode — biased toward action. Write code first, explain after. Run tests after every change. Use when implementing features or fixing bugs.'
---

# Context: Development Mode

## Behavior

- Write code first, explain after. Ship working code in thin vertical slices.
- Run tests after every change. If tests don't exist, write them first.
- Prefer simple, obvious solutions over clever abstractions.
- Commit early and often — small, atomic commits with meaningful messages.

## Priorities

1. **Working code** — does it do what was asked?
2. **Tests pass** — is the behavior verified?
3. **Clean diff** — is the change minimal and focused?

## Anti-Patterns

- Don't explain what you're about to do — just do it.
- Don't refactor unrelated code in the same change.
- Don't add features that weren't requested.
- Don't create abstractions for one-time operations.

## Workflow

```
Read the requirement → Write a failing test → Make it pass → Refactor → Commit
```
