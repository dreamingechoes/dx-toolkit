---
description: 'TypeScript coding standards. Use when writing or reviewing TypeScript code. Covers strict types, patterns, error handling, and modern features.'
applyTo: '**/*.ts, **/*.tsx, **/*.mts, **/*.cts'
---

# TypeScript Code Standards

## Strict Configuration

- Enable `strict: true` — never disable strictness flags individually
- Enable `noUncheckedIndexedAccess` for safe array/object access
- Use `verbatimModuleSyntax` for explicit type imports (`import type`)

## Type Design

- Prefer `interface` for object shapes, `type` for unions/intersections/mapped types
- Use discriminated unions for variant types (add a `type` or `kind` literal field)
- Use `satisfies` to validate values against types without widening
- Use branded types for IDs: `type UserId = string & { readonly __brand: 'UserId' }`
- Use `readonly` for arrays and objects that shouldn't be mutated
- No `any` — use `unknown` and narrow with type guards
- No `as` type assertions except `as const` — use type guards or `satisfies`

## Error Handling

- Use Result types (`{ ok: true; data: T } | { ok: false; error: E }`) for expected failures
- Use `try/catch` only for truly unexpected exceptions
- Always type error parameters: `catch (error: unknown)`
- Use `using` / `Symbol.dispose` for resource cleanup (TS 5.2+)

## Modern Features (ES2024+)

- Use `Object.groupBy()` and `Map.groupBy()` instead of manual grouping
- Use `Array.prototype.with()` for immutable updates
- Use `Promise.withResolvers()` for deferred promises
- Use `structuredClone()` instead of `JSON.parse(JSON.stringify())`
- Use `using` keyword for disposable resources

## Naming

- PascalCase: types, interfaces, enums, components
- camelCase: variables, functions, methods
- SCREAMING_SNAKE_CASE: constants and env variables
- Prefix interfaces only when needed for clarity (avoid `I` prefix)

## Imports

- Use `import type` for type-only imports
- Use path aliases (`@/`) for project imports
- Order: external → internal → types → styles
