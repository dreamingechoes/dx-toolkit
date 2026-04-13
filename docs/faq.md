# ❓ FAQ

Answers to common questions about the toolkit.

---

## Getting Started

### Can I use this with any programming language?

Yes. The toolkit is language-agnostic at its core. Skills, prompts, and most agents work regardless of your tech stack. Language-specific features come from instruction files (e.g., `python.instructions.md`) and specialized agents (e.g., `python-expert`). If your language doesn't have a dedicated instruction file, the general coding principles still apply.

### Do I need GitHub Copilot?

You need GitHub Copilot for the agents, prompts, instructions, and skills — they run inside Copilot Chat in VS Code (or JetBrains). The GitHub Actions workflows use Copilot's API through the `COPILOT_PAT` secret.

You can still use the reference checklists, PR templates, and issue templates without Copilot.

### Does this work with Cursor?

Partially. Cursor supports instruction files and can read agent definitions, but the integration isn't as tight as VS Code with GitHub Copilot. See the [Cursor setup guide](cursor-setup.md) for details on what works and what needs workarounds.

### Does this work with Windsurf?

Similar to Cursor — partial support. See the [Windsurf setup guide](windsurf-setup.md) for specifics.

### Does this work with Claude Code?

Yes. Claude Code reads `CLAUDE.md` at the repository root, which references the toolkit's structure and conventions. Skills and instruction content work as context. See the [Claude setup guide](claude-setup.md).

### Can I use only parts of the toolkit?

Absolutely. Every component is independent. Copy just the agents you want, just the instructions for your stack, or just the workflows. The [Getting Started guide](getting-started.md) has a table showing which directories to copy for different needs.

### How do I install it?

Three options:

1. **Bootstrap script** — Run `bash scripts/bootstrap.sh` for an interactive setup that picks components for your stack.
2. **Manual copy** — Copy the `.github/` directory (or parts of it) into your project.
3. **Cherry-pick** — Copy individual files you want.

See the [Installation guide](installation.md) for detailed instructions.

---

## Agents

### How do agents work?

Agents are `.agent.md` files in `.github/agents/`. Each file defines a persona with specialized knowledge, a description, and tool permissions. When you mention an agent in Copilot Chat (`@agent-name`), it activates that persona with its domain expertise.

### Can I create my own agent?

Yes. Create a new `.agent.md` file in `.github/agents/`. The minimum required fields are:

```yaml
---
name: my-custom-agent
description: 'Describe what this agent does'
tools: ['read', 'edit', 'search', 'execute', 'github/*']
---
Your agent's prompt and instructions here.
```

### Can agents call other agents?

Not directly. An agent can't invoke another agent within a single conversation. You can chain agents manually by asking one agent for a plan, then asking another to implement it.

### Which agent should I use?

- **For bugs**: `@bug-fixer`
- **For new features**: `@feature-implementer`
- **For code quality**: `@refactorer`, `@performance-optimizer`, `@security-fixer`
- **For tests**: `@test-writer`, `@tdd-expert`
- **For a specific language/framework**: Use the matching expert (e.g., `@python-expert`, `@react-expert`)
- **For docs**: `@docs-updater`, `@docs-humanizer`

### Do agents work in GitHub Issues?

Yes. With Copilot coding agent enabled, you can assign an agent to a GitHub issue. The agent reads the issue, creates a branch, makes changes, and opens a PR.

### What tools do agents have access to?

By default, agents can: read files, edit files, search the codebase, run terminal commands, and interact with GitHub (issues, PRs, etc.). You can restrict tools per agent in the agent definition.

---

## Skills

### What's the difference between a skill and a prompt?

A **prompt** handles a single task — it's a one-shot action like "write tests" or "create a Dockerfile." A **skill** is a multi-step procedure with decision points, templates, and structured output — like "perform a full security audit" or "set up a monorepo from scratch."

Prompts often invoke skills. The `/polish` prompt can use the `code-review`, `security-audit`, or `performance-optimization` skill depending on context.

### How do I invoke a skill?

Skills are invoked through prompts or by asking an agent to follow a skill:

```
# Through a lifecycle prompt
/explore

# By asking an agent to use a specific skill
@feature-implementer Use the incremental-implementation skill to build the checkout flow

# By referencing the skill directly
Use the code-review skill to review the changes in this PR
```

### Can I create my own skill?

Yes. Create a folder at `.github/skills/your-skill-name/` with a `SKILL.md` file inside. The skill needs frontmatter with `name` and `description`, plus structured content with steps and templates. See [Skill Anatomy](skill-anatomy.md) for the full spec.

### Do skills work outside VS Code?

