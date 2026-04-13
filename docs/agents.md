# 🤖 Agents

Agents are specialized AI personas that you can assign to GitHub issues or invoke in VS Code/JetBrains/CLI. Each agent has focused expertise, specific tool access, and tailored behavioral instructions.

**Location**: `templates/agents/*.agent.md`

## How Agents Work

1. An agent is a Markdown file with YAML frontmatter defining its name, description, and tools
2. The body contains behavioral instructions — what the agent does, how it works, and what it must NOT do
3. When assigned to an issue on GitHub.com, the agent autonomously reads the issue, explores the codebase, implements a solution, and creates a PR
4. In VS Code, agents appear in the Copilot Chat agent dropdown

### Agent Anatomy

```yaml
---
name: agent-name                  # kebab-case, matches filename
description: "Clear description"  # Used for discovery and selection
tools: ["read", "edit", "search", "execute", "github/*"]
---

You are a [role]. Your job is to [purpose].

## Workflow
1. [Step-by-step procedure]

## Constraints
- DO NOT [restriction]
```

### Available Tools

| Tool Alias | Purpose                              |
| ---------- | ------------------------------------ |
| `read`     | Read file contents                   |
| `edit`     | Edit files                           |
| `search`   | Text and file search                 |
| `execute`  | Run shell commands                   |
| `github/*` | GitHub MCP Server (issues, PRs, API) |
| `agent`    | Invoke other agents as subagents     |
| `web`      | Fetch URLs and web search            |
| `todo`     | Manage task lists                    |

---

## General-Purpose Agents

These agents handle common development tasks regardless of the tech stack.

### 🐛 Bug Fixer (`bug-fixer`)

**Purpose**: Diagnoses and fixes bugs reported in issues.

**Workflow**:

1. Reads the issue and extracts error details, reproduction steps
2. Searches the codebase for the relevant code
3. Identifies the root cause
4. Implements the fix
5. Adds regression tests
6. Creates a PR

**When to use**: Assign to any bug report issue. Works best with clear reproduction steps and error messages.

**Example issue**:

> "The `/api/users/:id` endpoint returns 500 when the user has no profile photo. Stack trace attached."

---

### ✨ Feature Implementer (`feature-implementer`)

**Purpose**: Implements new features from issue specifications.

**Workflow**:

1. Reads the issue requirements and acceptance criteria
2. Explores the codebase architecture
3. Plans the implementation following existing patterns
4. Implements the feature
5. Writes tests
6. Updates documentation
7. Creates a PR

**When to use**: Well-defined feature requests with clear requirements. The more detail in the issue, the better the result.

---

### 🔄 Refactorer (`refactorer`)

**Purpose**: Safely refactors code while preserving exact behavior.

**Workflow**:

1. Reads the issue (what to refactor and why)
2. Writes characterization tests for existing behavior
3. Applies refactoring incrementally
4. Verifies all tests pass after each step
5. Creates a PR

**When to use**: Code quality improvements, extracting abstractions, simplifying complex functions.

**Key behavior**: Always writes characterization tests FIRST, never changes behavior.

---

### 🧪 Test Writer (`test-writer`)

**Purpose**: Adds comprehensive test coverage without modifying production code.

**Workflow**:

1. Analyzes the code to understand what needs testing
2. Identifies untested paths, edge cases, and error scenarios
3. Writes tests using the project's existing framework and patterns
4. Verifies all tests pass

**When to use**: When you need better coverage for a module, or when coverage reports show gaps.

**Key behavior**: NEVER modifies production code — only creates/modifies test files.

---

### 📝 Docs Updater (`docs-updater`)

**Purpose**: Creates and updates project documentation.

**Workflow**:

1. Reads existing documentation structure
2. Identifies gaps or outdated content
3. Writes/updates READMEs, API docs, guides, changelogs
4. Creates a PR

**When to use**: Documentation refresh, new feature documentation, README improvements.

---

### 🛡️ Security Fixer (`security-fixer`)

**Purpose**: Fixes security vulnerabilities following OWASP best practices.

**Workflow**:

1. Reads the security finding (CVE, audit result, vulnerability report)
2. Analyzes the vulnerable code
3. Implements a fix following security best practices
4. Adds tests to verify the fix
5. Verifies no new vulnerabilities introduced

**When to use**: Dependabot alerts, security audit findings, manually reported vulnerabilities.

---

### ⚡ Performance Optimizer (`performance-optimizer`)

**Purpose**: Profiles bottlenecks and implements performance improvements.

**Workflow**:

