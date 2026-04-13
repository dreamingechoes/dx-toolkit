---
name: incident-response
description: 'Incident management runbook: detection, communication, mitigation, resolution, and post-mortem. Covers severity levels, escalation, and blameless retrospectives.'
---

# Incident Response

## Overview

When production breaks, every minute counts. Incident response isn't about preventing all failures — it's about detecting them fast, communicating clearly, fixing them systematically, and learning from them honestly. The difference between a 5-minute incident and a 5-hour incident is usually not technical skill — it's process. Teams with a practiced runbook resolve incidents faster than teams with better engineers but no playbook.

This skill covers the full incident lifecycle: detection, classification, assembly, communication, investigation, mitigation, resolution, and post-mortem. It's designed to be used before you need it — practice the process so it's muscle memory when production is on fire at 3 AM.

## When to Use

- Production service is down or degraded
- Setting up an incident response process for the first time
- After an incident to conduct a post-mortem
- Training new team members on on-call responsibilities
- Reviewing and improving an existing incident process

**When NOT to use:** Feature bugs that don't affect production availability (those are regular bug fixes). Development or staging environment issues. Planned maintenance windows with proactive communication.

## Process

### Step 1 — Detect & Classify

An incident starts when someone notices something is wrong. That someone can be a monitoring alert, a customer report, or an engineer.

**Severity levels:**

| Severity | Impact                                        | Response Time     | Examples                                                    |
| -------- | --------------------------------------------- | ----------------- | ----------------------------------------------------------- |
| SEV1     | Service down, data loss, security breach      | 15 min            | API returning 500s, database corruption, credentials leaked |
| SEV2     | Major feature broken, significant degradation | 30 min            | Payments failing, auth broken, >10% error rate              |
| SEV3     | Minor feature broken, workaround exists       | 2 hours           | Search slow, export broken, non-critical UI bug             |
| SEV4     | Cosmetic issue, minor inconvenience           | Next business day | Typo on page, styling glitch, minor log noise               |

**Classification rules:**

- When in doubt, classify higher — it's easier to downgrade than to upgrade
- Customer-reported issues start at SEV2 minimum (if customers notice, it matters)
- Data loss or security issues are always SEV1, regardless of blast radius
- A SEV1 that affects 0 users is still SEV1 until confirmed otherwise

**Detection channels:**

- Monitoring alerts (PagerDuty, Opsgenie, Grafana)
- Customer support tickets or reports
- Internal team notices ("the dashboard looks weird")
- Social media or status monitoring
- Automated health checks

### Step 2 — Assemble Responders

**Roles (for SEV1/SEV2):**

| Role                | Responsibility                                                     |
| ------------------- | ------------------------------------------------------------------ |
| Incident Commander  | Owns the process, makes decisions, delegates, tracks time          |
| Technical Lead      | Investigates root cause, proposes and implements fixes             |
| Communications Lead | Updates status page, notifies stakeholders, handles customer comms |
| Scribe              | Documents timeline, actions taken, decisions made (in real-time)   |

**Escalation rules:**

- SEV1: Page incident commander + on-call engineer immediately. Notify VP/Engineering within 15 min.
- SEV2: Notify on-call engineer. Incident commander joins if not resolved in 30 min.
- SEV3: On-call engineer handles during business hours. No paging.
- SEV4: Handled in normal ticket flow.

**Assembly template (Slack/Teams):**

```
🔴 INCIDENT DECLARED — SEV1

Summary: [one-line description]
Impact: [who/what is affected]
Detection: [how it was found]
Declared by: [name]
Time declared: [UTC timestamp]

Incident Commander: @[name]
Tech Lead: @[name]
Comms Lead: @[name]

War room: #incident-[date]-[slug]
Video call: [link]
Status page: [link]
```

### Step 3 — Communicate Status

Communication is not optional. Silence during an incident is worse than "we don't know yet."

**Status page update cadence:**

| Severity | First Update   | Subsequent Updates | Resolution Update |
| -------- | -------------- | ------------------ | ----------------- |
| SEV1     | Within 15 min  | Every 30 min       | Within 1 hour     |
| SEV2     | Within 30 min  | Every 60 min       | Within 2 hours    |
| SEV3     | Within 2 hours | As needed          | Next business day |

**Status update template:**

```
[INVESTIGATING / IDENTIFIED / MONITORING / RESOLVED]

Title: [Brief description]
Time: [UTC timestamp]
Impact: [Who is affected and how]
Current status: [What we know and what we're doing]
Next update: [When to expect the next update]
```

