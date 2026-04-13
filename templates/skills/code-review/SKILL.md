---
name: code-review
description: 'Perform a thorough code review with structured feedback. Use when reviewing pull requests, code submissions, or when you want a quality check on your code. Covers correctness, security, performance, readability, and maintainability.'
---

# Code Review

## When to Use

- Reviewing a pull request before merge
- Self-reviewing code before submitting a PR
- When asked to review a diff, file, or set of changes

## Procedure

1. **Understand the context**:
   - Read the PR description or issue for intent
   - Understand the scope of changes (what's supposed to change and what's not)
   - Check the project's conventions and patterns

2. **First pass — correctness**:
   - Does the code do what it claims?
   - Are all edge cases handled?
   - Are error paths handled correctly?
   - Are there any logical errors or off-by-one mistakes?
   - Do the types match the runtime behavior?

3. **Second pass — security**:
   - User input validated and sanitized?
   - No SQL injection, XSS, or command injection vectors?
   - Secrets not hardcoded or logged?
   - Authorization checks present?
   - Sensitive data not exposed?

4. **Third pass — architecture & design**:
   - Does the change follow the project's architecture patterns?
   - Is the abstraction level appropriate?
   - Is there unnecessary complexity?
   - Are there missing tests?
   - Is the naming clear and consistent?

5. **Fourth pass — performance**:
   - Any N+1 queries or unnecessary database calls?
   - Any unnecessary re-renders or computations?
   - Large data structures handled efficiently?
   - Pagination for list endpoints?

6. **Produce the review**:

```markdown
## Review Summary

**Overall**: ✅ Approve / ⚠️ Request Changes / 💬 Comment

### Findings

#### 🔴 Critical (must fix)

- **[file:line]**: [Issue description and suggested fix]

#### 🟡 Suggestions (should fix)

- **[file:line]**: [Issue description and suggested improvement]

#### 🔵 Nits (optional)

- **[file:line]**: [Minor suggestion]

#### ✅ What's Good

- [Positive observations]

### Testing

- [ ] Tests cover the happy path
- [ ] Tests cover edge cases
- [ ] Tests cover error scenarios
- [ ] Existing tests still pass
```
