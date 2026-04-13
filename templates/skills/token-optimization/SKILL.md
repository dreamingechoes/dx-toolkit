---
name: token-optimization
description: 'Manage context window size and optimize token usage. Use when sessions get slow, responses degrade, or costs are too high. Covers when to compact, what to preserve, and how to structure context efficiently.'
---

# Token Optimization

## Overview

AI agents have a limited context window. As conversations grow, the agent loses sight of early context, response quality drops, and costs increase. Token optimization is about keeping the context clean, relevant, and within budget — not about cutting corners.

## When to Use

- A session has been running for 30+ minutes and responses are getting worse
- The agent starts "forgetting" things you told it earlier
- You're switching from one task to a completely different one
- Costs are higher than expected for the work being done
- The agent is reading files it already read earlier in the session

**When NOT to use:** The session just started. You're mid-task and the agent is performing well. You're debugging a specific issue (don't lose the thread).

## Context Budget

Think of the context window as a budget:

| Consumer             | Typical Cost | Notes                                  |
| -------------------- | ------------ | -------------------------------------- |
| System prompt        | 2-5K tokens  | Instructions, rules, skills            |
| Conversation         | Grows fast   | Each message adds to the running total |
| File content         | 1-10K each   | Every `read_file` stays in context     |
| Tool results         | 1-5K each    | Search results, terminal output        |
| MCP server responses | 1-10K each   | API calls, web fetches                 |

**Rule of thumb**: If your context is over 80% full, response quality starts degrading. Plan ahead.

## The Process

### Step 1: Recognize Degradation Signals

Watch for these signs that context is getting stale:

- Agent re-reads files it already has
- Responses contradict earlier decisions
- Agent asks questions you already answered
- Suggestions ignore established project conventions
- Longer response times

### Step 2: Decide — Continue or Reset

| Situation                          | Action    |
| ---------------------------------- | --------- |
| Same task, context is relevant     | Continue  |
| Task complete, starting new task   | **Reset** |
| Research phase → implementation    | **Reset** |
| Debugging → different feature      | **Reset** |
| Mid-implementation, context useful | Continue  |
| Agent quality has degraded         | **Reset** |

### Step 3: Preserve Before Reset

Before starting a fresh session, capture what matters:

```markdown
## Session Summary

### Decisions Made

- [Decision 1: what and why]
- [Decision 2: what and why]

### Current State

- [What's done]
- [What's in progress]
- [What's blocked]

### Key Files

- [file1.ts — what was changed and why]
- [file2.ts — what was changed and why]

### Next Steps

- [Step 1]
- [Step 2]
```

Save this to a scratchpad file or memory before resetting.

### Step 4: Start Clean

In the new session:

1. Load only the context you need (project instructions, relevant files)
2. Paste the session summary from Step 3
3. State the immediate task clearly

### Step 5: Prevent Bloat

Structure your work to minimize context consumption:

- **One task per session** — don't context-switch mid-conversation
- **Be specific in requests** — "fix the login timeout in `auth.ts`" not "fix the login"
- **Limit file reads** — ask the agent to read specific sections, not entire files
- **Use instructions files** — put recurring context in `.instructions.md` so it loads automatically without conversation tokens
- **Chain skills** — `/explore` in one session, `/develop` in another

## Token-Saving Patterns

### Trigger-Table Lazy Loading

Don't front-load all project documentation. Instead:

```markdown
## Reference Files (load when needed)

- Architecture: docs/architecture.md
- API contracts: docs/api-design.md
- Testing strategy: docs/testing.md

Load only the reference relevant to your current task.
```

### Instructions Over Conversation

Move repeated guidance into `.instructions.md` files:

**Bad** (costs tokens every message):

> "Remember to use strict TypeScript, always handle errors with Result types, and follow our naming conventions..."

**Good** (free — loaded once as system prompt):

> Create `.github/instructions/typescript.instructions.md` with `applyTo: "**/*.ts"`

### Focused File Reads

**Bad**: "Read the entire `src/` directory"
**Good**: "Read `src/auth/login.ts` lines 40-80 where the timeout logic is"

## Common Rationalizations

| Rationalization                         | Reality                                                          |
| --------------------------------------- | ---------------------------------------------------------------- |
| "I'll just keep going, it's fine"       | Context degradation is gradual — you won't notice until it's bad |
| "Starting over loses all my context"    | A clean session with a good summary outperforms a bloated one    |
| "I need everything in context"          | You need the relevant 20%, not all 100%                          |
| "Instructions files are too much setup" | They pay for themselves after 2-3 sessions                       |

## Verification

After applying token optimization:

- [ ] Responses directly address the question (no tangents)
- [ ] Agent remembers recent decisions without prompting
- [ ] File reads are targeted, not redundant
- [ ] Session feels fast and focused
- [ ] Instructions files handle recurring context automatically
