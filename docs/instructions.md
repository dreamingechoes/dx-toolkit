# 📏 Instructions

Instructions are persistent rules that Copilot follows automatically — either whenever you open a specific file type or when manually referenced. They shape every suggestion without needing to repeat yourself.

**Location**: `templates/instructions/*.instructions.md`

## How Instructions Work

There are two modes:

### 1. Auto-Attached (file-type specific)

Uses `applyTo` globs in frontmatter. Whenever you open or edit a matching file, the instruction is silently loaded into context.

```yaml
---
applyTo: '**/*.ts,**/*.tsx'
---
Rules for TypeScript files...
```

### 2. On-Demand (task-based)

Uses `description` in frontmatter (no `applyTo`). Available via `#` reference in Copilot Chat to pull in when needed.

```yaml
---
description: 'REST API design conventions'
---
Rules for API design...
```

---

## Auto-Attached Instructions

These activate automatically when you edit matching files:

### Elixir (`elixir.instructions.md`)

**Applies to**: `**/*.ex`, `**/*.exs`

**Key rules**:

- Target Elixir 1.18+ / OTP 27+
- Use pipe operator `|>` for data transformations (3+ steps)
- Pattern match in function heads rather than `if/case` inside
- Use `with` for multi-step operations that may fail
- Return `{:ok, value}` / `{:error, reason}` for operations that can fail
- Use `@moduledoc` and `@doc` for public modules and functions
- ExUnit tests: use `describe` blocks grouped by function name

---

### TypeScript (`typescript.instructions.md`)

**Applies to**: `**/*.ts`, `**/*.tsx`, `**/*.mts`, `**/*.cts`

**Key rules**:

- Target TypeScript 5.7+ with strict mode
- Prefer `interface` for object shapes, `type` for unions/intersections
- Use discriminated unions over optional fields for variants
- Prefer `unknown` over `any` — use type guards to narrow
- Use `satisfies` operator for type checking without widening
- Use branded types for domain identifiers
- Use `as const` for literal tuples and config objects
- Prefer `Map`/`Set` over plain objects for dynamic keys
- Use `using`/`Symbol.dispose` for resource management

---

### React (`react.instructions.md`)

**Applies to**: `**/*.tsx`, `**/*.jsx`

**Key rules**:

- Target React 19+ patterns
- Use `use()` for promises and context, `useActionState()` for forms
- Return `ReactNode` from components (not `JSX.Element`)
- Keep components < 150 LOC — extract custom hooks for logic
- State hierarchy: URL → Server → Global → Local
- Memoize only with measured perf problems
- Every interactive element needs keyboard support
- Images need meaningful `alt` text

---

### CSS (`css.instructions.md`)

**Applies to**: `**/*.css`, `**/*.scss`, `**/*.module.css`, `**/*.module.scss`

**Key rules**:

- Use native CSS nesting instead of preprocessor nesting
- Use `oklch()` for perceptually uniform colors
- Use `@layer` for cascade management
- Use container queries `@container` for component-level responsiveness
- Use logical properties (`inline-start` over `left`)
- Design for dark mode with `prefers-color-scheme`
- Motion: respect `prefers-reduced-motion`
- Mobile-first media queries

---

### Docker (`docker.instructions.md`)

**Applies to**: `**/Dockerfile*`, `**/docker-compose*.yml`

**Key rules**:

- Always use multi-stage builds (builder → runner)
- Pin base images with digest or full version tag
- Install only production dependencies in final stage
- Run as non-root user with minimal permissions
- Use `.dockerignore` (exclude `.git`, `node_modules`, etc.)
- Order layers by change frequency (COPY deps → COPY source)
- Use `HEALTHCHECK` in production Dockerfiles
- Use `COPY --link` for better layer caching with BuildKit

---

### Testing (`testing.instructions.md`)

**Applies to**: `**/*.test.*`, `**/*.spec.*`, `**/*_test.*`, `**/test/**`

**Key rules**:

- Follow Arrange-Act-Assert (Given-When-Then) structure
- One assertion per test (or one logical assertion)
- Test behavior and outcomes, not implementation details
- Use descriptive names: `test "returns error when email is invalid"`
- Mock at boundaries only (HTTP, database, filesystem)
- Use factories/fixtures over raw data construction
- Async tests: always use explicit assertions for async outcomes
- Coverage: aim for critical paths, not arbitrary percentages