**Example updates through an incident lifecycle:**

```
[INVESTIGATING] 14:32 UTC
We are investigating reports of failed API requests to the orders service.
Impact: Users may be unable to place new orders.
Next update in 30 minutes.

[IDENTIFIED] 14:55 UTC
We have identified the cause as a database connection pool exhaustion
following the 14:20 UTC deployment. We are working on a fix.
Impact: ~40% of order requests are failing.
Next update in 30 minutes.

[MONITORING] 15:15 UTC
A fix has been deployed (rollback of 14:20 deployment). Error rates
are returning to normal. We are monitoring to confirm full recovery.
Next update in 30 minutes.

[RESOLVED] 15:45 UTC
The incident has been resolved. All services are operating normally.
A post-mortem will be published within 48 hours.
Total duration: 1 hour 13 minutes.
```

### Step 4 — Investigate Root Cause

Investigation happens in parallel with communication — don't wait until you've found the cause to start communicating.

**Investigation framework:**

```
1. What changed? (deployments, config changes, traffic spikes)
2. When did it start? (correlate with change timeline)
3. What's the blast radius? (which users, which regions, which services)
4. What does the data show? (error logs, metrics, traces)
```

**Tools to check (in order):**

1. Recent deployments — `git log --oneline -10` / deploy dashboard
2. Monitoring dashboards — error rates, latency, resource usage
3. Logs — error messages, stack traces, correlation IDs
4. Traces — distributed trace for a failing request
5. Infrastructure — CPU, memory, disk, network, DNS
6. Dependencies — third-party service status pages

**Timeline documentation (scribe writes this in real-time):**

```
14:20 UTC — Deploy v2.4.1 to production (included DB migration)
14:25 UTC — Error rate starts climbing (0.1% → 5%)
14:32 UTC — PagerDuty alert fires, on-call acknowledges
14:35 UTC — Incident declared SEV1, war room opened
14:40 UTC — Confirmed: connection pool exhausted after migration added long-running queries
14:50 UTC — Decision: rollback v2.4.1
15:05 UTC — Rollback deployed
15:15 UTC — Error rate returns to baseline
15:45 UTC — Monitoring confirms stable, incident resolved
```

### Step 5 — Mitigate

Mitigation stops the bleeding. It doesn't fix the root cause — it restores service.

**Mitigation options (fastest first):**

| Action                  | Time     | When to Use                          |
| ----------------------- | -------- | ------------------------------------ |
| Rollback deployment     | 2-5 min  | Recent deploy caused the issue       |
| Feature flag toggle     | < 1 min  | New feature is the root cause        |
| Restart service         | 1-3 min  | Memory leak, stuck process           |
| Scale up / add capacity | 5-10 min | Traffic spike, resource exhaustion   |
| Failover to secondary   | 5-15 min | Primary datastore/service is down    |
| Block bad traffic       | 1-5 min  | DDoS or abusive client               |
| DNS redirect            | 5-30 min | Regional failure, redirect to backup |

**Mitigation rules:**

- Mitigate first, investigate root cause second
- Prefer rollback over forward-fix under pressure
- Document what mitigation was applied and when
- Don't change multiple things simultaneously — you won't know what helped

### Step 6 — Resolve

Resolution means the service is fully restored and confirmed stable.

**Resolution criteria:**

- Error rates back to baseline for 30+ minutes
- No customer reports of ongoing issues
- All affected functionality verified working
- Monitoring confirms sustained recovery

**After resolution:**

- Update status page to RESOLVED
- Notify stakeholders with final timeline
- Schedule post-mortem within 48 hours
- Create tracking issues for follow-up work

### Step 7 — Post-Mortem

The post-mortem is where learning happens. Do it within 48 hours while memory is fresh. Make it blameless — or people will hide information next time.

**Blameless post-mortem template:**

