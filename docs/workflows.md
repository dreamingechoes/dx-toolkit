# ⚙️ Workflows

This toolkit includes 25 AI-powered GitHub Actions workflows. They automate code review, documentation, issue triage, security scanning, and more — all powered by GitHub Copilot CLI.

**Location**: `templates/workflows/`

## Architecture

```
dx-toolkit (source)                    Your Repository
┌──────────────────────┐     copy     ┌────────────────────┐
│ templates/workflows/ │ ──────────►  │ .github/workflows/ │
│  pr-code-reviewer    │              │  pr-code-reviewer  │
│  smart-labeler       │              │  smart-labeler     │
│  ...                 │              │  ...               │
└──────────────────────┘              └────────────────────┘
```

Each workflow is **self-contained** — you copy it directly to your repo's `.github/workflows/` folder. No cross-repo references needed. You own the file and can customize triggers, inputs, and steps directly.

All workflows use the default AI model (`claude-sonnet-4`) and can be customized by editing the workflow file directly.

---

## Workflow Catalog

### 🔍 PR Code Reviewer

`pr-code-reviewer.yml`

**Triggers**: `pull_request` (opened, synchronize)

**What it does**: AI-powered code review that analyzes PR diffs for bugs, security issues, performance problems, and best practice violations. Leaves inline review comments.

---

### 📏 PR Size Checker

`pr-size-checker.yml`

**Triggers**: `pull_request` (opened, synchronize)

**What it does**: Warns about oversized PRs, suggests how to break them down, adds size labels (`size/S`, `size/M`, `size/L`, `size/XL`), and leaves comments for large PRs.

---

### 📚 Continuous Documentation

`continuous-docs.yml`

**Triggers**: `pull_request` (opened, synchronize)

**What it does**: Analyzes PR code changes, detects documentation drift (outdated README, missing API docs), auto-fixes documentation, and pushes a commit to the PR branch.

---

### 🏷️ Smart Labeler

`smart-labeler.yml`

**Triggers**: `issues` (opened, edited), `pull_request` (opened, edited)

**What it does**: Analyzes issue/PR content to assign appropriate labels, removes incorrect ones, and creates new labels when the existing set is insufficient.

---

### ✍️ Issue Quality Enhancer

`issue-quality-enhancer.yml`

**Triggers**: `issues` (opened)

**What it does**: Auto-improves issue titles and bodies — translates to English, adds structure, emoji prefixes, code references, and labels. Makes every issue high-quality regardless of the author's experience.

---

### 🔄 Duplicate Issue Detector

`duplicate-issue-detector.yml`

**Triggers**: `issues` (opened)

**What it does**: Detects potential duplicate issues using AI analysis, labels duplicates, and adds a comment linking to the original issue.

---

### 👋 First Contributor Welcome

`first-contributor-welcome.yml`

**Triggers**: `pull_request_target` (opened), `issues` (opened)

**What it does**: Welcomes first-time contributors with a personalized message, assigns labels (e.g., `first-contribution`), and provides helpful resources and guidelines.

---

### 💡 Copilot Suggester

`copilot-suggester.yml`

**Triggers**: `schedule` (first day of each month at 9:00 UTC)

**What it does**: Scans the entire codebase and generates improvement suggestions across categories: security, performance, refactoring, testing, documentation, architecture, configuration, bugs, maintainability, UX, and README.

---

### 🔒 Security Scanner

`security-scanner.yml`

**Triggers**: `schedule` (Wednesday 6:00 UTC)

**What it does**: AI-powered security analysis that scans for vulnerabilities, misconfigurations, exposed secrets, and best practice violations. Optionally creates issues for findings.

---

### 📋 Release Notes Generator

`release-notes-generator.yml`

**Triggers**: `release` (created)

**What it does**: Auto-generates comprehensive release notes from merged PRs and commits between two tags. Groups changes by category, highlights breaking changes, and lists contributors.

---

### 🧹 Stale Issue Manager

`stale-issue-manager.yml`

**Triggers**: `schedule` (Monday 9:00 UTC)

**What it does**: Identifies stale issues using AI analysis (not just age), nudges maintainers with context-aware messages, and optionally closes truly abandoned issues.

---

### 🏷️✨ Label Beautifier

`label-beautifier.yml`

**Triggers**: `schedule` (quarterly, first day every 3 months at 9:00 UTC)

**What it does**: Modernizes all repository labels — adds emoji prefixes, consistent colors, and descriptions. Supports dry-run mode to preview changes.