---

### Migrations (`migrations.instructions.md`)

**Applies to**: `**/migrations/**`, `**/priv/repo/migrations/**`

**Key rules**:

- All migrations must be reversible (include `down`/`change`)
- Provide default values for new NOT NULL columns
- Use `CREATE INDEX CONCURRENTLY` for large tables
- Separate schema changes from data migrations
- Consider zero-downtime: add columns first, then constraints
- Name constraints explicitly
- Use appropriate PostgreSQL types (`citext`, `timestamptz`, `uuid`)
- Test migrations with representative data volume

---

### Writing Style (`writing-style.instructions.md`)

**Applies to**: `**/*.md`, `**/docs/**`

**Key rules**:

- Use active voice by default
- Use "you" for the reader and "we" for the team
- Cut filler: "In order to" → "To", "It should be noted that" → delete
- Remove hedge stacks: "might potentially" → "can"
- Replace vague adjectives with measurables: "fast" → "responds in <100ms"
- Avoid AI-marker phrases: "leverage", "robust", "comprehensive", "seamless"
- One idea per sentence, paragraphs of 3-4 sentences max
- Start sections with what the reader needs to do, not background

---

### Python (`python.instructions.md`)

**Applies to**: `**/*.py`

**Key rules**:

- Target Python 3.12+
- Use type hints on all function signatures
- Follow PEP 8 with 88-char line length (Black default)
- Prefer f-strings over `.format()` or `%` formatting
- Use `pathlib.Path` over `os.path`
- Use `dataclasses` or `attrs` for data containers
- Use `match/case` for structural pattern matching
- Prefer list/dict comprehensions over `map`/`filter`
- Use `from __future__ import annotations` for forward refs

---

### Ruby (`ruby.instructions.md`)

**Applies to**: `**/*.rb`, `**/Gemfile`, `**/Rakefile`

**Key rules**:

- Target Ruby 3.3+
- Add `# frozen_string_literal: true` to every file
- Use pattern matching (`in`/`case...in`) for complex conditionals
- Follow Rails conventions: fat models, skinny controllers
- Use `ActiveRecord` scopes over class methods for queries
- Prefer `then`/`and_then` chaining for sequential operations
- Use keyword arguments for methods with 3+ parameters
- Guard clauses over nested conditionals

---

### Go (`go.instructions.md`)

**Applies to**: `**/*.go`

**Key rules**:

- Target Go 1.22+
- Wrap errors with `fmt.Errorf("context: %w", err)`
- Use table-driven tests with `t.Run` subtests
- Use `context.Context` as the first parameter for cancellable operations
- Prefer `errors.Is`/`errors.As` over string comparison
- Use goroutines with `errgroup` for structured concurrency
- Follow Effective Go naming: short variable names in small scopes
- Use `slog` for structured logging

---

### Rust (`rust.instructions.md`)

**Applies to**: `**/*.rs`

**Key rules**:

- Target Rust 2024 edition
- Use `thiserror` for library errors, `anyhow` for application errors
- Prefer ownership patterns that avoid `clone()` where possible
- Avoid `unsafe` unless absolutely necessary and document why
- Use `#[must_use]` on functions that return important values
- Use `impl Trait` in argument position for flexibility
- Prefer iterators over manual loops
- Use `clippy` with `pedantic` lint group enabled

---

### Swift (`swift.instructions.md`)

**Applies to**: `**/*.swift`

**Key rules**:

- Target Swift 6+ with strict concurrency checking
- Use structured concurrency (`async let`, `TaskGroup`) over unstructured `Task {}`
- Prefer `@Observable` over `ObservableObject`/`@Published` (Swift 5.9+)
- Use SwiftUI patterns: small views, `ViewModifier` for reusable styling
- Use `sending` parameter modifier for cross-isolation data
- Use `guard` for early returns and precondition checks
- Prefer value types (`struct`, `enum`) over reference types (`class`)

---

### Kotlin (`kotlin.instructions.md`)

**Applies to**: `**/*.kt`, `**/*.kts`

