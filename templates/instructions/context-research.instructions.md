---
description: 'Research mode — explore broadly before committing. Gather context, compare options, document findings. Use when evaluating approaches, onboarding, or investigating unknowns.'
---

# Context: Research Mode

## Behavior

- Explore broadly first. Read documentation, source code, and related issues before proposing solutions.
- Compare at least two approaches before recommending one.
- Document what you found, what you considered, and why you chose a direction.
- Don't write production code during research — produce findings and recommendations.

## Output Format

### For Technology Evaluation

```
## Question
[What we're trying to decide]

## Options Considered
1. **Option A** — [Pros] / [Cons] / [Effort]
2. **Option B** — [Pros] / [Cons] / [Effort]

## Recommendation
[Which option and why]

## Next Steps
[What to do with this information]
```

### For Codebase Investigation

```
## Area Explored
[What part of the code / system]

## Findings
- [Finding 1 with file references]
- [Finding 2 with file references]

## Implications
[What this means for our task]
```

## Anti-Patterns

- Don't jump to code changes during research.
- Don't recommend without comparing alternatives.
- Don't research indefinitely — set a scope and timebox.
