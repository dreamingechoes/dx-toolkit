---
name: code-simplification
description: "Reduce complexity while preserving exact behavior. Use when code works but is harder to read or maintain than it should be. Applies Chesterton's Fence — understand the code before simplifying it."
---

# Code Simplification

## Overview

Working code that's hard to read is a liability. Code simplification reduces complexity while preserving exact behavior — no feature changes, no new functionality, just clearer code. Every simplification starts with understanding why the code exists as-is (Chesterton's Fence).

## When to Use

- Code works but is hard to follow
- A module has grown complex over time
- Before adding a feature to a complex area
- High cyclomatic complexity flagged by tooling
- "What does this do?" is a common question about a function

**When NOT to use:** The code doesn't work (fix the bug first). You want to add features (implement first, simplify later in a separate PR).

## Chesterton's Fence

Before simplifying any code, answer: **Why does this exist in its current form?**

```
BEFORE TOUCHING:
Code: [File:line range]
What it does: [Plain English description]
Why it's written this way: [Original reason — check git blame, comments, issues]
Tests covering it: [List existing tests]
```

If you can't explain why the code is the way it is, you don't understand it well enough to simplify it. Read the git history, check linked issues, ask the author.

## The Process

### Step 1: Identify Complexity

Look for these patterns:

| Pattern              | Symptom                            | Typical Simplification                        |
| -------------------- | ---------------------------------- | --------------------------------------------- |
| Deep nesting         | 4+ levels of indentation           | Early returns, extract functions              |
| Long functions       | 50+ lines                          | Extract logical sections into named functions |
| God objects          | Class/module doing too many things | Split by responsibility                       |
| Duplicated logic     | Same pattern in 3+ places          | Extract shared function                       |
| Over-abstraction     | Generic code used in one place     | Inline and simplify                           |
| Boolean parameters   | `doThing(true, false, true)`       | Create named options or separate functions    |
| Complex conditionals | `if (a && !b \|\| c && d)`         | Extract to named boolean or function          |

### Step 2: Ensure Test Coverage

You can't simplify safely without tests.

```
COVERAGE CHECK:
Existing tests: [List them]
Missing coverage: [Paths not tested]
Action: [Write missing tests BEFORE simplifying]
```

Write tests for existing behavior first. Run them. They should pass. These tests become your safety net.

### Step 3: Simplify Incrementally

Apply one transformation at a time. After each:

1. Run tests — they must still pass
2. Verify behavior is unchanged
3. Commit

**Never simplify multiple things in one commit.** If a simplification introduces a bug, you need to know which change caused it.

### Simplification Techniques

**Early returns** — Reduce nesting by handling edge cases first:

```typescript
// Before
function process(user) {
  if (user) {
    if (user.isActive) {
      if (user.hasPermission) {
        return doWork(user)
      }
    }
  }
  return null
}

// After
function process(user) {
  if (!user) return null
  if (!user.isActive) return null
  if (!user.hasPermission) return null
  return doWork(user)
}
```

**Extract named concepts** — Replace inline complexity with named functions:

```typescript
// Before
if (date.getTime() > Date.now() - 86400000 && status !== 'archived' && role === 'admin') {

// After
const isRecent = date.getTime() > Date.now() - 86400000;
const isVisible = status !== 'archived';
const hasAccess = role === 'admin';
if (isRecent && isVisible && hasAccess) {
```

**Inline over-abstractions** — Remove wrappers that add indirection without value:

```typescript
// Before: abstraction used in one place
class TaskRepository {
  private adapter: DatabaseAdapter
  constructor(adapter: DatabaseAdapter) {
    this.adapter = adapter
  }
  findById(id: string) {
    return this.adapter.query('tasks', { id })
  }
}

// After: direct usage (when only used once)
const task = await db.query('tasks', { id })
```

### The Rule of 500

A reasonable upper bound for a single file:

- **500 lines** per file
- **50 lines** per function
- **5 parameters** per function
- **3 levels** of nesting

These aren't hard rules — they're signals. Crossing them suggests simplification is due.

## Common Rationalizations

| Rationalization                          | Reality                                                                                               |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| "It's complex but it works"              | Working isn't enough. Code is read 10x more than it's written. Complexity compounds maintenance cost. |
| "I don't have time to simplify"          | You don't have time not to. Every minute spent reading complex code is multiplied across the team.    |
| "The tests will catch any mistakes"      | Only if tests exist. Check coverage before simplifying.                                               |
| "This abstraction might be useful later" | YAGNI. Inline it. It takes 5 minutes to re-extract when actually needed.                              |
| "It's just cosmetic — not worth a PR"    | Readability improvements are real improvements. They reduce bugs and speed up future development.     |

## Red Flags

- Simplifying without understanding the code's history
- No tests before refactoring — flying blind
- Multiple simplifications in a single commit
- Behavior changes mixed in with simplifications
- Removing code you don't understand
- Extracting abstractions during simplification (simplify now, abstract later if needed)

## Verification

After simplifying:

- [ ] You understood why the code existed before changing it
- [ ] Tests were in place before simplification started
- [ ] All existing tests still pass
- [ ] Behavior is provably unchanged (same inputs → same outputs)
- [ ] Each simplification was committed separately
- [ ] The code is measurably simpler (fewer lines, less nesting, clearer names)
- [ ] No feature changes were mixed in
