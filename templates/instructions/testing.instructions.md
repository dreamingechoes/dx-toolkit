---
description: 'Testing standards. Use when writing unit tests, integration tests, or end-to-end tests. Covers structure, assertions, mocking, and best practices across all frameworks.'
applyTo: '**/*.test.*, **/*.spec.*, **/*_test.*, **/test/**, **/tests/**, **/__tests__/**'
---

# Testing Standards

## Structure

- Use Arrange-Act-Assert (AAA) or Given-When-Then pattern
- One logical assertion per test (multiple related `expect` calls are fine)
- Group related tests with `describe`/`context` blocks
- Test names describe behavior: "returns empty list when no results found"

## What to Test

- Public API / behavior — not internal implementation details
- Happy path + edge cases + error scenarios
- Boundary values (0, 1, max, empty, null)
- State transitions and side effects
- Error messages and error types

## What NOT to Test

- Private methods directly (test through public interface)
- Framework/library internals
- Trivial getters/setters
- Implementation details (HOW something works vs WHAT it does)

## Mocking

- Mock at the boundary — external APIs, databases, file system, time
- Don't mock what you own — prefer fakes or in-memory implementations
- Verify interactions only when the side effect IS the purpose
- Reset mocks between tests to avoid leaking state

## Async Testing

- Always await async operations
- Use proper async matchers (`resolves`/`rejects` in Jest, `assert_receive` in ExUnit)
- Set reasonable timeouts for async operations
- Test both success and failure paths of async code

## Test Data

- Use factories/fixtures over hardcoded data
- Keep test data minimal — only what's relevant to the test
- Use random data for properties that don't affect the test outcome
- Name variables clearly: `validUser`, `expiredToken`, `emptyList`
