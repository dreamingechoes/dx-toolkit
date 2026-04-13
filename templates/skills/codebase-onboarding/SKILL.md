---
name: codebase-onboarding
description: "Generates a codebase overview for onboarding. Use when you need to understand a new project's architecture, conventions, and key files. Produces a structured summary."
---

# Codebase Onboarding

## When to Use

- First time working in a repository
- When you need to understand the project architecture
- Before starting a complex task in an unfamiliar codebase

## Procedure

1. **Read project metadata**:
   - README.md for project overview
   - package.json / mix.exs / Gemfile / requirements.txt for dependencies and scripts
   - Configuration files for the tech stack

2. **Map the architecture**:
   - List top-level directories and their purpose
   - Identify the main entry point(s)
   - Find the routing/controller layer
   - Find the data/model layer
   - Find the business logic layer
   - Identify shared utilities and helpers

3. **Understand conventions**:
   - Code style (linting config, formatters)
   - Test patterns (framework, organization, naming)
   - Git workflow (branch naming, PR templates)
   - Build and deployment (CI/CD config)

4. **Produce the overview**:

```markdown
## Project Overview

**Tech Stack**: [language, framework, database, etc.]
**Type**: [web app, API, library, CLI tool, etc.]

## Architecture

[Brief description of the architecture pattern]

### Directory Structure

- `src/` — [purpose]
- `test/` — [purpose]
- `config/` — [purpose]

### Key Files

- `[file]` — [why it's important]

## Development

**Install**: `[command]`
**Run**: `[command]`
**Test**: `[command]`
**Build**: `[command]`

## Conventions

- [Convention 1]
- [Convention 2]
```
