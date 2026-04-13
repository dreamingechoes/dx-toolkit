---
description: 'Outline a spec or feature into an ordered list of small, verifiable tasks ready for implementation.'
agent: 'agent'
---

Decompose the provided spec or feature description into implementation tasks.

## Procedure

1. **Read the spec** — Understand the objective, requirements, scope, and acceptance criteria.

2. **Identify components** — List every piece that needs to change:
   - Data model / schema changes
   - API endpoints or interfaces
   - Business logic
   - UI components
   - Tests
   - Configuration / infrastructure

3. **Slice vertically** — Each task should deliver a thin, working slice:
   - Prefer vertical slices (schema + logic + API + test) over horizontal layers
   - Each task is independently verifiable
   - Each task compiles and passes tests when complete

4. **Order by dependencies** — Arrange tasks so each builds on the previous:
   - Foundation first (schema, types, interfaces)
   - Core logic second
   - Integration and wiring third
   - Polish and edge cases last

5. **Write the task list** using this format:

```markdown
## Task List for: [Feature Name]

### Task 1: [Short descriptive title]

- **Priority**: P0 (must) / P1 (should) / P2 (could)
- **Depends on**: None / Task N
- **Effort**: S (< 1hr) / M (1-4hr) / L (4-8hr)
- **Files**: [likely files to touch]
- **Acceptance Criteria**:
  - [ ] [Specific, verifiable criterion]
  - [ ] Tests pass

### Task 2: ...
```

6. **Validate** — Check that:
   - All spec requirements are covered by at least one task
   - No task is larger than L (split XL tasks)
   - Dependencies form a DAG (no cycles)
   - A new contributor could pick up any individual task

## Skills Referenced

- `.github/skills/planning-and-task-breakdown/SKILL.md`
- `.github/skills/spec-driven-development/SKILL.md`

## Output

An ordered, dependency-aware task list ready for implementation.
