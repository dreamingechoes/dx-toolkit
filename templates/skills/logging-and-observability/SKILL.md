---
name: logging-and-observability
description: 'Set up structured logging, distributed tracing, and metrics dashboards. Covers the three pillars of observability for any tech stack.'
---

# Logging & Observability

## Overview

Observability tells you what your system is doing — and why it's misbehaving — without deploying new code. It rests on three pillars: **logs** (discrete events), **traces** (request paths across services), and **metrics** (aggregated measurements). Most teams start with logs, slap on metrics later, and never get tracing working. This skill sets up all three from the start so you're not reverse-engineering production failures.

Structured logging replaces "printf debugging in production" with queryable, machine-readable events. Distributed tracing connects the dots across service boundaries. Metrics give you the 10,000-foot view with dashboards and alerts. Together, they let you answer "is it broken?", "where is it broken?", and "why is it broken?" — in that order.

## When to Use

- Standing up a new service or microservice
- Replacing ad-hoc `console.log` / `Logger.info` with structured logging
- Debugging cross-service issues where requests span multiple systems
- Defining SLIs and SLOs for a service
- Setting up dashboards for an existing system that lacks visibility
- Preparing for production launch (observability is not optional)

**When NOT to use:** Quick prototypes or throwaway scripts where nobody will be on-call. If the code won't run in production, you don't need production observability.

## Process

### Step 1 — Define Logging Standards

Agree on a logging contract before writing a single log line.

**Log format — always JSON:**

```json
{
  "timestamp": "2025-01-15T10:23:45.123Z",
  "level": "error",
  "service": "order-service",
  "trace_id": "abc123def456",
  "span_id": "789ghi",
  "message": "Payment processing failed",
  "error": "TimeoutError: gateway did not respond within 5000ms",
  "context": {
    "order_id": "ord_42",
    "user_id": "usr_99",
    "amount_cents": 4999
  }
}
```

**Log level rules:**

| Level   | When to Use                                            | Example                                        |
| ------- | ------------------------------------------------------ | ---------------------------------------------- |
| `error` | Something failed and needs human attention             | Payment gateway timeout, database unreachable  |
| `warn`  | Something unexpected but handled — may need attention  | Retry succeeded after 2 attempts, cache miss   |
| `info`  | Normal operations worth recording                      | Request completed, user logged in, job started |
| `debug` | Detailed information for troubleshooting (off in prod) | SQL query executed, cache key checked          |

**Rules:**

- Never log PII (emails, passwords, tokens) — redact or hash
- Always include `trace_id` and `span_id` when available
- Use consistent field names across services (`user_id`, not `userId` in one and `user-id` in another)
- Log at the boundary, not inside every function

### Step 2 — Implement Structured Logging

Replace string-based logging with structured JSON output.

**Node.js (Pino):**

```typescript
import pino from 'pino'

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  formatters: {
    level: (label) => ({ level: label }),
  },
  timestamp: pino.stdTimeFunctions.isoTime,
  redact: ['req.headers.authorization', 'body.password'],
})

// Usage — pass context as first argument
logger.info({ orderId: 'ord_42', userId: 'usr_99' }, 'Order placed')
logger.error({ err, orderId: 'ord_42' }, 'Payment failed')
```

**Elixir (Logger with JSON formatter):**

```elixir
# config/config.exs
config :logger, :console,
  format: {MyApp.JSONFormatter, :format},
  metadata: [:request_id, :trace_id, :user_id]

# Attach metadata at the request boundary
Logger.metadata(request_id: conn.assigns[:request_id], user_id: current_user.id)
Logger.info("Order placed", order_id: order.id)
```

**Python (structlog):**

```python
import structlog

structlog.configure(
    processors=[
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.JSONRenderer(),
    ],
)

log = structlog.get_logger()
log.info("order_placed", order_id="ord_42", user_id="usr_99")
```

### Step 3 — Set Up Distributed Tracing

Tracing connects a single user request across every service it touches. Use OpenTelemetry — it's the vendor-neutral standard.

**Core concepts:**

- **Trace** — end-to-end journey of a request (one trace ID)
- **Span** — a single operation within a trace (has start/end time)
- **Context propagation** — passing trace/span IDs across service boundaries via HTTP headers (`traceparent`)

**Node.js (OpenTelemetry):**

```typescript
import { NodeSDK } from '@opentelemetry/sdk-node'
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-http'
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node'

const sdk = new NodeSDK({
  traceExporter: new OTLPTraceExporter({
    url: process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://localhost:4318/v1/traces',
  }),
  instrumentations: [getNodeAutoInstrumentations()],
  serviceName: 'order-service',
})

sdk.start()
```

**Correlation ID middleware:**

```typescript
import { context, trace } from '@opentelemetry/api'

function correlationMiddleware(req, res, next) {
  const span = trace.getActiveSpan()
  if (span) {
    const traceId = span.spanContext().traceId
    req.traceId = traceId
    res.setHeader('X-Trace-Id', traceId)
  }
  next()
}
```

### Step 4 — Define Key Metrics

Metrics answer "how is the system doing right now?" Pick metrics that map to user experience, not internal implementation details.

**The RED method (for request-driven services):**

