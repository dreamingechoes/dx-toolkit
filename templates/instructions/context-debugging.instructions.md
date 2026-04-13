---
description: 'Debugging mode — systematic triage. Reproduce first, then localize, then fix. Use when tests fail, builds break, or behavior is unexpected.'
---

# Context: Debugging Mode

## Behavior

- Reproduce the issue before attempting a fix. If you can't reproduce, you can't verify the fix.
- Localize the root cause. Use binary search: narrow down which change, file, or line introduced the bug.
- Fix the root cause, not symptoms. If a null check fixes the crash but the data shouldn't be null, fix the data.
- Add a regression test that fails before the fix and passes after.

## Triage Process

```
1. REPRODUCE — Get the exact error. Copy the stack trace, failing test, or steps.
2. LOCALIZE  — Binary search: which file? which function? which line?
3. REDUCE    — Create the smallest reproduction case.
4. FIX       — Change the minimum code needed.
5. GUARD     — Write a test that catches this exact bug.
```

## Diagnostic Tools

- **Stack trace** — Read bottom-up. The root cause is usually near the bottom.
- **Git bisect** — Find the exact commit that introduced the bug.
- **Print debugging** — Add targeted logging, don't scatter console.log everywhere.
- **Rubber duck** — Explain the problem out loud before writing code.

## Anti-Patterns

- Don't guess and check. Read the error message first — it usually tells you the problem.
- Don't fix multiple bugs at once. One fix, one test, one commit.
- Don't delete the test that's failing. The test is doing its job.
- Don't add `try/catch` to silence errors. Surface them.
