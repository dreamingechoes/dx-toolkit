---
name: testing-strategy
description: 'Design a testing strategy from requirements. Covers test pyramid, framework selection, coverage targets, fixture management, and CI integration. Language-agnostic.'
---

# Testing Strategy

## Overview

A testing strategy defines what to test, how to test it, and where each test runs. Without one, teams drift toward either too many slow E2E tests or too many brittle unit tests that mock everything. This skill walks through designing a balanced strategy tailored to your project's risk profile, tech stack, and team size.

The core principle: push tests as low on the pyramid as possible. Test behavior, not implementation. Every test should answer the question "what breaks if this test is removed?"

## When to Use

- Starting a new project and establishing testing patterns
- Inheriting a codebase with no tests or inconsistent testing
- Test suite is slow, flaky, or gives false confidence
- Changing frameworks or architecture (migration needs new test patterns)
- Coverage numbers are high but bugs still ship

**When NOT to use:** You already have a working strategy and just need to write individual tests. Use the `test-writer` agent or your framework's test docs instead.

## Process

### Step 1 — Assess Current State

Survey what exists before designing what should exist.

**Inventory checklist:**

| Question                                          | Answer |
| ------------------------------------------------- | ------ |
| Existing test count (unit / integration / E2E)    |        |
| Test runner and framework                         |        |
| Average test suite runtime                        |        |
| Flaky test count (tests that fail intermittently) |        |
| Coverage percentage (if measured)                 |        |
| CI pipeline — do tests run on every PR?           |        |
| Last time a test caught a real bug                |        |
| Last time a test caused a false alarm             |        |

**Assess risk zones** — where are the areas that break most?

```
HIGH RISK (test heavily):
- Payment processing, auth, data mutations
- Complex business logic with many branches
- Integration boundaries (APIs, databases, third-party services)

MEDIUM RISK (test key paths):
- CRUD operations, form validation
- UI components with conditional rendering

LOW RISK (test minimally):
- Static pages, configuration files
- Simple pass-through functions
```

### Step 2 — Define Test Pyramid Ratios

The classic pyramid is a starting point, not a law. Adjust for your project.

```
        ╱  E2E  ╲         ~5-10% of tests
       ╱──────────╲
      ╱ Integration ╲     ~20-30% of tests
     ╱────────────────╲
    ╱     Unit Tests    ╲  ~60-70% of tests
   ╱──────────────────────╲
```

**Ratio guidance by project type:**

| Project Type       | Unit | Integration | E2E |
| ------------------ | ---- | ----------- | --- |
| Library / SDK      | 80%  | 15%         | 5%  |
| API service        | 60%  | 30%         | 10% |
| Full-stack web app | 50%  | 30%         | 20% |
| Mobile app         | 60%  | 25%         | 15% |
| Data pipeline      | 40%  | 50%         | 10% |

Document your chosen ratios and the reasoning behind them.

### Step 3 — Choose Frameworks and Tools

Select one tool per test type. Avoid mixing multiple tools for the same purpose.

**Framework selection criteria:**

| Criteria                          | Weight |
| --------------------------------- | ------ |
| Team familiarity                  | High   |
| Community size and maintenance    | High   |
| Speed of test execution           | Medium |
| IDE integration                   | Medium |
| Parallel execution support        | Medium |
| Snapshot / visual testing support | Low    |

**Common stacks by language:**

| Language      | Unit              | Integration           | E2E                   |
| ------------- | ----------------- | --------------------- | --------------------- |
| JavaScript/TS | Vitest / Jest     | Vitest / Supertest    | Playwright / Cypress  |
| Python        | pytest            | pytest + httpx        | Playwright            |
| Elixir        | ExUnit            | ExUnit + Ecto Sandbox | Wallaby               |
| Go            | testing + testify | testing + httptest    | Playwright            |
| Ruby          | RSpec / Minitest  | RSpec + Capybara      | Playwright            |
| Java          | JUnit 5           | Spring Boot Test      | Selenium / Playwright |

### Step 4 — Design Fixture and Data Strategy

Bad test data is the #1 cause of flaky tests. Define how test data is created, shared, and cleaned up.

**Patterns:**

| Pattern              | Use When                                  | Example                                   |
| -------------------- | ----------------------------------------- | ----------------------------------------- |
| Factory functions    | Need realistic data with overrides        | `createUser({ role: "admin" })`           |
| Fixtures / seeds     | Shared read-only reference data           | `fixture("countries.json")`               |
| Builder pattern      | Complex objects with many optional fields | `UserBuilder().withRole("admin").build()` |
| Database sandbox     | Tests need real DB but isolation          | Ecto sandbox, transaction rollback        |
| Fake / stub services | External APIs in unit/integration tests   | `FakeStripeClient`                        |
| Contract tests       | Verifying API contracts between services  | Pact, contract-test libraries             |

