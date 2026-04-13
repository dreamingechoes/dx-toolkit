---
description: 'Writing style rules for documentation and markdown. Applied automatically to docs and markdown files to avoid AI-sounding prose.'
applyTo: '**/*.md, **/docs/**'
---

# Writing Style

Rules for writing clear, natural documentation. These apply automatically to all markdown files.

## Voice

- Use **active voice** by default — "The function returns X" not "X is returned by the function"
- Use **"you"** for the reader and **"we"** for the team — not "one" or "the user"
- Use contractions naturally — "don't", "you'll", "it's" are fine in docs
- Match formality to context — READMEs are casual, API references are precise

## Brevity

- One idea per sentence
- Cut filler: "In order to" → "To", "It should be noted that" → delete
- Remove hedge stacks: "might potentially" → "can" or commit to a statement
- Skip unnecessary transitions: "Furthermore", "Additionally", "Moreover"

## Specificity

- Replace vague adjectives with measurable claims — "fast" → "responds in <100ms"
- Prefer examples over explanations
- If a list has more than 5 items, consider whether all are necessary

## Avoid These Phrases

These are common markers of AI-generated text:

- "It's important to note that…"
- "This ensures that…"
- "Leverage" / "utilize" (use "use")
- "Robust" / "comprehensive" / "seamless" (be specific or remove)
- "In the context of…"
- "Serves as a…" / "Plays a crucial role in…"
- "A wide range of…"
- "Facilitates the process of…"

## Structure

- Start sections with what the reader needs to do, not background
- Put the most important information first
- Use headings to enable scanning — readers skip to what they need
- Keep paragraphs to 3-4 sentences max