```markdown
# Post-Mortem: [Incident Title]

**Date:** [date]
**Severity:** [SEV level]
**Duration:** [total incident time]
**Impact:** [who was affected and how]
**Authors:** [post-mortem writers]
**Status:** [Draft / Reviewed / Complete]

## Summary

[2-3 sentences: what happened, what was the impact, how was it resolved]

## Timeline (UTC)

| Time  | Event                        |
| ----- | ---------------------------- |
| 14:20 | Deploy v2.4.1                |
| 14:25 | Error rate increase detected |
| ...   | ...                          |

## Root Cause

[Technical explanation of what caused the incident]

## Contributing Factors

- [Factor 1 — e.g., no pre-deploy load test]
- [Factor 2 — e.g., migration ran in a transaction holding locks]
- [Factor 3 — e.g., alert threshold too high, delayed detection]

## What Went Well

- [e.g., rollback was fast because deploy pipeline supports it]
- [e.g., communication was clear and timely]

## What Went Poorly

- [e.g., took 12 minutes to acknowledge the alert]
- [e.g., no runbook existed for this failure mode]

## Action Items

| Action                                       | Owner  | Priority | Due Date   | Status |
| -------------------------------------------- | ------ | -------- | ---------- | ------ |
| Add pre-deploy load test                     | @alice | High     | 2025-02-01 | Open   |
| Lower alert threshold from 5% to 1%          | @bob   | High     | 2025-01-20 | Open   |
| Write runbook for connection pool exhaustion | @carol | Medium   | 2025-02-15 | Open   |

## Lessons Learned

[What did we learn that applies beyond this specific incident?]
```

**Root cause analysis techniques:**

**5 Whys:**

```
Why was the service down? → Connection pool was exhausted
Why was the pool exhausted? → A migration added queries running 30s+ each
Why were the queries slow? → They scanned a 50M row table without an index
Why was there no index? → The migration wasn't tested against production-scale data
Why wasn't it tested? → No load testing step in the deploy pipeline
→ Action: Add required load test before production deploy
```

**Fishbone diagram categories:**

- People (knowledge gaps, handoff issues)
- Process (missing steps, unclear ownership)
- Technology (bugs, capacity limits, dependencies)
- Environment (load spikes, third-party outages)

### Step 8 — Implement Preventions

Action items from the post-mortem are real work — track them like any other task.

**Action item rules:**

- Every action item has an owner, priority, and due date
- High-priority items go into the current or next sprint
- Review action item completion in the next post-mortem or team retro
- If the same root cause recurs, the prevention from the previous post-mortem wasn't implemented — escalate

**Recurring incident pattern detection:**

```
If you see the same incident type 3+ times:
1. Aggregate all related post-mortems
2. Identify the common thread
3. Prioritize a structural fix (not another band-aid)
4. Assign a DRI (directly responsible individual) for the fix
```

## Common Rationalizations

| Rationalization                                          | Reality                                                                                               |
| -------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| "We'll do the post-mortem next week"                     | Next week you'll have forgotten the details. Do it within 48 hours.                                   |
| "We know who caused it"                                  | Blame ensures people hide mistakes next time. The system failed — not the person.                     |
| "This was a one-off — it won't happen again"             | That's what was said last time. Track action items and verify they're completed.                      |
| "We don't have time for incident process — just fix it"  | Unstructured incident response takes longer because of duplicated effort and poor communication.      |
| "We'll add monitoring after the next incident"           | The next incident is where you'll wish you had monitoring. This IS the time.                          |
| "It was only down for 2 minutes — no post-mortem needed" | Short incidents with fast recovery still have causes. A 2-min outage today is a 2-hour one next time. |

## Red Flags

- No defined severity levels (everything is "urgent" or nothing is)
- No incident commander — multiple people giving conflicting directions
- Silence during an incident (no status page updates, no internal comms)
- Blame in post-mortems ("this happened because John deployed without testing")
- Post-mortem action items that never get completed
- Same root cause appearing in multiple post-mortems
- No on-call rotation (same person always handles incidents)
- Incidents discovered by customers, not by monitoring

## Verification

- [ ] Severity levels (SEV1-4) are defined with response time SLAs
- [ ] Incident roles (commander, tech lead, comms, scribe) are defined
- [ ] Escalation paths are documented and tested
- [ ] Status page update templates and cadence are defined
- [ ] Communication templates exist for declaring and updating incidents
- [ ] Mitigation playbooks exist for common failure modes (rollback, feature flags, restart)
- [ ] Post-mortem template is available and the team knows how to use it
- [ ] Post-mortems are conducted within 48 hours of SEV1/SEV2 incidents
- [ ] Post-mortems are blameless — focused on systems and processes, not individuals
- [ ] Action items have owners, due dates, and are tracked to completion
- [ ] Recurring incidents trigger structural fixes, not just more band-aids
- [ ] On-call rotation exists with clear handoff process
