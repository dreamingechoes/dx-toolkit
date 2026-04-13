# 🎯 Skills

Skills are multi-step workflows packaged as reusable procedures. Unlike prompts (single tasks) or instructions (passive rules), skills guide Copilot through a structured process with multiple phases, producing detailed outputs.

**Location**: `templates/skills/<skill-name>/SKILL.md` · **Anatomy**: [How to write skills](skill-anatomy.md)

## Development Lifecycle

Skills map to a six-phase development lifecycle through slash commands:

```
EXPLORE → OUTLINE → DEVELOP → CHECK → POLISH → LAUNCH
```

| Phase   | Slash Command | Skills Activated                                                                                                                                       |
| ------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| EXPLORE | `/explore`    | idea-refine, spec-driven-development, codebase-onboarding                                                                                              |
| OUTLINE | `/outline`    | planning-and-task-breakdown, issue-to-plan                                                                                                             |
| DEVELOP | `/develop`    | incremental-implementation, context-engineering, api-design, database-schema                                                                           |
| CHECK   | `/check`      | debugging-and-error-recovery                                                                                                                           |
| POLISH  | `/polish`     | code-simplification, performance-optimization, code-review, security-audit                                                                             |
| LAUNCH  | `/launch`     | git-workflow-and-versioning, ci-cd-and-automation, documentation-and-adrs, shipping-and-launch, deployment-checklist, pr-description, humanize-writing |

## Reference Checklists

Skills reference these standalone checklists in `templates/references/`:

| Checklist                    | Used By                                                  |
| ---------------------------- | -------------------------------------------------------- |
| `testing-patterns.md`        | debugging-and-error-recovery, incremental-implementation |
| `security-checklist.md`      | security-audit, shipping-and-launch, code-review         |
| `performance-checklist.md`   | performance-optimization, shipping-and-launch            |
| `accessibility-checklist.md` | code-review, shipping-and-launch                         |

## How Skills Work

1. Open Copilot Chat in VS Code
2. Type `/` to see available skills (listed alongside prompts)
3. Select a skill
4. Provide the required context
5. The skill walks through its structured procedure, producing each deliverable in order

### Skill Anatomy

```yaml
---
name: "skill-name"
description: "What this skill does — used for discovery"
---

## Procedure

Step 1: Gather information...
Step 2: Analyze...
Step 3: Produce output...

## Output Template

Structured template for the deliverable.
```

Skills are self-contained — all the context, procedures, and templates are in the single `SKILL.md` file.

---

For the full specification on writing skills, see [Skill Anatomy](skill-anatomy.md).

---

## Product & Discovery

### Idea Refine

**Purpose**: Structured divergent/convergent thinking for vague ideas.

**When to use**: You have a vague idea, feature request, or problem statement that needs clarity before writing a spec.

**Process**: Five Questions exploration, generate 3+ options, score matrix, write proposal.

---

### Spec-Driven Development

**Purpose**: Write a complete spec before code with full requirements, design, scope, testing strategy, and acceptance criteria.

**When to use**: Starting any feature that touches more than one file or takes more than an hour.

**Process**: Write spec using 9-section template, size the spec, review, get sign-off before coding.

---

### Codebase Onboarding

**Purpose**: Generates a comprehensive codebase overview for onboarding new developers.

**When to use**: Joining a new project, reviewing an unfamiliar codebase, or creating docs for your team.

**Procedure**:

1. Scans directory structure and reads configuration files
2. Identifies architecture patterns
3. Maps key files and their purposes
4. Documents conventions and standards

**Output includes**: Project summary, annotated directory structure, key files, development setup steps, coding conventions, architecture patterns, dependency overview.

---

## Planning & Design

### Issue to Plan

**Purpose**: Converts a GitHub issue into a detailed, actionable implementation plan.

**When to use**: Starting work on any issue: feature, bug fix, or refactoring task.

**Procedure**:

1. Reads and parses the issue requirements
2. Explores the codebase to understand architecture
3. Identifies files to modify/create
4. Produces a step-by-step plan

**Output includes**: Scope summary, file-level plan, implementation steps in dependency order, test strategy, acceptance criteria, estimated complexity.

---

### Planning and Task Breakdown

**Purpose**: Decompose specs into small, ordered, verifiable tasks.

**When to use**: After writing a spec and before starting implementation.

