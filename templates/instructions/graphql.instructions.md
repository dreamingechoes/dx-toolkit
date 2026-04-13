---
description: 'GraphQL schema and query standards. Use when writing or reviewing GraphQL schemas, queries, or resolvers. Covers naming, pagination, error handling, and performance.'
applyTo: '**/*.graphql, **/*.gql'
---

# GraphQL Code Standards

## Schema Design

- Use nouns for types: `User`, `Order`, `Product` — not `GetUser` or `UserData`
- Use verbs for mutations: `createUser`, `updateOrder`, `deleteProduct`
- Create `Input` types for all mutation arguments: `CreateUserInput`, `UpdateOrderInput`
- Use `ID` scalar for identifiers — not `Int` or `String`
- Make fields non-nullable by default — add `null` only when absence is meaningful
- Use a `Node` interface with a global `id` field for types that support direct lookup
- Add a top-level `node(id: ID!)` query for refetching any entity by ID
- Keep the schema as the source of truth — generate types from it, not the reverse

## Naming Conventions

- PascalCase for types, interfaces, unions, enums, and input types
- camelCase for fields, arguments, and query/mutation names
- SCREAMING_SNAKE_CASE for enum values: `ORDER_PLACED`, `PAYMENT_FAILED`
- Prefix boolean fields with `is`/`has`/`can`: `isActive`, `hasPermission`, `canEdit`
- Suffix connection types with `Connection` and edge types with `Edge`
- Name mutations as `<verb><Noun>`: `createUser`, `archiveProject`

## Pagination (Relay-Style Connections)

- Use cursor-based pagination with the Connection pattern for all list fields
- Return `Connection` types: `edges`, `pageInfo`, `totalCount`
- Include `pageInfo` with `hasNextPage`, `hasPreviousPage`, `startCursor`, `endCursor`
- Accept `first`/`after` for forward pagination, `last`/`before` for backward
- Never use offset-based pagination — it breaks with concurrent writes

```graphql
type UserConnection {
  edges: [UserEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type UserEdge {
  node: User!
  cursor: String!
}
```

## Error Handling

- Use union types for expected business errors — not top-level `errors` array

```graphql
union CreateUserResult = CreateUserSuccess | ValidationError | DuplicateEmailError

type CreateUserSuccess {
  user: User!
}

type ValidationError {
  message: String!
  field: String!
}
```

- Reserve the top-level `errors` array for unexpected/system errors
- Add `extensions` to errors with `code` field for machine-readable classification
- Use a common `UserError` interface for consistent error handling across mutations
- Return partial data with field-level errors when appropriate

## Performance

- Prevent N+1 queries with DataLoader — batch and cache per-request
- Implement query complexity analysis — reject queries exceeding a cost threshold
- Use persisted queries in production — clients send a hash instead of the query string
- Add `@cacheControl(maxAge:)` directives "for CDN and client cache hints
- Avoid deeply nested queries — set a max depth limit (typically 7-10 levels)
- Use `@defer` and `@stream` for incremental delivery of expensive fields

## Security

- Set a max query depth limit — reject deeply nested queries
- Set a max query complexity limit — assign costs to fields and connections
- Implement field-level authorization in resolvers — not at the gateway level
- Disable introspection in production — enable only in development environments
- Rate limit by query complexity, not just request count
- Validate and sanitize all input types — treat them like user input at a system boundary
- Use `@auth` or custom directives to declare permission requirements on fields

## Subscriptions

- Use subscriptions only for real-time data — prefer polling for infrequent updates
- Scope subscriptions to the minimum data needed — filter server-side
- Return the full updated object in subscription payloads — not just the changed field
- Use a consistent naming pattern: `on<Noun><Event>`: `onOrderUpdated`, `onMessageCreated`

## Tooling & Workflow

- Generate TypeScript/client types from the schema — never hand-write them
- Run schema linting in CI with `graphql-schema-linter` or `graphql-eslint`
- Version the schema — use `@deprecated(reason: "Use fieldX instead")` before removing fields
- Never remove fields without a deprecation period — additive changes are always safe
