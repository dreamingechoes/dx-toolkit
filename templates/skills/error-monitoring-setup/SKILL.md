---
name: error-monitoring-setup
description: 'Set up error monitoring and alerting with structured logging. Covers Sentry, Datadog, and custom solutions. Language-agnostic setup procedure.'
---

# Error Monitoring Setup

## Overview

Error monitoring answers two questions: "Is something broken?" and "What exactly broke?" Without it, you learn about production errors from users — and users notice far fewer errors than actually occur. With it, you get notified before users complain, with enough context to fix the problem.

This skill covers end-to-end setup: choosing a tool, installing the SDK, configuring error capture, adding structured logging, setting up alerts, and verifying the pipeline works. The goal is zero surprises in production.

## When to Use

- Setting up a new project for production deployment
- Migrating from one monitoring tool to another
- Current monitoring generates too many alerts (alert fatigue) or misses real issues
- After a production incident where errors were not detected quickly enough
- Adding monitoring to a project that currently has none
- Setting up structured logging for the first time

**When NOT to use:** Debugging a specific error in development. Use your debugger and local logs for that. This skill is for production monitoring infrastructure.

## Process

### Step 1 — Choose a Monitoring Tool

Pick based on your team size, budget, and existing infrastructure.

**Tool comparison:**

| Feature                | Sentry                | Datadog            | Grafana + Loki   | Custom (ELK)     |
| ---------------------- | --------------------- | ------------------ | ---------------- | ---------------- |
| Error tracking         | Excellent             | Good               | Basic            | DIY              |
| Performance monitoring | Good                  | Excellent          | Good             | DIY              |
| Log management         | Basic                 | Excellent          | Excellent        | Excellent        |
| Alerting               | Good                  | Excellent          | Good             | Good             |
| Source maps            | Built-in              | Manual             | Manual           | Manual           |
| Pricing                | Free tier + per-event | Per host           | Free (self-host) | Free (self-host) |
| Setup effort           | Low                   | Medium             | Medium           | High             |
| Best for               | Error tracking focus  | Full observability | Budget-conscious | Full control     |

**Decision criteria:**

```markdown
## Monitoring Tool Decision

Primary need: [Error tracking / Full observability / Log analysis]
Budget: [Free / $X per month]
Team size: [N engineers]
Existing tools: [list]

Selected tool: [choice]
Reason: [one sentence]
```

For most teams starting out: **Sentry for errors + structured logging to stdout** is the simplest effective setup.

### Step 2 — Install the SDK

Install and configure the monitoring SDK in your application.

**Configuration template (adapt for your tool and language):**

```
// Pseudo-code — adapt to your SDK
monitoring.init({
  dsn: ENV["SENTRY_DSN"],           // or equivalent connection string
  environment: ENV["APP_ENV"],       // production, staging, development
  release: ENV["APP_VERSION"],       // git SHA or semver tag
  sampleRate: 1.0,                   // capture 100% of errors
  tracesSampleRate: 0.1,             // sample 10% of transactions for performance
  beforeSend: function(event) {
    return scrubPII(event)           // remove sensitive data before sending
  }
})
```

**SDK configuration checklist:**

- [ ] DSN / API key loaded from environment variable (never hardcoded)
- [ ] Environment tag set (production, staging, development)
- [ ] Release version set (ties errors to specific deployments)
- [ ] Sample rate configured (100% for errors, 1-20% for performance)
- [ ] PII scrubbing enabled before any data leaves the application
- [ ] SDK only initialized in non-test environments

### Step 3 — Configure Error Capture

Not all errors are equal. Configure what gets captured and how it's grouped.

**Error levels:**

| Level   | When to Use                          | Alerts?        | Examples                                               |
| ------- | ------------------------------------ | -------------- | ------------------------------------------------------ |
| Fatal   | Application cannot continue          | Immediate page | Unhandled exception, OOM, database connection lost     |
| Error   | Operation failed, user impacted      | Within 5 min   | Payment failed, auth error, API 500                    |
| Warning | Recoverable issue, potential problem | Daily digest   | Retry succeeded, deprecated API called, slow query     |
| Info    | Normal operation worth noting        | Never          | User login, feature flag toggled, deployment completed |

**Error grouping strategy:**

Configure your tool to group errors by root cause, not by message text.

