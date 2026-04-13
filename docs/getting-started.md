# 🚀 Getting Started

Get up and running with dx-toolkit in minutes.

## Prerequisites

- **GitHub Copilot** subscription (Individual, Business, or Enterprise)
- **VS Code** with the GitHub Copilot extension (or JetBrains / Copilot CLI)
- **GitHub Actions** enabled on your repository (for workflows)
- A **Personal Access Token** (`COPILOT_PAT`) with `repo`, `read:org`, and `copilot` scopes (for workflows only)

## Quick Start (5 minutes)

### Step 1: Choose What You Need

Not everything is required. Pick what helps your workflow:

| Want to...                                     | Copy this                                      |
| ---------------------------------------------- | ---------------------------------------------- |
| Get AI coding assistance with best practices   | `agents/` + `instructions/`                    |
| Use task templates (scaffold, test, debug...)  | `prompts/`                                     |
| Automate code formatting and file protection   | `hooks/`                                       |
| Get multi-step procedures (reviews, audits...) | `skills/`                                      |
| Automate issue triage, labeling, reviews       | `workflows/`                                   |
| Standardize issues and PRs                     | `ISSUE_TEMPLATE/` + `PULL_REQUEST_TEMPLATE.md` |
| Set repo-wide Copilot guidelines               | `copilot-instructions.md`                      |

### Step 2: Copy Files to Your Repository

```bash
# Clone this repo
git clone https://github.com/dreamingechoes/dx-toolkit.git

# Navigate to your project
cd your-project

# Create the .github directory structure
mkdir -p .github/{agents,prompts,instructions,skills,hooks/scripts,workflows,ISSUE_TEMPLATE}

# Copy everything (the full toolkit)
cp -r dx-toolkit/templates/agents/* .github/agents/
cp -r dx-toolkit/templates/prompts/* .github/prompts/
cp -r dx-toolkit/templates/instructions/* .github/instructions/
cp -r dx-toolkit/templates/skills/* .github/skills/
cp -r dx-toolkit/templates/hooks/* .github/hooks/
cp dx-toolkit/templates/copilot-instructions.md .github/
cp dx-toolkit/templates/PULL_REQUEST_TEMPLATE.md .github/
cp -r dx-toolkit/templates/ISSUE_TEMPLATE/* .github/ISSUE_TEMPLATE/

# Copy workflow templates
cp dx-toolkit/templates/workflows/*.yml .github/workflows/
```

Or copy only what you need:

```bash
# Just agents and instructions (most common)
cp -r dx-toolkit/templates/agents/* .github/agents/
cp -r dx-toolkit/templates/instructions/* .github/instructions/
cp dx-toolkit/templates/copilot-instructions.md .github/

# Just prompts for quick tasks
cp -r dx-toolkit/templates/prompts/* .github/prompts/
```

### Step 3: Customize for Your Stack

1. **Edit `copilot-instructions.md`** — update the project description, tech stack, and conventions
2. **Remove irrelevant instructions** — if you don't use React, delete `react.instructions.md`
3. **Remove irrelevant agents** — keep only the agents for your tech stack
4. **Adjust hook scripts** — update formatter commands to match your project

### Step 4: Set Up Secrets (for Workflows Only)

If you're using the GitHub Actions workflows:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Add `COPILOT_PAT` with your Personal Access Token

### Step 5: Verify

Open VS Code in your project and:

1. Open Copilot Chat → type `/` → you should see prompts and skills in the list
2. Check the agent dropdown → you should see your agents
3. Edit a file → the relevant instruction should load automatically
4. Open a terminal → hooks should run on agent edits

## What Happens Automatically

Once installed, here's what kicks in:

| Trigger                        | What Happens                                               |
| ------------------------------ | ---------------------------------------------------------- |
| You open Copilot Chat          | Repo-wide instructions load from `copilot-instructions.md` |
| You edit a `.ts` file          | TypeScript instructions auto-attach                        |
| You edit a `.py` file          | Python instructions auto-attach                            |
| You edit a `.go` file          | Go instructions auto-attach                                |
| You edit a `.vue` file         | Vue instructions auto-attach                               |
| You type `/` in chat           | Prompts and skills appear as options                       |
| Agent edits a file             | Hook auto-formats the file                                 |
| Agent tries to edit a lockfile | Hook asks for confirmation                                 |
| Someone opens an issue         | Workflows triage, label, and enhance it                    |
| Someone opens a PR             | Workflows review code and check PR size                    |
| A PR is opened                 | Conventional commit checker + auto-assign reviewers run    |
| Weekly schedule                | Dependency update checker + branch cleanup run             |

## Architecture-Aware Quick Start

The toolkit adapts to different project shapes. Here's what to focus on depending on your setup.

### Monorepo Projects

Run the bootstrap script with monorepo architecture selected. This gives you:

- **monorepo-change-detector** workflow — only runs CI for packages that changed
- **monorepo.instructions.md** — auto-attaches when you edit workspace config files
- Per-package instruction scoping so each package gets its own rules

Use the `monorepo-setup` skill to configure Turborepo, Nx, or pnpm workspaces from scratch.

See [Monorepo Guide](monorepo-guide.md) for the full walkthrough.

### Mobile Projects

Run the bootstrap script with your mobile framework (React Native/Expo, Flutter, Swift, or Kotlin). You get:

- **react-native-expert**, **expo-expert**, **flutter-expert**, **swift-expert**, or **kotlin-expert** agents
- **mobile-release** and **mobile-testing** skills for App Store/Play Store submissions
- Platform-specific instructions that auto-attach to `.swift`, `.kt`, or `.dart` files

See [Mobile Guide](mobile-guide.md) for platform-specific workflows.

### API / Backend Projects

Focus on these components:

- **backend-expert** agent for architecture decisions
- **api-design** skill for endpoint specifications
- **security-audit** skill for vulnerability checks
- **pr-code-reviewer** and **security-scanner** workflows for automated PR checks

See [Architecture](architecture.md) for how the toolkit components compose.

### Full-Stack SPA

Combine frontend and backend agents:

- **frontend-expert** + **backend-expert** for architecture across the stack
- **nextjs-expert**, **vue-expert**, **svelte-expert**, or the relevant framework agent
- **pr-code-reviewer** and **continuous-docs** workflows for quality gates
- TypeScript, React, or Vue instructions auto-attach based on file type

---

## Next Steps

- Read [Agents](agents.md) to understand which agent to use for each task
- Read [Prompts](prompts.md) to learn the available task templates
- Read [Customization](customization.md) to adapt the toolkit to your stack
- Read [Architecture](architecture.md) to see how the toolkit components compose
- Read [Mobile Guide](mobile-guide.md) for mobile development workflows
- Read [Monorepo Guide](monorepo-guide.md) for monorepo setup and management
- Read [FAQ](faq.md) for common questions answered
- Read [Recipes](recipes/README.md) for step-by-step guides for common setups
