# Error Handling Patterns Reference

Quick-reference for error handling patterns across languages and architectures. Skills reference this when needed.

## Principles

1. **Fail fast, fail loud**: Detect errors early and surface them immediately
2. **Handle at the right level**: Catch where you can meaningfully recover or add context
3. **Don't swallow errors**: Every catch block must log, re-throw, or return an error
4. **User errors ≠ system errors**: Validation failures are expected; crashes are not
5. **Errors are data**: Use typed errors for control flow, not exceptions for everything

## Language-Specific Patterns

### TypeScript / JavaScript

```typescript
// Custom error classes for domain errors
class NotFoundError extends Error {
  constructor(resource: string, id: string) {
    super(`${resource} ${id} not found`)
    this.name = 'NotFoundError'
  }
}

// Result pattern (for expected failures)
type Result<T, E = Error> = { ok: true; value: T } | { ok: false; error: E }

// Never catch without handling
try {
  await doSomething()
} catch (error) {
  logger.error('doSomething failed', { error })
  throw error // re-throw if you can't recover
}
```

### Python

```python
# Custom exceptions for domain errors
class NotFoundError(Exception):
    def __init__(self, resource: str, id: str):
        super().__init__(f"{resource} {id} not found")
        self.resource = resource
        self.id = id

# Specific except clauses (never bare except)
try:
    result = do_something()
except ValueError as e:
    logger.warning("Invalid input", exc_info=e)
    raise
except ConnectionError as e:
    logger.error("Service unavailable", exc_info=e)
    return fallback_value
```

### Go

```go
// Wrap errors with context
if err != nil {
    return fmt.Errorf("failed to create user %s: %w", name, err)
}

// Sentinel errors for expected conditions
var ErrNotFound = errors.New("not found")

if errors.Is(err, ErrNotFound) {
    return nil, status.NotFound
}

// Custom error types for rich context
type ValidationError struct {
    Field   string
    Message string
}
func (e *ValidationError) Error() string {
    return fmt.Sprintf("%s: %s", e.Field, e.Message)
}
```

### Elixir

```elixir
# Tagged tuples for expected outcomes
case Repo.get(User, id) do
  nil -> {:error, :not_found}
  user -> {:ok, user}
end

# with for multi-step operations
with {:ok, user} <- find_user(id),
     {:ok, order} <- create_order(user, params),
     :ok <- send_confirmation(user, order) do
  {:ok, order}
end

# Let it crash (supervisor restarts)
# Don't defend against programming errors — fix them
```

### Rust

```rust
// thiserror for library errors
#[derive(Debug, thiserror::Error)]
enum AppError {
    #[error("user {0} not found")]
    NotFound(String),
    #[error("validation failed: {0}")]
    Validation(String),
    #[error(transparent)]
    Database(#[from] sqlx::Error),
}

// Use ? operator for propagation
fn get_user(id: &str) -> Result<User, AppError> {
    let user = db.find(id)?; // auto-converts sqlx::Error
    Ok(user)
}
```

## Retry Strategies

### Exponential Backoff

```
Attempt 1: wait 100ms
Attempt 2: wait 200ms
Attempt 3: wait 400ms
Attempt 4: wait 800ms
Attempt 5: give up
```

Add jitter (random ±20%) to prevent thundering herd.

### When to Retry

| Error Type              | Retry?                 | Example                        |
| ----------------------- | ---------------------- | ------------------------------ |
| Network timeout         | Yes                    | Connection reset, DNS failure  |
| 429 Too Many Requests   | Yes (with Retry-After) | Rate limited                   |
| 500 Server Error        | Yes (limited)          | Transient backend failure      |
| 503 Service Unavailable | Yes                    | Deployment, scaling            |
| 400 Bad Request         | No                     | Invalid input won't fix itself |
| 401/403 Unauthorized    | No                     | Auth won't fix by retrying     |
| 404 Not Found           | No                     | Resource doesn't exist         |
| 409 Conflict            | Maybe                  | Retry with fresh data          |

### Circuit Breaker

```
CLOSED → track failures → OPEN (after N failures)
OPEN → reject all requests → HALF-OPEN (after timeout)
HALF-OPEN → allow one request → CLOSED (if success) or OPEN (if failure)
```

Settings:

- **Failure threshold**: 5-10 failures (adjust per service)
- **Open duration**: 30-60 seconds
- **Half-open requests**: 1-3 test requests

## Error Boundaries

### API Layer

- Catch all unhandled errors → 500 response
- Map domain errors → HTTP status codes
- Log full error with stack trace
- Return sanitized error to client (no internals)

### Service/Business Layer

- Throw domain-specific errors
- Don't catch unless you can recover
- Wrap lower-level errors with business context

### Data/Infrastructure Layer

- Wrap driver errors with context
- Translate connection errors to retryable signals
- Handle timeouts with clear error messages

## Anti-Patterns

| Anti-Pattern                                   | Fix                                |
| ---------------------------------------------- | ---------------------------------- |
| Catching `Exception` / `Error` at every level  | Catch only what you can handle     |
| Empty catch blocks                             | At minimum: log the error          |
| Using exceptions for control flow              | Use Result types or tagged returns |
| Returning null/nil instead of error            | Return explicit error value        |
| String-matching on error messages              | Use error types or codes           |
| Logging errors at every level (duplicate logs) | Log once, at the boundary          |
| Generic "Something went wrong" to users        | Give actionable feedback           |
