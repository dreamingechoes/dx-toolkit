---
name: accessibility-audit
description: 'Full WCAG 2.2 AA accessibility audit procedure. Goes beyond the reference checklist with step-by-step testing methodology, tooling, and remediation guidance.'
---

# Accessibility Audit

## Overview

An accessibility audit systematically tests a web application against WCAG 2.2 Level AA criteria using a combination of automated tools and manual testing. Automated tools catch roughly 30-40% of accessibility issues — the rest require human testing with keyboards, screen readers, and careful review of interaction patterns.

This skill provides a repeatable, step-by-step audit procedure that goes beyond running a scanner. It covers every major category of accessibility failure and provides specific remediation guidance for each.

## When to Use

- Before launching a new product or feature
- During scheduled accessibility reviews (quarterly recommended)
- After receiving an accessibility complaint or legal notice
- When redesigning UI components or navigation
- During design system creation or updates
- When onboarding a new codebase that hasn't been audited

**When NOT to use:** For quick spot-checks of individual components. Use the accessibility reference checklist instead. This skill is for comprehensive audits of pages or flows.

## Process

### Step 1 — Automated Scan

Run automated tools to catch the low-hanging fruit.

**Tools (run all three — they catch different things):**

| Tool       | What It Catches                   | How to Run                           |
| ---------- | --------------------------------- | ------------------------------------ |
| axe-core   | DOM-level WCAG violations         | Browser extension or `@axe-core/cli` |
| Lighthouse | Performance + accessibility score | Chrome DevTools → Lighthouse tab     |
| WAVE       | Visual overlay of issues          | Browser extension                    |

**Procedure:**

1. Run axe-core on every unique page template (not every page — just each distinct layout)
2. Run Lighthouse accessibility audit on the top 5 most-visited pages
3. Use WAVE to visually inspect pages with complex layouts or forms
4. Export results from all three tools
5. Deduplicate findings — the same issue may appear in multiple tools

**Document automated findings:**

```markdown
## Automated Scan Results

Tool: [axe-core / Lighthouse / WAVE]
Pages scanned: [list]
Date: [date]

| #   | Issue                   | WCAG Criterion | Severity | Page   | Element    | Count |
| --- | ----------------------- | -------------- | -------- | ------ | ---------- | ----- |
| 1   | Images missing alt text | 1.1.1          | Critical | /home  | img.hero   | 3     |
| 2   | Low contrast text       | 1.4.3          | Serious  | /about | p.subtitle | 12    |
```

### Step 2 — Keyboard Testing

Put your mouse away. Everything in the application must be operable with only a keyboard.

**Test procedure:**

1. Start at the top of the page
2. Press `Tab` to move through every interactive element
3. Verify for each element:

| Check                      | Key         | Expected                                                         |
| -------------------------- | ----------- | ---------------------------------------------------------------- |
| Focus is visible           | Tab         | Every focused element has a visible outline or indicator         |
| Order is logical           | Tab         | Focus follows visual/reading order, left-to-right, top-to-bottom |
| No keyboard traps          | Tab         | You can always move forward — never get stuck                    |
| Escape closes overlays     | Escape      | Modals, dropdowns, popovers close and return focus               |
| Enter/Space activates      | Enter/Space | Buttons and links activate on keypress                           |
| Arrow keys work in widgets | Arrows      | Tabs, menus, sliders, date pickers respond to arrow keys         |
| Skip link exists           | Tab (first) | First Tab press reveals "Skip to main content" link              |

**Keyboard traps to check specifically:**

- Modal dialogs — focus should be trapped inside while open, released when closed
- Dropdown menus — Escape should close the menu
- Date pickers — must be fully operable with arrow keys
- Carousels and sliders — arrow keys should move between items
- Infinite scroll — must have a way to reach the footer

### Step 3 — Screen Reader Testing

Test with at least one screen reader. Two is better.

**Recommended combinations:**

| Platform | Screen Reader      | Browser           |
| -------- | ------------------ | ----------------- |
| macOS    | VoiceOver          | Safari            |
| Windows  | NVDA (free)        | Firefox or Chrome |
| Windows  | JAWS               | Chrome            |
| Mobile   | VoiceOver (iOS)    | Safari            |
| Mobile   | TalkBack (Android) | Chrome            |

**Test procedure:**

1. Navigate the page using only the screen reader
2. Verify each element:

| Check                                 | Expected                                                                 |
| ------------------------------------- | ------------------------------------------------------------------------ |
| Page title is announced               | Descriptive, unique title on every page                                  |
| Headings form a logical hierarchy     | h1 → h2 → h3, no skipped levels                                          |
| Images have alt text                  | Decorative images have `alt=""`, informative images have descriptive alt |
| Links describe their destination      | No "click here" or "read more" without context                           |
| Form fields have labels               | Every input is announced with its label                                  |
| Error messages are announced          | Errors are associated with fields via `aria-describedby` or live regions |
| Dynamic content updates are announced | `aria-live` regions announce changes                                     |
| Tables have headers                   | `<th>` elements with `scope` attribute                                   |
| ARIA roles are correct                | Custom widgets have appropriate `role`, `aria-expanded`, `aria-selected` |

### Step 4 — Color and Contrast Audit

**Text contrast (WCAG 1.4.3):**

| Element                             | Minimum Ratio |
| ----------------------------------- | ------------- |
| Normal text (< 18px / 14px bold)    | 4.5:1         |
| Large text (≥ 18px / 14px bold)     | 3:1           |
| UI components and graphical objects | 3:1           |

**Tools:**

- Chrome DevTools → inspect element → contrast ratio shown in color picker
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- Figma plugins: Stark, A11y - Color Contrast Checker

