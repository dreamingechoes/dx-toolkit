---
description: 'Write an Architecture Decision Record (ADR) using a structured template. Captures context, decision, and consequences for significant technical decisions.'
agent: 'agent'
---

Write an Architecture Decision Record for the described technical decision.

## Procedure

1. **Clarify the decision**: What exactly is being decided? What triggered it?
2. **Gather context**: What constraints, requirements, or pressures led to this decision point?
3. **List alternatives**: What options were considered? Why were they rejected?
4. **State the decision**: Clear, specific statement of what was chosen
5. **Document consequences**: Positive, negative, and neutral — be honest about trade-offs

## ADR Template

```markdown
# ADR-NNN: [Short Title]

## Status

Proposed

## Context

[What problem or situation prompted this decision? What constraints exist?]

## Options Considered

1. **[Option A]** — [Brief description, pros, cons]
2. **[Option B]** — [Brief description, pros, cons]
3. **[Option C]** — [Brief description, pros, cons]

## Decision

[What was chosen and why? Reference the specific option.]

## Consequences

### Positive

- [What improves or becomes easier]

### Negative

- [What gets harder, more expensive, or more complex]

### Neutral

- [What changes but isn't clearly better or worse]
```

## Rules

- Keep it under 300 words — ADRs are records, not essays
- Be specific: "We chose PostgreSQL 16" not "We chose a relational database"
- Include rejected alternatives — the "why not" is as valuable as the "why"
- Link to related ADRs if this supersedes or depends on another decision
- Store in `docs/adr/` or `docs/decisions/`, numbered sequentially