**Rules for test data:**

- Each test creates its own data — never depend on shared mutable state
- Use factories with sensible defaults, override only what the test cares about
- Clean up after each test (prefer transaction rollback over manual cleanup)
- Never use production data in tests

### Step 5 — Set Coverage Targets

Coverage is a signal, not a goal. High coverage with bad tests is worse than moderate coverage with meaningful tests.

**Recommended targets:**

| Metric                 | Target | Notes                                          |
| ---------------------- | ------ | ---------------------------------------------- |
| Line coverage          | 70-80% | Diminishing returns above 90%                  |
| Branch coverage        | 60-70% | More valuable than line coverage               |
| Critical path coverage | 100%   | Auth, payments, data mutations — no exceptions |
| New code coverage      | 80%+   | Enforce on PRs to prevent backsliding          |

**What NOT to cover:**

- Generated code (protobuf, ORM models, GraphQL types)
- Configuration files
- Simple getters/setters with no logic
- Third-party library wrappers with no custom logic

### Step 6 — Configure CI Integration

Tests are only useful if they run automatically.

**CI pipeline stages:**

```
PR opened / Push to branch
  │
  ├── Stage 1: Lint + Type Check (< 1 min)
  │
  ├── Stage 2: Unit Tests (< 3 min)
  │
  ├── Stage 3: Integration Tests (< 5 min)
  │
  └── Stage 4: E2E Tests (< 15 min)
       └── Run in parallel where possible
```

**CI configuration checklist:**

- [ ] Tests run on every PR and push to main
- [ ] Test stages are parallelized
- [ ] Flaky test detection is enabled (retry + report)
- [ ] Coverage report is generated and posted to PR
- [ ] Coverage threshold gates the PR (fail if below target)
- [ ] E2E tests use a dedicated test environment
- [ ] Test results are cached where possible

### Step 7 — Verify Strategy

Produce a testing strategy document:

```markdown
## Testing Strategy

**Project**: [Name]
**Date**: [Date]

### Test Pyramid

| Type        | Ratio | Framework | Runtime Target |
| ----------- | ----- | --------- | -------------- |
| Unit        | X%    | [Tool]    | < X min        |
| Integration | X%    | [Tool]    | < X min        |
| E2E         | X%    | [Tool]    | < X min        |

### Coverage Targets

| Metric                | Target | Enforcement   |
| --------------------- | ------ | ------------- |
| Overall line coverage | X%     | CI gate       |
| New code coverage     | X%     | PR check      |
| Critical paths        | 100%   | Manual review |

### Data Strategy

[Factory/fixture approach]

### CI Integration

[Pipeline stages and timing targets]

### Special Testing

- [ ] Property-based tests for [complex logic]
- [ ] Contract tests for [service boundaries]
- [ ] Visual regression for [UI components]
- [ ] Snapshot tests for [serialized outputs]
```

## Common Rationalizations

| Rationalization                       | Reality                                                                                                      |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| "We'll add tests later"               | Later never comes. Write the strategy first, tests become easier.                                            |
| "100% coverage means no bugs"         | Coverage measures execution, not correctness. A test that runs code without asserting behavior is useless.   |
| "E2E tests are enough"                | E2E tests are slow, flaky, and give poor error localization. They complement unit tests, never replace them. |
| "Mocking everything makes tests fast" | Over-mocking tests implementation details, not behavior. Tests pass but miss real bugs.                      |
| "We don't have time for tests"        | You don't have time for debugging production issues at 2 AM either.                                          |

## Red Flags

- All tests are E2E (inverted pyramid)
- Unit tests mock every dependency (testing mocks, not code)
- Tests take > 20 minutes to run (nobody waits, nobody runs them)
- Tests pass locally but fail in CI (environment-dependent fixtures)
- Coverage is high but bugs keep shipping (assertions are weak or missing)
- No test data strategy — tests share mutable state and break each other
- Tests are skipped or commented out instead of fixed

## Verification

- [ ] Test pyramid ratios are documented with reasoning
- [ ] Framework choices are made for each test level
- [ ] Fixture / data strategy is defined and consistent
- [ ] Coverage targets are set and enforced in CI
- [ ] CI runs all test stages on every PR
- [ ] Critical paths (auth, payments, data mutations) are specifically called out for 100% coverage
- [ ] Flaky test handling is addressed (detection, quarantine, fix process)
- [ ] The strategy accounts for property-based, contract, or visual tests if applicable
