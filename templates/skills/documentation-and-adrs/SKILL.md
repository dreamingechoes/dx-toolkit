---
name: documentation-and-adrs
description: 'Architecture Decision Records, API docs, inline documentation standards — document the why, not just the what. Use when making architectural decisions, changing APIs, or shipping features that others need to understand.'
---

# Documentation and ADRs

## Overview

Document decisions, not just code. The most valuable documentation explains **why** something was built the way it was — not what the code does (the code shows that). Architecture Decision Records (ADRs) capture the context, options, and reasoning behind significant decisions.

## When to Use

- Making an architectural decision (technology choice, pattern, trade-off)
- Changing a public API
- Shipping a feature that others will build on
- Someone asks "why is this built this way?" and the answer isn't obvious
- Onboarding a new team member who needs to understand the system

**When NOT to use:** Routine code changes that follow established patterns. Don't document the mundane — focus on decisions that affect future work.

## Architecture Decision Records (ADRs)

### When to Write an ADR

Write an ADR when:

- Choosing between technologies or libraries
- Defining a system boundary or communication pattern
- Making a trade-off that future engineers will question
- Changing a previous architectural decision

### ADR Format

Save ADRs in `docs/adr/` with sequential numbering.

```markdown
# ADR-0001: [Decision Title]

## Status

[Proposed | Accepted | Deprecated | Superseded by ADR-XXXX]

## Date

[YYYY-MM-DD]

## Context

[What is the issue that we're seeing that motivates this decision?
Include constraints, requirements, and forces at play.]

## Options Considered

### Option A: [Name]

- Pros: [advantages]
- Cons: [disadvantages]

### Option B: [Name]

- Pros: [advantages]
- Cons: [disadvantages]

### Option C: [Name]

- Pros: [advantages]
- Cons: [disadvantages]

## Decision

[Which option was chosen and why.]

## Consequences

[What becomes easier or harder because of this decision.
Include positive, negative, and neutral consequences.]
```

### ADR Rules

1. **ADRs are immutable** — Don't edit old ADRs. Write a new one that supersedes it.
2. **Include the options you rejected** — Future engineers will wonder "why didn't they just use X?" The ADR answers that.
3. **Write them when you decide, not after** — The context fades quickly. Capture it while it's fresh.
4. **Keep them short** — A good ADR is 1-2 pages. If it's longer, the decision might need breaking down.

## Documentation Types

| Type            | What to document                        | Where                       |
| --------------- | --------------------------------------- | --------------------------- |
| ADRs            | Architectural decisions                 | `docs/adr/`                 |
| README          | Project overview, setup, quickstart     | `README.md`                 |
| API docs        | Endpoints, schemas, auth, errors        | `docs/api/` or OpenAPI spec |
| Inline comments | **Why**, not what (the code shows what) | In the code                 |
| Changelogs      | User-facing changes per version         | `CHANGELOG.md`              |
| Guides          | How to accomplish specific tasks        | `docs/guides/`              |

## Inline Documentation Guidelines

### Comment the Why

```typescript
// BAD: comments that restate the code
// Increment counter by one
counter++

// GOOD: comments that explain why
// Rate limit resets after each billing cycle, so we track a per-cycle counter
// instead of a global one
counter++
```

### When to Add Inline Comments

- Business logic that isn't obvious from the code
- Workarounds for known bugs or limitations
- Performance optimizations that make code less readable
- Regex patterns or complex algorithms

### When NOT to Add Comments

- The code is self-explanatory
- You're restating what the function name already says
- The comment will become stale if the code changes

## API Documentation

Document every public API endpoint:

````markdown
## POST /api/tasks

Create a new task.

### Request

```json
{
  "title": "string (required, 1-200 chars)",
  "description": "string (optional)",
  "priority": "low | medium | high (default: medium)"
}
```
````

### Response (201 Created)

```json
{
  "id": "uuid",
  "title": "string",
  "createdAt": "ISO 8601"
}
```

### Errors

| Status | Code             | Description                         |
| ------ | ---------------- | ----------------------------------- |
| 400    | VALIDATION_ERROR | Invalid input                       |
| 401    | UNAUTHORIZED     | Missing or invalid auth token       |
| 409    | DUPLICATE        | Task with this title already exists |

```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The code is self-documenting" | Code shows what it does. It doesn't show why you chose this approach over the alternatives. |
| "We'll document it later" | Later never comes. Document decisions when you make them. |
| "ADRs are too formal" | A 10-line ADR is better than a Slack message that disappears in 3 months. |
| "Nobody reads docs" | Nobody reads bad docs. Good docs (short, focused, current) get read because they save time. |
| "Comments get stale" | Comments about why something exists don't go stale as fast as comments about how. Focus on the why. |

## Red Flags

- "Why is it done this way?" has no answer in the codebase
- Architecture decisions live only in Slack messages or meeting notes
- README hasn't been updated in months
- API documentation doesn't match actual behavior
- Inline comments describe what the code does instead of why
- No ADRs — every decision relies on institutional memory

## Verification

When documenting:

- [ ] Architectural decisions have ADRs with context, options, and rationale
- [ ] README is current — setup instructions work on a fresh clone
- [ ] Public APIs are documented with request/response schemas and error codes
- [ ] Inline comments explain why, not what
- [ ] Documentation lives near the code it describes (not a separate wiki that drifts)
- [ ] Changelogs reflect user-facing changes
```
