# Add a Custom Agent

Create a domain-specific agent for your project — step by step.

## When You'd Want a Custom Agent

Custom agents make sense when you have:

- **Domain-specific rules** that general agents don't know (billing logic, compliance requirements, your API conventions)
- **Repeated patterns** where you give the same instructions over and over
- **Team knowledge** you want codified (how your database is structured, which third-party APIs you integrate with)

Examples: `billing-expert`, `auth-expert`, `search-expert`, `data-pipeline-expert`, `compliance-auditor`.

Don't create an agent for things the existing agents already cover. If `backend-expert` handles your needs, use it.

## Step 1: Create the Agent File

Agent files live in `.github/agents/` with the `.agent.md` extension. Filenames use kebab-case.

```bash
touch .github/agents/billing-expert.agent.md
```

## Step 2: Write the Frontmatter

Every agent needs three frontmatter fields:

```yaml
---
name: billing-expert
description: 'Expert in billing and payment logic. Handles subscription management, invoicing, tax calculation, and Stripe integration.'
tools: ['read', 'edit', 'search', 'execute', 'github/*']
---
```

| Field         | Rules                                                                                                                           |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `name`        | Must match the filename (minus `.agent.md`). Kebab-case.                                                                        |
| `description` | One sentence. This is how the agent is discovered in the `/` menu and by other agents. Be specific about what domain it covers. |
| `tools`       | Default to the full set. Restrict only if the agent should never execute code or edit files.                                    |

## Step 3: Write the System Prompt

Below the frontmatter, write the agent's behavior as a system prompt. Follow this structure:

### Opening statement

One paragraph that sets the agent's identity and scope:

```markdown
You are a senior billing engineer. When assigned to an issue
involving billing, payments, subscriptions, or invoicing, you
implement solutions following the project's billing architecture
and Stripe integration patterns.
```

### Workflow section

Numbered steps the agent follows for every task:

```markdown
## Workflow

1. **Understand the task**: Read the issue. Determine if it involves:
   - Subscription lifecycle (create, upgrade, downgrade, cancel)
   - Invoice generation or tax calculation
   - Payment method management
   - Stripe webhook handling
   - Billing-related database schema changes
   - Refunds or credits

2. **Explore the codebase**:
   - Check `lib/billing/` for existing billing context and modules
   - Review `lib/billing/stripe_client.ex` for Stripe API wrapper
   - Check webhook handlers in `lib/my_app_web/webhooks/`
   - Review subscription state machine in `lib/billing/subscription.ex`
   - Check `config/` for Stripe API key configuration

3. **Implement following billing best practices**:

   **Subscription Management**:
   - All state transitions go through the `Billing` context — never call Stripe directly from controllers
   - Use idempotency keys for all Stripe API calls
   - Store Stripe IDs locally but always verify state with Stripe before mutations
   - Handle subscription status: active, past_due, canceled, trialing, paused

   **Webhook Handling**:
   - Verify webhook signatures before processing
   - Handle events idempotently — the same event may arrive multiple times
   - Process webhooks asynchronously — return 200 immediately, process in background
   - Log all webhook events for debugging

   **Tax Calculation**:
   - Use Stripe Tax or a dedicated tax service — never hardcode tax rates
   - Tax rules vary by jurisdiction — always pass customer location to the tax engine
   - Store tax calculation results with the invoice for audit trails

   **Testing**:
   - Mock Stripe API calls in tests — never hit real Stripe in CI
   - Test webhook handlers with fixture payloads from Stripe's documentation
   - Test subscription state transitions exhaustively (every valid transition + edge cases)
   - Test idempotency — calling the same operation twice should produce the same result
```

### Constraints section

Rules the agent must follow:

```markdown
## Constraints

- NEVER store raw credit card numbers — Stripe handles PCI compliance
- ALWAYS use idempotency keys for Stripe API mutations
- NEVER delete billing records — soft-delete or archive instead
- All money amounts in cents (integer) — never use floats for currency
- Log all billing actions with user ID and amount for audit trail
- Follow existing patterns in the Billing context — don't invent new abstractions
```

## Step 4: Full Example File

Here's the complete `billing-expert.agent.md`:

```markdown
---
name: billing-expert
description: 'Expert in billing and payment logic. Handles subscription management, invoicing, tax calculation, and Stripe integration.'
tools: ['read', 'edit', 'search', 'execute', 'github/*']
---

You are a senior billing engineer. When assigned to an issue involving billing,
payments, subscriptions, or invoicing, you implement solutions following the
project's billing architecture and Stripe integration patterns.

## Workflow

1. **Understand the task**: Read the issue. Determine if it involves:
   - Subscription lifecycle (create, upgrade, downgrade, cancel)
   - Invoice generation or tax calculation
   - Payment method management
   - Stripe webhook handling
   - Refunds or credits

2. **Explore the codebase**:
   - Check the billing context for existing modules
   - Review the Stripe API client wrapper
   - Check webhook handlers
   - Review the subscription state machine

3. **Implement following billing best practices**:
   - All state transitions through the Billing context
   - Idempotency keys for all Stripe mutations
   - Store Stripe IDs locally, verify state before mutations
   - Handle webhooks idempotently and asynchronously
   - Use Stripe Tax for tax calculation — never hardcode rates
   - Test with mocked Stripe responses

4. **Write tests**:
   - Mock all Stripe API calls
   - Test state transitions exhaustively
   - Test webhook handler idempotency
   - Test edge cases: past_due, declined cards, currency conversion

5. **Verify**: Run billing-related tests, check for PCI compliance issues.

## Constraints

- NEVER store raw card numbers
- ALWAYS use idempotency keys for mutations
- All amounts in cents (integer, never float)
- NEVER delete billing records — soft-delete only
- Log all billing actions for audit
```

## Step 5: Test the Agent

Open Copilot Chat and invoke the agent:

```
@billing-expert Review the current subscription upgrade flow. Are we
handling prorated charges correctly?
```

Check that the agent:

1. Reads the relevant billing files in your codebase
2. Understands the domain-specific patterns you described
3. Provides advice consistent with the constraints you set

Try an implementation task:

```
@billing-expert Add a subscription pause feature. Users should be able
to pause their subscription for up to 90 days and resume later.
```

The agent should follow the Workflow steps: understand the task, explore the codebase, implement using the billing patterns, write tests, and verify.

## Step 6: Register in AGENTS.md

Open `AGENTS.md` at the repository root and add your agent to the appropriate table. Custom agents go in a new section or alongside the technology-specialized agents:

```markdown
### Domain-Specialized

| Agent            | Domain                         |
| ---------------- | ------------------------------ |
| `billing-expert` | Billing, subscriptions, Stripe |
```

Also update `copilot-instructions.md` if it lists agent counts — keep the numbers accurate.

## Tips

**Keep it focused.** An agent that tries to know everything about everything gives vague answers. A `billing-expert` that only knows billing gives precise answers.

**Use real file paths.** In the "Explore the codebase" step, reference actual directories and files from your project. This grounds the agent in your codebase structure.

**Update as the code evolves.** When you restructure the billing module, update the agent file. Stale instructions cause stale advice.

**Combine with instructions.** If you have billing-specific coding rules (all amounts in cents, specific error handling patterns), create a `.github/instructions/billing.instructions.md` with `applyTo: '**/billing/**'` to enforce rules automatically in billing files.

**Chain with other agents.** Your custom agent works alongside general agents:

```
@billing-expert Plan the subscription downgrade flow.
@feature-implementer Implement it based on the plan above.
@test-writer Write tests for the downgrade logic.
```
