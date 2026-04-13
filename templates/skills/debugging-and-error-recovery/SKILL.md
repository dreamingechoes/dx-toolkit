---
name: debugging-and-error-recovery
description: 'Five-step triage for failing tests, broken builds, and unexpected behavior: reproduce, localize, reduce, fix, guard. Use when tests fail, builds break, or behavior is unexpected.'
---

# Debugging and Error Recovery

## Overview

Systematic debugging beats random guessing. This skill follows a five-step triage process: reproduce the failure, localize the cause, reduce to a minimal case, fix the root cause, and add a guard so it doesn't happen again.

## When to Use

- Tests fail unexpectedly
- Build breaks after a change
- Runtime behavior doesn't match expectations
- An error report or bug needs investigation
- CI pipeline fails

**When NOT to use:** Proactive code review (use `code-review`). Performance issues without errors (use `performance-optimization`).

## The Five-Step Triage

```
Reproduce ──→ Localize ──→ Reduce ──→ Fix ──→ Guard
```

### Step 1: Reproduce

Before fixing anything, confirm you can trigger the failure reliably.

```
REPRODUCTION:
Command: [Exact command that triggers the failure]
Output: [Error message, stack trace, or incorrect behavior]
Consistent: [Yes/No — does it fail every time?]
Environment: [OS, runtime version, relevant config]
```

Rules:

- **Don't guess** — run the failing command yourself
- **Copy the exact error** — paraphrased errors hide critical details
- **Check if it's flaky** — run 3 times. Flaky failures need different treatment.

If you can't reproduce it, you can't verify your fix. Stop and gather more information.

### Step 2: Localize

Find the smallest area of code where the bug lives.

Techniques:

1. **Read the stack trace** — Start from the top. The first frame in your code is usually the site.
2. **Binary search** — If the stack trace isn't helpful, `git bisect` to the commit that introduced it.
3. **Add logging** — Print inputs and outputs at key boundaries. The bug is between the last correct output and the first incorrect one.
4. **Check recent changes** — `git log --oneline -10` — did a recent change touch the failing area?

```
LOCALIZATION:
File: [path/to/file.ts]
Line(s): [approximate range]
Function: [name]
Hypothesis: [What you think is wrong and why]
```

### Step 3: Reduce

Simplify the failure to the minimal reproduction case.

- Remove unrelated code paths
- Use hardcoded values instead of complex inputs
- Isolate the failing unit from its dependencies

The goal: a test case that's 5-10 lines long and still fails. This test becomes your regression guard in Step 5.

```
MINIMAL REPRODUCTION:
[Code snippet or test that demonstrates the bug in isolation]
```

### Step 4: Fix

Apply the smallest change that resolves the root cause.

Rules:

- **Fix the cause, not the symptom** — If a null check would hide the bug, find out why it's null.
- **One fix per bug** — Don't bundle refactoring with the fix. Fix first, refactor later.
- **Verify the fix resolves the reproduction** — Run the exact command from Step 1.
- **Verify nothing else broke** — Run the full test suite.

```
FIX:
Change: [What you changed]
Root cause: [Why the bug existed]
Verified: [Reproduction command now passes]
Side effects: [None / describe any]
```

### Step 5: Guard

Add a test that would catch this bug if it was reintroduced.

```
GUARD:
Test file: [path/to/test.ts]
Test name: [descriptive name that mentions the bug]
Covers: [The exact scenario that was broken]
```

The guard test should:

- Fail without the fix (verify by temporarily reverting)
- Pass with the fix
- Be fast (unit test preferred over integration test)
- Have a descriptive name: `test_task_creation_fails_when_title_is_empty` not `test_fix_bug_42`

## Debugging Toolkit

| Situation                           | Tool                                                                               |
| ----------------------------------- | ---------------------------------------------------------------------------------- |
| Test fails but error is unclear     | Add `console.log` / `IO.inspect` at boundaries                                     |
| Don't know which commit broke it    | `git bisect`                                                                       |
| Flaky test                          | Run in isolation first. Check for shared state, timing, or external deps.          |
| Build fails after dependency update | Check changelog for breaking changes. Pin the previous version and compare.        |
| Error only in CI, not locally       | Check environment differences: Node version, env vars, file permissions            |
| Stack trace points to library code  | The bug is in how you call the library, not the library itself. Check your inputs. |

## Common Rationalizations

| Rationalization                                     | Reality                                                                                                            |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| "I know what the bug is, I'll just fix it"          | You know what you think the bug is. Reproduce first to confirm — 50% of the time the assumption is wrong.          |
| "I'll skip the regression test, the fix is obvious" | Obvious fixes get reverted by future refactors. The guard test takes 2 minutes and prevents hours of re-debugging. |
| "Let me rewrite this whole function instead"        | Rewrites introduce new bugs. Fix the specific cause. Refactor in a separate commit if needed.                      |
| "It works on my machine"                            | Reproduce in CI or a clean environment. "Works locally" isn't verification.                                        |
| "I'll add a try/catch to handle it"                 | Catching an error isn't fixing it. Understand why the error occurs.                                                |

## Red Flags

- Fixing without reproducing — "I think this will fix it"
- Multiple changes in the fix commit — impossible to know which one fixed it
- No regression test — the same bug will return
- Fixing the symptom (adding a null check) instead of the cause (why is it null?)
- "Let me try this..." repeated without a clear hypothesis

## Verification

After fixing a bug:

- [ ] The failure was reproduced before fixing
- [ ] The root cause is identified and documented
- [ ] The fix is minimal — no bundled refactoring
- [ ] The original reproduction case now passes
- [ ] A regression test guards against reintroduction
- [ ] The full test suite passes
- [ ] The fix is committed separately from any other changes
