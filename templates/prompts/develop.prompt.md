---
description: 'Develop the next task — write code in thin vertical slices with tests, following incremental implementation practices.'
agent: 'agent'
tools: ['read', 'edit', 'search', 'execute']
---

Implement the specified task or next task from the plan using incremental development.

## Procedure

1. **Identify the task** — Read the task description, acceptance criteria, and dependencies. Confirm prerequisites are met.

2. **Understand the codebase context** — Before writing code:
   - Read existing files that will be modified
   - Check for patterns, conventions, and existing abstractions
   - Look at related tests for expected behavior

3. **Implement in a thin vertical slice**:
   - Start with the smallest change that compiles and passes tests
   - Write the test first (or immediately after) for each behavior
   - One concern per commit — don't mix refactoring with feature work

4. **Follow implementation rules**:
   - Choose the simplest approach that works
   - Don't add code "for later" — solve the current task only
   - Match existing code style and patterns
   - Use existing abstractions — don't create new ones unless necessary
   - Keep functions short and focused

5. **Verify before marking done**:
   - All existing tests still pass
   - New tests cover the acceptance criteria
   - No lint errors or type errors
   - Code compiles/builds successfully

6. **Report what was done**:
   - Files created or modified
   - Key decisions made and why
   - Anything that needs follow-up

## Skills Referenced

- `.github/skills/incremental-implementation/SKILL.md`
- `.github/skills/context-engineering/SKILL.md`

## Output

Working code with tests that satisfies the task's acceptance criteria.