**Process**: Identify components, slice vertically, order by dependencies, write task list with Priority/Depends/Effort/Files/AC.

**Key principle**: Each task delivers a thin, working slice that compiles and passes tests independently.

---

### API Design

**Purpose**: Designs a RESTful API from business requirements, producing endpoint specifications ready for implementation.

**When to use**: Starting a new API, adding resources to an existing API, or redesigning endpoints.

**Procedure**:

1. Extracts resources and relationships from requirements
2. Maps CRUD and custom operations
3. Designs endpoint structure
4. Defines request/response schemas
5. Plans auth and error handling

**Output includes**: Resource inventory, endpoint table, request/response schemas, error catalog, pagination strategy, OpenAPI-ready specification.

---

### Database Schema

**Purpose**: Designs a database schema with tables, indexes, constraints, and migration plan.

**When to use**: Starting a new feature that needs data modeling, or redesigning an existing schema.

**Procedure**:

1. Identifies entities and relationships
2. Designs normalized tables
3. Plans indexes for known query patterns
4. Adds constraints and validations
5. Creates migration plan in dependency order

**Output includes**: Entity-Relationship summary, table definitions, index recommendations, migration files in execution order.

---

## Development

### Incremental Implementation

**Purpose**: Implement in thin vertical slices: code, test, verify, commit cycles.

**When to use**: During implementation of any task from the plan.

**Process**: Pick the task, implement smallest working change, write tests, verify, commit, repeat.

**Key rules**: Choose the simplest approach, don't add code for later, stay within the task scope, keep everything compilable.

---

### Context Engineering

**Purpose**: Feed AI agents the right context at the right time.

**When to use**: Setting up a new repo for AI-assisted development, or when agents produce poor results due to missing context.

**Process**: Audit the 5-layer context stack (Rules, Skills, References, Project Knowledge, Session State) then apply patterns (Progressive Disclosure, Context Packing, MCP Integrations).

---

### Debugging and Error Recovery

**Purpose**: Five-step triage: Reproduce, Localize, Reduce, Fix, Guard.

**When to use**: A test is failing, an error is occurring, or unexpected behavior is reported.

**Process**: Confirm the failure, read stack trace bottom-up, find minimal reproduction, apply minimal fix, write regression test.

**Key principle**: Fix the root cause, not the symptom. If the fix is more than 20 lines, you might be solving the wrong problem.

---

## Code Quality

### Code Simplification

**Purpose**: Reduce complexity while preserving behavior. Apply Chesterton's Fence: understand before you remove.

**When to use**: Code is hard to read, has deep nesting, long functions, or unnecessary abstractions.

**Process**: Measure complexity, identify patterns (deep nesting, long functions, dead code), apply simplification techniques (early returns, extract named concepts, inline over-abstractions).

---

### Performance Optimization

**Purpose**: Measure-first approach to performance problems. Every optimization must have a before/after number.

**When to use**: Measurable performance problem exists (slow queries, high latency, large bundles).

**Process**: Measure baseline, identify bottleneck with profilers, fix one thing, verify improvement, document.

**Reference**: `templates/references/performance-checklist.md`

---

### Code Review

**Purpose**: Performs a thorough, structured code review using a 4-pass methodology.

**When to use**: Before submitting a PR, reviewing someone else's PR, or self-reviewing critical code.

**Procedure**:

1. **Pass 1 (Correctness)**: Logic errors, wrong assumptions, missing edge cases
2. **Pass 2 (Security)**: OWASP Top 10, injection, auth, data exposure
3. **Pass 3 (Architecture)**: SOLID, coupling, naming, duplication
4. **Pass 4 (Performance)**: N+1, unnecessary allocations, missing indexes

**Output includes**: Findings categorized by severity (Must Fix / Should Fix / Consider), exact location, suggested fix, overall assessment.

---

### Security Audit

**Purpose**: Performs a comprehensive security audit following OWASP methodology.

**When to use**: Before a major release, after adding authentication/authorization features, or as a periodic check.

**Procedure**:

1. **Authentication review**: Password handling, session management, MFA
2. **Authorization review**: Access control, privilege escalation, IDOR
3. **Input validation**: Injection (SQL, XSS, command), file upload
4. **Data protection**: Encryption, secrets, PII handling
5. **Dependency scan**: Known vulnerabilities
6. **Configuration**: Headers, CORS, TLS, error exposure

