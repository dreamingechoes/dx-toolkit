---
name: planning-and-task-breakdown
description: 'Decompose specs into small, verifiable tasks with acceptance criteria and dependency ordering. Use when you have a spec or feature description and need implementable units of work.'
---

# Planning and Task Breakdown

## Overview

Break a spec into small, ordered tasks that can each be implemented, tested, and verified independently. Good task breakdowns prevent the "90% done, 90% left" problem by making progress visible and measurable.

## When to Use

- You have a spec (from `spec-driven-development`) and need to start building
- A feature feels too large to tackle in one sitting
- Multiple engineers will work on the same feature
- You need to estimate effort or prioritize work

**When NOT to use:** The task is already small enough to implement in one increment (< 100 lines of change). Jump to `incremental-implementation`.

## The Process

### Step 1: Read the Spec

Before breaking anything down:

1. Read the full spec — requirements, design, acceptance criteria
2. Identify the data model (what needs to exist before anything else)
3. Identify external dependencies (APIs, services, libraries)
4. Note the testing strategy

### Step 2: Identify the Slices

A **slice** is a thin vertical cut through the stack that delivers one piece of working functionality. Slice by user-visible behavior, not by technical layer.

```
BAD (horizontal slices):
  Task 1: Build the database schema
  Task 2: Build the API layer
  Task 3: Build the UI

GOOD (vertical slices):
  Task 1: User can create a task (DB + API + minimal UI)
  Task 2: User can list tasks (query + API + UI)
  Task 3: User can edit a task (update + API + UI)
  Task 4: User can delete a task (delete + API + confirmation)
```

Horizontal slicing produces tasks that can't be verified independently. Vertical slicing produces tasks where each one is testable end-to-end.

### Step 3: Order by Dependencies

Draw the dependency graph. Tasks that depend on nothing go first:

```
Task 1 (no deps)      → Task 3 (depends on 1)
Task 2 (no deps)      → Task 4 (depends on 1, 2)
                       → Task 5 (depends on 3, 4)
```

Rules:

- Foundation work (schema, types, interfaces) comes first
- Parallel-safe tasks get the same priority level
- Risky or uncertain tasks go early — fail fast

### Step 4: Write Each Task

Use this format for every task:

```markdown
### Task [N]: [Short title]

**Priority**: P[0-3] (0 = do first, 3 = nice to have)
**Depends on**: Task [X], Task [Y] (or "None")
**Effort**: S (< 1hr) / M (1-4hr) / L (4-8hr) / XL (break this down further)

**Description**:
[1-2 sentences of what to build]

**Files to touch**:

- `path/to/file.ts` — [what changes]
- `path/to/test.ts` — [what to test]

**Acceptance criteria**:

- [ ] [Verifiable criterion 1]
- [ ] [Verifiable criterion 2]
- [ ] Tests pass
- [ ] Build succeeds
```

### Step 5: Validate the Plan

Before starting implementation, check:

1. **Completeness** — Do all tasks together cover every acceptance criterion from the spec?
2. **Independence** — Can each task be merged without breaking the build?
3. **Size** — Is every task ≤ L (4-8 hours)? If XL, break it down further.
4. **Testability** — Does every task have testable acceptance criteria?
5. **Ordering** — Are dependencies explicit and correct?

### Output Template

```markdown
# Implementation Plan: [Feature Name]

**Spec**: [Link to spec]
**Estimated total effort**: [Sum of task efforts]
**Number of tasks**: [N]

## Task Dependency Graph
```

T1 ──→ T3 ──→ T5
T2 ──→ T4 ──↗

```

## Tasks

### Task 1: [Title]
Priority: P0 | Depends on: None | Effort: M
...

### Task 2: [Title]
Priority: P0 | Depends on: None | Effort: S
...

### Task 3: [Title]
Priority: P1 | Depends on: Task 1 | Effort: L
...

## Open Risks
- [Risk 1 and mitigation]
- [Risk 2 and mitigation]

## Out of Scope (deferred tasks)
- [Task deferred to a future iteration and why]
```

## Task Sizing Guide

| Size | Time      | Lines Changed | Rule                                       |
| ---- | --------- | ------------- | ------------------------------------------ |
| S    | < 1 hour  | < 50 lines    | Config changes, simple additions           |
| M    | 1-4 hours | 50-150 lines  | New function, new endpoint, new component  |
| L    | 4-8 hours | 150-400 lines | New module, complex feature slice          |
| XL   | > 8 hours | > 400 lines   | **Break this down.** No task should be XL. |

## Common Rationalizations

| Rationalization                                    | Reality                                                                                                |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| "I can hold it all in my head"                     | You can. The agent can't. And neither can future-you after a weekend. Write it down.                   |
| "Breaking it down takes longer than just doing it" | It takes 15-30 minutes to plan. It saves hours of rework when you realize slice 3 invalidates slice 1. |
| "These tasks are too granular"                     | Granular tasks are mergeable, reviewable, and revertable. Coarse tasks hide risk.                      |
| "I'll figure out the order as I go"                | Implicit ordering hides dependency bugs. Task 5 fails because Task 2 was skipped.                      |
| "This doesn't need a plan, I've built this before" | Great — then the plan will take 5 minutes. Write it anyway so the approach is reviewable.              |

## Red Flags

- Tasks sliced by technical layer instead of user behavior
- No dependency ordering — tasks list is flat
- Tasks without acceptance criteria
- Any task estimated as XL
- The plan doesn't account for all spec requirements
- Testing mentioned as a separate task instead of being part of each task

## Verification

After completing the plan:

- [ ] Every spec requirement maps to at least one task
- [ ] Every task has acceptance criteria
- [ ] No task is larger than L (4-8 hours)
- [ ] Dependencies are explicit
- [ ] Each task can be merged independently without breaking the build
- [ ] The plan was reviewed before implementation started
