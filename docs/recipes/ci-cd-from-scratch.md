# CI/CD from Scratch

Set up a full CI/CD pipeline using the DX Toolkit's workflow library.

## What the Toolkit Provides

The toolkit ships 25 self-contained GitHub Actions workflows in `templates/workflows/`. Copy the ones you need into your repo's `.github/workflows/` directory.

Here's the full catalog:

### PR Quality

| Workflow                      | Trigger           | What it does                         |
| ----------------------------- | ----------------- | ------------------------------------ |
| `pr-size-checker`             | PR opened/updated | Flags large PRs (>400 lines)         |
| `pr-code-reviewer`            | PR opened/updated | AI-powered code review               |
| `conventional-commit-checker` | PR opened/updated | Enforces Conventional Commits format |

### Security

| Workflow                  | Trigger                   | What it does                            |
| ------------------------- | ------------------------- | --------------------------------------- |
| `security-scanner`        | PR opened + push to main  | Scans for security vulnerabilities      |
| `container-image-scanner` | Push (Dockerfile changes) | Scans Docker images for CVEs            |
| `license-compliance`      | PR opened                 | Checks dependency license compatibility |

### Documentation

| Workflow              | Trigger             | What it does                                  |
| --------------------- | ------------------- | --------------------------------------------- |
| `auto-changelog`      | Release created     | Generates CHANGELOG from Conventional Commits |
| `api-docs-generator`  | Push to main        | Generates API docs from code/OpenAPI specs    |
| `broken-link-checker` | Push to main (docs) | Finds broken links in markdown/HTML           |
| `continuous-docs`     | PR opened/updated   | Builds and deploys documentation              |
| `wiki-docs-sync`      | PR merged to main   | Syncs documentation to GitHub wiki            |

### Code Quality

| Workflow               | Trigger          | What it does                                   |
| ---------------------- | ---------------- | ---------------------------------------------- |
| `code-coverage-report` | PR opened        | Generates coverage report, comments on PR      |
| `todo-tracker`         | Push to main     | Finds TODO/FIXME/HACK comments, creates issues |
| `copilot-suggester`    | Monthly schedule | Suggests improvements using Copilot            |

### Maintenance

| Workflow                    | Trigger         | What it does                             |
| --------------------------- | --------------- | ---------------------------------------- |
| `stale-issue-manager`       | Daily schedule  | Labels and closes stale issues/PRs       |
| `branch-cleanup`            | PR merged       | Deletes merged branches                  |
| `dependency-update-checker` | Weekly schedule | Reports outdated/vulnerable dependencies |

### Issue & PR Management

| Workflow                    | Trigger            | What it does                              |
| --------------------------- | ------------------ | ----------------------------------------- |
| `auto-assign-reviewers`     | PR opened          | Assigns reviewers based on file expertise |
| `smart-labeler`             | PR/issue opened    | Auto-labels based on content and files    |
| `duplicate-issue-detector`  | Issue opened       | Finds potential duplicate issues          |
| `issue-quality-enhancer`    | Issue opened       | Adds missing context to issues            |
| `first-contributor-welcome` | First PR           | Welcomes new contributors                 |
| `label-beautifier`          | Quarterly schedule | Standardizes label colors/descriptions    |

### Specialized

| Workflow                   | Trigger         | What it does                            |
| -------------------------- | --------------- | --------------------------------------- |
| `monorepo-change-detector` | PR opened       | Detects which monorepo packages changed |
| `release-notes-generator`  | Release created | Generates release notes                 |

## Step 1: Copy Workflows

Each workflow is a self-contained template in `templates/workflows/`. Copy the ones you need:

```bash
# From the dx-toolkit directory (or wherever you cloned it)
DX_TOOLKIT="/path/to/dx-toolkit"

# Copy specific workflows
cp $DX_TOOLKIT/templates/workflows/pr-size-checker.yml .github/workflows/
cp $DX_TOOLKIT/templates/workflows/pr-code-reviewer.yml .github/workflows/
```

Or use the bootstrap script with the **CI/CD Workflows** extra selected — it copies all workflows at once.

## Step 2: Configure Secrets

Most workflows need only the default `GITHUB_TOKEN` — no extra secrets required.

### AI-powered workflows

Workflows that use AI (code reviewer, copilot suggester, issue quality enhancer) need model access. The default model is `claude-sonnet-4`.

If your organization restricts model access, check:

1. GitHub Copilot is enabled for the repository
2. The model specified in the workflow is accessible

### Optional secrets

Some workflows accept optional configuration:

| Workflow                    | Secret/Variable                 | Purpose                            |
| --------------------------- | ------------------------------- | ---------------------------------- |
| `container-image-scanner`   | None — uses Trivy (open source) |                                    |
| `auto-changelog`            | `GITHUB_TOKEN` (default)        | Commits changelog to repo          |
| `dependency-update-checker` | `GITHUB_TOKEN` (default)        | Creates issues for vulnerable deps |

## Step 3: Essential Pipeline

Start here. These three workflows catch the most common PR quality issues.

```bash
cp templates/workflows/pr-size-checker.yml .github/workflows/
cp templates/workflows/pr-code-reviewer.yml .github/workflows/
cp templates/workflows/conventional-commit-checker.yml .github/workflows/
```

**What you get:**

- PRs over 400 lines get flagged with a warning label
- Every PR gets an AI code review comment with actionable suggestions
- PR titles must follow `type(scope): description` format (e.g., `feat(auth): add password reset`)

