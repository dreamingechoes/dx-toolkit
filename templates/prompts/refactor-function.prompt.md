---
description: 'Refactor a function or module to improve readability, maintainability, and performance while preserving exact behavior.'
agent: 'agent'
---

Refactor the provided code safely and effectively.

## Procedure

1. **Understand the current behavior** — read the code and its tests
2. **Identify improvement opportunities**:
   - Long functions → extract smaller, well-named functions
   - Deep nesting → early returns, guard clauses, pattern matching
   - Repeated code → extract shared abstractions
   - Unclear names → rename for intent
   - Complex conditionals → simplify or extract
   - Missing types → add type annotations
3. **Apply refactoring** one step at a time
4. **Verify** the behavior is preserved (run tests if available)

## Rules

- NEVER change observable behavior — inputs/outputs must remain identical
- Follow the existing code style and patterns in the project
- Prefer small, incremental changes over large rewrites
- Add types/documentation only where the refactored code benefits from it
- If tests don't exist, suggest adding characterization tests first

## Output

- Refactored code
- Brief summary of changes made and why
- Note any risks or areas that need manual verification
