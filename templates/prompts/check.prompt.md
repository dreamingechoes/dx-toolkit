---
description: 'Check a failing test or error — reproduce, localize, fix, and add a regression guard.'
agent: 'agent'
tools: ['read', 'edit', 'search', 'execute']
---

Diagnose and fix the reported error or test failure.

## Procedure

1. **Reproduce** — Confirm the failure:
   - Run the failing test or trigger the error
   - Capture the exact error message and stack trace
   - Note the environment (OS, runtime version, dependencies)

2. **Localize** — Narrow down the cause:
   - Read the stack trace bottom-up — find the first frame in your code
   - Check recent changes (`git diff`, `git log --oneline -10`)
   - Binary search with `git bisect` if the cause isn't obvious
   - Add diagnostic logging if needed (remove before committing)

3. **Understand** — Before fixing, explain:
   - What the code expected to happen
   - What actually happened
   - Why the difference exists

4. **Fix** — Apply the minimal change:
   - Fix the root cause, not the symptom
   - If the fix is > 20 lines, consider whether you're solving the right problem
   - Don't refactor while fixing — separate commits

5. **Guard** — Prevent recurrence:
   - Write a test that fails without the fix and passes with it
   - If the bug was in error handling, add tests for adjacent error paths
   - Update documentation if the behavior was misunderstood

6. **Verify** — Confirm the fix:
   - The new test passes
   - All existing tests still pass
   - The original reproduction steps no longer trigger the error

## Skills Referenced

- `.github/skills/debugging-and-error-recovery/SKILL.md`

## References

- `.github/references/testing-patterns.md`

## Output

- Root cause explanation
- The fix (minimal, targeted)
- Regression test
- Verification that all tests pass