Skills are markdown files with structured procedures. Any AI tool that can read files can follow a skill's instructions. They work with Claude Code, Cursor, and other AI assistants that read repository files.

---

## Workflows

### Do workflows cost money?

GitHub Actions has a free tier (2,000 minutes/month for free accounts, 3,000 for Pro). Workflows that call Copilot's API require a `COPILOT_PAT` with a Copilot subscription. The Copilot API calls count against your Copilot usage, not your Actions minutes.

### Can I use a different AI model?

Yes. Each workflow has a `MODEL` env variable that defaults to `claude-sonnet-4`. To change the model, edit the workflow file and update the `MODEL` value in the step's `env:` section:

```yaml
- name: 🔍 Review
  env:
    MODEL: gpt-4o # Change from default claude-sonnet-4
```

### How do I set up the COPILOT_PAT secret?

1. Go to [GitHub Settings → Developer Settings → Personal Access Tokens](https://github.com/settings/tokens)
2. Create a token with `repo`, `read:org`, and `copilot` scopes
3. In your repository, go to **Settings → Secrets and variables → Actions**
4. Add a new secret named `COPILOT_PAT` with the token value

### Can I disable specific workflows?

Yes. Delete the workflow file from your `.github/workflows/` directory. Or disable the workflow from the GitHub Actions UI without deleting the file.

### Why does my workflow fail with "Resource not accessible by integration"?

The workflow needs proper permissions. Check that:

- The `COPILOT_PAT` secret is set and hasn't expired
- The token has the required scopes
- The repository has GitHub Actions enabled in Settings → Actions → General

---

## Customization

### How do I add my own coding rules?

Create a new `.instructions.md` file in `.github/instructions/`. Use `applyTo` for rules that auto-attach to specific file types:

```yaml
---
applyTo: '**/*.py'
---
# Python Project Rules

- Use pydantic for all API request/response models
- Run black with line-length 100
```

Or use `description` for rules you invoke manually with `#`:

```yaml
---
description: 'Our API versioning conventions'
---
```

### Can I remove components I don't need?

Yes. Delete any files or directories you don't want. No component depends on another for basic operation. If you remove all agents, prompts and instructions still work. If you remove instructions, agents still work (they just won't have file-type-specific rules).

### How do I override a built-in instruction?

Edit the instruction file directly. Or delete it and create your own with the same `applyTo` pattern. The toolkit is meant to be modified — it's a starting point, not a locked framework.

### Can I use this with an existing .github directory?

Yes. The toolkit creates files in subdirectories (`agents/`, `prompts/`, `instructions/`, etc.) that likely don't conflict with your existing setup. Copy only the subdirectories you want. If you already have a `copilot-instructions.md`, merge the content rather than overwriting.

### How do I update the toolkit?

Pull the latest version of the toolkit repository and copy the updated files. The bootstrap script (`scripts/bootstrap.sh`) can be run again — it won't overwrite files without asking.

---

## Troubleshooting

### My agent isn't responding

Check these in order:

1. **Is GitHub Copilot active?** Look for the Copilot icon in VS Code's status bar.
2. **Is the agent file in the right location?** It must be at `.github/agents/agent-name.agent.md`.
3. **Does the file have valid frontmatter?** The YAML between `---` markers must be valid.
4. **Are you using the right syntax?** Type `@agent-name` in Copilot Chat.

See the [Troubleshooting guide](troubleshooting.md) for more details.

### My instruction isn't auto-attaching

The most common causes:

1. **Wrong glob pattern.** Test your `applyTo` glob at [globster.xyz](https://globster.xyz/).
2. **File isn't in the workspace.** The file you're editing must be inside the VS Code workspace.
3. **YAML frontmatter syntax error.** Check for missing quotes around glob patterns with special characters.

### My workflow keeps failing

Check these:

1. **Secrets configured?** Go to Settings → Secrets and variables → Actions.
2. **Token expired?** Personal Access Tokens expire. Regenerate if needed.
3. **Permissions sufficient?** Check the workflow's `permissions:` block matches what it needs.
4. **Model available?** If you changed the `MODEL` env variable, make sure that model is available on your Copilot plan.

### A hook is blocking my actions

Hooks run before or after tool use. If a hook is too strict:

1. **Check the hook config** in `.github/hooks/*.json` for the matching pattern.
2. **Check the script** in `.github/hooks/scripts/` for the validation logic.
3. **Temporarily disable** by moving the `.json` config file out of the `hooks/` directory.

### The slash menu doesn't show my prompt

Prompts need valid frontmatter with a `description` field to appear in the `/` menu:

```yaml
---
description: 'What this prompt does'
---
```

Reload VS Code (`Cmd+Shift+P` → "Reload Window") after adding new prompt files.
