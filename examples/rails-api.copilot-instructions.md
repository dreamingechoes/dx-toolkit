# Repository-Wide Instructions for GitHub Copilot

## About This Project

This is a REST API built with Ruby on Rails 8, PostgreSQL, and Sidekiq.

### Tech Stack

- **Language**: Ruby 3.3+
- **Framework**: Rails 8 (API mode)
- **Database**: PostgreSQL 17
- **Cache**: Redis (caching + Sidekiq broker)
- **Background Jobs**: Sidekiq
- **Auth**: Devise + JWT tokens
- **Deployment**: Docker + Kamal
- **Testing**: RSpec + FactoryBot

### Project Structure

```
app/
├── controllers/        # API controllers (versioned: api/v1/)
│   └── api/v1/        # V1 endpoints
├── models/            # ActiveRecord models
├── serializers/       # JSON serializers (Alba or Blueprinter)
├── services/          # Service objects for complex operations
├── jobs/              # Sidekiq background jobs
├── policies/          # Pundit authorization policies
└── mailers/           # Action Mailer classes
config/
├── routes.rb          # Route definitions
├── database.yml       # Database config
└── initializers/      # App initialization
db/
├── migrate/           # Database migrations
├── schema.rb          # Current schema state
└── seeds.rb           # Seed data
spec/
├── models/            # Model specs
├── requests/          # Request/integration specs
├── services/          # Service specs
├── factories/         # FactoryBot definitions
└── support/           # Test helpers
```

## Code Conventions

- API-only mode — no views, no assets pipeline. JSON responses only.
- Version all endpoints: `/api/v1/resources`. Never break existing versions.
- Use service objects for business logic that spans multiple models. Controllers stay thin.
- Use Pundit for authorization. Every controller action calls `authorize @resource`.
- Use `strong_parameters` in controllers. Never pass `params` directly to model methods.
- Prefer `find_by!` over `find_by` + manual nil check. Let Rails raise `RecordNotFound`.
- Use scopes for common queries. Keep them chainable.
- Background jobs are idempotent. Use `sidekiq_options retry: 5` and handle retries gracefully.
- Migrations are reversible. Test both `up` and `down` paths.
- Use `frozen_string_literal: true` in all Ruby files.

## dx-toolkit Components in Use

### Active Agents

- `rails-expert` — Rails conventions, ActiveRecord patterns
- `postgresql-expert` — Query optimization, indexing
- `backend-expert` — API design, error handling
- `security-fixer` — OWASP Top 10 for Rails

### Active Instructions

- `ruby.instructions.md` — Applied to `**/*.rb, **/Gemfile, **/Rakefile`
- `api-design.instructions.md` — Applied on-demand for endpoint design
- `testing.instructions.md` — Applied to `**/spec/**`
- `migrations.instructions.md` — Applied to `**/db/migrate/**`

### Recommended Skills

- `/explore` — Define API endpoints with specs
- `/develop` — Implement endpoints in vertical slices
- `/check` — Debug failures, write request specs
- `/launch` — Deployment checklist, documentation

### Active Hooks

- `format-on-edit` — No auto-formatter (use RuboCop manually)
- `guard-protected-files` — Protect Gemfile.lock, .env, database.yml
- `secret-scanner` — Catch hardcoded credentials
- `config-protector` — Don't weaken RuboCop rules
- `large-dependency-guard` — Review new gem additions

## Testing Conventions

- Request specs: `spec/requests/api/v1/*_spec.rb` — test full HTTP cycle
- Model specs: `spec/models/*_spec.rb` — validations, scopes, associations
- Service specs: `spec/services/*_spec.rb` — business logic
- Use FactoryBot — define factories in `spec/factories/`
- Run: `bundle exec rspec` (all), `bundle exec rspec spec/requests/` (requests only)
- Use `DatabaseCleaner` with transaction strategy for test isolation
