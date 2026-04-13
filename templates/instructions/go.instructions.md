---
description: 'Go coding standards. Use when writing or reviewing Go code. Covers error handling, concurrency, package design, and idiomatic Go 1.22+ patterns.'
applyTo: '**/*.go'
---

# Go Code Standards

## Naming

- Use MixedCaps (exported) and mixedCaps (unexported) — never snake_case
- Keep acronyms uppercase: `HTTPClient`, `userID`, `parseJSON`
- Interface names use `-er` suffix for single-method interfaces: `Reader`, `Stringer`
- Package names are lowercase, single-word, no underscores: `http`, `user`, `auth`
- Avoid stuttering: `user.User` is fine, `user.UserService` is not — use `user.Service`
- Receivers: short (1-2 letter) consistent names — `(s *Server)`, not `(server *Server)`

## Error Handling

- Always check errors — never use `_` to discard an error
- Wrap errors with context using `fmt.Errorf("doing X: %w", err)`
- Define sentinel errors with `errors.New` for errors callers need to match
- Use `errors.Is()` and `errors.As()` — never compare errors with `==`
- Return errors, don't panic — `panic` is for unrecoverable programmer errors only
- Use custom error types when callers need to extract structured information
- At the top of the call stack, log the error and return an appropriate response

## Concurrency

- Always pass `context.Context` as the first parameter
- Use `errgroup.Group` for coordinating concurrent operations with error collection
- Specify channel direction in function params: `chan<-` (send), `<-chan` (receive)
- Use `sync.Once` for lazy initialization — not `sync.Mutex` with a bool flag
- Close channels from the sender side only — never from the receiver
- Prefer `sync.Map` only for append-only caches — use `sync.RWMutex` for general maps
- Use `context.WithCancel` or `context.WithTimeout` — always `defer cancel()`

## Package Design

- Keep interfaces small — 1-3 methods maximum
- Accept interfaces, return concrete structs
- Define interfaces in the consumer package, not the provider
- Use `internal/` for packages that shouldn't be imported by other modules
- One package per concern — avoid "utils" or "helpers" catchall packages

## Functions & Types

- Return early to avoid nesting — guard clauses at the top
- Use functional options pattern for complex constructors: `func WithTimeout(d time.Duration) Option`
- Use `struct{}` as a set element type: `map[string]struct{}`
- Prefer value receivers for small immutable types, pointer receivers for mutating or large types
- Use `range` over integers (Go 1.22+): `for i := range 10`

## Testing

- Use table-driven tests with `t.Run` for subtests
- Use `testify/assert` or `testify/require` for readable assertions
- Use `httptest.NewServer` for HTTP integration tests
- Use `t.Parallel()` for independent tests
- Use `t.Helper()` in test helper functions for correct line reporting
- Put test fixtures in `testdata/` — Go tooling ignores this directory
- Use `t.TempDir()` for temporary files — automatically cleaned up

## Project Layout

- `cmd/<app>/main.go` — application entry points
- `internal/` — private packages not importable by other modules
- `pkg/` — public library packages (use sparingly — prefer `internal/`)
- Keep `main.go` minimal — parse config, wire dependencies, call `run()`
- Use `go generate` for code generation — commit generated files

## Dependencies

- Run `go mod tidy` before committing — keep `go.sum` clean
- Use `go vet` and `staticcheck` in CI
- Vendor dependencies only when reproducibility is critical
