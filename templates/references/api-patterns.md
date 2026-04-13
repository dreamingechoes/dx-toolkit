# API Patterns Reference

Quick-reference for REST and GraphQL API design patterns. Skills and prompts reference this when needed.

## REST Conventions

### HTTP Methods

| Method | Purpose          | Idempotent | Safe | Body     |
| ------ | ---------------- | ---------- | ---- | -------- |
| GET    | Read resource(s) | Yes        | Yes  | No       |
| POST   | Create resource  | No         | No   | Yes      |
| PUT    | Replace resource | Yes        | No   | Yes      |
| PATCH  | Partial update   | No         | No   | Yes      |
| DELETE | Remove resource  | Yes        | No   | Optional |

### Status Codes

| Code | When to Use                                    |
| ---- | ---------------------------------------------- |
| 200  | Success with body                              |
| 201  | Resource created (include Location header)     |
| 204  | Success, no body (DELETE, some PUT/PATCH)      |
| 301  | Permanent redirect                             |
| 304  | Not modified (caching)                         |
| 400  | Invalid request (validation error)             |
| 401  | Not authenticated                              |
| 403  | Authenticated but not authorized               |
| 404  | Resource not found                             |
| 409  | Conflict (duplicate, stale update)             |
| 422  | Semantically invalid (business rule violation) |
| 429  | Rate limited                                   |
| 500  | Server error                                   |

### URL Design

```
GET    /users              List users
POST   /users              Create user
GET    /users/:id          Get user
PUT    /users/:id          Replace user
PATCH  /users/:id          Update user
DELETE /users/:id          Delete user
GET    /users/:id/orders   List user's orders
POST   /users/:id/orders   Create order for user
```

Rules:

- Plural nouns for resources (`/users` not `/user`)
- Kebab-case for multi-word resources (`/order-items`)
- Nest only one level deep (`/users/:id/orders`, not `/users/:id/orders/:orderId/items`)
- Use query params for filtering, sorting, paging: `/users?role=admin&sort=-created_at&page=2`

## Pagination Patterns

### Cursor-Based (Recommended)

```json
{
  "data": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6MTAwfQ==",
    "has_more": true
  }
}
```

- Best for: real-time feeds, large datasets, infinite scroll
- Stable: no duplicates or skips when data changes

### Offset-Based

```json
{
  "data": [...],
  "pagination": {
    "page": 2,
    "per_page": 20,
    "total": 156,
    "total_pages": 8
  }
}
```

- Best for: admin dashboards, static data, "page X of Y" UI
- Breaks when data changes between pages

### Keyset-Based

```
GET /users?after_id=100&limit=20
```

- Best for: chronological data, simple cursor without encoding
- Requires consistent ordering

## Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The request body contains invalid fields.",
    "details": [
      {
        "field": "email",
        "code": "INVALID_FORMAT",
        "message": "Must be a valid email address."
      },
      {
        "field": "age",
        "code": "OUT_OF_RANGE",
        "message": "Must be between 13 and 120."
      }
    ]
  }
}
```

Rules:

- Machine-readable `code` + human-readable `message`
- Never expose stack traces, SQL errors, or internal paths
- Include per-field details for validation errors
- Use consistent format across all endpoints

## Versioning Strategies

| Strategy      | URL                                   | Pros             | Cons                |
| ------------- | ------------------------------------- | ---------------- | ------------------- |
| URL path      | `/v1/users`                           | Simple, explicit | URL changes         |
| Header        | `Accept: application/vnd.api.v2+json` | Clean URLs       | Hidden              |
| Query param   | `/users?version=2`                    | Simple           | Clutters params     |
| No versioning | Evolve with backward compat           | Cleanest         | Requires discipline |

Recommendation: URL path versioning (`/v1/`) for public APIs, no versioning for internal APIs evolved with backward compatibility.

## Rate Limiting

Response headers:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1625097600
Retry-After: 30
```

Strategies:

- **Fixed window**: 100 requests per minute (simple, can burst at window edges)
- **Sliding window**: Smooth rate limiting across time
- **Token bucket**: Allow controlled bursts above steady rate
- **Per-user + per-IP**: Authenticated users get higher limits

## Authentication Patterns

| Pattern            | Best For                      | Token Location                         |
| ------------------ | ----------------------------- | -------------------------------------- |
| Bearer token (JWT) | SPAs, mobile apps             | `Authorization: Bearer <token>`        |
| API key            | Server-to-server, third-party | `X-API-Key: <key>` or query param      |
| Session cookie     | Server-rendered apps          | `Cookie: session=<id>`                 |
| OAuth 2.0          | Third-party integrations      | `Authorization: Bearer <access_token>` |

## GraphQL Patterns

### Query Design

```graphql
# Good: specific fields
query GetUser($id: ID!) {
  user(id: $id) {
    id
    name
    email
  }
}

# Bad: over-fetching
query {
  user(id: "1") {
    ...AllUserFields
  }
}
```

### Error Handling (Union Pattern)

```graphql
union CreateUserResult = User | ValidationError | DuplicateEmailError

type Mutation {
  createUser(input: CreateUserInput!): CreateUserResult!
}
```

### N+1 Prevention

- Use DataLoader for batching related queries
- Query complexity analysis to reject expensive queries
- Depth limiting (max 5-7 levels)
- Persisted queries in production

## Caching Headers

```
Cache-Control: public, max-age=3600           # CDN + browser cache for 1 hour
Cache-Control: private, max-age=60            # Browser only, 1 minute
Cache-Control: no-cache                        # Revalidate every time
ETag: "v1-abc123"                              # Version-based revalidation
Last-Modified: Wed, 21 Oct 2023 07:28:00 GMT  # Time-based revalidation
```

## Anti-Patterns

| Anti-Pattern                           | Fix                                |
| -------------------------------------- | ---------------------------------- |
| Using POST for reads                   | Use GET with query params          |
| Returning 200 for errors               | Use proper status codes            |
| Nested URLs 3+ levels deep             | Flatten or use query params        |
| Exposing internal IDs (auto-increment) | Use UUIDs or slugs                 |
| Different error formats per endpoint   | Standardize error schema           |
| No pagination on list endpoints        | Always paginate (default limit 20) |
