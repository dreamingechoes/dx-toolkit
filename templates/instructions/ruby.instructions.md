---
description: 'Ruby and Rails coding standards. Use when writing or reviewing Ruby code. Covers Rails conventions, ActiveRecord patterns, and modern Ruby 3.3+ style.'
applyTo: '**/*.rb, **/Gemfile, **/Rakefile'
---

# Ruby & Rails Code Standards

## Ruby Style

- Add `# frozen_string_literal: true` to every file
- Use pattern matching (`case/in`) for complex destructuring (Ruby 3.0+)
- Use endless methods (`def name = expression`) for simple one-liners (Ruby 3.0+)
- Prefer `then` over `do/end` for single-expression blocks on one line
- Use `Symbol#to_proc` (`&:method_name`) for simple map/select/reject calls
- Use `Data.define` (Ruby 3.2+) for immutable value objects
- Use `it` as default block parameter (Ruby 3.4+) for simple blocks
- Prefer `%i[]` for symbol arrays and `%w[]` for string arrays

## Rails Conventions

- Thin controllers — one action should be ~5-10 lines
- Push business logic into models, service objects, or concerns — not controllers
- Use strong parameters — never permit all with `params.permit!`
- Use `before_action` for auth/loading — keep it declared at the top
- One job per concern — name after the verb: `SendWelcomeEmailJob`
- Use `ActiveSupport::CurrentAttributes` for request-scoped global state
- Use `config_for` for YAML-based configuration

## ActiveRecord

- Use scopes for reusable queries — chain them instead of writing raw SQL
- Add database-level constraints _and_ model validations — don't rely on just one
- Prevent N+1 with `includes`, `preload`, or `eager_load` — use `strict_loading!`
- Use `counter_cache` for count columns instead of `COUNT(*)` queries
- Use `find_each` / `in_batches` for processing large datasets
- Add indexes for all foreign keys and commonly queried columns
- Use `belongs_to :parent, optional: true` only when NULL is valid
- Use `has_many ... dependent: :destroy` or `:restrict_with_error` — never leave implicit

## Naming

- PascalCase: classes, modules
- snake_case: methods, variables, file names
- Predicate methods end with `?` — no `is_` prefix
- Dangerous methods end with `!` (modifies in-place or raises on failure)
- Constants: `SCREAMING_SNAKE_CASE`

## Testing (RSpec)

- Structure: `describe` for class/method, `context` for scenario, `it` for behavior
- Use `FactoryBot` factories — never fixtures for new tests
- Use `let` for lazy-loaded test data — `let!` only when eager loading is needed
- One assertion per `it` block when feasible
- Name examples as behaviors: `it "returns nil when user is not found"`
- Use `have_enqueued_job` matcher to test background jobs without running them
- Use `freeze_time` or `travel_to` for time-dependent tests

## Security

- Parameterize all user input in queries — never interpolate into SQL strings
- Use CSRF tokens for all non-GET requests — Rails enables this by default
- Set `content_security_policy` in `config/initializers/`
- Use `has_secure_password` for authentication — never roll your own bcrypt
- Sanitize HTML output — use `sanitize` helper or `ActionText`
- Keep secrets in `credentials.yml.enc` — never commit plaintext secrets

## Performance

- Use `select` to limit columns when you don't need the full record
- Use `exists?` instead of `present?` to check record existence
- Cache expensive views with fragment caching — use Russian Doll pattern
- Use `Turbo Frames` / `Turbo Streams` for partial page updates instead of full reloads
