---
description: 'Review code for security vulnerabilities following OWASP Top 10. Covers injection, auth, data exposure, XSS, CSRF, and more.'
agent: 'agent'
tools: [read, search]
---

Perform a thorough security review of the provided code.

## Review Checklist (OWASP Top 10)

### 1. Injection (SQL, NoSQL, Command, LDAP)

- Are all user inputs parameterized/escaped?
- Are ORMs used correctly (no raw string interpolation)?

### 2. Broken Authentication

- Are passwords hashed with bcrypt/Argon2 (not MD5/SHA)?
- Are sessions managed securely (httpOnly, secure, SameSite)?
- Is there rate limiting on auth endpoints?

### 3. Sensitive Data Exposure

- Are secrets in environment variables (not hardcoded)?
- Is PII logged or exposed in error messages?
- Is data encrypted in transit (TLS) and at rest?

### 4. XML External Entities (XXE)

- Is XML parsing disabled or configured safely?

### 5. Broken Access Control

- Are authorization checks on every endpoint?
- Is there IDOR (Insecure Direct Object Reference) risk?

### 6. Security Misconfiguration

- Are default credentials changed?
- Are CORS policies restrictive enough?
- Are security headers set (CSP, HSTS, X-Frame-Options)?

### 7. Cross-Site Scripting (XSS)

- Is user input sanitized before rendering?
- Are template engines auto-escaping?

### 8. Insecure Deserialization

- Is untrusted data deserialized?

### 9. Known Vulnerable Components

- Are dependencies up to date?
- Are there known CVEs in current versions?

### 10. Insufficient Logging

- Are auth events logged?
- Are error details hidden from users but logged internally?

## Output Format

For each finding:

- **Severity**: 🔴 Critical / 🟡 Warning / 🔵 Info
- **Location**: File and line
- **Issue**: What's wrong
- **Fix**: How to fix it with code example

## Constraints

- DO NOT modify any code — report findings only
- Prioritize findings by severity
- Include false positives only if they warrant investigation