1. Reads the performance issue (slow endpoint, memory usage, etc.)
2. Profiles the code to identify bottlenecks
3. Implements optimizations
4. Measures improvement
5. Adds benchmarks

**When to use**: Slow queries, high memory usage, response time issues.

---

### 📦 Dependency Updater (`dependency-updater`)

**Purpose**: Upgrades project dependencies safely.

**Workflow**:

1. Reads the update requirements (specific package or all)
2. Updates dependencies
3. Resolves breaking changes
4. Runs tests to verify stability
5. Creates a PR with a detailed changelog

**When to use**: Scheduled dependency updates, major version upgrades, security patches.

---

### ✍️ Docs Humanizer (`docs-humanizer`)

**Purpose**: Rewrites AI-sounding documentation, PR descriptions, and issue comments into natural, human prose.

**Workflow**:

1. Reads the target text (file, PR, or issue)
2. Scans for anti-patterns: filler phrases, passive voice, vague adjectives
3. Determines format and audience
4. Rewrites using the `humanize-writing` skill
5. Verifies no technical information was lost

**When to use**: Documentation that sounds generic, PR descriptions full of filler, any text flagged as "sounds like AI".

---

## Technology-Specialized Agents

These agents bring deep domain expertise for specific technologies. They enforce the latest best practices and target the latest stable versions.

### 💧 Elixir Expert (`elixir-expert`)

**Expertise**: OTP patterns, GenServer, supervision trees, pattern matching, pipe operator

**Target**: Elixir 1.18+ / OTP 27+

**Best for**: Designing OTP architectures, idiomatic Elixir, concurrency patterns, ExUnit testing

---

### 🔥 Phoenix Expert (`phoenix-expert`)

**Expertise**: Context-based architecture, LiveView 1.0+, Ecto, PubSub, Channels

**Target**: Phoenix 1.8+ / LiveView 1.0+ / Ecto 3.12+

**Best for**: Web applications with real-time features, context design, LiveView UIs

---

### 🔷 TypeScript Expert (`typescript-expert`)

**Expertise**: Strict mode, discriminated unions, branded types, `satisfies`, conditional types

**Target**: TypeScript 5.7+ / ES2024+

**Best for**: Type system design, refactoring JS to TS, complex generic patterns

---

### ▲ Next.js Expert (`nextjs-expert`)

**Expertise**: App Router, Server Components, Server Actions, caching, streaming

**Target**: Next.js 15+

**Best for**: Full-stack React with SSR/SSG, API routes, middleware, ISR

---

### 🐘 PostgreSQL Expert (`postgresql-expert`)

**Expertise**: Schema design, query optimization, indexing, RLS, partitioning, window functions

**Target**: PostgreSQL 17+

**Best for**: Schema design, slow query optimization, advanced query patterns

---

### ⚡ Supabase Expert (`supabase-expert`)

**Expertise**: RLS policies, Auth, Edge Functions, Realtime, Storage, typed client

**Target**: Supabase platform (latest)

**Best for**: Building on Supabase, RLS policy design, real-time features

---

### 🐳 Docker Expert (`docker-expert`)

**Expertise**: Multi-stage builds, BuildKit, security hardening, Compose V2

**Target**: Docker with BuildKit

**Best for**: Containerizing applications, optimizing image size, Compose setups

---

### 🎨 Design Systems Expert (`design-systems-expert`)

**Expertise**: Atomic design, design tokens, theming, WCAG 2.2 AA, component API design

**Target**: Framework-agnostic

**Best for**: Building component libraries, implementing design tokens, accessibility

---

### 🖥️ Frontend Expert (`frontend-expert`)

**Expertise**: Core Web Vitals, state management, responsive design, error boundaries

**Target**: Framework-agnostic

**Best for**: Performance optimization, architecture decisions, complex UIs

---

### ⚙️ Backend Expert (`backend-expert`)

**Expertise**: API design, observability, resilience patterns, database patterns, security

**Target**: Framework-agnostic

**Best for**: Service architecture, production readiness, observability setup

---

### 📋 Conventional Commits Expert (`conventional-commits-expert`)

**Expertise**: Commit standards, semantic versioning, changelog generation, Git workflows

**Target**: Conventional Commits spec 1.0

**Best for**: Setting up commit standards, configuring release automation

---

### 🌐 Web Development Expert (`web-development-expert`)

**Expertise**: Semantic HTML, modern CSS, browser APIs, SEO, progressive enhancement

**Target**: Web platform (latest standards)

**Best for**: Accessibility, SEO, modern CSS features, web performance

---

