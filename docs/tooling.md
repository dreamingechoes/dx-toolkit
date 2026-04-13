# 🛠️ Editor & Tooling

Pre-configured editor settings, MCP servers, formatting, and dev containers that make the repo productive from the first `git clone`.

## VS Code Settings (`.vscode/settings.json`)

Applied automatically for anyone who opens the repo in VS Code:

| Setting                        | Value                    | Why                                      |
| ------------------------------ | ------------------------ | ---------------------------------------- |
| `editor.formatOnSave`          | `true`                   | Every save produces formatted code       |
| `editor.defaultFormatter`      | `esbenp.prettier-vscode` | Prettier handles MD, YAML, JSON, CSS     |
| `editor.tabSize`               | `2`                      | Consistent indentation across file types |
| `editor.rulers`                | `[100, 120]`             | Visual guides for line length            |
| `files.trimTrailingWhitespace` | `true`                   | Clean diffs                              |
| `files.insertFinalNewline`     | `true`                   | POSIX compliance                         |
| `files.eol`                    | `\n`                     | LF everywhere, even on Windows           |
| `markdown.validate.enabled`    | `true`                   | Catches broken links in Markdown         |
| `git.autofetch`                | `true`                   | Stay in sync with remote                 |
| `chat.agent.enabled`           | `true`                   | Enable Copilot agent mode                |

---

## Recommended Extensions (`.vscode/extensions.json`)

VS Code prompts to install these on first open:

| Extension                | Purpose                                |
| ------------------------ | -------------------------------------- |
| **Prettier**             | Code formatter for MD, YAML, JSON, CSS |
| **EditorConfig**         | Cross-editor consistent formatting     |
| **YAML**                 | YAML language support + validation     |
| **markdownlint**         | Markdown linting rules                 |
| **GitHub Copilot**       | AI code completion                     |
| **GitHub Copilot Chat**  | AI chat and agent mode                 |
| **GitHub Actions**       | Workflow syntax + validation           |
| **GitHub Pull Requests** | PR review inside VS Code               |
| **GitLens**              | Git blame, history, annotations        |
| **Git Graph**            | Visual branch graph                    |
| **Code Spell Checker**   | Catches typos in code and docs         |
| **Todo Tree**            | Find and track TODOs                   |
| **Error Lens**           | Inline error/warning display           |
| **Path Intellisense**    | Autocomplete file paths                |

---

## MCP Servers (`.vscode/mcp.json`)

### What is MCP?

