# Repository-Wide Instructions for GitHub Copilot

## About This Project

This is a gRPC microservice built with Go 1.22+, PostgreSQL, and Docker.

### Tech Stack

- **Language**: Go 1.22+
- **API**: gRPC + protobuf (with gRPC-Gateway for REST)
- **Database**: PostgreSQL 17 (via pgx)
- **Migrations**: golang-migrate
- **Config**: Viper + environment variables
- **Observability**: OpenTelemetry (traces + metrics + logs)
- **Deployment**: Docker + Kubernetes
- **Testing**: Go standard testing + testify

### Project Structure

```
cmd/
└── server/           # Application entry point (main.go)
internal/
├── config/           # Configuration loading
├── domain/           # Domain types and interfaces (no external deps)
│   ├── model/        # Domain models
│   └── port/         # Repository and service interfaces
├── adapter/          # Interface implementations
│   ├── postgres/     # PostgreSQL repositories
│   ├── grpc/         # gRPC handlers
│   └── http/         # HTTP/REST handlers (gRPC-Gateway)
├── service/          # Business logic (implements domain ports)
└── middleware/       # gRPC interceptors
proto/
└── v1/              # Protobuf definitions
migrations/
└── *.sql            # Database migration files
deploy/
├── Dockerfile       # Multi-stage build
└── k8s/             # Kubernetes manifests
```

## Code Conventions

- Follow hexagonal architecture: `domain/` has zero external dependencies. `adapter/` implements domain interfaces.
- All exported functions return `error` as the last return value. Never ignore errors.
- Use `context.Context` as the first parameter in all public functions that do I/O.
- Use structured logging with `slog`. No `fmt.Println` in production code.
- Use `pgx` for PostgreSQL — not `database/sql`. Use connection pooling via `pgxpool`.
- Protobuf is the source of truth for API contracts. Generate Go code with `buf generate`.
- Use `golang-migrate` for database migrations. Migrations are numbered and reversible.
- Tests use `testify/assert` and `testify/require`. Use table-driven tests for multiple cases.
- Use `errgroup` for concurrent operations. Avoid raw goroutines without error handling.
- Graceful shutdown: handle `SIGINT`/`SIGTERM`, drain connections, flush telemetry.

## dx-toolkit Components in Use

### Active Agents

- `go-expert` — Idiomatic Go patterns, concurrency
- `postgresql-expert` — Query optimization, indexing
- `docker-expert` — Multi-stage builds, security
- `backend-expert` — API design, error handling

### Active Instructions

- `go.instructions.md` — Applied to `**/*.go`
- `docker.instructions.md` — Applied to `**/Dockerfile*`
- `api-design.instructions.md` — Applied on-demand for endpoint design
- `testing.instructions.md` — Applied to `**/*_test.go`

### Recommended Skills

- `/explore` — Define service endpoints and domain model
- `/develop` — Implement in vertical slices (proto → handler → service → repo)
- `/check` — Debug failures, write table-driven tests
- `/polish` — Performance profiling, security audit

### Active Hooks

- `format-on-edit` — `gofmt` for .go files
- `guard-protected-files` — Protect go.sum, .env
- `secret-scanner` — Catch hardcoded credentials
- `console-log-detector` — Catch fmt.Println debug statements
- `config-protector` — Don't weaken golangci-lint rules

## Testing Conventions

- Unit tests: `*_test.go` co-located with source files
- Integration tests: `internal/adapter/postgres/*_test.go` — use testcontainers-go
- Use TestMain for setup/teardown when needed
- Table-driven tests: `tests := []struct{ name string; ... }{...}`
- Run: `go test ./...` (all), `go test ./internal/service/...` (specific package)
- Use `t.Parallel()` for independent tests
- Mock interfaces with `testify/mock` or hand-written fakes
