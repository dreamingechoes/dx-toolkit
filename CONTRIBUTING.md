# Contributing to DX Toolkit

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to this project.

## How to Contribute

### Reporting Issues

- Use the [Issues](https://github.com/dreamingechoes/dx-toolkit/issues) tab to report bugs or request features
- Check for existing issues before creating a new one
- Provide as much detail as possible (steps to reproduce, expected vs actual behavior)

### Suggesting New Workflows

We welcome ideas for new AI-powered workflows! When suggesting a new workflow:

1. Open an issue with the title `[Workflow Idea] Your Workflow Name`
2. Describe what the workflow does and when it triggers
3. Explain the value it provides
4. List any special permissions or secrets it needs

### Suggesting New Agents or Skills

We also welcome ideas for custom agents and skills:

1. **Agents**: Open an issue with `[Agent Idea] Your Agent Name`
2. **Skills**: Open an issue with `[Skill Idea] Your Skill Name`
3. Describe the use case and what problems it solves
4. Specify any special tools or MCP servers it needs

### Submitting Changes

1. **Fork** the repository
2. **Create a branch** from `main`:
   ```bash
   git checkout -b feature/my-new-workflow
   ```
3. **Make your changes** following the patterns described below
4. **Run checks locally** before pushing:
   ```bash
   npm run format:check                  # Prettier formatting
   bash scripts/validate-frontmatter.sh  # Frontmatter conventions
   ```
5. **Submit a Pull Request** with a clear description
6. Your PR title must follow [Conventional Commits](https://www.conventionalcommits.org/) — e.g., `feat: add new agent`, `docs: update README`
7. All CI checks must pass before merging

### CI Checks

Every PR runs these automated checks:

- **Format Check** — Prettier on all markdown, YAML, JSON files
- **Validate YAML** — Syntax check on all `.yml`/`.yaml` files
- **Validate JSON** — Syntax check on all `.json` files
- **Validate Shell Scripts** — `bash -n` + ShellCheck on all `.sh` files
- **Validate Frontmatter** — Required fields in agents, skills, prompts, instructions
- **Validate File Structure** — Required files, skill folders, agent naming
- **Conventional Commits Title** — PR title format
- **Auto Labels** — Applied based on changed paths and PR size

## Workflow Development Guidelines

### File Structure

Each new workflow needs:

- A workflow in `templates/workflows/your-workflow.yml`
- An entry in the README.md

### Workflow Template Pattern

Follow this template for new workflows:

```yaml
name: 🎯 Your Workflow Name

on:
  # Add event triggers as needed (push, pull_request, schedule, etc.)
  push:
    branches: [main]

permissions:
  contents: read
  # Add only the permissions your workflow needs

concurrency:
  group: your-workflow-${{ github.run_id }}
  cancel-in-progress: true

jobs:
  your-job:
    name: 🎯 Your Job Name
    runs-on: ubuntu-latest
    timeout-minutes: 15

    steps:
      - name: 📥 Checkout repository
        uses: actions/checkout@v5

      - name: 📦 Install GitHub Copilot CLI
        run: |
          curl -fsSL https://gh.io/copilot-install | bash
          echo "$HOME/.local/bin" >> "$GITHUB_PATH"

      - name: 🎯 Your main step
        env:
          GH_TOKEN: ${{ secrets.COPILOT_PAT || secrets.GITHUB_TOKEN }}
          MODEL: claude-sonnet-4
        run: |
          export PATH="$HOME/.local/bin:$PATH"
          copilot -p "Your prompt here" --allow-all-tools --model "$MODEL"
```

### Best Practices

- **Always include** `timeout-minutes` on jobs (max 15 for most workflows)
- **Always include** `concurrency` groups to prevent duplicate runs
- **Set** `MODEL` as an env variable with `claude-sonnet-4` as the default
- **Use `secrets.COPILOT_PAT || secrets.GITHUB_TOKEN`** for authentication
- **Keep prompts structured** with clear steps and formatting
- **Request minimal permissions** — only what the workflow needs
- **Add icons** to workflow and job names for visual clarity

### Prompt Engineering Tips

When writing Copilot CLI prompts:

- Use clear step-by-step instructions with numbered sections
- Use separator lines (`──────`) between sections for clarity
- Be explicit about what to do and what NOT to do
- Specify output format clearly (especially for comments)
- Always include "Use the GitHub MCP Server to..." for API operations

## Agent Development Guidelines

### File Structure

Each new agent needs:

- An agent file in `templates/agents/your-agent.agent.md`
- An entry in the README.md agents table

### Agent Template

Follow this template for new agents:

```markdown
---
name: your-agent
description: 'Clear, concise description of what this agent does'
tools:
  - read
  - edit
  - search
  - execute
  - 'github/*'
---

# Your Agent Name

You are a [role description]. Your task is to [primary objective].

## Workflow

1. **Step One**: Description
2. **Step Two**: Description
3. **Step Three**: Description

## Constraints

- Constraint one
- Constraint two
```

### Agent Naming Conventions

- Use **kebab-case** for filenames: `my-agent.agent.md`
- The `name` field must match the filename (without `.agent.md`)
- Use clear, action-oriented names: `bug-fixer`, `test-writer`, `docs-updater`

### Tool Selection

Only include the tools your agent actually needs:

| Tool       | Use When                                     |
| ---------- | -------------------------------------------- |
| `read`     | Agent needs to read files                    |
| `edit`     | Agent needs to modify files                  |
| `search`   | Agent needs to search code                   |
| `execute`  | Agent needs to run commands (tests, builds)  |
| `github/*` | Agent needs GitHub API (issues, PRs, labels) |

**Important**: If your agent only reads/writes documentation, omit `execute` to prevent unintended side effects.

### Agent Prompt Best Practices

- Start with a clear role definition ("You are a...")
- Define a step-by-step workflow
- Include explicit constraints (what NOT to do)
- Keep the total prompt under 30,000 characters
- Be specific about output expectations
- Include quality gates (e.g., "verify tests pass before committing")

## Skill Development Guidelines

### File Structure

Each new skill needs:

- A directory in `templates/skills/your-skill/`
- A `SKILL.md` file inside that directory
- An entry in the README.md skills table

### Skill Template

```markdown
---
name: your-skill
description: 'What this skill teaches the agent to do'
---

# Your Skill Name

Brief description of purpose.

## When to Use

- Trigger condition 1
- Trigger condition 2

## Procedure

### Step 1: Title

Description and instructions.

### Step 2: Title

Description and instructions.

## Output Template

\`\`\`markdown
Expected output format
\`\`\`
```

### Skill Best Practices

- Skills should be **self-contained** — all necessary context in the SKILL.md
- Include concrete templates and examples
- Define clear trigger conditions ("When to Use")
- Keep procedures actionable with numbered steps
- The folder name must match the `name` field in frontmatter

## Instruction Development Guidelines

### File Structure

Each new instruction needs:

- A file in `templates/instructions/your-instruction.instructions.md`
- An entry in the README.md instructions section

### Instruction Template

```markdown
---
applyTo: '**/*.ext'
---

# Rule Category

## Rule 1: Title

Description and rationale.

### Do

\`\`\`ext
Good example
\`\`\`

### Don't

\`\`\`ext
Bad example
\`\`\`
```

### Two Kinds of Instructions

1. **Auto-attached** — Uses `applyTo` to activate on matching files:
   ```yaml
   applyTo: '**/*.py'
   ```
2. **On-demand** — Uses `description` for manual invocation:
   ```yaml
   description: 'API design standards. Use when designing REST APIs.'
   ```

One concern per file — don't mix testing rules with API design rules.

### `applyTo` Glob Patterns

| Pattern                    | Matches                         |
| -------------------------- | ------------------------------- |
| `**/*.ts`                  | All TypeScript files            |
| `**/*.tsx, **/*.jsx`       | React component files           |
| `**/migrations/**`         | Any file in a migrations folder |
| `**/Dockerfile*`           | Dockerfiles and variants        |
| `**/*.test.*, **/*.spec.*` | Test files across frameworks    |

### Instruction Best Practices

- Keep instructions concise — they share context window space
- Use concrete "Do" / "Don't" examples
- Focus on patterns the AI consistently gets wrong
- Test by editing a matching file and checking if rules appear in chat

## Reference Development Guidelines

### File Structure

Each new reference needs:

- A markdown file in `templates/references/your-reference.md`
- Entries in skills that reference it (via direct path)

### Reference Template

```markdown
# Reference Title

## Section

- [ ] Checkbox item with actionable criteria
- [ ] Another item — clear pass/fail
```

### When to Create a Reference vs. an Instruction

| Use a **Reference** when...              | Use an **Instruction** when...             |
| ---------------------------------------- | ------------------------------------------ |
| It's a checklist (security, performance) | It's a coding convention (naming, style)   |
| Skills link to it during procedures      | It should auto-activate on file types      |
| It applies across multiple file types    | It targets a specific language / framework |

### Reference Best Practices

- Use checkboxes for actionable items
- Group items into logical sections
- Keep items specific with clear pass/fail criteria
- Cross-reference from relevant skills using the full path

## Code of Conduct

- Be respectful and constructive in all interactions
- Focus on the technical merit of contributions
- Help others learn and improve

## Questions?

Open an issue with the `question` label and we'll be happy to help!
