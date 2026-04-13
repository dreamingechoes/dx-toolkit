---
description: 'CSS and styling standards. Use when writing CSS, SCSS, or Tailwind styles. Covers modern CSS features, responsive design, and accessibility.'
applyTo: '**/*.css, **/*.scss, **/*.module.css, **/*.module.scss'
---

# CSS Standards

## Modern CSS Features (use them)

- CSS Nesting — `& .child {}` instead of flat selectors
- Container Queries — `@container` for component-relative sizing
- CSS Layers — `@layer` for managing specificity
- `color-mix()` for dynamic colors
- `oklch()` / `oklab()` for perceptually uniform colors
- Logical properties — `margin-inline`, `padding-block` instead of directional
- `dvh`, `svh`, `lvh` units instead of `vh` (fixes mobile viewport issues)

## Layout

- Use CSS Grid for 2D layouts (page structure, dashboards)
- Use Flexbox for 1D layouts (navbars, card rows)
- Use `gap` instead of margin hacks for spacing
- Use `min()`, `max()`, `clamp()` for fluid sizing
- Mobile-first: start with small screen, use `min-width` media queries

## Architecture

- Use CSS custom properties (variables) for design tokens
- Define tokens at `:root` for global, at component level for local
- Namespace custom properties: `--color-primary`, `--spacing-md`
- Prefer CSS Modules or scoped styles over global CSS
- Avoid `!important` — fix specificity with layers or better selectors

## Performance

- Avoid animating `width`/`height` — use `transform` and `opacity`
- Use `will-change` sparingly and only before animations
- Use `content-visibility: auto` for off-screen content
- Prefer `prefers-reduced-motion` media query for accessibility

## Naming (when not using CSS Modules)

- BEM-like: `.block__element--modifier`
- Lowercase with hyphens: `.user-avatar`, not `.userAvatar`
- State classes: `.is-active`, `.has-error`