---

### Auto Changelog

`auto-changelog.yml`

**Triggers**: `release` (created)

**What it does**: Generates a changelog from merged PRs and commits between releases. Groups entries by type (features, fixes, chores) and formats them for readability.

---

### 📦 Dependency Update Checker

`dependency-update-checker.yml`

**Triggers**: `schedule` (weekly)

**What it does**: Scans for outdated dependencies across your project and creates issues for updates. Detects the package manager automatically or accepts a manual override.

---

### 🔗 Broken Link Checker

`broken-link-checker.yml`

**Triggers**: `push` to main (markdown files)

**What it does**: Scans documentation files for broken internal and external links, then reports them as annotations or comments.

---

### ⚖️ License Compliance

`license-compliance.yml`

**Triggers**: `pull_request`

**What it does**: Checks dependency licenses against configurable allow/deny lists. Fails the check if a dependency uses a denied license and comments with details.

---

### 📊 Code Coverage Report

`code-coverage-report.yml`

**Triggers**: `pull_request`

**What it does**: Runs your test suite, generates a coverage report, and comments on the PR with a coverage summary. Fails if coverage drops below the threshold.

---

### 📝 Conventional Commit Checker

`conventional-commit-checker.yml`

**Triggers**: `pull_request`

**What it does**: Validates that the PR title and all commits follow the Conventional Commits specification. Comments with specific violations and fix suggestions.

---

### 👥 Auto Assign Reviewers

`auto-assign-reviewers.yml`

**Triggers**: `pull_request` (opened)

**What it does**: AI assigns reviewers based on file ownership and recent commit history. Picks the people most familiar with the changed code.

---

### 🧹 Branch Cleanup

`branch-cleanup.yml`

**Triggers**: `pull_request` (closed) + `schedule` (weekly)

**What it does**: Deletes merged and stale branches that haven't seen activity. Respects exclusion patterns so protected branches stay untouched.

---

### 🐳 Container Image Scanner

`container-image-scanner.yml`

**Triggers**: `pull_request` (Dockerfile changes)

**What it does**: Builds the container image and scans it with Trivy for vulnerabilities. Comments on the PR with findings grouped by severity.

---

### 🔄 Monorepo Change Detector

`monorepo-change-detector.yml`

**Triggers**: `pull_request`

**What it does**: Detects which packages changed in a monorepo and outputs the affected list. Downstream jobs can use this to run only the relevant builds and tests.

---

### 📚 API Docs Generator

`api-docs-generator.yml`

**Triggers**: `push` to main (API files)

**What it does**: Generates API documentation from source code annotations and type definitions. Pushes the updated docs to the repository.

---

### ✅ Todo Tracker

`todo-tracker.yml`

**Triggers**: `push` to main

**What it does**: Finds `TODO` and `FIXME` comments in the codebase and creates or updates GitHub issues for each one. Closes issues when the comment is removed.

---

### 📖 Wiki Docs Sync

`wiki-docs-sync.yml`

**Triggers**: `pull_request` closed (merged to main)

**What it does**: When a PR is merged, analyzes the diff and touched files, clones the repository's GitHub Wiki, and creates or updates wiki pages to reflect the changes. Maintains a standard wiki structure (Home, Architecture, API Reference, Configuration, Changelog, etc.) and comments on the merged PR with a summary of wiki updates.

---

## Setup Requirements

All workflows require:

1. **GitHub Copilot CLI** — Installed automatically via `curl -fsSL https://gh.io/copilot-install | bash`
2. **`GH_TOKEN` secret** — A Personal Access Token with appropriate permissions (`repo`, `issues`, `pull_requests`)
3. **Concurrency control** — Every workflow defines a concurrency group to prevent parallel runs on the same PR/issue
4. **Timeout** — Every job has `timeout-minutes` set to prevent runaway jobs

## Installation

See [Installation](installation.md) for detailed setup instructions.

## Tips

- **Start small**: Install `pr-code-reviewer` and `smart-labeler` first — they provide the most immediate value
- **Customize triggers**: Edit the workflow's `on:` section to match your branching strategy
- **Model selection**: Change the default model by editing the `MODEL` env variable in the workflow file
- **Monitor costs**: AI-powered workflows consume Copilot API quota — monitor usage in your GitHub settings
- **Concurrency**: The built-in concurrency groups prevent double-runs, but check your org's concurrent job limits