```
Good grouping (by error class + location):
  "PaymentError in checkout/process.js:42" — 847 occurrences

Bad grouping (by message text):
  "Payment failed for user 12345" — 1 occurrence
  "Payment failed for user 12346" — 1 occurrence
  (same bug, 847 "unique" errors)
```

**Breadcrumbs** — context trail leading to the error:

```
Configure automatic breadcrumbs:
  - HTTP requests (method, URL, status — NOT body)
  - Database queries (query pattern — NOT parameters)
  - User navigation (page visited — NOT form data)
  - Console logs (last 20 entries)
  - UI interactions (button clicked, form submitted)
```

### Step 4 — Set Up Structured Logging

Logs should be machine-parseable and human-readable. Use structured (JSON) logging.

**Log format:**

```json
{
  "timestamp": "2025-01-15T10:23:45.123Z",
  "level": "error",
  "message": "Payment processing failed",
  "service": "checkout-api",
  "environment": "production",
  "request_id": "req_abc123",
  "user_id": "usr_789",
  "error": {
    "type": "StripeCardError",
    "message": "Card declined",
    "code": "card_declined"
  },
  "context": {
    "payment_method": "card",
    "amount_cents": 4999,
    "currency": "usd"
  }
}
```

**Structured logging rules:**

| Rule                                           | Why                                                                                                       |
| ---------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Use consistent field names across services     | `user_id` everywhere, not `userId` in one and `user` in another                                           |
| Include `request_id` in every log line         | Correlate all logs from a single request                                                                  |
| Log at the boundary (controller/handler level) | Don't scatter logs deep in business logic                                                                 |
| Never log PII in plain text                    | No emails, passwords, tokens, credit cards, SSNs                                                          |
| Use log levels correctly                       | Error = something failed. Warning = something might fail. Info = notable event. Debug = development only. |
| Include relevant IDs, not full objects         | `{ user_id: "123" }` not `{ user: { name: "...", email: "...", ... } }`                                   |

**What to log at each level:**

| Level   | Log These Events                                                             |
| ------- | ---------------------------------------------------------------------------- |
| Error   | Unhandled exceptions, failed operations, external service failures           |
| Warning | Retries, deprecated usage, approaching limits, slow operations               |
| Info    | Request start/end, authentication events, configuration changes, deployments |
| Debug   | Detailed execution flow (disabled in production)                             |

### Step 5 — Define Alert Rules

Alerts should wake you up for real problems and stay quiet otherwise.

**Alert design principles:**

1. **Every alert must be actionable** — if you can't do anything about it, it's not an alert
2. **Alert on symptoms, not causes** — "error rate > 5%" not "database connection count > 50"
3. **Use thresholds, not individual events** — "5 errors in 1 minute" not "1 error occurred"
4. **Reduce noise aggressively** — alert fatigue is worse than missing an occasional issue

**Recommended alert rules:**

| Alert               | Condition                                   | Severity | Channel             |
| ------------------- | ------------------------------------------- | -------- | ------------------- |
| Error rate spike    | Error rate > 2x baseline for 5 min          | Critical | PagerDuty / on-call |
| New error type      | First occurrence of error never seen before | High     | Slack / Teams       |
| P95 latency spike   | P95 > 2x baseline for 10 min                | High     | Slack / Teams       |
| Error budget burn   | > 50% of monthly error budget consumed      | Medium   | Email digest        |
| Uptime check failed | Health endpoint returns non-200 for 2 min   | Critical | PagerDuty / on-call |

**Alert routing:**

```markdown
## Alert Routing

| Severity | Channel                      | Response Time     | Escalation             |
| -------- | ---------------------------- | ----------------- | ---------------------- |
| Critical | PagerDuty → on-call engineer | 15 minutes        | Team lead after 30 min |
| High     | Slack #alerts channel        | 1 hour            | On-call after 2 hours  |
| Medium   | Email digest (daily)         | Next business day | —                      |
| Low      | Monitoring dashboard only    | Next audit        | —                      |
```

### Step 6 — Configure Source Maps and Release Tracking

Minified stack traces are useless. Upload source maps so errors point to your actual source code.

**Source map upload (per tool):**

| Tool    | Method                                                        |
| ------- | ------------------------------------------------------------- |
| Sentry  | `sentry-cli releases files upload-sourcemaps` or build plugin |
| Datadog | `datadog-ci sourcemaps upload`                                |
| Custom  | Serve source maps privately, never publicly                   |

