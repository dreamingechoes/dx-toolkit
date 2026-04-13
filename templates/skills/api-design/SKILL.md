---
name: api-design
description: 'Design a RESTful API from requirements. Use when creating a new API, adding endpoints, or restructuring an existing API. Produces endpoint specifications, schemas, and implementation guidance.'
---

# API Design

## When to Use

- Designing a new API or service
- Adding endpoints to an existing API
- Restructuring or versioning an API
- Creating API documentation from requirements

## Procedure

1. **Identify resources** from the requirements:
   - Map domain concepts to REST resources
   - Determine relationships between resources
   - Identify collections vs. singletons

2. **Design endpoints** for each resource:
   - List (`GET /resources`)
   - Get (`GET /resources/:id`)
   - Create (`POST /resources`)
   - Update (`PUT/PATCH /resources/:id`)
   - Delete (`DELETE /resources/:id`)
   - Actions (`POST /resources/:id/action`)

3. **Define schemas** for each endpoint:
   - Request body (create/update)
   - Response body (single and list)
   - Error responses
   - Query parameters (filters, pagination, sorting)

4. **Add cross-cutting concerns**:
   - Authentication and authorization
   - Pagination strategy (cursor or offset)
   - Rate limiting headers
   - Caching headers
   - CORS configuration

5. **Produce the specification**:

````markdown
## API Specification: [Resource Name]

### Endpoints

#### `GET /api/v1/resources`

List resources with filtering and pagination.

**Query Parameters**:
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `cursor` | string | - | Pagination cursor |
| `limit` | integer | 20 | Items per page (max: 100) |
| `status` | string | - | Filter by status |

**Response** `200 OK`:

```json
{
  "data": [...],
  "meta": {
    "total": 42,
    "next_cursor": "abc123",
    "has_more": true
  }
}
```
````

#### `POST /api/v1/resources`

Create a new resource.

**Request Body**:

```json
{
  "name": "string (required)",
  "description": "string (optional)"
}
```

**Response** `201 Created`:

```json
{
  "data": { "id": "uuid", "name": "...", "created_at": "..." }
}
```

**Errors**:

- `400` — Invalid request body
- `401` — Not authenticated
- `422` — Validation failed

```

## Validation Checklist

- [ ] Every endpoint has a clear purpose
- [ ] HTTP methods match the operation semantics
- [ ] Status codes are correct for each response
- [ ] All inputs are validated
- [ ] Error responses are consistent
- [ ] Pagination is applied to list endpoints
- [ ] Authentication requirements are documented
- [ ] Rate limiting is considered
```
