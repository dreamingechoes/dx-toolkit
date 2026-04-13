---
description: 'YAML coding standards. Auto-attached when editing YAML files. Covers structure, indentation, anchors, multi-document files, and GitHub Actions conventions.'
applyTo: '**/*.yml, **/*.yaml'
---

# YAML Standards

## Formatting

- Use 2-space indentation — never tabs
- Use block style for multi-line strings (`|` for literal, `>` for folded)
- Quote strings that look like booleans or numbers: `"true"`, `"3.14"`, `"yes"`
- Quote strings containing special characters: `:`, `{`, `}`, `[`, `]`, `,`, `&`, `*`, `#`, `?`, `|`, `-`, `<`, `>`, `=`, `!`, `%`, `@`, `` ` ``

## Structure

- Keep files focused — one concern per file when possible
- Use meaningful key names in lowercase kebab-case or snake_case (match the ecosystem)
- Place comments above the key they describe, not inline
- Group related keys together with blank lines between sections
- Prefer explicit `null` over empty values

## Anchors & Aliases

- Use YAML anchors (`&name`) and aliases (`*name`) to avoid repetition
- Use merge keys (`<<: *name`) for shared configuration
- Name anchors descriptively: `&default-settings` not `&a`

## GitHub Actions Specific

- Always quote `on:` trigger values that could be misinterpreted: `"true"`, `"false"`
- Use specific action versions pinned by SHA or tag — not `@main`
- Define `timeout-minutes` on every job
- Use `concurrency` groups to prevent duplicate runs
- Store secrets in GitHub Secrets — never hardcode values

## Multi-Document Files

- Separate documents with `---`
- Use `...` to mark end of document only when followed by non-YAML content
