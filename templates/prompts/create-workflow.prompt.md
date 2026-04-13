---
description: 'Generate a GitHub Actions workflow from requirements. Specify triggers, jobs, and automation goals — get a production-ready workflow file.'
agent: 'agent'
---

Generate a GitHub Actions workflow based on the described requirements.

## Procedure

1. **Clarify requirements**: Identify what triggers the workflow, what it does, and what outputs/side effects it produces
2. **Choose the right triggers**: `push`, `pull_request`, `schedule`, `workflow_dispatch`, `release`, or a combination
3. **Design the job structure**: Single job or multi-job with dependencies
4. **Generate the workflow YAML** following these conventions:
   - Include emoji prefix in `name:`
   - Add `timeout-minutes` to every job
   - Add `concurrency` group to prevent duplicate runs
   - Pin action versions (e.g., `actions/checkout@v5`)
   - Use `secrets: inherit` pattern when appropriate

## Rules

- Every workflow sets `MODEL` as an env variable defaulting to `claude-sonnet-4` for AI-powered steps
- Use 2-space YAML indentation
- Quote strings that contain special YAML characters
- Use `${{ }}` for expressions, not shell interpolation for GitHub context
- Cache dependencies where possible (`actions/cache` or built-in caching)
- Use `--frozen-lockfile` or equivalent for reproducible installs
