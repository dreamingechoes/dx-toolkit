# Observability Checklist Reference

Quick-reference for the three pillars of observability: logging, metrics, and tracing. Skills reference this when needed.

## Logging

### Structured Format

- [ ] JSON format in production (machine-parseable)
- [ ] Human-readable format in development (pretty-print)
- [ ] Consistent field names across all services:
  - `timestamp` (ISO 8601)
  - `level` (error, warn, info, debug)
  - `message` (human-readable description)
  - `service` (service name)
  - `request_id` (correlation ID)
  - `trace_id` (distributed tracing)

### Log Levels

| Level   | When to Use                         | Example                                         |
| ------- | ----------------------------------- | ----------------------------------------------- |
| `error` | Something failed, needs attention   | DB connection lost, payment failed              |
| `warn`  | Degraded but functional             | Rate limit approaching, deprecated API call     |
| `info`  | Business events                     | User signed up, order completed, deploy started |
| `debug` | Development/troubleshooting details | SQL query, cache hit/miss, function params      |

### Checklist

- [ ] Correlation IDs propagate across all services
- [ ] No PII (passwords, tokens, SSN, email) in logs
- [ ] Error logs include stack trace and context
- [ ] Request/response logging at API boundaries (with body size limit)
- [ ] Log retention policy configured (30-90 days typical)
- [ ] Log volume alerts to detect logging storms
- [ ] Searchable via centralized logging tool (ELK, Loki, CloudWatch, Datadog)

## Metrics

### Four Golden Signals

| Signal         | What to Measure        | Example Metric                            |
| -------------- | ---------------------- | ----------------------------------------- |
| **Latency**    | Time to serve requests | `http_request_duration_seconds`           |
| **Traffic**    | Request volume         | `http_requests_total`                     |
| **Errors**     | Failed request rate    | `http_requests_errors_total`              |
| **Saturation** | Resource utilization   | `cpu_usage_percent`, `memory_usage_bytes` |

### RED Method (Request-focused)

- **R**ate: requests per second
- **E**rrors: error rate (errors/total)
- **D**uration: latency distribution (p50, p95, p99)

### USE Method (Resource-focused)

- **U**tilization: % of resource capacity used
- **S**aturation: amount of queued work
- **E**rrors: error events from the resource

### Checklist

- [ ] Prometheus/StatsD/OTLP metrics endpoint exposed
- [ ] HTTP request duration histogram with labels (method, path, status)
- [ ] Error rate by endpoint
- [ ] Database query duration
- [ ] Cache hit/miss ratio
- [ ] Queue depth and processing time
- [ ] Custom business metrics (signups, orders, revenue)
- [ ] Cardinality managed (no user IDs or unbounded labels)

## Tracing

### Distributed Tracing

- [ ] OpenTelemetry SDK integrated
- [ ] Trace context propagated across HTTP/gRPC/message boundaries
- [ ] Key spans created for:
  - Incoming HTTP/gRPC requests
  - Outgoing HTTP/gRPC calls
  - Database queries
  - Cache operations
  - Message queue produce/consume
  - External API calls
- [ ] Span attributes include relevant context (user_id, order_id)
- [ ] Error spans marked with status and error message
- [ ] Sampling rate configured (100% in dev, 1-10% in production)
- [ ] Traces exported to backend (Jaeger, Zipkin, Tempo, Datadog, Honeycomb)

### Trace Anatomy

```
[API Gateway] ──────────────────────────────── 200ms
  └─[Auth Service] ─────────────── 30ms
  └─[User Service] ────────────────────── 80ms
      └─[PostgreSQL Query] ──────── 15ms
      └─[Redis Cache] ─── 2ms
  └─[Email Service (async)] ───────── (fire-and-forget)
```

## Alerting

### SLI/SLO Framework

| SLI (Indicator)      | SLO (Objective)    | Alert Threshold        |
| -------------------- | ------------------ | ---------------------- |
| Request success rate | 99.9% over 30 days | < 99.5% over 5 minutes |
| p95 latency          | < 500ms            | > 1000ms for 5 minutes |
| Error rate           | < 0.1%             | > 1% for 5 minutes     |

### Alert Design

- [ ] Every alert has a runbook or link to documentation
- [ ] Alerts have severity levels (critical, warning, info)
- [ ] Critical alerts page on-call; warnings create tickets
- [ ] Alert fatigue monitored: if an alert fires > 5x/week without action, fix or remove it
- [ ] Alerts test a symptom (user impact), not a cause (CPU spike)

### Checklist

- [ ] Health check endpoint (`/health` or `/healthz`) for liveness
- [ ] Readiness endpoint (`/ready`) for load balancer routing
- [ ] Uptime monitoring from external probe (Pingdom, Uptime Robot)
- [ ] Error rate alerts with burn-rate based windows
- [ ] Latency alerts on p95/p99 (not average)
- [ ] Resource alerts: disk space > 80%, memory > 90%
- [ ] On-call rotation configured with escalation policy
- [ ] Incident notification channels (Slack, PagerDuty, Opsgenie)

## Dashboards

### Service Dashboard (per service)

- Request rate (req/s)
- Error rate (%)
- Latency distribution (p50, p95, p99)
- Active connections
- CPU and memory usage

### Business Dashboard

- Sign-ups per hour
- Orders processed
- Revenue (if applicable)
- Feature flag adoption rates
- Error counts by feature area

### Infrastructure Dashboard

- Node count and health
- Database connections (active, idle, max)
- Cache hit ratio
- Queue depth and consumer lag
- Disk I/O and network throughput

## Tool Recommendations

| Category   | Tools                                                    |
| ---------- | -------------------------------------------------------- |
| Logging    | ELK Stack, Grafana Loki, Datadog Logs, CloudWatch Logs   |
| Metrics    | Prometheus + Grafana, Datadog, CloudWatch Metrics        |
| Tracing    | Jaeger, Grafana Tempo, Datadog APM, Honeycomb            |
| All-in-one | Datadog, New Relic, Grafana Cloud, Elastic Observability |
| Alerting   | PagerDuty, Opsgenie, Grafana Alerting, Datadog Monitors  |
| Uptime     | Pingdom, Uptime Robot, Better Uptime, Checkly            |
