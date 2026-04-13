---
description: 'Audit project dependencies for security vulnerabilities, outdated versions, maintenance status, and license compatibility.'
agent: 'agent'
---

Audit the dependencies in this project for health, security, and compliance.

## Procedure

1. **Detect package manager**: Identify lock files (package-lock.json, yarn.lock, pnpm-lock.yaml, Gemfile.lock, mix.lock, go.sum, Cargo.lock, requirements.txt, poetry.lock)
2. **Run vulnerability scan**: Use the built-in audit tool (`npm audit`, `pip-audit`, `cargo audit`, `mix audit`, etc.)
3. **Check for outdated packages**: List packages with available updates, grouped by major/minor/patch
4. **Assess maintenance status**: For each dependency, check last publish date, open issues, and bus factor
5. **Review licenses**: List all dependency licenses, flag any that are copyleft or unknown
6. **Analyze bundle impact**: For frontend projects, check which dependencies contribute most to bundle size
7. **Generate report**: Create a structured summary with priority recommendations

## Output Format

```markdown
## Dependency Audit Report

### Critical (fix immediately)

- [package]: [vulnerability CVE / issue]

### High Priority

- [package]: [outdated by N major versions / unmaintained / license issue]

### Medium Priority

- [package]: [outdated minor / large bundle impact]

### Recommendations

- [specific actionable recommendation]
```
