---
description: 'Debug an error using the stack trace, error message, or symptom description. Identifies root cause and provides a fix. Use when you encounter a bug or error.'
agent: 'agent'
---

Debug the provided error and identify the root cause.

## Procedure

1. **Parse the error** — extract the error type, message, stack trace, and relevant context
2. **Locate the source** — find the file and line where the error originates
3. **Trace the data flow** — understand how the code reached the error state
4. **Identify the root cause** — distinguish between the symptom and the actual bug
5. **Propose a fix** — with code changes and explanation

## Analysis Framework

- **What** failed? (the error message and type)
- **Where** did it fail? (file, line, function)
- **When** does it fail? (always, sometimes, under specific conditions?)
- **Why** did it fail? (the actual root cause)
- **How** to fix it? (minimal change that addresses the root cause)

## Common Patterns to Check

- Null/undefined access on optional data
- Type mismatches or wrong function signatures
- Race conditions or timing issues
- Missing error handling on async operations
- Environment or configuration differences
- Dependency version conflicts
- State mutations in unexpected places

## Output

1. **Root cause** — clear explanation of why the error occurs
2. **Fix** — code changes with explanations
3. **Prevention** — how to prevent this class of bug (test, type, guard)
