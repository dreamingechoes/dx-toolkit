# Repository-Wide Instructions for GitHub Copilot

## About This Project

This is a web application built with Elixir, Phoenix 1.8, LiveView, and PostgreSQL.

### Tech Stack

- **Language**: Elixir 1.18+ / OTP 27+
- **Framework**: Phoenix 1.8 (LiveView, Ecto, PubSub)
- **Database**: PostgreSQL 17
- **Frontend**: LiveView + Tailwind CSS (no JavaScript framework)
- **Background Jobs**: Oban
- **Deployment**: Fly.io with releases
- **Testing**: ExUnit

### Project Structure

```
lib/
├── my_app/           # Business logic (contexts)
│   ├── accounts/     # Accounts context (users, auth, teams)
│   ├── billing/      # Billing context (plans, subscriptions)
│   └── catalog/      # Domain context (your core domain)
├── my_app_web/       # Web layer
│   ├── components/   # Shared function components
│   ├── live/         # LiveView modules (by feature)
│   ├── controllers/  # Traditional controllers (API, webhooks)
│   ├── router.ex     # Routes
│   └── endpoint.ex   # HTTP endpoint config
test/
├── my_app/           # Context tests (unit)
├── my_app_web/       # Web tests (integration)
└── support/          # Test helpers, fixtures, factories
priv/
└── repo/migrations/  # Ecto migrations
```

## Code Conventions

- Organize by context (bounded contexts), not by type. `Accounts`, `Billing`, `Catalog` — not `models/`, `services/`.
- Public context functions are the API boundary. LiveViews call context functions, never Ecto queries directly.
- Use pattern matching and guard clauses over conditional logic.
- Use `with` for multi-step operations that can fail. Return `{:ok, result}` or `{:error, changeset}`.
- LiveView event handlers return `{:noreply, socket}`. Assign data with `assign/3` or `assign_new/3`.
- Use `Ecto.Multi` for operations that touch multiple tables.
- Migrations are always reversible. Use `up/down` for complex migrations.
- PubSub for real-time: contexts broadcast, LiveViews subscribe. Never broadcast from LiveViews.
- Background jobs use Oban workers. Keep workers small and idempotent.
- No `import Ecto.Query` in contexts — use explicit `from/2` or named query functions.

## dx-toolkit Components in Use

### Active Agents

- `elixir-expert` — OTP patterns, GenServer, supervision
- `phoenix-expert` — LiveView, Ecto, context architecture
- `postgresql-expert` — Query optimization, indexing, migrations
- `tdd-expert` — ExUnit test-driven development

### Active Instructions

- `elixir.instructions.md` — Applied to `**/*.ex, **/*.exs`
- `testing.instructions.md` — Applied to `**/test/**`
- `migrations.instructions.md` — Applied to `**/priv/repo/migrations/**`

### Recommended Skills

- `/develop` — Implement in thin vertical slices
- `/check` — Debug and test failures
- `/polish` — Code simplification, security audit

### Active Hooks

- `format-on-edit` — `mix format` for .ex/.exs files
- `guard-protected-files` — Protect mix.lock, .env
- `secret-scanner` — Catch hardcoded credentials
- `console-log-detector` — Catch IO.inspect/IEx.pry/dbg()

## Testing Conventions

- Unit tests: `test/my_app/*_test.exs` — test context functions
- Integration tests: `test/my_app_web/live/*_live_test.exs` — test LiveViews
- Use `DataCase` for database tests, `ConnCase` for HTTP, `FeatureCase` for browser
- Factories with `ExMachina` — define in `test/support/factory.ex`
- Run: `mix test` (all), `mix test test/my_app/accounts_test.exs` (specific)
- Async tests by default: `use MyApp.DataCase, async: true`
