---
description: 'Explain complex code in plain language. Breaks down algorithms, patterns, data flows, and design decisions. Use when you need to understand unfamiliar or complex code.'
agent: 'agent'
tools: [read, search]
---

Explain the provided code clearly and thoroughly.

## What to Cover

1. **Purpose** — What does this code accomplish? What problem does it solve?
2. **How it works** — Step-by-step walkthrough of the logic
3. **Key patterns** — Design patterns, idioms, or techniques used (name them)
4. **Data flow** — How data moves through the code (inputs → transformations → outputs)
5. **Dependencies** — What this code depends on and what depends on it
6. **Edge cases** — How are errors, nil values, and boundaries handled?
7. **Complexity** — Time/space complexity for algorithms, performance considerations

## Format

- Start with a one-paragraph summary
- Use numbered steps for the logic walkthrough
- Use code annotations for complex lines
- Call out anything surprising, clever, or potentially problematic
- If the code could be improved, mention it briefly at the end

## Constraints

- DO NOT modify any code
- DO NOT suggest refactoring unless asked
- Keep explanations accessible — avoid jargon without defining it
