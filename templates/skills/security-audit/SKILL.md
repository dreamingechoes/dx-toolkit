---
name: security-audit
description: 'Perform a comprehensive security audit of a codebase. Use when conducting security reviews, before major releases, or after security incidents. Covers OWASP Top 10, dependency scanning, configuration review, and remediation guidance.'
---

# Security Audit

## When to Use

- Scheduled security reviews (quarterly/before releases)
- After a security incident or vulnerability report
- When onboarding a new codebase
- Before going to production for the first time

## Procedure

1. **Dependency audit**:
   - Run the package manager's audit command:
     - `mix hex.audit` + `mix deps.audit` (Elixir)
     - `npm audit` / `yarn audit` / `pnpm audit` (Node.js)
     - `pip audit` (Python)
   - Check for outdated dependencies with known CVEs
   - Verify lockfile integrity
   - Document findings with severity and remediation

2. **Authentication & Authorization**:
   - Verify password hashing (bcrypt/Argon2 with appropriate cost)
   - Check session management (secure cookies, expiry, rotation)
   - Verify JWT implementation (algorithm, expiry, refresh)
   - Test authorization on every endpoint (not just in UI)
   - Check for privilege escalation paths
   - Verify rate limiting on auth endpoints

3. **Input Validation & Injection**:
   - Search for raw SQL queries / string interpolation in queries
   - Check for command injection (`exec`, `system`, `eval`)
   - Verify HTML/JS output escaping (XSS prevention)
   - Check file upload validation (type, size, path traversal)
   - Test for SSRF (Server-Side Request Forgery)
   - Verify CSRF protection on state-changing endpoints

4. **Data Protection**:
   - Search for hardcoded secrets / API keys / passwords
   - Check logging for sensitive data (PII, tokens, passwords)
   - Verify encryption in transit (TLS, HSTS)
   - Check encryption at rest for sensitive fields
   - Review error messages for information leakage
   - Verify PII handling complies with requirements

5. **Configuration & Infrastructure**:
   - Check security headers (CSP, X-Frame-Options, HSTS, etc.)
   - Verify CORS configuration is restrictive
   - Check for debug mode / verbose errors in production config
   - Review Docker configuration (non-root user, minimal image)
   - Check for exposed admin interfaces
   - Verify secrets management (env vars, vaults — not config files)

6. **Produce the audit report**:

```markdown
## Security Audit Report

**Date**: [Date]
**Scope**: [Repository/Module]
**Auditor**: [Name]

### Executive Summary

[One paragraph: overall security posture and critical findings]

### Findings

#### 🔴 Critical

| #   | Finding | Location    | Impact   | Remediation |
| --- | ------- | ----------- | -------- | ----------- |
| 1   | [Title] | [File:line] | [Impact] | [Fix]       |

#### 🟡 High

| #   | Finding | Location | Impact | Remediation |
| --- | ------- | -------- | ------ | ----------- |

#### 🟠 Medium

| #   | Finding | Location | Impact | Remediation |
| --- | ------- | -------- | ------ | ----------- |

#### 🔵 Low / Informational

| #   | Finding | Location | Impact | Remediation |
| --- | ------- | -------- | ------ | ----------- |

### Dependency Vulnerabilities

| Package | Current | Patched | Severity | CVE |
| ------- | ------- | ------- | -------- | --- |

### Recommendations

1. [Prioritized action items]

### Next Steps

- [ ] Fix critical findings immediately
- [ ] Schedule high findings for next sprint
- [ ] Review medium/low findings in backlog
```
