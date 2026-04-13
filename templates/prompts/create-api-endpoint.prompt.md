---
description: 'Create a REST API endpoint with proper routing, validation, error handling, and documentation. Use for backend development in any framework.'
agent: 'agent'
---

Create a complete API endpoint based on the user's description.

## Procedure

1. **Detect the framework** (Phoenix, Express, Next.js API routes, FastAPI, etc.)
2. **Follow existing patterns** — match the project's routing, controller, and service structure
3. **Generate**:
   - Route/controller with proper HTTP method and path
   - Input validation (params, query, body)
   - Service/business logic layer (if the project separates concerns)
   - Error handling with appropriate HTTP status codes
   - Response serialization/formatting
   - Tests for the endpoint

## API Design Rules

- Use proper HTTP methods (GET for reads, POST for creates, PUT/PATCH for updates, DELETE for deletes)
- Return appropriate status codes (200, 201, 204, 400, 401, 403, 404, 422, 500)
- Validate all inputs at the boundary — never trust user data
- Use consistent error response format matching the project's convention
- Include pagination for list endpoints
- Use proper content types (application/json)

## Output

- All generated files with clear explanations
- Example request/response for the endpoint
- Notes on authentication/authorization if applicable