**Output includes**: Findings by OWASP category, severity, remediation guidance with code examples, executive summary with risk score.

**Reference**: `templates/references/security-checklist.md`

---

## Documentation & Communication

### Documentation and ADRs

**Purpose**: Architecture Decision Records, API docs, inline documentation. Document the why, not the what.

**When to use**: Making a decision with multiple options, adding a new API, or when code needs explanation.

**Key template**: ADR format with Status, Context, Decision, Consequences, Alternatives Considered.

---

### PR Description

**Purpose**: Generates a well-structured PR description from the current diff.

**When to use**: After implementing changes, before creating the pull request.

**Procedure**:

1. Reads the current git diff
2. Categorizes changes by type
3. Identifies the intent behind changes
4. Produces a structured PR description

**Output includes**: Title suggestion (Conventional Commits format), what changed, why, how, testing performed, checklist.

---

### Humanize Writing

**Purpose**: Rewrite AI-generated text to sound natural, specific, and human.

**When to use**: Documentation, PR descriptions, commit messages, or issue comments that sound robotic.

**Key rules**: Cut filler, active voice, replace vague adjectives with specifics, use you/we, never sacrifice correctness for style.

---

## DevOps & Delivery

### Git Workflow and Versioning

**Purpose**: Trunk-based development, atomic commits, Conventional Commits, semantic versioning.

**When to use**: Before committing, creating branches, or tagging releases.

**Key rules**: Each commit has a single purpose, messages follow `type(scope): description`, prefer short-lived branches, squash WIP commits.

---

### CI/CD and Automation

**Purpose**: Shift Left quality gates, deployment automation, feature flags.

**When to use**: Setting up or improving CI/CD pipelines, adding quality gates, configuring deployments.

**Process**: Define quality gate pipeline, configure stages (Lint/Type, Unit, Integration, E2E, Security), set up deployment with feature flags.

---

### Shipping and Launch

**Purpose**: Pre-launch checklists, staged rollouts, rollback procedures.

**When to use**: Preparing a production deployment.

**Process**: Run pre-launch checklist (Code/Database/Security/Performance/Feature Flags/Monitoring/Communication), deploy in stages (1%, 10%, 50%, 100%), monitor for 48 hours.

**Key rule**: If you can't ship safely in 5 minutes, your deployment process needs work.

---

### Deployment Checklist

**Purpose**: Generates a comprehensive pre-deployment verification checklist tailored to your codebase.

**When to use**: Before any production deployment, especially for major releases or critical fixes.

**Procedure**:

1. Analyzes changes for risk areas
2. Checks database migration safety
3. Verifies security considerations
4. Reviews performance implications
5. Plans rollback strategy

**Output includes**: Code verification checklist, database migration safety checks, security verification, performance assessment, rollback plan.

---

## Testing & Quality

### Testing Strategy

**Purpose**: Generates a comprehensive testing strategy tailored to your project's stack and requirements.

**When to use**: Starting a new project, improving test coverage, or rethinking your testing approach after reliability issues.

**Process**: Analyze project stack, design test pyramid distribution, select frameworks, define coverage targets, set up fixture management, configure CI integration.

---

### Accessibility Audit

**Purpose**: Performs a full WCAG 2.2 AA compliance audit with step-by-step testing methodology and remediation guidance.

**When to use**: Reviewing UI code for accessibility, before a release with user-facing changes, or when addressing accessibility complaints.

**Procedure**:

1. Automated scanning with axe-core and Lighthouse
2. Keyboard navigation testing
3. Screen reader testing
4. Color contrast and motion verification
5. Form and error message review

**Output includes**: Violations by severity, affected elements with selectors, remediation code snippets, testing methodology used.

**Reference**: `templates/references/accessibility-checklist.md`

---

### Refactoring Catalog

**Purpose**: Identifies and applies named refactoring patterns with safety checklists and test requirements.

**When to use**: Code works but needs structural improvement — long methods, deep nesting, conditional complexity, or duplicated logic.

**Patterns include**: Extract Method, Replace Conditional with Polymorphism, Introduce Parameter Object, Replace Temp with Query, Decompose Conditional, and more.

**Key rule**: Every refactoring has a before/after example, a safety checklist, and required test coverage.

---

## DevOps & Infrastructure

### Feature Flag Management

