# 🔧 Troubleshooting

Common problems and fixes, organized by component type.

---

## Agent Issues

### Agent not responding

**Symptom:** You type `@agent-name` in Copilot Chat but get no response or a generic reply without the agent's persona.

**Cause:** The agent file isn't detected by Copilot.

**Fix:**

1. Verify the file exists at `.github/agents/agent-name.agent.md`
2. Check that the filename uses kebab-case and ends with `.agent.md`
3. Validate the YAML frontmatter:
   ```yaml
   ---
   name: agent-name
   description: 'What this agent does'
   tools: ['read', 'edit', 'search', 'execute', 'github/*']
   ---
   ```
4. Reload VS Code: `Cmd+Shift+P` → "Reload Window"
5. Check that GitHub Copilot Chat extension is active (look for the Copilot icon in the status bar)

---

### Wrong agent invoked

**Symptom:** You ask `@react-expert` a question but the response doesn't reflect React expertise.

**Cause:** Agent name mismatch or the agent file's `name` field doesn't match the filename.

**Fix:**

1. Check that the filename matches the `name` field in frontmatter:
   ```
   File: react-expert.agent.md
   name: react-expert          ← must match
   ```
2. Check for duplicate agent names — two files with the same `name` field cause conflicts
3. Make sure you're typing the full agent name: `@react-expert`, not `@react`

---

### Agent ignoring instructions

**Symptom:** The agent generates code that violates your instruction rules (e.g., uses `var` instead of `const` despite `typescript.instructions.md` saying otherwise).

**Cause:** Instructions may not be auto-attaching, or the agent's context window is full.

**Fix:**

1. Verify the instruction's `applyTo` glob matches the files you're editing:
   ```yaml
   applyTo: '**/*.ts, **/*.tsx'
   ```
2. Check that the instruction file is in `.github/instructions/`
3. Keep instruction files concise — long instructions may be truncated
4. For complex tasks, explicitly reference the instruction: "Follow the rules in `#typescript` instructions"

---

## Instruction Issues

### Instruction not auto-attaching

**Symptom:** You edit a `.py` file but `python.instructions.md` rules aren't being followed.

**Cause:** The `applyTo` glob doesn't match the file path.

**Fix:**

1. Check the glob pattern in the instruction's frontmatter:
   ```yaml
   applyTo: '**/*.py'
   ```
