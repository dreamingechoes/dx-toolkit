# Accessibility Checklist Reference

Build products that work for everyone. Test with real assistive technology, not just automated tools.

## WCAG 2.1 AA Targets

These are the minimum requirements, not aspirational goals.

### Perceivable

- [ ] All images have meaningful `alt` text (or `alt=""` for decorative)
- [ ] Color is not the only way to convey information
- [ ] Color contrast ratio ≥ 4.5:1 for normal text, ≥ 3:1 for large text
- [ ] Text resizable to 200% without loss of content
- [ ] Video has captions; audio has transcripts
- [ ] No content flashes more than 3 times per second
- [ ] Page has a meaningful `<title>`

### Operable

- [ ] All functionality available via keyboard
- [ ] Visible focus indicator on all interactive elements
- [ ] Focus order follows logical reading order
- [ ] Skip-to-content link as first focusable element
- [ ] No keyboard traps (focus can always escape)
- [ ] Touch targets ≥ 44×44px on mobile
- [ ] Timeouts can be extended or disabled
- [ ] Page doesn't auto-redirect without warning

### Understandable

- [ ] `lang` attribute set on `<html>` element
- [ ] Form inputs have visible labels (not just placeholders)
- [ ] Error messages identify the field and suggest a fix
- [ ] Consistent navigation across pages
- [ ] No unexpected context changes on focus or input

### Robust

- [ ] Valid HTML (no duplicate IDs, proper nesting)
- [ ] ARIA attributes used correctly (or not at all — native HTML first)
- [ ] Custom components have proper roles and states
- [ ] Works with latest versions of major screen readers

## Keyboard Navigation

Every interactive element must be operable with these keys:

| Key                 | Action                                          |
| ------------------- | ----------------------------------------------- |
| `Tab` / `Shift+Tab` | Move between focusable elements                 |
| `Enter` / `Space`   | Activate buttons, links, checkboxes             |
| `Arrow keys`        | Navigate within components (tabs, menus, lists) |
| `Escape`            | Close modals, dropdowns, tooltips               |
| `Home` / `End`      | Jump to first/last item in list                 |

## ARIA Quick Reference

### Use Native HTML First

```html
<!-- GOOD: native button -->
<button>Save</button>

<!-- BAD: div pretending to be a button -->
<div role="button" tabindex="0" onclick="save()">Save</div>
```

### When ARIA is Needed

```html
<!-- Live regions for dynamic content -->
<div aria-live="polite">3 items in cart</div>

<!-- Describing relationships -->
<input aria-describedby="password-hint" type="password" />
<p id="password-hint">Must be 8+ characters</p>

<!-- State for custom components -->
<button aria-expanded="false" aria-controls="menu">Menu</button>
<ul id="menu" hidden>
  ...
</ul>
```

### ARIA Rules

1. Don't use ARIA if native HTML works
2. Don't change native semantics (`<h2 role="tab">` is wrong)
3. All interactive ARIA elements must be keyboard operable
4. Don't use `role="presentation"` or `aria-hidden="true"` on focusable elements
5. All interactive elements must have an accessible name

## Common Patterns

### Modal Dialog

```html
<div role="dialog" aria-labelledby="title" aria-modal="true">
  <h2 id="title">Confirm Delete</h2>
  <p>This action cannot be undone.</p>
  <button>Cancel</button>
  <button>Delete</button>
</div>
```

- Trap focus inside modal
- Return focus to trigger element on close
- Close on `Escape`

### Form Validation

```html
<label for="email">Email</label>
<input id="email" type="email" aria-invalid="true" aria-describedby="email-error" />
<p id="email-error" role="alert">Please enter a valid email address</p>
```

## Testing Tools

| Tool              | Type          | Use For                               |
| ----------------- | ------------- | ------------------------------------- |
| axe DevTools      | Automated     | Catch ~30% of issues automatically    |
| Lighthouse        | Automated     | Quick audit scores                    |
| VoiceOver (macOS) | Screen reader | Test real screen reader experience    |
| NVDA (Windows)    | Screen reader | Most popular free screen reader       |
| Keyboard only     | Manual        | Tab through entire page without mouse |
| Zoom to 200%      | Manual        | Check layout doesn't break            |

## Testing Process

1. Run automated scan (axe) — catches obvious issues
2. Tab through entire page with keyboard — check focus order and visibility
3. Test with screen reader — listen to the experience
4. Zoom to 200% — check content reflows properly
5. Check color contrast — use browser DevTools

Automated tools catch about 30% of accessibility issues. Manual testing with assistive technology catches the rest.
