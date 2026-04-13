---
description: 'API design standards. Use when designing REST APIs, writing controllers, or implementing endpoints. Covers HTTP methods, status codes, error handling, and pagination.'
---

# API Design Standards

## REST Conventions

- Use nouns for resources: `/users`, `/posts/123/comments`
- Use HTTP methods correctly: GET (read), POST (create), PUT (full replace), PATCH (partial update), DELETE (remove)
- Use plural nouns: `/users` not `/user`
- Nest resources max 2 levels deep: `/users/123/posts` (not `/users/123/posts/456/comments`)

## Status Codes

- `200 OK` — successful GET, PUT, PATCH
- `201 Created` — successful POST (include `Location` header)
- `204 No Content` — successful DELETE
- `400 Bad Request` — invalid input format
- `401 Unauthorized` — missing or invalid authentication
- `403 Forbidden` — authenticated but not authorized
- `404 Not Found` — resource doesn't exist
- `409 Conflict` — resource conflict (duplicate, version mismatch)
- `422 Unprocessable Entity` — valid format but business rule violation
- `429 Too Many Requests` — rate limited
- `500 Internal Server Error` — unexpected server failure

## Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable description",
    "details": [{ "field": "email", "message": "must be a valid email" }]
  }
}
```

## Pagination

- Use cursor-based pagination for feeds/timelines
- Use offset-based only for admin/dashboard UIs
- Include `meta` with total count, next/prev cursors
- Default page size: 20, max: 100

## Request Validation

- Validate all inputs at the API boundary
- Return specific error messages per field
- Reject unknown fields (strict parsing)
- Sanitize strings (trim whitespace, normalize unicode)

## Versioning

- Use URL prefix versioning: `/api/v1/users`
- Or header versioning: `Accept: application/vnd.api.v1+json`
- Never break existing clients without a version bump
