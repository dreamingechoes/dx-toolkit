---
description: 'Generate a typed API client from an OpenAPI spec or endpoint definitions. Produces functions with proper types, error handling, and authentication.'
agent: 'agent'
---

Generate a typed API client from the provided API specification or endpoint definitions.

## Procedure

1. **Identify the API source**: OpenAPI/Swagger spec, route files, or manual endpoint list
2. **Detect target language**: TypeScript, Python, Dart, Swift, Kotlin — based on the project
3. **Generate client functions** for each endpoint:
   - Function name derived from `operationId` or `METHOD /path`
   - Request types (path params, query params, body)
   - Response types (success and error)
   - Authentication header injection
4. **Add error handling**: Typed error responses, network errors, timeout handling
5. **Include configuration**: Base URL, auth token, timeout, retry policy

## Rules

- Use the project's existing HTTP client (fetch, axios, ky, httpx, etc.) — don't add a new one
- All parameters and return types must be fully typed — no `any`
- Group endpoints by resource (users, orders, etc.)
- Include JSDoc/docstrings with endpoint description and example usage
- Handle pagination if the API uses cursor or offset pagination
- Export types separately for consumers who only need the types
