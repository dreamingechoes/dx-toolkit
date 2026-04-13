# Security Checklist Reference

Pre-commit and pre-deploy security checks. Covers OWASP Top 10 categories.

## Pre-Commit Checks

- [ ] No secrets in code (API keys, passwords, tokens)
- [ ] No hardcoded credentials — use environment variables
- [ ] `.env` files are in `.gitignore`
- [ ] SQL queries use parameterized statements
- [ ] User input is validated and sanitized
- [ ] Error messages don't leak internal details

## Authentication & Authorization

- [ ] Passwords hashed with bcrypt/argon2 (never MD5/SHA1)
- [ ] Session tokens are cryptographically random
- [ ] JWT tokens have reasonable expiry (< 1 hour for access tokens)
- [ ] Refresh tokens are rotated on use
- [ ] Failed login attempts are rate-limited
- [ ] Authorization checked on every endpoint (not just UI)
- [ ] Role checks happen server-side, never client-only
- [ ] Default deny — explicitly grant access, don't restrict

## Input Validation

| Input Type   | Validation                                               |
| ------------ | -------------------------------------------------------- |
| Strings      | Max length, allowed characters, sanitize HTML            |
| Numbers      | Range check (min/max), integer vs float                  |
| Email        | Format validation + domain check                         |
| URLs         | Allowlist schemes (https only), prevent SSRF             |
| File uploads | File type check (magic bytes, not extension), size limit |
| IDs          | UUID format or integer range, never trust user-provided  |
| JSON         | Schema validation, reject unknown fields                 |

## Injection Prevention

### SQL Injection

```typescript
// GOOD: parameterized query
db.query('SELECT * FROM users WHERE id = $1', [userId])

// BAD: string concatenation
db.query(`SELECT * FROM users WHERE id = ${userId}`)
```

### XSS Prevention

```typescript
// GOOD: framework auto-escaping
<p>{userInput}</p>

// BAD: dangerously setting HTML
<div dangerouslySetInnerHTML={{ __html: userInput }} />
```

### Command Injection

```typescript
// GOOD: use library APIs
import { execFile } from 'child_process'
execFile('ls', ['-la', directory])

// BAD: shell interpolation
exec(`ls -la ${directory}`)
```

## API Security

- [ ] HTTPS everywhere — no HTTP endpoints
- [ ] CORS configured with specific origins (not `*`)
- [ ] Rate limiting on all public endpoints
- [ ] Request size limits configured
- [ ] API versioning in place
- [ ] Sensitive data not in URL query parameters
- [ ] `Content-Type` headers validated

## Data Protection

- [ ] PII encrypted at rest
- [ ] Database connections use TLS
- [ ] Backups encrypted
- [ ] Logs don't contain PII, tokens, or passwords
- [ ] Data retention policy enforced (auto-delete old data)
- [ ] GDPR: data export and deletion endpoints exist

## Dependency Security

- [ ] No known CVEs in dependencies (`npm audit`, `pip audit`)
- [ ] Lock files committed (`package-lock.json`, `poetry.lock`)
- [ ] Dependabot or Renovate configured for auto-updates
- [ ] Minimal dependencies — each one is an attack surface

## Infrastructure

- [ ] Environment variables for all secrets
- [ ] Secrets rotated on schedule (90 days max)
- [ ] Minimal IAM permissions (least privilege)
- [ ] Database not publicly accessible
- [ ] Security headers set (CSP, HSTS, X-Frame-Options)
- [ ] Docker images use non-root user
- [ ] Container images pinned to digest, not `latest`

## Incident Response

When a vulnerability is found:

1. **Assess** — What data is affected? Is it actively exploited?
2. **Contain** — Revoke compromised credentials, block attack vector
3. **Fix** — Patch the vulnerability
4. **Notify** — Inform affected users per legal requirements
5. **Post-mortem** — Document what happened and prevent recurrence
