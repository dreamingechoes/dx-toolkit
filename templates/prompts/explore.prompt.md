---
description: 'Explore a feature or idea — turn vague concepts into a clear spec with requirements, scope, and acceptance criteria.'
agent: 'agent'
---

Turn a vague idea or feature request into a well-defined specification.

## Procedure

1. **Clarify the idea** — Read the provided description. Ask the Five Questions:
   - What specific problem does this solve?
   - Who experiences this problem and how often?
   - What does "done" look like?
   - What's the simplest version that delivers value?
   - What are we explicitly NOT doing?

2. **Explore options** — Generate at least 3 different approaches. For each:
   - Describe the approach in 2-3 sentences
   - List pros and cons
   - Estimate relative effort (S/M/L)

3. **Write the spec** using this structure:

```markdown
## Objective

One sentence: what we're building and why.

## Background

Why now? What user pain or business need drives this?

## Requirements

### Must Have

- [Requirement with measurable criteria]

### Should Have

- [Important but not launch-blocking]

### Won't Have (this iteration)

- [Explicitly out of scope]

## Design

### API / Interface

### Data Model

### Key Decisions

## Scope

- Estimated size: [S/M/L/XL]
- Files likely touched: [list]
- Dependencies: [list]

## Testing Strategy

- Unit: [what to test]
- Integration: [what to test]
- Manual: [what to verify]

## Acceptance Criteria

- [ ] [Verifiable criterion]
```

4. **Flag unknowns** — List anything that needs research or stakeholder input before implementation begins.

## Skills Referenced

- `.github/skills/idea-refine/SKILL.md`
- `.github/skills/spec-driven-development/SKILL.md`

## Output

A complete spec document ready for planning and task breakdown.
