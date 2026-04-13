# Setup a Phoenix Project

Bootstrap an Elixir/Phoenix project with the DX Toolkit and build your first feature through the full development lifecycle.

## Prerequisites

- **Elixir** 1.18+ (`elixir --version`)
- **Erlang/OTP** 27+ (`erl -eval 'io:format("~s~n", [erlang:system_info(otp_release)]), halt().'`)
- **PostgreSQL** 14+ running locally
- **Phoenix** installer (`mix archive.install hex phx_new`)
- **Git** repository initialized
- **GitHub Copilot** in VS Code (or Claude Code / Cursor)

## Step 1: Create the Phoenix Project

Scaffold a new Phoenix app if you don't have one:

```bash
mix phx.new my_app --database postgres
cd my_app
mix ecto.create
git init && git add -A && git commit -m "chore: scaffold phoenix project"
```

For a LiveView-heavy app (no JSON API), the default setup is fine. For an API-only project:

```bash
mix phx.new my_api --database postgres --no-html --no-assets
```

## Step 2: Run the Bootstrap Script

```bash
git clone https://github.com/dreamingechoes/dx-toolkit.git /tmp/dx-toolkit
/tmp/dx-toolkit/scripts/bootstrap.sh .
```

### Question 1: AI coding tool

Pick your editor — VS Code with Copilot, Claude Code, Cursor, or Windsurf.

### Question 2: Project type

Select **Elixir / Phoenix**. This installs:

| Component    | What you get                                                                                                   |
| ------------ | -------------------------------------------------------------------------------------------------------------- |
| Agents       | `elixir-expert`, `phoenix-expert`, `backend-expert`, `tdd-expert`, `bdd-expert`, plus 9 general-purpose agents |
| Instructions | `elixir.instructions.md` (auto-attaches to `**/*.ex`, `**/*.exs`)                                              |
| Skills       | All 33+ skills                                                                                                 |
| Prompts      | All 27+ prompts                                                                                                |
| Extras       | PostgreSQL agent auto-included                                                                                 |

The `elixir-expert` agent handles OTP patterns, GenServer, supervision trees, and Elixir idioms. The `phoenix-expert` handles LiveView, Ecto, contexts, and Phoenix conventions.

### Question 3: Extras

Recommended extras for Phoenix:

- **Docker / Containers** — adds `docker-expert` for `mix release` containerization
- **CI/CD Workflows** — GitHub Actions for your Elixir project
- **GitHub Templates** — issue forms and PR template

### Confirm and install

Review the plan, confirm, and commit:

```bash
git add .github/ CLAUDE.md AGENTS.md
git commit -m "chore: install dx-toolkit for phoenix project"
```

## Step 3: Verify the Setup

Test that agents understand your Phoenix project:

```
@phoenix-expert What contexts does this project have?
What patterns are used for data fetching?
```

The agent scans `lib/my_app/` for contexts, checks `router.ex` for route structure, and reviews `mix.exs` for dependencies.

Test that instructions auto-attach:

1. Open any `.ex` file
2. The `elixir.instructions.md` rules activate — pattern matching style, pipe operator usage, documentation with `@doc`, and error handling with tagged tuples

## Step 4: Build Your First Feature

Walk through the full EXPLORE → OUTLINE → DEVELOP → CHECK → POLISH lifecycle.

### 4a. Explore — define the feature

Say you need a blog system. Start with `/explore`:

```
/explore I need a blog system with posts, categories, and tags.
Posts support draft/published states. Authors are existing user accounts.
```

The **idea-refine** skill helps clarify scope:

- What's the URL structure? (`/blog/:slug`)
- LiveView for the admin, or server-rendered pages?
- Full-text search needed?

### 4b. Outline — break into tasks

```
/outline Blog system: Post context with CRUD, Category and Tag schemas,
draft/published state machine, admin LiveView for managing posts,
public-facing post list and detail pages.
```

The **planning-and-task-breakdown** skill produces ordered tasks:

1. Create `Blog` context with `Post` schema and changeset
2. Add `Category` schema with many-to-many through `PostCategory`
3. Add `Tag` schema with many-to-many through `PostTag`
4. Create Ecto migrations for all tables
5. Build admin LiveView for post CRUD
6. Build public post list and detail pages
7. Add tests for context functions and LiveView interactions

### 4c. Develop — implement each slice

Start with the data layer:

```
@feature-implementer Create the Blog context with a Post schema.
Posts have: title (string, required), slug (string, unique),
body (text), status (enum: draft/published), published_at (utc_datetime).
```

The agent creates:

- `lib/my_app/blog.ex` — context module with `list_posts/0`, `get_post!/1`, `create_post/1`, `update_post/1`
- `lib/my_app/blog/post.ex` — schema with `Ecto.Enum` for status
- `priv/repo/migrations/..._create_posts.exs` — migration with indexes

