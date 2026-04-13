# Security Policy

## Supported Versions

| Version | Supported |
| ------- | --------- |
| main    | Yes       |

## Reporting a Vulnerability

If you discover a security vulnerability in this repository, please report it responsibly.

**Do NOT open a public GitHub issue for security vulnerabilities.**

Instead:

1. Go to the [Security Advisories](https://github.com/dreamingechoes/dx-toolkit/security/advisories) page
2. Click **"Report a vulnerability"**
3. Provide as much detail as possible:
   - Description of the vulnerability
   - Steps to reproduce
   - Affected components (workflows, hooks, agents, etc.)
   - Potential impact

## Response Timeline

- **Acknowledgment**: Within 48 hours
- **Assessment**: Within 1 week
- **Fix**: Depends on severity — critical issues are prioritized

## Scope

This security policy covers:

- GitHub Actions workflows
- Hook scripts
- DevContainer configuration
- Any secrets handling patterns or examples in documentation

## Best Practices for Users

When using this toolkit in your repositories:

- **Never commit secrets** — use GitHub repository secrets or environment variables
- **Review hook scripts** before enabling them — they execute on your machine
- **Pin workflow versions** — use `@sha` or `@tag` instead of `@main` in production
- **Audit MCP servers** — review MCP server packages before connecting them to your editor
- **Restrict PAT scopes** — grant only the minimum permissions needed
