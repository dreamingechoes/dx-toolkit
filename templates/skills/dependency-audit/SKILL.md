---
name: dependency-audit
description: 'Audit dependency health: outdated versions, unmaintained packages, known vulnerabilities, license issues, and bundle size impact.'
---

# Dependency Audit

## Overview

Dependencies are other people's code running in your application. Every dependency is a bet that the maintainer will keep it secure, compatible, and maintained. This skill provides a systematic process for evaluating that bet — checking for vulnerabilities, assessing maintenance health, analyzing bundle impact, and reviewing license compliance.

A dependency audit isn't a one-time event. Run it quarterly at minimum, and after any major version upgrade of your language or framework.

## When to Use

- Quarterly dependency health review
- Before upgrading a framework or language version
- When adopting a new dependency (vet it before adding)
- After a security advisory for a dependency you use
- When bundle size or install time has grown unexpectedly
- Before a major release or security compliance review

**When NOT to use:** Routine version bumps with no breaking changes. Use your package manager's update command with tests for that.

## Process

### Step 1 — Inventory Dependencies

Get a complete picture of what you depend on, including transitive dependencies.

**Commands by ecosystem:**

| Ecosystem    | List Direct           | List All (incl. transitive)          |
| ------------ | --------------------- | ------------------------------------ |
| npm          | `npm ls --depth=0`    | `npm ls --all`                       |
| yarn         | `yarn list --depth=0` | `yarn list`                          |
| pnpm         | `pnpm list --depth=0` | `pnpm list --depth=Infinity`         |
| pip          | `pip list`            | `pip list` (all are "direct" in pip) |
| mix (Elixir) | `mix deps`            | `mix deps.tree`                      |
| cargo (Rust) | `cargo metadata`      | `cargo tree`                         |
| go           | `go list -m all`      | `go mod graph`                       |
| Maven        | `mvn dependency:list` | `mvn dependency:tree`                |

**Produce the inventory:**

```markdown
## Dependency Inventory

**Total direct dependencies**: [N]
**Total transitive dependencies**: [N]
**Last audit date**: [date]

### Direct Dependencies

| Package | Version   | Purpose         | Last Updated | License   |
| ------- | --------- | --------------- | ------------ | --------- |
| [name]  | [version] | [why we use it] | [date]       | [license] |
```

Flag any dependency where you can't explain "why we use it" — it may be removable.

### Step 2 — Check for Known Vulnerabilities

Run the package manager's built-in audit tool.

**Commands:**

| Ecosystem | Command                                      | Notes                                                   |
| --------- | -------------------------------------------- | ------------------------------------------------------- |
| npm       | `npm audit`                                  | Add `--production` to skip dev deps                     |
| yarn      | `yarn audit`                                 |                                                         |
| pnpm      | `pnpm audit`                                 |                                                         |
| pip       | `pip-audit`                                  | Install: `pip install pip-audit`                        |
| mix       | `mix deps.audit` + `mix hex.audit`           |                                                         |
| cargo     | `cargo audit`                                | Install: `cargo install cargo-audit`                    |
| go        | `govulncheck ./...`                          | Install: `go install golang.org/x/vuln/cmd/govulncheck` |
| Maven     | `mvn org.owasp:dependency-check-maven:check` |                                                         |

**Document findings:**

| Package | Vulnerability | Severity                 | CVE      | Patched Version | Action                         |
| ------- | ------------- | ------------------------ | -------- | --------------- | ------------------------------ |
| [name]  | [title]       | Critical/High/Medium/Low | [CVE-ID] | [version]       | Update / Replace / Accept Risk |

**Severity response times:**

| Severity | Action Required Within |
| -------- | ---------------------- |
| Critical | 24 hours               |
| High     | 1 week                 |
| Medium   | 1 month                |
| Low      | Next quarterly audit   |

### Step 3 — Assess Maintenance Status

A dependency with no vulnerabilities today can become one tomorrow if it's unmaintained.

**Health signals to check (per dependency):**

| Signal           | Healthy               | Concerning            | Unhealthy           |
| ---------------- | --------------------- | --------------------- | ------------------- |
| Last commit      | < 3 months            | 3-12 months           | > 12 months         |
| Last release     | < 6 months            | 6-18 months           | > 18 months         |
| Open issues      | Active triage         | Growing backlog       | Hundreds unanswered |
| Open PRs         | Reviewed regularly    | Stale PRs piling up   | No PR reviews       |
| Maintainer count | 2+ active             | 1 active (bus factor) | 0 active            |
| Downloads/month  | Stable or growing     | Declining             | Expired             |
| Funding          | Sponsored / corporate | Community only        | None                |

**Where to check:**