2. Test your glob at [globster.xyz](https://globster.xyz/) with your actual file paths
3. Common mistakes:
   - Missing `**/` prefix (matches only root files without it)
   - Wrong extension (`.tsx` vs `.ts`)
   - Spaces in the glob list not after commas: `'**/*.ts,**/*.tsx'` — add a space: `'**/*.ts, **/*.tsx'`
4. Make sure the file is inside the VS Code workspace folder (not an external file)

---

### Conflicting instruction rules

**Symptom:** Two instruction files give contradictory advice (e.g., one says "use semicolons," another says "no semicolons").

**Cause:** Multiple instruction files with overlapping `applyTo` patterns.

**Fix:**

1. Check which instructions apply to the file type:
   ```bash
   grep -l "applyTo.*\.ts" .github/instructions/*.md
   ```
2. Merge conflicting rules into one file, or narrow the `applyTo` globs so they don't overlap
3. Remove the instruction file you don't want

---

### Glob pattern not matching expected files

**Symptom:** Your custom instruction with `applyTo: 'src/components/**'` doesn't activate.

**Cause:** Glob pattern syntax is off.

**Fix:**

Common glob patterns and what they match:

| Pattern         | Matches                        | Doesn't Match      |
| --------------- | ------------------------------ | ------------------ |
| `**/*.ts`       | Any `.ts` file at any depth    | `.tsx` files       |
| `**/*.{ts,tsx}` | Any `.ts` or `.tsx` file       | `.js` files        |
| `src/**`        | All files under `src/`         | Files in root      |
| `**/test/**`    | Files in any `test/` directory | `tests/` directory |
| `**/*.test.*`   | `foo.test.ts`, `bar.test.js`   | `test_foo.py`      |

---

## Skill Issues

### Skill not found

**Symptom:** You ask an agent to use a skill but it doesn't follow the skill's procedure.

**Cause:** The skill folder or `SKILL.md` file is missing, or the agent can't locate it.

**Fix:**

1. Verify the folder exists: `.github/skills/skill-name/SKILL.md`
2. Check that the folder name matches the `name` field in the skill's frontmatter
3. Reference the skill explicitly:
   ```
   Read and follow the procedure in .github/skills/code-review/SKILL.md
   ```
4. Check that the skill file has valid frontmatter:
   ```yaml
   ---
   name: code-review
   description: 'Perform a thorough code review'
   ---
   ```

---

### Skill output is incomplete

**Symptom:** The agent follows only part of a skill's steps, skipping later steps.

**Cause:** Context window limits. Long skills may be truncated in the agent's context.

**Fix:**

1. Ask the agent to continue: "Continue with the remaining steps of the skill"
2. Break the request into smaller chunks: "Now do step 3 of the code-review skill"
3. If the skill is very long, consider whether all steps are needed for your task

---

## Prompt Issues

### Prompt not appearing in slash menu

**Symptom:** You type `/` in Copilot Chat but your prompt doesn't show up.

**Cause:** Missing or invalid frontmatter.

**Fix:**

1. Check that the file is at `.github/prompts/prompt-name.prompt.md`
2. Check that the file has a `description` field in frontmatter:
   ```yaml
   ---
   description: 'Generate tests for selected code'
   ---
   ```
3. Reload VS Code: `Cmd+Shift+P` → "Reload Window"
4. Check for YAML syntax errors in the frontmatter (missing quotes, wrong indentation)

---

### Prompt ignores my custom instructions

**Symptom:** The prompt works but doesn't follow your project-specific rules.

**Cause:** The prompt doesn't reference your instructions, or the instructions aren't auto-attaching.

**Fix:**

1. Make sure your instruction file's `applyTo` glob covers the files the prompt operates on
2. Add explicit instruction references in your `copilot-instructions.md`
3. Include context in your prompt invocation: "/write-tests Follow our testing conventions in #testing instructions"

---

## Workflow Issues

### Workflow failing with authentication error

**Symptom:** Workflow run fails with "Bad credentials" or "Resource not accessible by integration."

**Cause:** Missing or expired Personal Access Token.

**Fix:**

1. Check that the `COPILOT_PAT` secret exists in your repo: **Settings → Secrets and variables → Actions**
2. Verify the token hasn't expired at [GitHub Settings → Tokens](https://github.com/settings/tokens)
3. Make sure the token has these scopes: `repo`, `read:org`, `copilot`
4. Regenerate the token if expired and update the secret

---

### Workflow failing with model quota exceeded

**Symptom:** Workflow fails with a rate limit or quota error message.

**Cause:** Too many API calls to the Copilot model.

**Fix:**

1. Space out workflow triggers — don't run all AI workflows on every push
2. Use `paths:` filters to trigger workflows only when relevant files change:
   ```yaml
   on:
     push:
       paths: ['src/**', 'lib/**']
   ```
3. Reduce the frequency of scheduled workflows
4. Try a different model if available: change the `MODEL` env variable to an alternative

---

### Workflow not triggering

**Symptom:** You push code or open a PR but the workflow doesn't start.

**Cause:** Workflow trigger configuration doesn't match the event.

**Fix:**

1. Check the workflow's `on:` section matches your event type
2. For PRs, make sure the workflow is on the default branch (workflows must exist on the target branch)
3. Check that GitHub Actions is enabled: **Settings → Actions → General → Actions permissions**
4. Look at the Actions tab for any disabled workflows
5. Check for `paths:` filters that might exclude your changes

---

### Secrets not available in workflow

**Symptom:** Workflow can't access `${{ secrets.COPILOT_PAT }}` — it's empty.

**Cause:** Secrets aren't available in forked repository PRs (by design), or the secret name is misspelled.

**Fix:**

1. Check the exact secret name — it's case-sensitive
2. For forked PRs, secrets are intentionally hidden. Use `pull_request_target` trigger instead of `pull_request` (but be cautious — this has security implications)
3. Check secret scope: repository secrets are only available to workflows in that repo. Organization secrets need to be shared with the repo

---

## Hook Issues

### Hook not running

**Symptom:** You commit code but the commit message validator or secret scanner doesn't check anything.

**Cause:** Hook config not detected, or the script isn't executable.

**Fix:**

1. Verify the hook config is at `.github/hooks/hook-name.json`
2. Check that the config JSON is valid:
   ```json
   {
     "hooks": [
       {
         "event": "PreToolUse",
         "tools": ["git_commit"],
         "script": ".github/hooks/scripts/commit-message-validator.sh"
       }
     ]
   }
   ```
3. Make the script executable:
   ```bash
   chmod +x .github/hooks/scripts/commit-message-validator.sh
   ```
4. Check that VS Code is configured to use Copilot hooks (this is editor-version dependent)

---

### Hook blocking valid actions

**Symptom:** A hook rejects a valid commit message or flags a valid string as a secret.

**Cause:** The hook's validation regex is too strict, or it's a false positive.

**Fix:**

1. **For commit message validation:** Check the regex in `.github/hooks/scripts/commit-message-validator.sh`. The default requires Conventional Commits format: `type(optional-scope): description`
2. **For secret scanning:** Check the patterns in `.github/hooks/scripts/secret-scanner.sh`. If it flags a test fixture or example key, add the pattern to an allowlist in the script
3. **Temporary bypass:** Move the hook's `.json` config out of `.github/hooks/` temporarily. Move it back when you're done

---

### Hook interfering with other hooks

**Symptom:** One hook runs but another doesn't, or hooks run in an unexpected order.

**Cause:** Hook configs with the same `event` and `tools` combination may conflict.

**Fix:**

1. Check all hook configs for overlapping `event` + `tools` patterns
2. Combine related validations into a single hook script
3. Make sure each hook script exits with code 0 on success and non-zero on failure

---

## General Tips

- **Reload VS Code** after adding or modifying any toolkit files. `Cmd+Shift+P` → "Reload Window."
- **Check YAML frontmatter** syntax first — it's the #1 cause of files not being detected. Use a YAML validator if unsure.
- **Read the error message.** Workflow failures show detailed logs in the Actions tab. Hook failures show output in the Copilot Chat panel.
- **Simplify to isolate.** If something doesn't work, strip it to the minimum (one file, one rule) and verify that works before adding complexity.
- **Check the docs.** The [FAQ](faq.md) covers most "how do I" questions. The [Architecture](architecture.md) page explains how components interact.
