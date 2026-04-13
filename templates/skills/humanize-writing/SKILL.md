---
name: 'humanize-writing'
description: 'Rewrite AI-generated text to sound natural, specific, and human. Use when documentation, PR descriptions, commit messages, or issue comments read like they were written by a language model.'
---

# Humanize Writing

Transform robotic, AI-sounding text into clear, natural prose that reads like it was written by an experienced developer.

## When to Use

- Documentation that sounds generic or overly formal
- PR descriptions full of filler phrases
- Issue comments that feel templated
- README sections that lack personality
- Any text flagged as "sounds like AI"

## Anti-Patterns to Detect

Watch for these common AI-writing markers and eliminate them:

### Filler Phrases

| ❌ Remove                           | ✅ Replace With                 |
| ----------------------------------- | ------------------------------- |
| "It's important to note that…"      | (just state the thing)          |
| "This ensures that…"                | "This prevents X" / "So that…"  |
| "In order to…"                      | "To…"                           |
| "Leverage / utilize"                | "Use"                           |
| "Robust / comprehensive / seamless" | (specific adjective or remove)  |
| "In the context of…"                | (remove, start with the noun)   |
| "It should be noted that…"          | (delete entirely)               |
| "This approach allows us to…"       | "This lets us…" / "We can now…" |
| "Moving forward…"                   | (delete or "Next,…")            |
| "Please feel free to…"              | "You can…"                      |
| "Serves as a…"                      | "Is a…" / "Acts as…"            |
| "Plays a crucial role in…"          | "Handles…" / "Does…"            |
| "A wide range of…"                  | (be specific or "many")         |
| "Facilitates the process of…"       | "Helps…" / "Makes X easier"     |
| "Based on the aforementioned…"      | "From this…" / "So…"            |

### Structural Red Flags

- **Excessive hedging** — "might potentially" → "can" or commit to a position
- **Triple-stacked adjectives** — "robust, scalable, and maintainable" → pick the one that matters
- **Over-explaining the obvious** — "This function, which returns a boolean value indicating whether…" → "Returns true when…"
- **Symmetrical lists** — every bullet the exact same length and structure feels generated
- **Starting every paragraph with "This…"** — vary sentence openings
- **Unnecessary transitions** — "Furthermore, additionally, moreover" → just write the next sentence

### Tone Markers

- **Too formal for the context** — "One might consider" → "You could" or "Try"
- **Passive voice overuse** — "The configuration is loaded by…" → "X loads the config"
- **Avoiding first/second person** — dev docs should use "you" and "we" freely
- **Exclamation inflation** — "Great news! 🎉" in a bugfix PR is suspicious

## Procedure

1. **Read the input text** completely before making changes
2. **Identify anti-patterns** from the lists above — note which ones appear
3. **Determine the audience** — developers? end-users? stakeholders? Match their expectations
4. **Determine the format** — README, PR description, commit message, inline comment, issue? Each has its own voice:
   - **README**: direct, scannable, practical
   - **PR description**: concise context for reviewers, what and why
   - **Commit message**: imperative mood, 50/72 rule
   - **Issue comment**: conversational, focused
   - **Inline comment**: terse, explain _why_ not _what_
5. **Rewrite** applying these rules:
   - Cut filler words and phrases ruthlessly
   - Replace vague adjectives with specifics ("fast" → "responds in <100ms")
   - Use active voice by default
   - Keep sentences short — one idea per sentence
   - Vary sentence length and structure (mix short punchy with medium)
   - Use "you/we" not "one/the user"
   - Preserve all technical accuracy — never sacrifice correctness for style
   - Keep the same meaning — only change _how_ it's said, not _what_ it says
6. **Compare** the rewrite against the original — verify no information was lost
7. **Output** the rewritten version

## Voice Guidelines

- **Be direct**: say what you mean in the fewest words
- **Be specific**: numbers beat adjectives, examples beat explanations
- **Be human**: contractions are fine, humor is fine if natural, personality is welcome
- **Be honest**: if something is a trade-off, say so — don't spin everything as a win
- **Match energy**: a hotfix PR is not a TED talk, a README intro is not a legal brief

## Output

Produce the rewritten text. If the user gave a single block, return a single rewritten block. If reviewing a full document, return the complete rewritten document.

When significant changes were made, add a brief summary at the end:

```
### Changes Made
- Removed N filler phrases (listed)
- Switched to active voice in sections X, Y
- Replaced vague claims with specifics in Z
- Shortened overall by ~N%
```
