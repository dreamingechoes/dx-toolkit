---
name: estimation-and-sizing
description: 'Techniques for estimating development effort. Covers T-shirt sizing, story points, reference stories, and capacity planning. Helps teams estimate consistently.'
---

# Estimation & Sizing

## Overview

Estimation is not about predicting the future — it's about making uncertainty visible. A team that estimates well doesn't hit every deadline; they know when they're off track early enough to adjust scope, resources, or timelines. Bad estimation isn't wrong numbers — it's false confidence. "This will take two weeks" is worse than "this is a Large, which historically takes 1-3 weeks for us."

This skill covers practical estimation techniques that work: T-shirt sizing for roadmap-level planning, story points for sprint planning, reference stories for calibration, and velocity tracking for honest forecasting. The goal is consistency — not precision.

## When to Use

- Planning a sprint or iteration and need effort estimates
- Sizing a roadmap or quarterly plan at the epic level
- New team forming and need to establish estimation norms
- Estimates are consistently inaccurate and need recalibration
- Stakeholders want delivery timelines for a feature set

**When NOT to use:** Tasks with well-known fixed scope (deploy this config change, update this dependency version). If it takes less than 2 hours, just do it — don't estimate it.

## Process

### Step 1 — Choose Estimation Method

Pick one method per level of granularity. Don't mix them.

**Methods by planning horizon:**

| Horizon         | Method         | Unit        | Audience         |
| --------------- | -------------- | ----------- | ---------------- |
| Quarterly plan  | T-shirt sizing | XS/S/M/L/XL | Leadership, PMs  |
| Sprint planning | Story points   | Fibonacci   | Development team |
| Task breakdown  | Hours (range)  | 2-4h, 4-8h  | Individual dev   |

**T-shirt sizing — effort bands:**

| Size | Effort Band | Typical Scope                                          |
| ---- | ----------- | ------------------------------------------------------ |
| XS   | < 1 day     | Config change, copy update, simple bug fix             |
| S    | 1-3 days    | Single feature, isolated change, straightforward test  |
| M    | 3-5 days    | Feature with integration, involves 2-3 files/systems   |
| L    | 1-2 weeks   | Cross-system feature, needs design + implementation    |
| XL   | 2-4 weeks   | Large initiative — must be broken down before starting |

**Story points with Fibonacci (1, 2, 3, 5, 8, 13, 21):**

| Points | Relative Complexity                                      |
| ------ | -------------------------------------------------------- |
| 1      | Trivial — obvious how, minimal risk                      |
| 2      | Simple — clear approach, one unknown                     |
| 3      | Moderate — understood approach, couple of unknowns       |
| 5      | Complex — approach known but implementation has risks    |
| 8      | Very complex — multiple unknowns, cross-cutting concerns |
| 13     | Highly complex — should probably be split                |
| 21     | Too big — must be split before estimating                |

### Step 2 — Create Reference Stories

Reference stories are concrete examples of each size that the whole team agrees on. Without them, "a 5" means different things to different people.

**How to build reference stories:**

1. Pick 3-5 completed stories the whole team remembers
2. As a group, assign each a size or point value
3. Document them as the team's estimation anchor

**Reference story template:**

```
## Reference Stories

### 1 point — "Add created_at timestamp to API response"
- Scope: Add one field to one serializer, update one test
- Risk: None — straightforward mapping
- Duration: Took 2 hours including review

### 3 points — "Add search filter to product listing"
- Scope: Backend query filter + frontend search input + tests
- Risk: Low — clear requirements, known patterns
- Duration: Took 1.5 days

### 5 points — "Implement password reset flow"
- Scope: Email sending, token generation, reset page, error handling, tests
- Risk: Medium — email deliverability, token security
- Duration: Took 3 days

### 8 points — "Add Stripe payment integration"
- Scope: Stripe SDK, webhook handling, payment page, error states, refund flow
- Risk: High — third-party dependency, PCI considerations
- Duration: Took 6 days

### 13 points — "Migrate from REST to GraphQL for mobile API"
- Scope: Schema design, resolver implementation, auth integration, client update
- Risk: High — wide blast radius, backwards compatibility needed
- Duration: Took 2 weeks — should have been split
```

### Step 3 — Estimate Work Items

Use planning poker or async voting — avoid anchoring bias.

**Planning poker process:**

1. Product owner reads the story and answers questions
2. Each team member privately selects their estimate (cards face down)
3. All reveal simultaneously
4. If estimates differ by more than 2× (e.g., 3 vs 13), the highest and lowest explain their reasoning
5. Re-vote after discussion
6. Take the consensus (not the average — if one person sees a risk others missed, listen)

**Async estimation (for distributed teams):**

- Post story in a thread with context
- Each person reacts with their estimate (emoji: 1️⃣ 2️⃣ 3️⃣ 5️⃣ 8️⃣)
- Discuss outliers asynchronously
- Timebox to 24 hours

**Estimation rules:**