- GitHub repository → Insights → Contributors, Pulse
- npm: `npm info <package>` (last publish date)
- [Snyk Advisor](https://snyk.io/advisor/) — package health score
- [Socket.dev](https://socket.dev/) — supply chain risk
- [deps.dev](https://deps.dev/) — Google's dependency analysis

**Flag unmaintained packages:**

```markdown
## Maintenance Concerns

| Package | Last Release | Maintainers | Risk           | Alternative   |
| ------- | ------------ | ----------- | -------------- | ------------- |
| [name]  | [date]       | [count]     | [High/Med/Low] | [replacement] |
```

### Step 4 — Analyze Bundle Size Impact

For frontend projects, every dependency adds to what users download.

**Tools:**

| Tool                      | What It Shows                    | Command                                        |
| ------------------------- | -------------------------------- | ---------------------------------------------- |
| `source-map-explorer`     | Treemap of bundle contents       | `npx source-map-explorer build/static/js/*.js` |
| `webpack-bundle-analyzer` | Interactive bundle visualization | Add plugin to webpack config                   |
| `bundlephobia.com`        | Size of any npm package          | Search on website                              |
| `size-limit`              | CI-integrated size checking      | `npx size-limit`                               |
| `import-cost`             | VS Code extension — inline size  | Install extension                              |

**Size budget guidelines:**

| Metric                    | Target          | Notes                           |
| ------------------------- | --------------- | ------------------------------- |
| Total JS bundle (gzipped) | < 200 KB        | For initial page load           |
| Single dependency         | < 50 KB gzipped | Question anything larger        |
| CSS bundle                | < 50 KB gzipped |                                 |
| Largest dependency        | Document it     | Know what dominates your bundle |

**Identify heavy dependencies:**

```markdown
## Bundle Impact

| Package | Size (gzipped) | % of Bundle | Lighter Alternative     |
| ------- | -------------- | ----------- | ----------------------- |
| [name]  | [size]         | [%]         | [alternative or "none"] |
```

### Step 5 — Review Licenses

License incompatibility can force you to open-source your code or remove a dependency.

**License compatibility (for proprietary projects):**

| License                 | Commercial Use  | Conditions                                     | Risk     |
| ----------------------- | --------------- | ---------------------------------------------- | -------- |
| MIT                     | Yes             | Attribution                                    | None     |
| Apache 2.0              | Yes             | Attribution + patent grant                     | None     |
| BSD 2/3-Clause          | Yes             | Attribution                                    | None     |
| ISC                     | Yes             | Attribution                                    | None     |
| MPL 2.0                 | Yes             | Modified files must be shared                  | Low      |
| LGPL 2.1/3.0            | Yes (with care) | Dynamic linking OK, static may require sharing | Medium   |
| GPL 2.0/3.0             | Restricted      | Derivative work must use GPL                   | High     |
| AGPL 3.0                | Restricted      | Network use triggers sharing requirement       | High     |
| SSPL                    | Restricted      | Service use triggers sharing requirement       | High     |
| Unlicensed / No License | No              | No permission granted                          | Critical |

**Commands to check:**

| Ecosystem | Command                            |
| --------- | ---------------------------------- |
| npm       | `npx license-checker --summary`    |
| pip       | `pip-licenses`                     |
| mix       | `mix licenses` (with hex_licenses) |
| cargo     | `cargo license`                    |
| go        | `go-licenses check ./...`          |

**Flag problematic licenses:**

```markdown
## License Concerns

| Package | License   | Risk    | Action                            |
| ------- | --------- | ------- | --------------------------------- |
| [name]  | [license] | [level] | [Replace / Accept / Legal review] |
```

### Step 6 — Create Remediation Plan

Combine all findings into an actionable plan.

```markdown
## Dependency Audit Report

**Project**: [Name]
**Date**: [Date]
**Auditor**: [Name]

### Summary

| Category        | Issues Found  | Critical | Action Required        |
| --------------- | ------------- | -------- | ---------------------- |
| Vulnerabilities | [N]           | [N]      | Update / Replace       |
| Unmaintained    | [N]           | [N]      | Find alternatives      |
| Bundle impact   | [N] oversized | —        | Optimize / Replace     |
| License issues  | [N]           | [N]      | Replace / Legal review |

### Prioritized Actions

| Priority | Action                                        | Package | Risk if Ignored      | Effort |
| -------- | --------------------------------------------- | ------- | -------------------- | ------ |
| P1       | Patch critical CVE                            | [name]  | Exploitation         | S      |
| P2       | Replace unmaintained package                  | [name]  | Future vulnerability | M      |
| P3       | Swap heavy dependency for lighter alternative | [name]  | Bundle bloat         | M      |
| P4       | Resolve license concern                       | [name]  | Legal risk           | S      |

### Packages to Remove

| Package | Reason                                         | Replacement                    |
| ------- | ---------------------------------------------- | ------------------------------ |
| [name]  | [unused / duplicate / replaceable with stdlib] | [replacement or "none needed"] |

### Next Audit

Scheduled: [date — within 90 days]
```

## Common Rationalizations

| Rationalization                                                 | Reality                                                                                                                       |
| --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| "It's just a dev dependency, vulnerabilities don't matter"      | Supply chain attacks target dev tools (build scripts, linters). Dev dependencies run on your machine with your credentials.   |
| "We pin versions so we're safe"                                 | Pinning prevents unexpected updates but also prevents security patches. You still need to audit and update deliberately.      |
| "It's a popular package, it must be maintained"                 | Popular packages get abandoned too. Check the signals, not the star count.                                                    |
| "We need this dependency — there's no alternative"              | Almost every dependency has alternatives. If there truly isn't one, consider inlining the specific functionality you need.    |
| "License compliance is a legal problem, not an engineering one" | Engineers choose dependencies. If you add a GPL library to a proprietary project, legal can't fix that without a code change. |

## Red Flags

- Dependencies with known critical vulnerabilities that haven't been patched
- More than 3 dependencies with no commit in the past 12 months
- No lockfile committed to version control
- Transitive dependency count is 10x+ direct dependency count
- A dependency with a single maintainer and no corporate backing
- Packages with no license file (not MIT/Apache — literally no license)
- Bundle size has grown > 20% since last audit with no new features
- Dependencies pulled from unofficial registries or git URLs

## Verification

- [ ] Full dependency inventory completed (direct + transitive)
- [ ] Vulnerability scan run with package manager's audit tool
- [ ] Critical and high vulnerabilities have immediate action items
- [ ] Maintenance health assessed for all direct dependencies
- [ ] Bundle size impact analyzed (frontend projects)
- [ ] License compatibility verified for all direct dependencies
- [ ] Remediation plan created with priorities and effort estimates
- [ ] Next audit date scheduled (within 90 days)