### ⚛️ React Expert (`react-expert`)

**Expertise**: Hooks, Server Components, concurrent features, composition, Testing Library

**Target**: React 19+

**Best for**: Component architecture, state management, React 19 migration

---

### 📱 React Native Expert (`react-native-expert`)

**Expertise**: New Architecture (Fabric + TurboModules), navigation, animations, native modules

**Target**: React Native 0.77+

**Best for**: Cross-platform mobile development, performance tuning, native integration

---

### 📲 Expo Expert (`expo-expert`)

**Expertise**: Expo Router v4, EAS Build/Submit/Update, Config Plugins, SDK modules

**Target**: Expo SDK 52+

**Best for**: Managed workflow mobile apps, EAS pipeline setup, Expo module usage

---

### 🔴 TDD Expert (`tdd-expert`)

**Expertise**: Red-Green-Refactor cycle, test design, Transformation Priority Premise

**Target**: Language-agnostic

**Best for**: Driving implementation through tests, test design decisions

---

### 🟢 BDD Expert (`bdd-expert`)

**Expertise**: Gherkin scenarios, ubiquitous language, outside-in development

**Target**: Language-agnostic (Cucumber, Wallaby, Cypress)

**Best for**: Defining behavior from user perspective, Gherkin scenario design

---

### 🔵 WordPress Expert (`wordpress-expert`)

**Expertise**: Theme and plugin development, WP-CLI, WooCommerce, performance, security hardening

**Target**: WordPress (latest stable) / PHP 8.2+

**Best for**: Custom theme/plugin development, WooCommerce integrations, WordPress site architecture

---

### 💳 Payments Expert (`payments-expert`)

**Expertise**: Stripe, PayPal, webhooks, PCI compliance, subscriptions, Apple Pay, Google Pay

**Target**: Provider-agnostic (Stripe, PayPal, Square, Braintree)

**Best for**: Payment integration, webhook handling, subscription billing, PCI compliance

---

### 🐍 Python Expert (`python-expert`)

**Expertise**: Type hints, async/await, data classes, pattern matching, Django/FastAPI

**Target**: Python 3.12+

**Best for**: Idiomatic Python, async services, data processing, type safety

---

### 🔵 Go Expert (`go-expert`)

**Expertise**: Goroutines, channels, error handling, interfaces, testing, modules

**Target**: Go 1.22+

**Best for**: Concurrent services, CLI tools, microservices, idiomatic Go

---

### 🦀 Rust Expert (`rust-expert`)

**Expertise**: Ownership, lifetimes, traits, async with Tokio, error handling

**Target**: Rust 2024 edition

**Best for**: Systems programming, performance-critical code, safe concurrency

---

### 🍎 Swift Expert (`swift-expert`)

**Expertise**: Structured concurrency, SwiftUI, Combine, protocol-oriented design

**Target**: Swift 6+

**Best for**: iOS apps, SwiftUI layouts, async patterns, Apple platform APIs

---

### 🟣 Kotlin Expert (`kotlin-expert`)

**Expertise**: Coroutines, Flow, Jetpack Compose, multiplatform, sealed classes

**Target**: Kotlin 2.0+

**Best for**: Android apps, Compose UI, coroutine patterns

---

### 🦋 Flutter Expert (`flutter-expert`)

**Expertise**: Widget composition, state management (Riverpod/BLoC), platform channels, animations

**Target**: Flutter 3.24+ / Dart 3.5+

**Best for**: Cross-platform mobile with Flutter, custom widgets, state patterns

---

### 💎 Rails Expert (`rails-expert`)

**Expertise**: Convention over configuration, ActiveRecord, Hotwire/Turbo, Stimulus, ActiveJob

**Target**: Rails 8+ / Ruby 3.3+

**Best for**: Full-stack web apps, Hotwire UIs, background jobs

---

### 💚 Vue Expert (`vue-expert`)

**Expertise**: Composition API, `<script setup>`, Pinia, Vue Router 4, Nuxt 3

**Target**: Vue 3.5+

**Best for**: Component design, state management, Nuxt server routes

---

### 🅰️ Angular Expert (`angular-expert`)

**Expertise**: Signals, standalone components, NgRx SignalStore, control flow syntax

**Target**: Angular 19+

**Best for**: Enterprise apps, signal-based reactivity, standalone components

---

### 🔶 Svelte Expert (`svelte-expert`)

**Expertise**: Runes, SvelteKit, `$state`/`$derived`, server routes, form actions

**Target**: Svelte 5+ / SvelteKit 2+

