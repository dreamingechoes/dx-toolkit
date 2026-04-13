---
description: 'Set up structured logging for the project. Configures log format, levels, context, and integrations with monitoring tools.'
agent: 'agent'
---

Set up structured logging for this project.

## Procedure

1. **Detect the tech stack**: Language, framework, existing logging setup
2. **Choose logging library** if none exists:
   - Node.js: pino (recommended) or winston
   - Python: structlog or python-json-logger
   - Go: slog (stdlib) or zerolog
   - Elixir: Logger with JSON formatter
   - Ruby: Semantic Logger or Lograge (Rails)
3. **Configure structured format**:
   - JSON output in production, pretty-print in development
   - Standard fields: timestamp, level, message, service, request_id
   - Request context: method, path, status, duration, user_id
   - Error context: error type, message, stack trace
4. **Add correlation IDs**: Generate or propagate request IDs across service boundaries
5. **Set log levels**: Define what goes at each level (debug, info, warn, error)
6. **Add sensitive data filtering**: Redact passwords, tokens, PII from logs

## Log Level Guide

| Level   | Use For                                | Example                                             |
| ------- | -------------------------------------- | --------------------------------------------------- |
| `error` | Failures requiring immediate attention | Database connection lost, payment failed            |
| `warn`  | Degraded but functional                | Rate limit approaching, deprecated API used         |
| `info`  | Business events                        | User signed up, order placed, deploy completed      |
| `debug` | Development details                    | SQL queries, cache hits/misses, function entry/exit |

## Rules

- Never log passwords, tokens, API keys, or PII
- Always include correlation/request IDs for tracing
- Use structured fields, not string interpolation: `{ userId: 123 }` not `"User 123"`
- Set `error` level for production, `debug` for development
- Log at request boundaries (start + end), not inside every function
