---
description: 'Scaffold a new UI component with proper structure, types, styles, tests, and documentation. Detects framework from the codebase.'
agent: 'agent'
---

Scaffold a complete UI component based on the user's description.

## Requirements

1. **Detect the framework** from the codebase (React, Vue, Svelte, Phoenix LiveView, Rails ViewComponent, Angular, Blazor, etc.)
2. **Follow existing patterns** — match the project's component structure, naming, and style approach
3. **Generate these files** (adapt to the project's conventions):
   - Component file with typed props or documented parameters
   - Style file matching the project's approach (CSS Modules, Tailwind, SCSS, utility classes, etc.)
   - Test file following existing test patterns
   - Documentation or story file if the project uses component docs (Storybook, Lookbook, Histoire, etc.)
   - Index/barrel export if the project uses them

## Component Guidelines

- Props/parameters must be fully typed or documented
- Include sensible defaults for optional props
- Follow accessibility best practices (semantic HTML, ARIA attributes, keyboard navigation)
- Keep the component focused — single responsibility
- Match the codebase's existing patterns for state management, event handling, and composition

## Output

For each generated file, explain:

- What it does
- Key design decisions
- How to use the component (brief example)
