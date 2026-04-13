# Architecture Patterns Reference

Quick-reference for system architecture patterns, trade-offs, and decision criteria. Skills and prompts reference this when needed.

## Architecture Styles

### Modular Monolith

```
┌─────────────────────────────────────┐
│              Monolith               │
│  ┌─────────┐ ┌─────────┐ ┌──────┐  │
│  │ Billing │ │  Users  │ │Orders│  │
│  │ Module  │ │ Module  │ │Module│  │
│  └────┬────┘ └────┬────┘ └──┬───┘  │
│       └───────────┼─────────┘      │
│            Shared Database          │
└─────────────────────────────────────┘
```

- **Best for:** 1-5 dev teams, clear domain boundaries, single deployment
- **Pros:** Simple operations, refactor-friendly, shared transactions
- **Cons:** Scales as one unit, shared DB can create coupling

### Microservices

```
┌─────────┐  ┌─────────┐  ┌─────────┐
│ Billing │  │  Users  │  │ Orders  │
│ Service │  │ Service │  │ Service │
│   (DB)  │  │   (DB)  │  │   (DB)  │
└────┬────┘  └────┬────┘  └────┬────┘
     └──────────┬──────────────┘
           API Gateway / Mesh
```

- **Best for:** 5+ teams, independent deployment, polyglot tech
- **Pros:** Scale independently, team autonomy, fault isolation
- **Cons:** Network complexity, distributed transactions, operational overhead

### Event-Driven

```
Producer → [Event Bus] → Consumer A
                      → Consumer B
                      → Consumer C
```

- **Best for:** Async workflows, decoupled components, audit trails
- **Pros:** Loose coupling, scalable consumers, natural audit log
- **Cons:** Eventual consistency, debugging across events, message ordering

### Serverless

- **Best for:** Sporadic workloads, quick prototypes, event-triggered tasks
- **Pros:** Zero idle cost, auto-scaling, no server management
- **Cons:** Cold starts, vendor lock-in, limited execution time

## Decision Criteria

| Factor                | Monolith  | Modular Monolith | Microservices | Serverless |
| --------------------- | --------- | ---------------- | ------------- | ---------- |
| Team size             | 1-3       | 2-5              | 5+            | Any        |
| Deployment complexity | Low       | Low              | High          | Medium     |
| Operational cost      | Low       | Low              | High          | Variable   |
| Independent scaling   | No        | No               | Yes           | Yes        |
| Technology freedom    | No        | Limited          | Full          | Limited    |
| Transaction support   | Full ACID | Full ACID        | Saga/eventual | Limited    |
| Time to first deploy  | Fast      | Fast             | Slow          | Fast       |

## Migration Patterns

### Strangler Fig

Gradually replace parts of a monolith by routing traffic to new services:

1. Identify a bounded context to extract
2. Build the new service alongside the monolith
3. Route traffic to the new service (feature flag or proxy)
4. Remove the old code once fully migrated

### Branch by Abstraction

Introduce an abstraction layer, swap implementation behind it:

1. Create interface/protocol for the component to extract
2. Implement the interface with the existing code
3. Build new implementation (new service/module)
4. Switch to new implementation
5. Remove old implementation

### Database Decomposition

Split a shared database into service-owned databases:

1. Identify which tables belong to which service
2. Add API endpoints/events for cross-service data access
3. Stop direct cross-service table access
4. Physically separate databases

## Communication Patterns

| Pattern            | Coupling  | Latency  | Reliability | Use When                      |
| ------------------ | --------- | -------- | ----------- | ----------------------------- |
| Sync HTTP/gRPC     | High      | Low      | Medium      | Request-response, real-time   |
| Async messaging    | Low       | Higher   | High        | Fire-and-forget, workflows    |
| Event streaming    | Low       | Variable | High        | Real-time feeds, audit        |
| GraphQL federation | Medium    | Low      | Medium      | Unified API, multiple sources |
| Shared database    | Very High | Lowest   | High        | Avoid if possible             |

## Scaling Patterns

| Pattern                | Description                               | Use When                        |
| ---------------------- | ----------------------------------------- | ------------------------------- |
| **Horizontal scaling** | Add more instances behind a load balancer | Stateless services              |
| **Vertical scaling**   | Bigger machine                            | Databases, legacy systems       |
| **CQRS**               | Separate read and write models            | Read-heavy with complex queries |
| **Read replicas**      | Database replicas for read traffic        | Read-heavy workloads            |
| **Caching**            | Redis/Memcached for hot data              | Repeated reads of stable data   |
| **Sharding**           | Split data across databases by key        | Very large datasets             |
| **CDN**                | Edge caching for static assets            | Global audience, static content |

## Quality Attribute Assessment

Rate each 1-5 with evidence:

```
Attribute        1 (Critical)    3 (Adequate)    5 (Excellent)
─────────────────────────────────────────────────────────────
Scalability      Single server    Manual scaling   Auto-scaling
Reliability      No redundancy    Basic HA         Multi-region
Maintainability  Spaghetti code   Some modules     Clean boundaries
Observability    No monitoring    Basic logs       Logs+metrics+traces
Security         No auth          Basic auth       Zero-trust
Performance      >5s responses    <1s typical      <100ms p99
Operability      Manual deploys   CI/CD partial    Full GitOps
```

## Anti-Patterns

| Anti-Pattern                   | Symptom                                | Fix                                                              |
| ------------------------------ | -------------------------------------- | ---------------------------------------------------------------- |
| **Distributed monolith**       | All services deploy together           | Define clear contracts, deploy independently                     |
| **Shared database**            | Multiple services write to same tables | Split ownership, use events for cross-service data               |
| **Chatty services**            | 20+ API calls per user request         | Aggregate at the gateway, use batch APIs                         |
| **Big ball of mud**            | No clear module boundaries             | Identify domains, enforce boundaries with interfaces             |
| **Golden hammer**              | Same architecture for everything       | Match pattern to problem (not every problem needs microservices) |
| **Resume-driven architecture** | Choosing tech for career growth        | Use the simplest thing that works                                |