| Metric       | What It Measures              | Example                                   |
| ------------ | ----------------------------- | ----------------------------------------- |
| **R**ate     | Requests per second           | `http_requests_total`                     |
| **E**rror    | Error rate (% of requests)    | `http_errors_total / http_requests_total` |
| **D**uration | Request latency (p50/p95/p99) | `http_request_duration_seconds`           |

**The USE method (for resources — CPU, memory, queues):**

| Metric          | What It Measures     | Example                    |
| --------------- | -------------------- | -------------------------- |
| **U**tilization | % of resource in use | `cpu_usage_percent`        |
| **S**aturation  | Queued work          | `thread_pool_queue_length` |
| **E**rrors      | Resource errors      | `disk_errors_total`        |

**Prometheus metrics example:**

```typescript
import { Counter, Histogram } from 'prom-client'

const httpRequestsTotal = new Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status'],
})

const httpRequestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route'],
  buckets: [0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5],
})
```

**Cardinality management** — the silent killer of metrics systems:

- Never use unbounded values as label values (user IDs, request IDs, email addresses)
- Keep label cardinality under ~100 unique values per label
- Use bucketed histograms instead of exact values

### Step 5 — Create Dashboards

Start with one overview dashboard per service. Add drill-down dashboards only when the overview isn't enough.

**Grafana dashboard layout:**

```
Row 1: Traffic Overview
  - Request rate (requests/sec)
  - Error rate (%)
  - Availability (% of non-5xx responses)

Row 2: Latency
  - p50 response time
  - p95 response time
  - p99 response time

Row 3: Resources
  - CPU usage
  - Memory usage
  - Active connections / thread pool

Row 4: Dependencies
  - Database query latency
  - External API latency
  - Cache hit rate
```

**Dashboard rules:**

- Every dashboard has a time range selector (default: last 1 hour)
- Every graph has clear titles, units, and thresholds
- Use red/yellow/green thresholds that match your SLOs
- No dashboard with more than 12 panels — create drill-downs instead

### Step 6 — Configure Alerts

Alerts tell you when SLOs are at risk. Bad alerts page people for things they can't act on.

**SLI → SLO → Alert chain:**

```
SLI: 99th percentile latency of /api/orders
SLO: p99 latency < 500ms, measured over 30-day rolling window
Error budget: 0.1% of requests can exceed 500ms
Alert: Fire when burn rate exceeds 10x (consuming 10% of budget in 1 hour)
```

**Alert rules:**

- Alert on symptoms (high error rate, slow responses), not causes (high CPU)
- Every alert must have a runbook link
- If an alert fires and nobody needs to act, delete it
- Use multi-window burn rate alerting to avoid flappy alerts

**Prometheus alert example:**

```yaml
groups:
  - name: order-service
    rules:
      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{service="order-service", status=~"5.."}[5m]))
          / sum(rate(http_requests_total{service="order-service"}[5m]))
          > 0.01
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: 'Error rate > 1% for order-service'
          runbook: 'https://wiki.internal/runbooks/order-service-errors'
```

### Step 7 — Verify

Confirm that all three pillars are working end-to-end.

**Verification checklist:**

1. Generate a test request → confirm JSON log appears in log aggregator
2. Trace the test request → confirm trace spans appear in Jaeger/Tempo/your trace backend
3. Check the dashboard → confirm the request shows in the rate/latency graphs
4. Trigger a failure → confirm the alert fires within the expected window
5. Search the trace by trace ID → confirm you can follow the request across services

## Common Rationalizations

| Rationalization                                | Reality                                                                                                   |
| ---------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| "We'll add observability later"                | Later means after the first production incident when you have zero visibility. Set it up now.             |
| "Logs are enough — we don't need tracing"      | Logs tell you something happened. Tracing tells you where in the chain it happened. Both are necessary.   |
| "We can just grep the logs"                    | Grepping works for one server. With 5+ instances, you need structured logs and a log aggregator.          |
| "Metrics add overhead"                         | Prometheus-style metrics add microseconds of overhead. The cost of not having them is hours of debugging. |
| "We'll use DEBUG level everywhere to be safe"  | DEBUG in production generates noise that drowns out real signals and inflates storage costs.              |
| "Let's track everything — more data is better" | High-cardinality metrics blow up your metrics backend. Track what matters, not everything.                |

## Red Flags

- String interpolation in log messages instead of structured fields
- Log levels used inconsistently (INFO for errors, DEBUG in production)
- No correlation ID / trace ID connecting logs across services
- Metrics with unbounded label cardinality (user IDs, UUIDs as labels)
- Dashboards that nobody looks at — or that have been "coming soon" for months
- Alerts that fire constantly and get ignored (alert fatigue)
- PII showing up in logs (emails, tokens, passwords)

## Verification

- [ ] All services emit structured JSON logs with consistent field names
- [ ] Log levels follow the agreed standard (error/warn/info/debug)
- [ ] PII is redacted or excluded from all log output
- [ ] Every log line includes `trace_id` when tracing is active
- [ ] Distributed tracing is configured with OpenTelemetry (or equivalent)
- [ ] Context propagation works across service boundaries (test with a multi-service request)
- [ ] RED metrics (rate, error, duration) are exposed for every request-driven service
- [ ] Metric label cardinality is bounded (no user IDs or UUIDs as labels)
- [ ] At least one dashboard exists per service with traffic, latency, errors, and resources
- [ ] Alerts are defined for SLO violations with runbook links
- [ ] A test request can be traced from ingress to response through all services