**Best for**: Reactive UIs, SvelteKit full-stack apps, rune-based state

---

### ◆ GraphQL Expert (`graphql-expert`)

**Expertise**: Schema design, resolvers, DataLoader, subscriptions, federation

**Target**: GraphQL spec (latest)

**Best for**: API design, resolver patterns, caching, N+1 prevention

---

### 🏗️ Terraform Expert (`terraform-expert`)

**Expertise**: HCL modules, state management, provider patterns, workspaces

**Target**: Terraform 1.7+ / OpenTofu

**Best for**: Infrastructure as Code, multi-cloud, module design

---

## Content-Specialized Agents

These agents handle content creation, strategy, and marketing with domain-specific expertise.

### ✍️ SEO Writer (`seo-writer`)

**Purpose**: Writes blog articles and posts optimized for traditional search engines and LLM-powered search.

**Workflow**:

1. Fetches reference URLs or reads local files to build a style and tone profile
2. Analyzes voice, structure, audience, and SEO patterns from reference content
3. Confirms the detected style profile with the user before writing
4. Researches the topic — primary keyword, secondary keywords, and search intent
5. Plans the article structure with headings, FAQ section, and meta data
6. Writes the article following SEO and LLM-SEO best practices
7. Delivers the article with full SEO metadata

**When to use**: Writing new blog posts, refreshing existing content, or any SEO-focused writing task. Works best when you provide reference URLs from the existing blog to match tone and style.

**Example request**:

> "Write a 1500-word article about 'TypeScript strict mode'. Here's our blog for reference: https://blog.example.com"

---

### 📈 Marketing Expert (`marketing-expert`)

**Purpose**: Develops marketing strategy, campaign plans, growth tactics, and analytics frameworks.

**Workflow**:

1. Identifies the marketing objective and target audience
2. Audits existing assets and funnel performance when available
3. Develops the requested deliverable — strategy, campaign plan, automation workflow, A/B test plan, or analysis
4. Prioritizes recommendations by impact and effort
5. Delivers a structured, actionable output

**When to use**: Campaign planning, funnel optimization, A/B test design, marketing automation, email marketing, social media strategy, or analytics setup. Complements `seo-writer` for content; focuses on strategy, channels, and measurement.

**Example request**:

> "Design an email nurture sequence for leads who downloaded our pricing page but didn't book a demo."

---

## Composing Agents

Agents work well together. Chain them for multi-step workflows where each agent handles what it does best.

### Issue → Plan → Implement → Review

A full feature lifecycle using four agents:

1. **feature-implementer** reads the issue, explores the codebase, and produces an implementation plan
2. **typescript-expert** (or the relevant language expert) implements the code following the plan
3. **test-writer** adds unit and integration tests for the new code
4. **refactorer** reviews the result for unnecessary complexity and cleans it up

```
@feature-implementer Plan the implementation for #142
@typescript-expert Implement the plan from #142
@test-writer Add tests for the auth module changes
@refactorer Review the changes in this branch for simplification opportunities
```

### Security Hardening

Combine security-focused agents for a thorough sweep:

1. **security-fixer** audits the codebase for OWASP vulnerabilities
2. **dependency-updater** patches outdated packages with known CVEs
3. **docker-expert** hardens Dockerfiles and Compose configs

```
@security-fixer Audit the authentication flow for vulnerabilities
@dependency-updater Update all packages with known security advisories
@docker-expert Harden our production Dockerfile
```

### Mobile Feature

Build a mobile feature with platform and tooling experts:

1. **react-native-expert** implements the feature with proper native patterns
2. **expo-expert** configures EAS builds and OTA updates
3. **test-writer** adds component and integration tests

```
@react-native-expert Build the push notification preferences screen
@expo-expert Set up EAS Update for the notifications feature
@test-writer Add tests for the notification preferences flow
```

---

## Usage Examples

### On GitHub.com (Issue Assignment)

1. Create an issue: "Fix the N+1 query in the posts listing endpoint"
2. Open the Copilot coding agent panel
3. Select **bug-fixer** (or **postgresql-expert** for query-focused fixes)
4. The agent autonomously creates a PR

### In VS Code (Chat)

```
@bug-fixer Fix the null pointer exception in src/services/auth.ts:42

@typescript-expert Refactor this module to use discriminated unions instead of type guards

@react-expert Convert this class component to a modern functional component with hooks
```

### Via Copilot CLI

```bash
copilot /agent bug-fixer "Fix the authentication timeout issue"
```

## Creating Your Own Agents

See [Customization](customization.md) for how to create custom agents for your specific needs.
