---
name: context-engineering
description: 'Feed agents the right information at the right time — rules files, context packing, MCP integrations. Use when starting a session, switching tasks, or when agent output quality drops due to missing context.'
---

# Context Engineering

## Overview

Agent output quality is bounded by input context quality. Context engineering is the practice of feeding agents the right information at the right time — not everything, but exactly what's needed for the current task. Too little context produces hallucinations. Too much dilutes attention.

## When to Use

- Starting a new coding session with an AI agent
- Switching between tasks or repositories
- Agent output quality drops (wrong assumptions, missing patterns)
- Setting up a repository for first-time agent use
- Onboarding a team to agent-assisted workflows

**When NOT to use:** The agent already has the right context and is producing good output.

## The Context Stack

Agents consume context from multiple layers. Each layer has a different scope and persistence:

```
┌─────────────────────────────────────┐
│  Layer 5: Conversation              │  ← Ephemeral (this session)
│  Pasted code, error messages, URLs  │
├─────────────────────────────────────┤
│  Layer 4: Skills                    │  ← On-demand (loaded when relevant)
│  SKILL.md files, reference docs     │
├─────────────────────────────────────┤
│  Layer 3: Instructions              │  ← Auto-attached per file type
│  .instructions.md with applyTo      │
├─────────────────────────────────────┤
│  Layer 2: Project Rules             │  ← Always loaded
│  copilot-instructions.md, CLAUDE.md │
├─────────────────────────────────────┤
│  Layer 1: Agent Definition          │  ← Set once per agent
│  .agent.md persona and constraints  │
└─────────────────────────────────────┘
```

## Context Engineering Patterns

### Pattern 1: Rules Files

Place conventions and boundaries in rules files so agents follow them automatically:

| File                              | Tool               | Scope                     |
| --------------------------------- | ------------------ | ------------------------- |
| `.github/copilot-instructions.md` | GitHub Copilot     | All sessions in this repo |
| `CLAUDE.md`                       | Claude Code        | All sessions in this repo |
| `AGENTS.md`                       | Codex, multi-agent | All agents in this repo   |
| `.cursorrules`                    | Cursor             | All sessions in this repo |
| `.windsurfrules`                  | Windsurf           | All sessions in this repo |

Keep rules files concise. They're loaded into every session — bloated rules waste context window on every interaction.

### Pattern 2: Progressive Disclosure

Don't dump everything upfront. Structure context so it loads when needed:

```
Always loaded:   Project conventions, tech stack, boundaries
On file open:    Language-specific rules (.instructions.md with applyTo)
On demand:       Skills (loaded when task matches description)
On request:      Reference checklists, supporting docs
```

### Pattern 3: Context Packing

When starting a task, pack the relevant context into the first message:

```markdown
## Task

[What you're building]

## Relevant Files

- `src/auth/middleware.ts` — Current auth implementation
- `src/types/user.ts` — User type definitions
- `tests/auth/` — Existing auth tests

## Constraints

- Must maintain backward compatibility with v2 API
- Auth tokens expire after 24 hours
- Rate limit: 100 requests/minute per user

## Spec

[Link or paste the relevant spec section]
```

### Pattern 4: MCP Integrations

Model Context Protocol servers extend what agents can access:

| MCP Server     | Provides                                  |
| -------------- | ----------------------------------------- |
| GitHub MCP     | Issues, PRs, repo metadata, file contents |
| Filesystem MCP | Read/write access to local files          |
| Fetch MCP      | Web page content, API responses           |
| Memory MCP     | Persistent notes across sessions          |
| Database MCP   | Schema inspection, query execution        |

Configure MCP servers in `.vscode/settings.json` or the tool's config file. Only enable servers the project actually needs — each server adds to the context window.

### Pattern 5: Session Priming

Start each session with a brief orientation:

```
I'm working on [project]. The stack is [tech stack].
Today I'm implementing [task] from [spec/issue link].
The relevant code is in [directory].
Run tests with [command]. Build with [command].
```

This gives the agent enough context to make good decisions without reading the entire codebase.

## Context Anti-Patterns

| Anti-Pattern                             | Fix                                                                   |
| ---------------------------------------- | --------------------------------------------------------------------- |
| Dumping the entire codebase into context | Reference specific files. Use search to locate relevant code.         |
| Rules file over 200 lines                | Split into separate instruction files with `applyTo` globs.           |
| Repeating the same context every message | Put it in a rules file or instruction file — load it once.            |
| No project rules at all                  | Agent guesses conventions. Create a minimal rules file.               |
| Skills that are 1000+ lines              | Split into SKILL.md (entry point) + supporting reference files.       |
| Ignoring agent mistakes                  | Mistakes often signal missing context. Add the missing info to rules. |

## Setting Up a New Repository

Minimum context setup for any repository:

1. **Create `.github/copilot-instructions.md`** — Tech stack, conventions, build/test commands
2. **Add `.instructions.md` files** — Per-language rules with `applyTo` globs
3. **Add relevant skills** — Copy the skills your workflow uses
4. **Configure MCP servers** — GitHub, Filesystem at minimum
5. **Test the setup** — Ask the agent a question about the project. If it gets the tech stack wrong, your context is insufficient.

## Common Rationalizations

| Rationalization                                         | Reality                                                                                            |
| ------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| "The agent should figure out the context itself"        | Agents can explore, but cold-start exploration wastes tokens and time. Provide the starting point. |
| "I don't need rules files, I'll just tell it each time" | You'll forget. Teammates won't know. Rules files make context persistent and shared.               |
| "More context is always better"                         | Context windows are finite. Irrelevant context dilutes attention and increases hallucination.      |
| "Setting this up takes too long"                        | A 15-minute setup saves hours of correcting agent mistakes across every session.                   |

## Red Flags

- Agent consistently misidentifies the tech stack or patterns
- Agent suggests deprecated APIs or wrong conventions
- You're copy-pasting the same context into every session
- Rules files are so long that agents ignore parts of them
- Skills are never activated because descriptions don't match tasks
- No MCP servers configured for a project that needs external data

## Verification

After setting up context for a repository:

- [ ] A fresh agent session correctly identifies the tech stack
- [ ] The agent follows project conventions without being told
- [ ] Language-specific rules activate when editing the right file types
- [ ] Relevant skills trigger for matching tasks
- [ ] MCP servers provide the external data the project needs
- [ ] The setup works for a teammate who didn't configure it