**Commit and test:**

```bash
git add .github/workflows/
git commit -m "ci: add essential PR quality workflows"
git push
```

Open a test PR to confirm all three workflows trigger and pass.

## Step 4: Security Pipeline

Add security scanning to catch vulnerabilities early.

```bash
cp templates/workflows/security-scanner.yml .github/workflows/
cp templates/workflows/license-compliance.yml .github/workflows/
```

If you use Docker, also add:

```bash
cp templates/workflows/container-image-scanner.yml .github/workflows/
```

**What you get:**

- Security scanner runs on every PR and push to main — checks dependencies and code patterns
- License compliance verifies that no dependency introduces a copyleft or restricted license
- Container image scanner checks Docker images for known CVEs before deployment

## Step 5: Documentation Pipeline

Keep docs fresh and accurate automatically.

```bash
cp templates/workflows/auto-changelog.yml .github/workflows/
cp templates/workflows/broken-link-checker.yml .github/workflows/
```

If you have OpenAPI specs or annotated API code:

```bash
cp templates/workflows/api-docs-generator.yml .github/workflows/
```

**What you get:**

- CHANGELOG.md auto-generated from Conventional Commits when you create a release
- Broken links in markdown files detected on every push to main
- API documentation regenerated when code changes

The auto-changelog workflow relies on Conventional Commits. If you added `conventional-commit-checker` in Step 3, your commits are already in the right format.

## Step 6: Maintenance Pipeline

Reduce manual housekeeping.

```bash
cp templates/workflows/stale-issue-manager.yml .github/workflows/
cp templates/workflows/branch-cleanup.yml .github/workflows/
cp templates/workflows/dependency-update-checker.yml .github/workflows/
```

**What you get:**

- Issues with no activity for 30 days get labeled `stale`, closed after 7 more days
- Merged PR branches are automatically deleted
- Weekly check for outdated or vulnerable dependencies, reported as issues

## Customizing Workflows

### Change the AI model

Workflows use a `MODEL` env variable (defaults to `claude-sonnet-4`). Edit the workflow file to change it:

```yaml
jobs:
  review:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - name: 🔍 Review
        env:
          MODEL: 'gpt-4o' # Change from default claude-sonnet-4
```

### Adjust concurrency

Every workflow job should have concurrency to prevent duplicate runs:

```yaml
jobs:
  scan:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    concurrency:
      group: security-${{ github.head_ref || github.ref }}
      cancel-in-progress: true
```

This cancels previous runs when you push new commits to the same branch.

### Change PR size thresholds

Edit the `pr-size-checker.yml` workflow to adjust the line threshold:

```yaml
with:
  max_lines: 600 # Default is 400
```

### Disable workflows for specific paths

Use `paths-ignore` to skip workflows for non-code changes:

```yaml
on:
  pull_request:
    paths-ignore:
      - '**.md'
      - 'docs/**'
      - '.github/ISSUE_TEMPLATE/**'
```

## Recommended Setups by Project Size

### Solo project / small team

```bash
# Just the essentials
cp templates/workflows/pr-size-checker.yml .github/workflows/
cp templates/workflows/conventional-commit-checker.yml .github/workflows/
cp templates/workflows/security-scanner.yml .github/workflows/
cp templates/workflows/auto-changelog.yml .github/workflows/
```

### Medium team (5-15 people)

Add code review, dependency updates, and issue management:

```bash
cp templates/workflows/pr-code-reviewer.yml .github/workflows/
cp templates/workflows/auto-assign-reviewers.yml .github/workflows/
cp templates/workflows/dependency-update-checker.yml .github/workflows/
cp templates/workflows/stale-issue-manager.yml .github/workflows/
cp templates/workflows/branch-cleanup.yml .github/workflows/
```

### Large team / open source

Add everything from above, plus:

```bash
cp templates/workflows/license-compliance.yml .github/workflows/
cp templates/workflows/first-contributor-welcome.yml .github/workflows/
cp templates/workflows/duplicate-issue-detector.yml .github/workflows/
cp templates/workflows/smart-labeler.yml .github/workflows/
cp templates/workflows/code-coverage-report.yml .github/workflows/
cp templates/workflows/todo-tracker.yml .github/workflows/
```

## Verifying Your Pipeline

After copying all workflows, run through this checklist:

1. **Push to a branch** and open a PR → PR quality workflows should trigger
2. **Check the Actions tab** → all workflows should appear and run
3. **Merge the PR** → branch cleanup should delete the branch
4. **Create a release** → auto-changelog and release notes should generate
5. **Wait for scheduled runs** → stale issue manager (daily) and dependency checker (weekly) should run on schedule

If a workflow doesn't trigger, check:

- The `on:` trigger matches (PR, push, schedule)
- The workflow file is in `.github/workflows/`
- Required secrets are available
- Branch protection rules aren't blocking the workflow

## Troubleshooting

**Workflow not running?** Make sure you copied the workflow file to `.github/workflows/` in your repository. Each workflow is self-contained and doesn't reference external repos.

**AI review adds too many comments?** Edit the workflow to adjust review scope or model temperature.

**Stale manager closing valid issues?** Adjust the `daysBeforeStale` and `daysBeforeClose` inputs, or add the `pinned` label to exempt important issues.

**Dependency checker creates too many issues?** Filter by severity level in the workflow to focus on critical and high vulnerabilities only.
