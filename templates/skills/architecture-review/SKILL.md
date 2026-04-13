---
name: architecture-review
description: 'Assess system architecture, identify risks and bottlenecks, document decisions with ADRs. Covers modular monolith, microservices, event-driven, and serverless patterns.'
---

# Architecture Review

## Overview

Evaluate a system's architecture — its strengths, risks, and evolution options. This skill produces an architecture assessment document and (optionally) Architecture Decision Records (ADRs) for any recommended changes.

## When to Use

- Before a major feature that changes system boundaries
- When performance, reliability, or scalability concerns emerge
- During periodic health checks (quarterly reviews)
- When evaluating a migration (monolith → services, on-prem → cloud)
- When onboarding to an unfamiliar system

**When NOT to use:** Routine code changes that don't affect system boundaries or data flow.

## Process

### Step 1 — Map the Current Architecture

Identify and document:

- **Components**: Services, databases, queues, caches, CDNs, third-party APIs
- **Communication**: Sync (HTTP/gRPC) vs async (queues/events), data formats
- **Data flow**: Where data enters, how it transforms, where it persists
- **Deployment**: How components deploy (containers, serverless, VMs)
- **Boundaries**: What code belongs together, what crosses service/module lines

**Output:** Architecture diagram (boxes + arrows) or structured list.

### Step 2 — Assess Quality Attributes

Rate each on a 1-5 scale with evidence:

| Attribute           | Questions to Ask                                                            |
| ------------------- | --------------------------------------------------------------------------- |
| **Scalability**     | Can each component scale independently? Are there shared bottlenecks?       |
| **Reliability**     | What happens when component X fails? Are there single points of failure?    |
| **Maintainability** | Can a team change one component without coordinating with others?           |
| **Observability**   | Can you tell what's happening in production? Logs, metrics, traces?         |
| **Security**        | Are boundaries enforced? Are secrets managed properly? Is auth centralized? |
| **Performance**     | Where are the latency hotspots? Are there N+1 queries or chatty APIs?       |
| **Operability**     | How hard is it to deploy, rollback, debug in production?                    |

### Step 3 — Identify Risks and Technical Debt

Look for:

- **Coupling hotspots** — Components that always change together (should they merge?)
- **Distributed monolith** — Microservices that can't deploy independently
- **Missing boundaries** — Code that reaches across domains without an interface
- **Data ownership conflicts** — Multiple services writing to the same table
- **Scaling cliffs** — Components that work at current load but break at 2-10x
- **Unmonitored dependencies** — Third-party services with no fallback or circuit breaker

### Step 4 — Evaluate Architecture Patterns

Choose based on team size, complexity, and operational maturity:

| Pattern              | Best For                                              | Team Size | Operational Cost  |
| -------------------- | ----------------------------------------------------- | --------- | ----------------- |
| **Modular monolith** | Clear domains, single deployment                      | 1-5 teams | Low               |
| **Microservices**    | Independent deployment, polyglot                      | 5+ teams  | High              |
| **Event-driven**     | Async workflows, decoupled producers/consumers        | 3+ teams  | Medium            |
| **Serverless**       | Sporadic workloads, rapid prototyping                 | Any       | Low (until scale) |
| **Hybrid**           | Monolith core + extracted services for specific needs | 2-5 teams | Medium            |

**Decision framework:**

1. Start with the simplest architecture that meets requirements
2. Extract only when there's a proven need (scaling, team autonomy, technology mismatch)
3. Prefer modular monolith → extract services over starting with microservices
4. Factor in operational maturity — microservices need strong CI/CD, observability, and on-call

### Step 5 — Write Recommendations

For each recommendation:

1. **What** — The specific change
2. **Why** — The risk or limitation it addresses (reference Step 2-3 findings)
3. **Trade-offs** — What you gain vs what it costs
4. **Priority** — Critical / High / Medium / Low
5. **Effort** — T-shirt size (S/M/L/XL)

### Step 6 — Document Decisions as ADRs

For each significant decision, write an ADR:

```markdown
# ADR-NNN: [Title]

## Status

Proposed | Accepted | Deprecated | Superseded by ADR-XXX

## Context

What is the problem or situation that requires a decision?

## Decision

What is the change we're making?

## Consequences

### Positive

- [What improves]

### Negative

- [What gets harder or more expensive]

### Neutral

- [What changes but isn't clearly better or worse]
```

Store ADRs in `docs/adr/` or `docs/decisions/` — number them sequentially.

### Step 7 — Verify

- [ ] Current architecture is documented (diagram or structured list)
- [ ] Quality attributes are assessed with evidence, not opinions
- [ ] Risks are ranked by impact × likelihood
- [ ] Recommendations include trade-offs, not just "you should do X"
- [ ] ADRs are written for any decisions made
- [ ] No recommendation requires a rewrite — prefer incremental migration

## Common Rationalizations

| Rationalization                  | Reality                                                                                       |
| -------------------------------- | --------------------------------------------------------------------------------------------- |
| "We need microservices to scale" | Most apps never outgrow a well-structured monolith. Netflix's scale is not your scale.        |
| "This is too big to change"      | The strangler fig pattern lets you migrate incrementally. You don't need a rewrite.           |
| "We'll refactor later"           | Later never comes. Extract a clean boundary now, even if the module stays in the monolith.    |
| "Event-driven will decouple us"  | Events without clear ownership create invisible coupling. Define schemas and contracts first. |

## Red Flags

- Architecture diagrams that haven't been updated in 6+ months
- "We deploy everything together" for a system with 10+ services
- No ADRs or documented decisions — everything is tribal knowledge
- Services that share a database without clear ownership boundaries
- Latency spikes traced to synchronous call chains across 5+ services
