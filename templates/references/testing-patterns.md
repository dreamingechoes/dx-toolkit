# Testing Patterns Reference

Quick-reference for test structure, naming, and patterns. Skills reference this checklist when needed.

## Test Structure

```
describe('[unit under test]', () => {
  describe('[scenario]', () => {
    it('[expected behavior]', () => {
      // Arrange → Act → Assert
    });
  });
});
```

## Naming Convention

`[unit]_[scenario]_[expected result]`

```
createTask_withValidInput_returnsTask
createTask_withEmptyTitle_throwsValidationError
createTask_whenUnauthorized_returns401
```

## Test Pyramid

```
        ╱  E2E  ╲         5% — Critical user paths only
       ╱─────────╲
      ╱Integration╲       15% — Module boundaries, API contracts
     ╱─────────────╲
    ╱     Unit      ╲     80% — Functions, classes, business logic
   ╱─────────────────╲
```

Use the lowest level that captures the behavior.

## DAMP Over DRY

Tests should be **Descriptive And Meaningful Phrases**, not Don't Repeat Yourself. Duplication in tests is fine if it makes them more readable:

```typescript
// GOOD: each test is self-contained and readable
it('creates task with priority', () => {
  const task = createTask({ title: 'Buy milk', priority: 'high' })
  expect(task.priority).toBe('high')
})

it('creates task with default priority', () => {
  const task = createTask({ title: 'Buy milk' })
  expect(task.priority).toBe('medium')
})
```

## What to Test

| Test                                           | Yes       | No        |
| ---------------------------------------------- | --------- | --------- |
| Business logic                                 | ✅ Always |           |
| Edge cases (null, empty, max)                  | ✅ Always |           |
| Error paths                                    | ✅ Always |           |
| Happy path                                     | ✅ Always |           |
| Implementation details                         |           | ❌ Never  |
| Private methods directly                       |           | ❌ Never  |
| Framework code (React renders, Express routes) |           | ❌ Rarely |

## Mocking Guidelines

- Mock at the boundary (database, external API, filesystem)
- Don't mock what you own — test real implementations
- If a mock is complex (> 10 lines), the interface is too wide

```typescript
// GOOD: mock the database boundary
const mockDb = { findTask: vi.fn().mockResolvedValue(task) }
const result = await getTask(mockDb, taskId)

// BAD: mock internal implementation details
vi.mock('./utils', () => ({ formatDate: vi.fn() }))
```

## The Beyonce Rule

If you liked it, you should have put a test on it. If a behavior matters to your users, it needs a test. "Seems right" is not verification.

## Anti-Patterns

| Anti-Pattern                              | Fix                                                  |
| ----------------------------------------- | ---------------------------------------------------- |
| Tests depend on execution order           | Each test sets up its own state                      |
| Tests share mutable state                 | Use `beforeEach` to reset, or create fresh instances |
| Tests verify implementation, not behavior | Assert on outputs, not internal calls                |
| "God test" that tests everything          | One assertion per test (or one logical assertion)    |
| Ignoring flaky tests                      | Fix or delete within 48 hours                        |
| Testing getters/setters                   | Only test if they contain logic                      |