**Release tracking setup:**

```
// Tag each deployment with a release identifier
monitoring.setRelease(gitSha)

// After deploying, notify the monitoring tool
monitoring.notifyDeploy({
  release: gitSha,
  environment: "production",
  deployedBy: deployUser
})
```

**Benefits of release tracking:**

- See which deploy introduced a new error
- Track error count per release
- Automatically resolve errors fixed in a new release
- Correlate performance changes with deployments

### Step 7 — Verify End-to-End

Test the entire pipeline before relying on it.

**Verification procedure:**

1. **Trigger a test error in staging:**

   ```
   // Add a temporary endpoint or command
   throw new Error("Monitoring test — verify this appears in [tool]")
   ```

2. **Verify the error appears in your monitoring tool:**
   - [ ] Error captured with correct severity
   - [ ] Stack trace points to correct source file and line
   - [ ] Environment tag is correct
   - [ ] Release version is correct
   - [ ] Breadcrumbs show context leading to error
   - [ ] User context attached (if applicable)
   - [ ] PII is scrubbed (no emails, tokens, or passwords visible)

3. **Verify alerting:**
   - [ ] Alert fires within expected timeframe
   - [ ] Alert reaches the correct channel (Slack, PagerDuty, email)
   - [ ] Alert contains enough context to start debugging
   - [ ] Alert resolves when error stops occurring

4. **Verify structured logging:**
   - [ ] Logs appear in log aggregation tool
   - [ ] Logs are JSON-parseable
   - [ ] `request_id` correlates across log lines
   - [ ] Log levels are correct
   - [ ] No PII in log output

**Produce setup documentation:**

```markdown
## Error Monitoring Setup

**Tool**: [Sentry / Datadog / Other]
**Dashboard**: [URL]
**Alert channel**: [Slack channel / PagerDuty service]

### Configuration

- SDK: [package name and version]
- DSN: Stored in ENV `[VAR_NAME]`
- Sample rate: Errors [X%], Transactions [X%]
- Source maps: [Upload method]

### Alert Rules

| Alert  | Condition   | Channel   |
| ------ | ----------- | --------- |
| [name] | [condition] | [channel] |

### On-Call Rotation

[Link to rotation schedule]

### Runbook

When an alert fires:

1. Check the error in [tool dashboard URL]
2. Identify affected users and scope
3. Check recent deployments for correlation
4. Follow incident response process in [link]
```

## Common Rationalizations

| Rationalization                                | Reality                                                                                                                   |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| "We'll add monitoring after launch"            | Launch is when you need monitoring most. Set it up before the first deploy.                                               |
| "Logs are enough"                              | Logs tell you what happened. Error monitoring tells you something is wrong and alerts you proactively. You need both.     |
| "We capture every error — thorough monitoring" | Capturing everything creates noise. Alerting on everything creates fatigue. Be selective about what wakes you up at 3 AM. |
| "Users will report bugs"                       | Users report ~1% of errors they encounter. The other 99% silently churn.                                                  |
| "We don't need source maps in production"      | Without source maps, your stack trace reads `a.js:1:47382`. That's not debuggable.                                        |

## Red Flags

- Monitoring DSN or API key hardcoded in source code
- No PII scrubbing configured (emails, passwords, tokens in error reports)
- Alert on every single error event (alert fatigue guaranteed)
- No source maps uploaded (stack traces show minified code)
- No release tracking (can't correlate errors with deployments)
- Logging full request/response bodies (PII risk + storage cost)
- Debug logging enabled in production (noise + performance impact)
- No test error triggered to verify the pipeline works

## Verification

- [ ] Monitoring SDK installed and configured with environment variables
- [ ] Error capture tested with a deliberate test error in staging
- [ ] Stack traces resolve to correct source files and lines
- [ ] Structured logging produces machine-parseable JSON output
- [ ] PII scrubbing verified — no sensitive data in captured errors or logs
- [ ] Alert rules configured for error rate spikes and new error types
- [ ] Alerts tested and verified to reach the correct channel
- [ ] Source maps uploaded and verified for production builds
- [ ] Release tracking configured and tied to deployment pipeline
- [ ] On-call rotation and escalation path documented
