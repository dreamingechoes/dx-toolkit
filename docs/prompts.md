# 💬 Prompts

Prompts are reusable task templates you invoke on-demand via the `/` slash menu in Copilot Chat. Each prompt handles a single, focused task with clear inputs and outputs.

**Location**: `templates/prompts/*.prompt.md`

## How Prompts Work

1. Open Copilot Chat in VS Code
2. Type `/` to see available prompts (and skills)
3. Select a prompt
4. Provide context (select code, describe the task, or paste data)
5. The prompt guides Copilot to produce structured, high-quality output

### Prompt Anatomy

```yaml
---
description: 'What this prompt does — used for discovery'
agent: 'agent' # Run in agent mode (can use tools)
tools: [read, search] # Optional: specific tools needed
---
Instructions for what to do and how to do it.
```

---

## Available Prompts

### 🧩 Scaffold Component (`/scaffold-component`)

**Purpose**: Generates a complete UI component with types, styles, tests, and documentation. Detects framework from the codebase.

**Input**: Describe the component you need (name, behavior, props).

**What it generates**:

- Component file with typed props or documented parameters
- Style file matching the project's approach (CSS Modules, Tailwind, SCSS, etc.)
- Test file
- Documentation or story file if the project uses component docs
- Index/barrel export if the project uses them

**Example**:

```
/scaffold-component Create a `UserAvatar` component that displays a user's
profile picture with fallback to initials. Supports sizes: sm, md, lg.
```

---

### 🧪 Write Tests (`/write-tests`)

**Purpose**: Generates comprehensive tests for selected code — happy paths, edge cases, and error scenarios.

**Input**: Select the code you want to test, or describe the function/module.

**What it generates**:

- Test file using the project's testing framework
- Happy path tests
- Edge case tests (empty, null, boundary values)
- Error scenario tests
- Integration tests where appropriate

**Example**:

```
/write-tests [select a function in the editor]
```

---

### 📖 Explain Code (`/explain-code`)

**Purpose**: Explains complex code in plain language — algorithms, patterns, data flows, and design decisions.

**Input**: Select the code you want explained.

**What it produces**:

- One-paragraph summary
- Step-by-step logic walkthrough
- Pattern identification
- Complexity analysis
- Potential improvement opportunities

**Example**:

```
/explain-code [select a complex function]
```

---

### ♻️ Refactor Function (`/refactor-function`)

**Purpose**: Refactors code to improve readability and maintainability while preserving exact behavior.

**Input**: Select the code to refactor, or describe what needs improvement.

**What it produces**:

- Refactored code
- Summary of changes and reasoning
- Risk notes for manual verification

**Example**:

```
/refactor-function This function has too many responsibilities and deep nesting
```

---

### 🔌 Create API Endpoint (`/create-api-endpoint`)

**Purpose**: Creates a complete REST API endpoint with routing, validation, error handling, and tests.

**Input**: Describe the endpoint (resource, method, behavior).

**What it generates**:

- Route/controller
- Input validation
- Service/logic layer
- Error handling
- Tests
- Example request/response

**Example**:

```
/create-api-endpoint POST /api/v1/invitations — send an invite email to a user,
requires auth, validates email format, prevents duplicate invites
```

---

### 🗃️ Write Migration (`/write-migration`)

**Purpose**: Creates a safe, reversible database migration with zero-downtime considerations.

**Input**: Describe the schema change.

**What it generates**:

- Migration file (up + down)
- Safety checks (reversibility, locking, defaults)
- Zero-downtime notes

**Example**:

```
/write-migration Add a `role` column to the users table with values
'user', 'admin', 'moderator', defaulting to 'user'
```

---

### 🐳 Create Dockerfile (`/create-dockerfile`)

**Purpose**: Creates an optimized, secure multi-stage Dockerfile with caching and production best practices.

**Input**: Describe your application (or let it auto-detect from the codebase).

**What it generates**:

- Multi-stage Dockerfile with comments
- `.dockerignore` file
- `docker-compose.yml` for local development
- Build and run commands

**Example**:

```
/create-dockerfile for a Phoenix 1.8 app with Tailwind CSS and PostgreSQL
```

---

### 🔒 Review Security (`/review-security`)

**Purpose**: Reviews code for security vulnerabilities following OWASP Top 10.

**Input**: Select code to review, or point to a file/module.

**What it produces**:

- Findings categorized by severity (🔴 Critical / 🟡 Warning / 🔵 Info)
- Location, issue description, and fix suggestion for each finding
- No code modifications — report only

**Example**:

```
/review-security [select an authentication module]
```

---

### 📐 Generate Types (`/generate-types`)

**Purpose**: Generates type definitions, schemas, or data structures from data or descriptions. Works with any typed language.

**Input**: Sample JSON, API response, database schema, or description.

**What it generates**:

- Type definitions in the project's language (TypeScript, Python, Elixir, Go, etc.)
- Validation schemas if applicable (Zod, Pydantic, Ecto, etc.)
- Usage examples

**Example**:

```
/generate-types Generate types for this API response:
{ "id": "uuid", "name": "string", "email": "string", "role": "admin" | "user", "created_at": "ISO8601" }
```

---

### 🐛 Debug Error (`/debug-error`)

**Purpose**: Analyzes an error message or stack trace to identify the root cause and provide a fix.

**Input**: Paste the error message, stack trace, or describe the symptom.

**What it produces**:

- Root cause analysis (What, Where, When, Why)
- Code fix with explanation
- Prevention advice (how to avoid this class of bug)

**Example**:

```
/debug-error TypeError: Cannot read properties of undefined (reading 'map')
  at UserList (src/components/UserList.tsx:23:18)
```

---

### ⚡ Optimize Query (`/optimize-query`)

**Purpose**: Optimizes a slow database query with indexing, restructuring, and caching suggestions.

**Input**: The query (SQL or any ORM) and optionally the explain plan.

**What it produces**:

- Optimized query with explanation
- Recommended indexes with `CREATE INDEX` statements
- N+1 detection and fix
- Performance impact estimates

**Example**:

```
/optimize-query This Ecto query is slow on a table with 2M rows:
from p in Post, where: p.status == "published", order_by: [desc: p.created_at], preload: [:author, :tags]
```

---

### 📝 Commit Message (`/commit-message`)

**Purpose**: Generates a Conventional Commits message from the current staged changes.

**Input**: Stage your changes with `git add`, then invoke the prompt.

**What it produces**:

- Formatted commit message with type, scope, and description
- Body explaining what and why
- Footer with issue references
- Suggestion to split if changes are too large for one commit

**Example**:

```
/commit-message
```

---

### 🔍 Refine Issue (`/refine-issue`)

**Purpose**: Rewrites a vague or incomplete issue into a well-structured, actionable format.

**Input**: A GitHub issue (pasted text or issue number).

**What it does**:

1. Reads the original issue
2. Identifies missing elements: repro steps, acceptance criteria, context
3. Infers what it can without inventing requirements
4. Rewrites using a structured template (Summary, Context, Current/Expected Behavior, Acceptance Criteria)
5. Flags anything that still needs clarification

**Output**: Structured issue with Summary, Context, Expected Behavior, Acceptance Criteria, and Notes.

**Example**:

```
/refine-issue The login page is broken sometimes
```

---

## Tips

- **Combine with selection**: Select code in the editor before invoking a prompt for targeted results
- **Chain prompts**: Use `/write-tests` after `/create-api-endpoint` to get full coverage
- **Customize**: Edit the prompt files to match your team's conventions
- **Create your own**: See [Customization](customization.md) for creating custom prompts
