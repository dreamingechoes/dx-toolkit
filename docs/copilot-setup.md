# GitHub Copilot Setup

How to use the DX Toolkit with [GitHub Copilot](https://github.com/features/copilot) in VS Code.

## Quick Start

1. Copy the toolkit into your project (see [Installation](installation.md))
2. Copilot automatically reads `.github/copilot-instructions.md` for project-wide context
3. Skills and prompts appear in the `/` slash menu in Copilot Chat

That's it. The DX Toolkit was designed for Copilot first — everything works out of the box.

## What Copilot Uses Automatically

| File                                     | How Copilot Uses It                                  |
| ---------------------------------------- | ---------------------------------------------------- |
| `.github/copilot-instructions.md`        | Auto-loaded as project context for every interaction |
| `.github/agents/*.agent.md`              | Available as `@agent-name` in Copilot Chat           |
| `.github/prompts/*.prompt.md`            | Available via `/prompt-name` in the slash menu       |
| `.github/skills/*/SKILL.md`              | Available via `/skill-name` in the slash menu        |
| `.github/instructions/*.instructions.md` | Auto-attached by file glob or available on-demand    |
| `.github/hooks/*.json`                   | Run automatically on tool use (pre/post)             |

## Lifecycle Slash Commands

The six lifecycle commands are prompts that chain together the right skills:

| Command    | Phase   | What It Does                                      |
| ---------- | ------- | ------------------------------------------------- |
| `/explore` | EXPLORE | Explore ideas, write specs, understand codebase   |
| `/outline` | OUTLINE | Break a spec into ordered, verifiable tasks       |
| `/develop` | DEVELOP | Implement the next task with tests                |
| `/check`   | CHECK   | Debug a failing test or error                     |
| `/polish`  | POLISH  | Review code for correctness, simplicity, security |
| `/launch`  | LAUNCH  | Prepare commits, docs, and deploy                 |

## Agents

Use `@agent-name` to invoke a specialized agent:

```
@bug-fixer Fix the login timeout issue in auth.ts
@test-writer Write tests for the UserService class
@security-fixer Review the API routes for vulnerabilities
```

See [AGENTS.md](../AGENTS.md) for the full list.

## Skills

Invoke skills directly via the slash menu:

```
/code-review        # 4-pass structured code review
/security-audit     # OWASP-based security audit
/api-design         # Design REST APIs from requirements
/issue-to-plan      # Convert issue to implementation plan
/pr-description     # Generate PR description from diff
```

## Instructions

Instructions auto-attach by file type:

- Editing `*.ts` → TypeScript instructions load automatically
- Editing `*.ex` → Elixir instructions load automatically
- Editing `*.css` → CSS instructions load automatically

On-demand instructions (API Design, Accessibility, Git Workflow) can be referenced explicitly.

## Hooks

Hooks run automatically:

- **format-on-edit** — Auto-formats files after Copilot edits them
- **guard-protected-files** — Prevents accidental edits to lock files

## Tips

- **Chain lifecycle commands**: `/explore` → `/outline` → `/develop` → `/check` → `/polish` → `/launch`
- **Combine agents + skills**: `@feature-implementer /explore Design a notification system`
- **Reference checklists**: Mention `.github/references/security-checklist.md` in chat for targeted reviews
- **MCP servers**: Configure GitHub, Fetch, Filesystem, and Memory MCP servers in `.vscode/mcp.json` for extended capabilities
