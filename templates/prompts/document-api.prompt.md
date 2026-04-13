---
description: 'Generate API documentation from code annotations, route definitions, or an OpenAPI spec. Produces markdown docs with endpoints, parameters, and examples.'
agent: 'agent'
---

Generate complete API documentation for this project.

## Procedure

1. **Scan for API definitions**: Look for route files, controllers, handlers, or OpenAPI/Swagger specs
2. **Extract endpoint metadata**: Method, path, parameters, request body, response types, auth requirements
3. **Generate documentation** for each endpoint:
   - HTTP method and path
   - Description of what it does
   - Path parameters, query parameters, request body schema
   - Response schema (success and error)
   - Authentication requirements
   - Example request and response (curl + JSON)
4. **Organize by resource**: Group related endpoints together
5. **Add overview section**: Base URL, authentication method, rate limits, error format

## Output Format

```markdown
## [Resource Name]

### [METHOD] /path

[Description]

**Parameters:**
| Name | In | Type | Required | Description |
|------|-----|------|----------|-------------|

**Request Body:**
\`\`\`json
{ "example": "value" }
\`\`\`

**Response (200):**
\`\`\`json
{ "example": "response" }
\`\`\`
```

## Rules

- Include curl examples for every endpoint
- Document error responses, not just success
- Note which endpoints require authentication
- Use realistic example values, not "string" or "0"