**Additional color checks:**

- [ ] Information is not conveyed by color alone (use icons, patterns, or text)
- [ ] Links are distinguishable from surrounding text without relying on color (underline or other visual cue)
- [ ] Error states use more than red color (icon + text)
- [ ] Charts and graphs use patterns or labels in addition to color
- [ ] Focus indicators have 3:1 contrast against the background

### Step 5 — Form and Error Audit

Forms are where most accessibility failures impact users.

**Form checklist:**

| Check                                  | WCAG  | How to Verify                                                    |
| -------------------------------------- | ----- | ---------------------------------------------------------------- |
| Every input has a visible `<label>`    | 1.3.1 | Inspect DOM — `<label for="">` or `aria-label`                   |
| Required fields are indicated          | 1.3.1 | Visual indicator + `aria-required="true"`                        |
| Input purpose is identified            | 1.3.5 | `autocomplete` attribute on name, email, address, etc.           |
| Error messages identify the field      | 3.3.1 | Error text names the specific field                              |
| Error messages suggest correction      | 3.3.3 | "Email format: name@example.com" not just "Invalid input"        |
| Errors are announced to screen readers | 4.1.3 | `aria-describedby` linking error to field, or `aria-live` region |
| Form can be submitted with Enter key   | 2.1.1 | Press Enter in last field — form submits                         |
| Success/confirmation is announced      | 4.1.3 | `aria-live="polite"` for success messages                        |

**Error pattern implementation:**

```html
<!-- Correct: error linked to input -->
<label for="email">Email</label>
<input id="email" type="email" aria-describedby="email-error" aria-invalid="true" />
<span id="email-error" role="alert">Enter a valid email address</span>

<!-- Incorrect: error not associated -->
<label>Email</label>
<input type="email" />
<span class="error">Invalid</span>
```

### Step 6 — Motion and Animation Audit

**Checks:**

- [ ] `prefers-reduced-motion` media query is respected — animations are disabled or reduced
- [ ] No content flashes more than 3 times per second (seizure risk, WCAG 2.3.1)
- [ ] Auto-playing video or audio has visible pause/stop control
- [ ] Carousels and auto-advancing content have pause controls
- [ ] Parallax scrolling effects can be disabled
- [ ] Loading spinners and skeleton screens don't cause excessive motion

**Implementation:**

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

### Step 7 — Document Findings and Prioritize Fixes

Produce the audit report.

```markdown
## Accessibility Audit Report

**Application**: [Name]
**Date**: [Date]
**Auditor**: [Name]
**Standard**: WCAG 2.2 Level AA

### Summary

| Severity                 | Count |
| ------------------------ | ----- |
| Critical (blocks access) | X     |
| Serious (major barrier)  | X     |
| Moderate (inconvenient)  | X     |
| Minor (best practice)    | X     |

### Findings

#### Critical — Blocks Access for Some Users

| #   | Issue         | WCAG        | Page  | Element    | Remediation |
| --- | ------------- | ----------- | ----- | ---------- | ----------- |
| 1   | [Description] | [Criterion] | [URL] | [Selector] | [Fix]       |

#### Serious — Major Barrier

| #   | Issue | WCAG | Page | Element | Remediation |
| --- | ----- | ---- | ---- | ------- | ----------- |

#### Moderate — Inconvenient

| #   | Issue | WCAG | Page | Element | Remediation |
| --- | ----- | ---- | ---- | ------- | ----------- |

#### Minor — Best Practice

| #   | Issue | WCAG | Page | Element | Remediation |
| --- | ----- | ---- | ---- | ------- | ----------- |

### Prioritized Remediation Plan

| Priority | Issue             | Effort  | Sprint  |
| -------- | ----------------- | ------- | ------- |
| P1       | [Critical issues] | [S/M/L] | Current |
| P2       | [Serious issues]  | [S/M/L] | Next    |
| P3       | [Moderate issues] | [S/M/L] | Backlog |
```

## Common Rationalizations

| Rationalization                             | Reality                                                                                                                                     |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| "Our users don't have disabilities"         | ~15-20% of the population has a disability. You also have users with temporary impairments (broken arm, bright sunlight, loud environment). |
| "We'll fix accessibility later"             | Retrofitting accessibility is 10x more expensive than building it in. Fix it now.                                                           |
| "The automated scan found no issues"        | Automated tools catch 30-40% of issues. Manual testing is required for keyboard, screen reader, and cognitive accessibility.                |
| "ARIA will fix it"                          | `aria-` attributes don't add behavior — they add semantics. Use native HTML elements first. ARIA is a last resort, not a shortcut.          |
| "Screen reader users are a tiny percentage" | Accessibility benefits everyone: keyboard users, power users, users with slow connections, users with temporary injuries, and SEO.          |

## Red Flags

- Audit only used automated tools without manual testing
- No keyboard testing was performed
- No screen reader testing was performed
- Custom widgets (tabs, accordions, modals) without ARIA roles
- Focus management not tested after dynamic content changes
- Color contrast only checked on white backgrounds (check all backgrounds)
- Forms tested only with mouse clicks, not keyboard
- `prefers-reduced-motion` not addressed

## Verification

- [ ] Automated scan completed with axe-core, Lighthouse, or equivalent
- [ ] Full keyboard navigation tested on all pages
- [ ] Screen reader testing completed with at least one reader
- [ ] Color contrast verified for all text and UI components
- [ ] Every form field has an associated label
- [ ] Error messages are specific, helpful, and announced to screen readers
- [ ] Motion and animation respect `prefers-reduced-motion`
- [ ] Findings are documented with severity, WCAG criterion, and remediation
- [ ] Remediation plan is prioritized by impact
