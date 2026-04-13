---
description: 'Accessibility (a11y) standards. Use when working on UI components, forms, navigation, or any user-facing code. Covers WCAG 2.2 AA requirements.'
---

# Accessibility Standards (WCAG 2.2 AA)

## Semantic HTML

- Use `<button>` for actions, `<a>` for navigation — never `<div onClick>`
- Use heading hierarchy (`h1` → `h2` → `h3`) without skipping levels
- Use `<nav>`, `<main>`, `<aside>`, `<footer>` landmarks
- Use `<ul>`/`<ol>` for lists, `<table>` for tabular data
- Use `<fieldset>` + `<legend>` to group related form fields

## Forms

- Every input MUST have a visible `<label>` (or `aria-label` for icon-only inputs)
- Use `aria-describedby` for help text and error messages
- Mark required fields with `aria-required="true"`
- Show errors inline, associated to the field, and announced by screen readers
- Use `autocomplete` attributes for common fields (name, email, address)

## Images & Media

- Every `<img>` needs `alt` text (empty `alt=""` for decorative images)
- Complex images (charts, diagrams) need detailed `aria-describedby` text
- Videos need captions and audio descriptions
- Don't use images of text — use real text

## Keyboard Navigation

- All interactive elements must be keyboard accessible
- Visible focus indicators on all focusable elements (never `outline: none` without a replacement)
- Logical tab order following the visual layout
- Modal dialogs must trap focus
- Escape key closes modals/popups
- Skip-to-content link as first focusable element

## Color & Contrast

- `4.5:1` contrast ratio for normal text
- `3:1` contrast ratio for large text (18px+ or 14px+ bold)
- Never use color alone to convey information (add icons, patterns, or text)

## Dynamic Content

- Use `aria-live` regions for dynamic updates (toasts, notifications)
- Use `aria-busy` during loading states
- Announce route changes in SPAs
- Respect `prefers-reduced-motion` — disable or reduce animations
