# 📋 Templates

Issue and PR templates provide structured forms for contributors, ensuring consistent and complete information every time.

**Location**: `templates/ISSUE_TEMPLATE/` (issues) + `templates/PULL_REQUEST_TEMPLATE.md` (PRs)

## Issue Templates

### 🐛 Bug Report (`bug_report.yml`)

A YAML-based form that guides reporters through structured bug reporting with required fields and dropdowns.

**Fields**:

| Field              | Type       | Required | Description                                    |
| ------------------ | ---------- | -------- | ---------------------------------------------- |
| Description        | textarea   | ✅       | Clear description of the bug                   |
| Steps to Reproduce | textarea   | ✅       | Numbered steps to reproduce                    |
| Expected Behavior  | textarea   | ✅       | What should have happened                      |
| Actual Behavior    | textarea   | ✅       | What actually happened                         |
| Environment        | textarea   | ❌       | OS, browser, runtime versions                  |
| Logs / Screenshots | textarea   | ❌       | Error output, stack traces, screenshots        |
| Severity           | dropdown   | ✅       | Critical / High / Medium / Low                 |
| Checklist          | checkboxes | —        | Searched existing issues, reproduced on latest |

**Auto-labels**: `bug`, `needs-triage`

**Example** (what contributors see):

```
┌─────────────────────────────────────────┐
│  🐛 Bug Report                          │
├─────────────────────────────────────────┤
│ Description *                           │
│ ┌─────────────────────────────────────┐ │
│ │                                     │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ Steps to Reproduce *                    │
│ ┌─────────────────────────────────────┐ │
│ │ 1.                                  │ │
│ │ 2.                                  │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ Severity *                              │
│ ┌─────────────────┐                     │
│ │ Medium        ▼ │                     │
│ └─────────────────┘                     │
└─────────────────────────────────────────┘
```

---

### ✨ Feature Request (`feature_request.yml`)

A structured form for feature proposals with scope and priority classification.

**Fields**:

| Field              | Type     | Required | Description                                   |
| ------------------ | -------- | -------- | --------------------------------------------- |
| Problem Statement  | textarea | ✅       | What problem this solves                      |
| Proposed Solution  | textarea | ✅       | How you'd like it to work                     |
| Alternatives       | textarea | ❌       | Other approaches considered                   |
| Scope              | dropdown | ✅       | Small / Medium / Large / Breaking Change      |
| Priority           | dropdown | ✅       | Critical / High / Medium / Low / Nice-to-have |
| Additional Context | textarea | ❌       | Mockups, references, examples                 |

**Auto-labels**: `enhancement`, `needs-triage`

---

### Blank Issues (`config.yml`)

The configuration file allows blank issues (for anything that doesn't fit the templates) and provides links to documentation and discussions.

```yaml
blank_issues_enabled: true
contact_links:
  - name: 📖 Documentation
    url: https://github.com/dreamingechoes/dx-toolkit/tree/main/docs
    about: Check the documentation before opening an issue
  - name: 💬 Discussions
    url: https://github.com/dreamingechoes/dx-toolkit/discussions
    about: Ask questions and share ideas in Discussions
```

---

## PR Template (`PULL_REQUEST_TEMPLATE.md`)

Every new PR is pre-filled with this structured template.

**Sections**:

| Section                 | Purpose                                                                        |
| ----------------------- | ------------------------------------------------------------------------------ |
| **What**                | One-line summary of the change                                                 |
| **Why**                 | Context, motivation, link to issue (`Closes #N`)                               |
| **How**                 | Technical approach and key decisions                                           |
| **Type of Change**      | Checkboxes: bug fix, feature, breaking change, docs, refactor, deps, CI, other |
| **Testing**             | How the change was tested                                                      |
| **Checklist**           | Tests pass, docs updated, no secrets committed, conventional commit            |
| **Screenshots**         | Space for UI change screenshots                                                |
| **Notes for Reviewers** | Additional context for the reviewer                                            |

**Example** (what PR authors see):

```markdown
## What

Add cursor-based pagination to the /api/v1/users endpoint

## Why

The offset-based pagination was causing performance issues with 100K+ users.
Closes #42

## How

- Replaced offset pagination with cursor-based using `id` as cursor
- Added `cursor` and `limit` query parameters
- Returns `next_cursor` in response meta

## Type of Change

- [ ] 🐛 Bug fix
- [x] ✨ New feature
- [ ] 💥 Breaking change
      ...
```

---

## Why YAML Forms?

The issue templates use YAML forms (`.yml`) instead of Markdown templates (`.md`) because:

1. **Required fields**: Ensure reporters fill in critical information
2. **Dropdowns**: Standardize severity/priority without free-text ambiguity
3. **Checkboxes**: Guide reporters through pre-submission checks
4. **Validation**: GitHub validates the form before submission
5. **Structured data**: Easier for automation (workflows, bots) to parse

---

## Customization

### Adding a New Issue Template

Create a new `.yml` file in `.github/ISSUE_TEMPLATE/`:

```yaml
name: '🔧 Maintenance Request'
description: 'Request a maintenance task (dependency update, cleanup, etc.)'
labels: ['maintenance', 'needs-triage']
body:
  - type: textarea
    id: description
    attributes:
      label: 'What needs maintenance?'
      placeholder: 'Describe the maintenance task...'
    validations:
      required: true
  - type: dropdown
    id: urgency
    attributes:
      label: 'Urgency'
      options:
        - 'Can wait for next sprint'
        - 'Should do this week'
        - 'Urgent — blocking other work'
    validations:
      required: true
```

### Editing the PR Template

Edit `.github/PULL_REQUEST_TEMPLATE.md` directly. Keep it concise — too many sections lead to contributors deleting the template.

---

## Tips

- **Keep templates focused**: One template per concern, not a mega-form
- **Required fields wisely**: Only require what's truly necessary — excessive requirements discourage reporting
- **Auto-labels**: Use the `labels` field to auto-categorize for triage workflows
- **Link to templates**: In your README, link directly to issue creation: `https://github.com/owner/repo/issues/new/choose`
- **Iterate**: Review filled templates monthly — if contributors delete sections, those sections are too demanding
