---
description: 'Run an accessibility review on UI code. Checks WCAG 2.2 AA compliance for components, pages, or the full application.'
agent: 'agent'
---

Perform an accessibility review on the specified UI code.

## Procedure

1. **Scan the code** for accessibility issues:
   - Missing or incorrect ARIA attributes
   - Images without alt text
   - Form inputs without labels
   - Missing heading hierarchy
   - Color contrast issues in styles
   - Missing keyboard navigation support
   - Focus management problems
2. **Check interactive elements**:
   - Buttons and links are keyboard accessible
   - Custom components have proper roles
   - Modals trap focus and restore it on close
   - Dropdown/menu components support arrow key navigation
3. **Review forms**:
   - Every input has a visible label
   - Error messages are announced to screen readers
   - Required fields are indicated accessibly
   - Form validation is accessible
4. **Generate report** with specific fixes for each issue

## Severity Levels

- **Critical**: Content or functionality is inaccessible (missing labels, keyboard traps)
- **Major**: Significant barrier for assistive technology users
- **Minor**: Best practice violation, not blocking

## Rules

- Reference specific WCAG 2.2 AA success criteria for each finding
- Provide code fix for each issue, not just a description
- Check both visual and programmatic accessibility
- Test with reduced motion, high contrast, and zoom scenarios
