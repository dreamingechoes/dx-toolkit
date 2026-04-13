---
description: 'React and JSX component standards. Use when writing React components, hooks, or JSX/TSX files. Covers composition, hooks, state management, and accessibility.'
applyTo: '**/*.tsx, **/*.jsx'
---

# React Component Standards

## Component Design

- Use function components exclusively — no class components
- Export named components (not default exports) for better refactoring
- One component per file — colocate styles, tests, and stories
- Use composition over configuration — prefer `children` and render props over complex prop APIs
- Keep components under 150 lines — extract when they grow

## Props

- Destructure props in the function signature
- Use `React.ComponentPropsWithoutRef<'element'>` to extend HTML props
- Use `ref` as a regular prop (React 19+) — no `forwardRef`
- Provide defaults via default parameter values, not `defaultProps`

## Hooks

- Follow the Rules of Hooks — only call at the top level
- Extract custom hooks when logic is reused or complex
- Use `useActionState` (React 19+) for form state management
- Use `use()` hook for reading promises and context (React 19+)
- Prefer `useMemo`/`useCallback` only when there's a measurable performance need
- Use `useId()` for accessible form labels

## State Management

- Component state (`useState`) for local UI state
- URL state (search params) for shareable/bookmarkable state
- Server state (React Query, SWR, Server Components) for remote data
- Global state (context, Zustand) only for truly app-wide state(auth, theme)

## Accessibility

- Use semantic HTML elements (`button`, `nav`, `main`, `section`)
- Every `<img>` needs `alt` text
- Every form input needs a `<label>` (use `useId()`)
- Respect `prefers-reduced-motion` in animations
- Test with keyboard navigation
