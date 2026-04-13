---
name: idea-refine
description: 'Structured divergent/convergent thinking to turn vague ideas into concrete proposals. Use when you have a rough concept that needs exploration, when starting a greenfield project, or when evaluating multiple approaches to a problem.'
---

# Idea Refine

## Overview

Turn a vague idea into a concrete, actionable proposal through structured exploration. This skill uses divergent thinking (explore many options) followed by convergent thinking (narrow to the best one) to avoid premature commitment to the first approach that comes to mind.

## When to Use

- You have a rough concept but no clear direction
- Starting a greenfield project or major feature
- Evaluating multiple approaches to a problem
- A stakeholder says "we should do something about X" without specifics
- You're unsure whether to build, buy, or adapt

**When NOT to use:** The problem and solution are already well-defined. Jump straight to `spec-driven-development` or `planning-and-task-breakdown`.

## The Process

### Phase 1: Capture the Raw Idea

Write down the idea exactly as stated — don't filter or refine yet.

```
RAW IDEA: [Paste the original idea as-is]
STATED BY: [Who proposed this]
CONTEXT: [What triggered this idea — pain point, opportunity, request]
```

### Phase 2: Diverge — Ask the Five Questions

Explore the idea from five angles. Write at least 2-3 bullet points per question:

1. **Who benefits?** — List every user, persona, or system that would be affected
2. **What problem does this solve?** — Restate the problem in 3+ different ways
3. **What exists already?** — Prior art, similar tools, partial solutions in the codebase
4. **What could go wrong?** — Risks, edge cases, unintended consequences
5. **What's the smallest version?** — The absolute minimum that would deliver value

### Phase 3: Generate Options

Produce at least 3 distinct approaches. For each:

```
OPTION [N]: [Name]
Approach: [1-2 sentence summary]
Effort: [S/M/L/XL]
Risk: [Low/Medium/High]
Tradeoff: [What you gain vs what you lose]
```

Don't evaluate yet — just generate. Include at least one "boring" option and one ambitious one.

### Phase 4: Converge — Score and Select

Score each option against these criteria (1-5 scale):

| Criteria              | Option 1 | Option 2 | Option 3 |
| --------------------- | -------- | -------- | -------- |
| User impact           |          |          |          |
| Technical feasibility |          |          |          |
| Time to first value   |          |          |          |
| Maintenance burden    |          |          |          |
| Reversibility         |          |          |          |
| **Total**             |          |          |          |

Pick the highest-scoring option. If two are tied, pick the one with better reversibility — you can always expand later, but unwinding a bad decision is expensive.

### Phase 5: Write the Proposal

```markdown
## Proposal: [Title]

### Problem

[1-2 sentences describing the pain point]

### Proposed Solution

[2-3 sentences describing the chosen approach]

### Why This Approach

[Why this option won over the alternatives]

### Scope

- IN: [What's included]
- OUT: [What's explicitly excluded]

### Success Criteria

- [Measurable outcome 1]
- [Measurable outcome 2]

### Open Questions

- [Anything still unresolved]

### Next Step

[Concrete action — usually "write a spec" or "build a prototype"]
```

## Common Rationalizations

| Rationalization                           | Reality                                                                                           |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------- |
| "The first idea is obviously right"       | The first idea is the most available, not the best. Generate alternatives before committing.      |
| "We don't have time to explore options"   | Picking the wrong approach wastes more time than spending 30 minutes on exploration.              |
| "Let me just start coding and see"        | Coding without a direction produces throwaway work. A 10-minute proposal prevents days of rework. |
| "This is too small to need a proposal"    | If it takes more than a day to build, it's worth 15 minutes of structured thinking.               |
| "Everyone already agrees on the approach" | Write it down anyway. "Agreement" without a written proposal often hides different assumptions.   |

## Red Flags

- Jumping straight to implementation without stating the problem
- Only one option considered
- The proposal doesn't mention what's out of scope
- No success criteria — you won't know when you're done
- The "smallest version" is still large

## Verification

After completing this skill:

- [ ] The raw idea is captured verbatim
- [ ] At least 3 options were generated
- [ ] Options were scored against consistent criteria
- [ ] A written proposal exists with problem, solution, scope, and success criteria
- [ ] Open questions are listed (not hidden)
- [ ] The next step is a concrete action, not "think more about it"
