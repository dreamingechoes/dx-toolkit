---
description: 'Generate type definitions, schemas, or data structures from sample data, API responses, or database schemas. Works with any typed language.'
agent: 'agent'
---

Generate type definitions from the provided data or schema description.

## Procedure

1. **Analyze the input** — sample JSON, API response, database schema, or description
2. **Detect the project's language and type system** — TypeScript interfaces, Python dataclasses/Pydantic, Elixir typespecs, Go structs, Rust structs, Java records, Ruby Sorbet, etc.
3. **Generate types** following the project's existing patterns and conventions

## Type Generation Rules

- Follow the language's idiomatic type patterns
- Use strict types — avoid escape hatches (`any` in TS, `Object` in Java, `interface{}` in Go)
- Model variants with discriminated unions, tagged unions, or sum types as the language supports
- Include documentation comments for non-obvious fields
- Generate runtime validation schemas if the project uses a validation library (Zod, Pydantic, Ecto changesets, etc.)
- Prefer immutability where the language supports it

## Naming Conventions

- Follow the language's standard naming (PascalCase for TS/Go/Java, snake_case for Python/Elixir/Rust)
- Suffix with purpose: `CreateUserInput`, `UserResponse`, `UserRow`
- Match existing naming patterns in the codebase

## Output

- Type definitions file in the project's language
- Validation schemas if applicable
- Usage example showing how to use the types