**Key rules**:

- Target Kotlin 2.0+
- Use coroutines with structured concurrency (`coroutineScope`, `supervisorScope`)
- Use `sealed class`/`sealed interface` for restricted hierarchies
- Prefer `data class` for DTOs and value objects
- Use Compose patterns: stateless composables, state hoisting
- Prefer `when` expressions over `if-else` chains
- Use `Result` type for operations that can fail
- Use extension functions to add behavior without inheritance

---

### Vue (`vue.instructions.md`)

**Applies to**: `**/*.vue`

**Key rules**:

- Target Vue 3.5+ with Composition API
- Use `<script setup>` for all components
- Use TypeScript with `defineProps<T>()` and `defineEmits<T>()`
- Use `composables` (use-prefixed functions) for reusable logic
- Prefer `ref()` over `reactive()` for primitives
- Use `computed()` for derived state, `watch()` sparingly
- Use `defineModel()` for two-way binding
- Follow SFC order: `<script setup>`, `<template>`, `<style scoped>`

---

### GraphQL (`graphql.instructions.md`)

**Applies to**: `**/*.graphql`, `**/*.gql`

**Key rules**:

- Use schema-first design — define types before resolvers
- Use DataLoader for batching and caching N+1 queries
- Use union types for error handling (`type Result = Success | NotFound | ValidationError`)
- Use persisted queries in production to prevent arbitrary query execution
- Use `ID` scalar for node identifiers
- Paginate with Relay-style connections (`edges`, `pageInfo`)
- Prefer input types for mutations over loose arguments
- Use `@deprecated` directive before removing fields

---

## On-Demand Instructions

These are available via `#` reference in Copilot Chat:

### API Design (`#api-design`)

**Use when**: Designing or implementing REST API endpoints.

**Key rules**:

- Use plural nouns for resources (`/users`, `/posts`)
- HTTP methods: GET (read), POST (create), PUT (full update), PATCH (partial), DELETE
- Status codes: 200 OK, 201 Created, 204 No Content, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 409 Conflict, 422 Unprocessable Entity, 429 Too Many Requests
- Always return consistent error format with `code`, `message`, and `details`
- Use cursor-based pagination for large collections
- Version via URL prefix (`/api/v1/`)
- Rate limiting headers on all responses

---

### Accessibility (`#accessibility`)

**Use when**: Building UI components, forms, or interactive elements.

**Key rules**:

- Target WCAG 2.2 Level AA
- Use semantic HTML elements (`<nav>`, `<main>`, `<article>`, `<button>`)
- All images need meaningful `alt` text (or `alt=""` for decorative)
- All interactive elements must be keyboard-accessible
- Focus must be visible and follow logical order
- Color contrast: 4.5:1 for text, 3:1 for large text and UI components
- ARIA: use only when no native HTML element works
- Forms: associate all inputs with labels, provide error messages

---

### Git Workflow (`#git-workflow`)

**Use when**: Creating branches, writing commits, or preparing PRs.

**Key rules**:

- Branch naming: `feat/`, `fix/`, `chore/`, `docs/`, `refactor/` prefixes
- Conventional Commits: `type(scope): subject`
- Subject: imperative mood, ≤72 chars, no period
- Body: what and **why**, not how (code explains how)
- Keep commits atomic — one logical change per commit
- Squash WIP commits before merge
- PRs: descriptive title, reference issue with `Closes #N`

---

## How Auto-Attach Works

```
You open src/components/Button.tsx
  → *.tsx matches react.instructions.md ✅
  → *.tsx matches typescript.instructions.md ✅
  → Both are silently loaded into Copilot's context
  → Every suggestion follows both rule sets
```

Multiple instructions can stack on the same file. Keep instructions focused (one concern per file) to avoid context bloat.

## Tips

- **Test auto-attach**: Open a matching file and ask Copilot Chat "what instructions are active?"
- **Reference on-demand**: Type `#` in Chat, then select the instruction file
- **Don't overlap**: If two instructions conflict on the same glob, one wins unpredictably
- **Keep them concise**: Instructions share the context window with your code — shorter is better
- **Create your own**: See [Customization](customization.md) for adding custom instructions
