---
description: 'Generate comprehensive test cases for the selected code. Covers unit tests, edge cases, error scenarios, and integration tests.'
agent: 'agent'
---

Generate thorough tests for the provided code.

## Procedure

1. **Analyze the code** — understand inputs, outputs, side effects, and error paths
2. **Detect the test framework** from the project (ExUnit, Jest, Vitest, Pytest, etc.)
3. **Follow existing test patterns** — match naming, structure, helpers, and assertions already in the codebase
4. **Generate tests covering**:
   - Happy path — normal expected behavior
   - Edge cases — empty inputs, boundary values, nil/null/undefined
   - Error scenarios — invalid inputs, failures, exceptions
   - Integration points — interactions with dependencies (mock appropriately)

## Test Quality Rules

- Each test has a single, clear assertion (or closely related assertions)
- Test names describe the behavior, not the implementation
- Use Arrange-Act-Assert (Given-When-Then) structure
- Mock external dependencies, not internal implementation
- Avoid testing private methods directly — test through the public API
- Include setup/teardown when needed, prefer test-level setup over global

## Output

- Test file(s) ready to run
- Brief comment explaining any non-obvious test decisions