**Purpose**: Designs feature flag architecture covering flag types, naming conventions, lifecycle, and cleanup procedures.

**When to use**: Adding feature flags to a project, designing a rollout strategy, or cleaning up stale flags.

**Process**: Choose flag types (release, experiment, ops, permission), define naming convention, set up lifecycle (create → roll out → monitor → clean up), plan technical debt cleanup.

---

### Infrastructure as Code

**Purpose**: Generates IaC configurations for Terraform, Pulumi, or CloudFormation with best practices baked in.

**When to use**: Setting up cloud infrastructure, migrating from click-ops to code, or reviewing existing IaC.

**Process**: Define resource requirements, select provider and tool, generate module structure, configure state management, set up environment promotion, add drift detection.

---

### Error Monitoring Setup

**Purpose**: Configures error tracking (Sentry, Bugsnag, Datadog) with alerting rules and triage workflows.

**When to use**: Adding error monitoring to a project, improving alert quality, or reducing alert fatigue.

**Process**: Select tool, configure SDK integration, define alert thresholds, set up triage workflow, configure release tracking.

**Reference**: `templates/references/error-handling-patterns.md`

---

### Logging and Observability

**Purpose**: Designs structured logging, metrics collection, and distributed tracing across services.

**When to use**: Setting up observability for a new service, debugging production issues, or standardizing logging across a team.

**Process**: Define log levels and structure, configure metrics collection, set up distributed tracing, build dashboards, create runbooks.

**Reference**: `templates/references/observability-checklist.md`

---

## Mobile

### Mobile Release

**Purpose**: Manages the mobile app release lifecycle from versioning through store submission and staged rollouts.

**When to use**: Preparing an App Store or Play Store submission, setting up OTA updates, or defining your mobile release process.

**Process**: Configure versioning scheme, prepare store metadata, build release artifacts, submit for review, stage rollout (1% → 10% → 50% → 100%), monitor crash rates.

---

### Mobile Testing

**Purpose**: Designs a mobile-specific testing strategy covering device labs, screenshot tests, and gesture interactions.

**When to use**: Setting up testing for a mobile app, expanding device coverage, or debugging platform-specific issues.

**Process**: Define device matrix, configure screenshot/snapshot tests, set up gesture testing, plan E2E flows with Detox or Maestro, configure device farm CI integration.

---

## Project Management

### Estimation and Sizing

**Purpose**: T-shirt sizing and story point estimation with reference stories and capacity planning.

**When to use**: Planning sprints, estimating feature work, or calibrating your team's estimation process.

**Process**: Define reference stories per size, estimate using comparison, track actuals vs estimates, adjust calibration over time.

---

### Incident Response

**Purpose**: Guides incident management from detection through resolution and blameless retrospective.

**When to use**: During a production incident, or when setting up your team's incident response process.

**Process**: Detect and classify severity, communicate status, mitigate impact, resolve root cause, run blameless retrospective, publish post-mortem.

---

### Dependency Audit

**Purpose**: Audits project dependencies for security vulnerabilities, license compliance, freshness, and maintenance status.

**When to use**: Before major releases, periodically as part of maintenance, or when evaluating a new dependency.

**Process**: Scan for known CVEs, check license compatibility, identify unmaintained packages, measure bundle size impact, produce upgrade plan.

---

## Reference Checklists (continued)

Additional reference checklists for the new skills:

| Checklist                    | Used By                                              |
| ---------------------------- | ---------------------------------------------------- |
| `mobile-checklist.md`        | mobile-release, mobile-testing                       |
| `api-patterns.md`            | api-design, incremental-implementation               |
| `error-handling-patterns.md` | debugging-and-error-recovery, error-monitoring-setup |
| `observability-checklist.md` | logging-and-observability, shipping-and-launch       |

---

## Tips

- **Use lifecycle commands**: `/explore` then `/outline` then `/develop` then `/check` then `/polish` then `/launch` for a full development loop
- **Chain skills**: Use `/issue-to-plan` then implement then `/code-review` then `/pr-description` for a focused workflow
- **Skills + Agents**: Reference a skill from an agent for specialized expertise
- **Reference checklists**: Point to `templates/references/` for targeted security, performance, or accessibility reviews
- **Customize**: Edit the SKILL.md to match your team's standards and templates
- **Create your own**: See [Skill Anatomy](skill-anatomy.md) and [Customization](customization.md)