[Model Context Protocol (MCP)](https://modelcontextprotocol.io/) is an open standard that lets AI agents (like GitHub Copilot) use external tools — browse the web, read files, interact with APIs, control a browser, and more. Each MCP server exposes a set of "tools" that the agent can call during a conversation.

Think of it this way: without MCP, the agent can only read/write files and run terminal commands. **With MCP, the agent gains superpowers** — it can search GitHub issues, fetch documentation from the web, open a browser to debug your app, or remember context across sessions.

### How it works

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   You (VS Code)  │────▶│  Copilot Agent   │────▶│   MCP Server     │
│                  │     │                  │     │  (e.g. GitHub)   │
│  "Find issues    │     │  Decides which   │     │                  │
│   labeled bug"   │     │  MCP tool to use │     │  Calls GitHub API│
│                  │◀────│                  │◀────│  Returns results │
└──────────────────┘     └──────────────────┘     └──────────────────┘
```

1. You ask the agent something in Copilot Chat (agent mode)
2. The agent sees the available MCP tools and decides which one to use
3. The MCP server executes the action (API call, browser action, file read, etc.)
4. The result comes back to the agent, which uses it to answer your question

### Pre-configured servers

This repo includes 7 MCP servers ready to use:

| Server                  | Package                                        | What it does                                                                                     |
| ----------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| **GitHub**              | `@anthropic-ai/github-mcp-server`              | Search code, read/write issues and PRs, list repos, manage labels — anything you do on GitHub    |
| **Fetch**               | `@anthropic-ai/fetch-mcp-server`               | Fetch any URL — documentation pages, API responses, web content — and bring it into the context  |
| **Filesystem**          | `@anthropic-ai/filesystem-mcp-server`          | Read, write, search, and manage files in your workspace (beyond what Copilot can do natively)    |
| **Memory**              | `@anthropic-ai/memory-mcp-server`              | Store and retrieve notes, decisions, and context that persist across conversations               |
| **Sequential Thinking** | `@anthropic-ai/sequential-thinking-mcp-server` | Break down complex problems step by step — helps the agent reason through multi-step tasks       |
| **Playwright**          | `@playwright/mcp`                              | Open a browser, navigate pages, click buttons, fill forms, take screenshots, read console errors |
| **Context7**            | `@upstash/context7-mcp`                        | Look up live documentation for libraries and frameworks — always current, version-aware          |

### First-time setup

1. **Open VS Code** in this repo — the MCP config loads automatically from `.vscode/mcp.json`

2. **Start agent mode** — open Copilot Chat and switch to **Agent** mode (the toggle at the top of the chat panel, or press `Ctrl/Cmd + Shift + I`)

3. **GitHub token** — the first time the agent uses the GitHub MCP server, VS Code will prompt you for a Personal Access Token. Create one at [github.com/settings/tokens](https://github.com/settings/tokens) with these scopes:
   - `repo` — read/write repositories
   - `read:org` — read organization data
   - `read:user` — read user profile

   You can also set it as an environment variable to avoid the prompt:

   ```bash
   export GITHUB_PERSONAL_ACCESS_TOKEN=ghp_your_token_here
   ```

4. **That's it** — the other servers (Fetch, Filesystem, Memory, Sequential Thinking, Playwright, Context7) require no configuration

### Using MCP in practice

Once in agent mode, just ask naturally. The agent will pick the right MCP tool automatically:

**GitHub server — work with issues and PRs:**

```
> Show me all open issues labeled "bug" in this repo
> Create an issue titled "Fix login timeout" with a description of the problem
> What PRs are waiting for review?
```

**Fetch server — pull in external context:**

```
> Read the Tailwind CSS docs for the grid layout utilities
> Fetch the JSON response from https://api.example.com/health
> What does the MDN documentation say about the Intl.DateTimeFormat API?
```

**Playwright server — debug in a real browser:**

```
> Open http://localhost:3000 and tell me if there are any console errors
> Navigate to the login page, fill in test@example.com / password123, and click Submit
> Take a screenshot of the homepage on mobile viewport (375px wide)
> Check if the navigation menu is accessible — tab through all links
```

**Memory server — persist context across sessions:**

```
> Remember that our API uses snake_case for all field names
> What conventions did we decide on for error handling?
> Save a note: the deploy pipeline takes ~8 minutes on average
```

**Sequential Thinking — complex reasoning:**

```
> Think step by step about how to migrate our auth from JWT to session-based
> Break down the architecture for adding real-time notifications to the app
```

**Context7 — live documentation lookup:**

```
> Look up the Context7 docs for Next.js App Router caching behavior
> What does the Stripe API documentation say about subscription webhooks?
> Show me the Tailwind CSS docs for the new container queries feature
```

### Verifying MCP servers are working

Open the **Output** panel in VS Code (`Ctrl/Cmd + Shift + U`) and select **GitHub Copilot Chat** from the dropdown. You'll see MCP server initialization logs when they start.

You can also check in agent mode:

```
> What MCP tools do you have available?
```

The agent will list all available tools from all configured servers.

### Adding more servers

Edit `.vscode/mcp.json` and add a new entry under `servers`:

```json
{
  "servers": {
    "my-server": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@some-org/some-mcp-server@latest"]
    }
  }
}
```

Popular community MCP servers:

| Server                                                                                                               | What it does                |
| -------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| [`@anthropic-ai/brave-search-mcp-server`](https://github.com/brave/brave-search-mcp-server)                          | Web search via Brave Search |
| [`@anthropic-ai/everart-mcp-server`](https://github.com/modelcontextprotocol/servers-archived/tree/main/src/everart) | AI image generation         |
| [`@modelcontextprotocol/server-postgres`](https://github.com/modelcontextprotocol/servers)                           | Query PostgreSQL databases  |
| [`@modelcontextprotocol/server-sqlite`](https://github.com/modelcontextprotocol/servers)                             | Query SQLite databases      |
| [`@modelcontextprotocol/server-slack`](https://github.com/modelcontextprotocol/servers)                              | Read/write Slack messages   |

Browse the full directory at [mcp.so](https://mcp.so/) or [github.com/modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers).

---

## Prettier (`.prettierrc`)

All Markdown, YAML, JSON, and CSS files are formatted consistently via Prettier.

### Commands

```bash
# Format everything
npm run format

# Check without modifying (CI-friendly)
npm run format:check

# Format only specific types
npm run format:md
npm run format:yml
npm run format:json
```

### Configuration

| Option          | Default  | Markdown | YAML  | JSON |
| --------------- | -------- | -------- | ----- | ---- |
| `printWidth`    | 100      | 120      | 100   | 100  |
| `tabWidth`      | 2        | 2        | 2     | 2    |
| `singleQuote`   | true     | —        | false | —    |
| `trailingComma` | all      | —        | —     | none |
| `proseWrap`     | preserve | preserve | —     | —    |

---

## EditorConfig (`.editorconfig`)

Works with any editor that supports [EditorConfig](https://editorconfig.org/) — VS Code, JetBrains, Vim, Sublime, etc.

```ini
[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
```

---

## DevContainer (`.devcontainer/`)

Open the repo in GitHub Codespaces or VS Code with the Dev Containers extension and get a ready-to-use environment.

### What's included

- **Base**: Debian Bookworm with common tools
- **Node.js 22**: For Prettier and MCP servers
- **GitHub CLI**: For `gh` commands
- **Pre-installed extensions**: All recommended extensions
- **Post-create**: Runs `npm install` automatically

### Usage

```bash
# VS Code: open the repo, then
# Ctrl/Cmd + Shift + P → "Dev Containers: Reopen in Container"

# Or use GitHub Codespaces:
# Click "Code" → "Codespaces" → "Create codespace on main"
```

---

## Git Configuration

### `.gitattributes`

Enforces LF line endings across all platforms:

```
* text=auto eol=lf
*.sh text eol=lf
*.png binary
```

### `.gitignore`

Ignores `node_modules/`, `.env`, OS files, editor state, and build artifacts.

---

## Other Pro Files

| File              | Purpose                                              |
| ----------------- | ---------------------------------------------------- |
| `CODEOWNERS`      | Assigns `@dreamingechoes` as default reviewer        |
| `SECURITY.md`     | Security policy with vulnerability reporting process |
| `FUNDING.yml`     | GitHub Sponsors button                               |
| `CONTRIBUTING.md` | Contribution guidelines                              |
| `LICENSE`         | MIT license                                          |