- Compare to reference stories, not to wall-clock time
- Include testing, code review, and deploy — not just coding
- If nobody on the team has done something similar before, add uncertainty (bump up a size)
- Items estimated at 13+ points must be split before entering a sprint
- "I don't know enough to estimate" is a valid answer — spike it first

### Step 4 — Validate Estimates

After completing work, compare actual effort to estimates. Not to punish — to calibrate.

**Tracking template:**

```
| Story                   | Estimate | Actual  | Delta | Notes                        |
| ----------------------- | -------- | ------- | ----- | ---------------------------- |
| Add search filter       | 3 pts    | 3 pts   | 0     | Clean match                  |
| Stripe integration      | 8 pts    | 13 pts  | +5    | Webhook retry logic unknown  |
| Password reset          | 5 pts    | 5 pts   | 0     | Reference story calibrated   |
| CSV export              | 3 pts    | 8 pts   | +5    | Memory issues with large files|
```

**What to track:**

- Stories where estimate and actual differed by 2× or more
- Patterns in over/underestimation (always underestimating integrations?)
- Whether reference stories still feel accurate

### Step 5 — Track Velocity

Velocity is the team's average throughput per sprint. Use it for forecasting — not performance management.

**Velocity calculation:**

```
Sprint 1: 34 points completed
Sprint 2: 28 points completed
Sprint 3: 31 points completed
Sprint 4: 36 points completed

Average velocity: ~32 points/sprint
Range: 28-36 points/sprint
```

**Forecasting with velocity:**

```
Remaining backlog: 120 points
Average velocity: 32 points/sprint
Optimistic (high velocity): 120 / 36 = ~3.3 sprints
Likely (average velocity): 120 / 32 = ~3.75 sprints
Pessimistic (low velocity): 120 / 28 = ~4.3 sprints

Estimate: 4-5 sprints (include buffer for unknowns)
```

**Velocity rules:**

- Never compare velocity between teams (different calibration)
- Never use velocity as a performance metric (teams will inflate estimates)
- Expect velocity to fluctuate ±20% sprint to sprint
- New team members temporarily reduce velocity (onboarding cost)
- Use rolling 4-sprint average, not all-time average

### Step 6 — Adjust Calibration

Every 3-4 sprints, review estimation accuracy and update reference stories.

**Calibration session (30 minutes):**

1. Review the estimate vs actual tracking data
2. Identify patterns: "We consistently underestimate API integrations by 2×"
3. Update reference stories with recent examples
4. Adjust sizing guidelines if needed
5. Revisit any items in the backlog that were estimated before the recalibration

**Cone of uncertainty — communicate confidence levels:**

```
Feature idea stage:   Estimate × 0.25 to × 4.0  (very wide)
Spec approved:        Estimate × 0.5 to × 2.0   (narrowing)
Design complete:      Estimate × 0.8 to × 1.25   (focused)
Implementation started: Estimate × 0.9 to × 1.1  (tight)
```

Tell stakeholders which stage you're at. A "2-week estimate" at the idea stage really means "1-8 weeks." At the design stage, it means "1.5-2.5 weeks."

## Common Rationalizations

| Rationalization                                     | Reality                                                                                                      |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| "I can give you an exact date"                      | You can give a range with a confidence level. Exact dates are fiction — communicate the uncertainty instead. |
| "Story points are meaningless — just use hours"     | Hours feel precise but aren't. People estimate 4 hours and take 2 days. Points embrace relative sizing.      |
| "We don't have time to estimate"                    | Not estimating means committing to scope without knowing the cost. That's how deadlines get missed.          |
| "This developer is faster, so it's a smaller story" | Estimate complexity, not speed. The story doesn't change because a senior is assigned to it.                 |
| "We always deliver what we commit to"               | If velocity never misses, you're sandbagging estimates or burning out. Some variance is healthy.             |
| "Estimation is waste — just build and see"          | #NoEstimates works when scope is fully flexible. Most teams need at least rough sizing for coordination.     |

## Red Flags

- Single-point estimates without ranges ("it will take exactly 4 days")
- Estimates that never miss (usually means padding or undercounting scope)
- Items larger than 13 points entering a sprint without being split
- No reference stories — everyone calibrates differently
- Velocity used as a performance metric ("why did velocity drop?")
- Estimates made by someone other than the person doing the work
- Never revisiting past estimates to check accuracy

## Verification

- [ ] Estimation method is chosen and agreed upon by the team
- [ ] Reference stories exist for each size category with real examples
- [ ] All work items are estimated before beginning a sprint
- [ ] Items 13+ points are split into smaller items before committing
- [ ] Estimates include testing, review, and deployment — not just coding
- [ ] Planning poker or async voting is used to avoid anchoring bias
- [ ] Estimate vs actual delta is tracked after each sprint
- [ ] Velocity is calculated from rolling 4-sprint average
- [ ] Velocity is never used to compare teams or evaluate performance
- [ ] Calibration session happens every 3-4 sprints
- [ ] Stakeholder estimates include confidence range (cone of uncertainty)