For Phoenix-specific decisions, ask the domain expert:

```
@phoenix-expert Should the blog admin use LiveView with streams for the
post list, or a standard controller? We expect ~1000 posts.
```

The `phoenix-expert` recommends LiveView with `stream/3` for the admin (real-time updates when posts change) and standard controllers for the public pages (better SEO, simpler caching).

```
@elixir-expert What's the right way to handle the draft → published
state transition? I want to set published_at automatically.
```

The `elixir-expert` suggests a changeset function with pattern matching:

```elixir
def publish_changeset(%Post{status: :draft} = post) do
  post
  |> change(status: :published, published_at: DateTime.utc_now())
end
```

### 4d. Check — fix issues

If tests fail:

```
/check The blog context test for create_post/1 fails with
"constraint error on unique slug" but I'm generating unique slugs.
```

The **debugging-and-error-recovery** skill traces through: reproduction, localization (probably a test isolation issue — the database isn't resetting between tests), and fix (ensure `Ecto.Adapters.SQL.Sandbox` is set to `:shared` mode or use unique slugs per test).

### 4e. Polish — review and clean up

```
/polish Review the Blog context implementation for Elixir idioms,
Ecto best practices, and test coverage.
```

The `elixir-expert` checks for:

- Proper use of pattern matching over conditionals
- Pipe operator chains that read top-to-bottom
- `@doc` and `@spec` on public context functions
- Preload strategies (explicit over lazy loading)
- Index coverage for foreign keys and unique constraints

## Step 5: Set Up CI Workflows

Copy the workflows that matter for Elixir projects:

### Essential pipeline

```bash
cp templates/workflows/pr-size-checker.yml .github/workflows/
cp templates/workflows/pr-code-reviewer.yml .github/workflows/
cp templates/workflows/conventional-commit-checker.yml .github/workflows/
```

### Add Elixir-specific CI

The toolkit workflows handle AI-powered review and PR hygiene. For Elixir compilation and tests, add a standard CI workflow:

```yaml
# .github/workflows/elixir-ci.yml
name: Elixir CI

on:
  pull_request:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 15

    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: postgres
        ports: ['5432:5432']
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v4
      - uses: erlef/setup-beam@v1
        with:
          otp-version: '27.0'
          elixir-version: '1.18.0'

      - name: Cache deps
        uses: actions/cache@v4
        with:
          path: |
            deps
            _build
          key: ${{ runner.os }}-mix-${{ hashFiles('mix.lock') }}

      - run: mix deps.get
      - run: mix compile --warnings-as-errors
      - run: mix format --check-formatted
      - run: mix credo --strict
      - run: mix test
```

### Security and docs pipelines

```bash
cp templates/workflows/security-scanner.yml .github/workflows/
cp templates/workflows/auto-changelog.yml .github/workflows/
cp templates/workflows/dependency-update-checker.yml .github/workflows/
```

Commit and push:

```bash
git add .github/workflows/
git commit -m "ci: add elixir CI and toolkit quality workflows"
git push
```

## Step 6: Day-to-Day Workflow

1. **Pick a task** — read the issue, then `/outline` to break it into steps
2. **Develop** — use `@feature-implementer` with `@phoenix-expert` and `@elixir-expert` for guidance
3. **Test** — use `@tdd-expert` to write tests first, or `@test-writer` to backfill tests
4. **Review** — run `/polish` to check Elixir idioms and Phoenix patterns
5. **PR** — use `/pr-description` to generate the PR body
6. **CI** — workflows run automatically; fix any flagged issues

## What's Installed (Quick Reference)

| Component                      | Purpose                                             |
| ------------------------------ | --------------------------------------------------- |
| `elixir-expert`                | OTP patterns, GenServer, supervision, Elixir idioms |
| `phoenix-expert`               | LiveView, Ecto, contexts, Phoenix 1.8+ conventions  |
| `postgresql-expert`            | Query optimization, indexing, schema design         |
| `tdd-expert`                   | Test-first development workflow                     |
| `bdd-expert`                   | Behavior-driven development with scenarios          |
| `elixir.instructions.md`       | Auto-attaches to `**/*.ex`, `**/*.exs`              |
| `/explore` → `/launch`         | Full lifecycle prompts                              |
| `incremental-implementation`   | Build in thin vertical slices                       |
| `debugging-and-error-recovery` | Five-step triage for failing tests                  |

## Troubleshooting

**Agent doesn't know about Phoenix contexts?** Make sure `.github/agents/phoenix-expert.agent.md` exists. The agent reads your `lib/` directory structure to understand contexts.

**Elixir instructions not activating?** Check that the file you're editing matches `**/*.ex` or `**/*.exs`. The instructions won't activate for `.eex` or `.heex` templates.

**Mix tests fail in CI?** Verify the PostgreSQL service is running and the `MIX_ENV=test` database config in `config/test.exs` matches the CI service credentials.
