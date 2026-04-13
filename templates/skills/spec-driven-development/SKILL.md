---
name: spec-driven-development
description: 'Write a specification covering objectives, structure, code style, testing, and boundaries before writing any code. Use when starting a new project, feature, or significant change. The spec becomes the source of truth for all implementation decisions.'
---

# Spec-Driven Development

## Overview

Write the spec before the code. A spec defines what you're building, how it should behave, and where the boundaries are. Without one, you discover requirements mid-implementation — leading to rework, scope creep, and ambiguous "done" criteria.

## When to Use

- Starting a new project or significant feature
- Building something that will take more than a day
- Multiple people need to agree on what "done" means
- The feature touches multiple modules or services
- You're about to write a design doc and want a template

**When NOT to use:** Bug fixes with clear reproduction steps, small refactors, or tasks where the spec already exists (jump to `planning-and-task-breakdown`).

## The Process

### Step 1: Define the Objective

Answer in 1-2 sentences:

```
OBJECTIVE: What are we building and why?
TRIGGER: What prompted this work? (issue, user feedback, tech debt)
```

Don't write a paragraph. If you can't state the objective concisely, use the `idea-refine` skill first.

### Step 2: Write the Spec

Use this template. Every section is required — mark sections as "N/A" if truly not applicable, but justify why.

```markdown
# Spec: [Feature Name]

## 1. Objective

[1-2 sentences. What problem does this solve and for whom?]

## 2. Background

[Context needed to understand the problem. Prior art, current behavior, why now.]

## 3. Requirements

### Functional Requirements

- FR-1: [The system shall...]
- FR-2: [The system shall...]
- FR-3: [The system shall...]

### Non-Functional Requirements

- NFR-1: [Performance: Response time < Xms for Y operation]
- NFR-2: [Security: All inputs validated, auth required]
- NFR-3: [Accessibility: WCAG 2.2 AA compliance]

## 4. Design

### Architecture

[High-level approach. Which modules/services are involved?
Include an ASCII diagram if helpful.]

### API / Interface

[Public interfaces this feature exposes or consumes.
Method signatures, REST endpoints, event payloads.]

### Data Model

[New tables, columns, or schema changes.
Include types, constraints, and relationships.]

### Key Decisions

[Architecture decisions with rationale.
Format: Decision → Rationale → Alternatives considered]

## 5. Scope

### In Scope

- [What's included]

### Out of Scope

- [What's explicitly excluded and why]

### Future Considerations

- [Things intentionally deferred — may be built later]

## 6. Testing Strategy

- Unit: [What to test at the unit level]
- Integration: [What to test across boundaries]
- E2E: [Critical user paths to verify]
- Edge cases: [Known edge cases to cover]

## 7. Rollout Plan

- Feature flag: [Yes/No — flag name]
- Migration: [Database changes, data backfill]
- Rollback: [How to undo if something goes wrong]

## 8. Open Questions

- [ ] [Unresolved question 1]
- [ ] [Unresolved question 2]

## 9. Acceptance Criteria

- [ ] [Criteria 1 — verifiable with evidence]
- [ ] [Criteria 2 — verifiable with evidence]
- [ ] [Criteria 3 — verifiable with evidence]
```

### Step 3: Review the Spec

Before proceeding to implementation, verify:

1. **Can someone else implement this?** — The spec should contain enough detail that a different engineer could build it without asking clarifying questions.
2. **Are the acceptance criteria testable?** — Each criterion should map to a test you can write.
3. **Is scope clear?** — Both "in scope" and "out of scope" are explicit.
4. **Are open questions flagged?** — Don't hide uncertainty. Surface it.

### Step 4: Get Sign-Off

Share the spec with stakeholders. Resolve open questions. Only then proceed to `planning-and-task-breakdown`.

## Spec Sizing Guide

| Feature Size      | Spec Depth                                                              | Typical Length |
| ----------------- | ----------------------------------------------------------------------- | -------------- |
| Small (1-2 days)  | Requirements + Acceptance Criteria are enough                           | 1 page         |
| Medium (3-5 days) | Full spec, lighter on architecture                                      | 2-3 pages      |
| Large (1-2 weeks) | Full spec with detailed design section                                  | 3-5 pages      |
| XL (2+ weeks)     | Break into smaller specs. No single spec should cover 2+ weeks of work. | Multiple docs  |

## Common Rationalizations

| Rationalization                        | Reality                                                                                                                      |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| "I'll figure it out as I go"           | Figuring it out while coding means rewriting when assumptions prove wrong. A 1-hour spec saves days of rework.               |
| "The requirements are obvious"         | Obvious to you. Write them down so they're obvious to everyone — including future you.                                       |
| "Specs slow us down"                   | Specs front-load the thinking. The total time (spec + build) is almost always less than (build + rework + miscommunication). |
| "I'll write the spec after I build it" | That's documentation, not a spec. The spec's value is in forcing decisions before code exists.                               |
| "This is too small for a spec"         | If it's truly small, the spec takes 15 minutes. If the spec takes longer, it wasn't small.                                   |

## Red Flags

- Starting to code before the spec is reviewed
- Spec has no acceptance criteria
- "Out of scope" section is empty — scope isn't bounded
- Open questions are left unresolved during implementation
- The spec describes implementation details instead of requirements
- No testing strategy — "I'll figure out tests later"

## Verification

After completing the spec:

- [ ] Objective is stated in 1-2 sentences
- [ ] Functional and non-functional requirements are listed
- [ ] Scope has both "in" and "out" sections
- [ ] Acceptance criteria are testable and measurable
- [ ] Open questions are surfaced (not hidden)
- [ ] Testing strategy covers unit, integration, and edge cases
- [ ] A different engineer could implement this from the spec alone
