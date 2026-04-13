---
name: performance-optimization
description: 'Measure-first approach to finding and fixing performance problems. Use when performance requirements exist, users report slowness, or you suspect regressions. Covers profiling, Core Web Vitals, bundle analysis, and database query optimization.'
---

# Performance Optimization

## Overview

Don't optimize code you haven't measured. This skill follows a strict measure-first approach: profile to find the bottleneck, fix the bottleneck, measure again to prove the fix worked. Optimizing without profiling data is guessing — and guessing is usually wrong.

## When to Use

- Performance requirements exist (response time, throughput, bundle size)
- Users report slowness or timeouts
- Metrics show regressions (response time increase, memory growth)
- Database queries appear in slow query logs
- Bundle size exceeds targets
- Core Web Vitals scores drop

**When NOT to use:** The code works correctly but "might be slow." Correctness first, performance second. Use this skill only when you have evidence of a performance problem or explicit performance requirements.

## The Optimization Cycle

```
Measure ──→ Identify ──→ Fix ──→ Verify
   ▲                                │
   └────────────────────────────────┘
```

Never skip a step. Never start at "Fix."

### Step 1: Measure

Capture baseline metrics before changing anything.

```
BASELINE:
Metric: [What you're measuring — response time, FCP, bundle size, query time]
Current value: [Measured value with units]
Target value: [Required value]
Tool used: [How you measured it]
Date: [When you measured]
```

**Frontend metrics:**

- Lighthouse performance score
- Core Web Vitals: LCP < 2.5s, FID < 100ms, CLS < 0.1
- Bundle size (`npm run build` output, or `source-map-explorer`)
- Time to Interactive

**Backend metrics:**

- Response time (p50, p95, p99)
- Throughput (requests/second)
- Database query time (slow query log)
- Memory usage
- CPU usage

**Measurement tools:**

| Environment | Tools                                                    |
| ----------- | -------------------------------------------------------- |
| Browser     | Chrome DevTools Performance tab, Lighthouse, WebPageTest |
| Node.js     | `--prof`, `clinic.js`, `0x` (flamegraphs)                |
| Database    | `EXPLAIN ANALYZE`, slow query log, `pg_stat_statements`  |
| General     | `time` command, custom timing instrumentation, APM tools |

### Step 2: Identify the Bottleneck

The bottleneck is the single slowest thing. Focus there.

**Common bottleneck patterns:**

| Pattern              | Symptom                            | Diagnostic                                                           |
| -------------------- | ---------------------------------- | -------------------------------------------------------------------- |
| N+1 queries          | Response time grows with data size | Count queries per request — if it scales with result count, it's N+1 |
| Missing index        | Single query is slow               | `EXPLAIN ANALYZE` shows sequential scan on large table               |
| Overfetching         | Slow API response, high memory     | Response includes unused fields, related data fetched eagerly        |
| Unnecessary renders  | UI feels sluggish                  | React DevTools Profiler shows re-renders not caused by prop changes  |
| Large bundle         | Slow initial load                  | `source-map-explorer` shows large dependencies                       |
| Synchronous blocking | Request hangs                      | Profiler shows long synchronous operation on the main thread         |
| Memory leak          | Gradual slowdown                   | Heap snapshot comparison shows growing allocations                   |

### Step 3: Fix the Bottleneck

Apply the minimum change that addresses the bottleneck.

**Database optimizations:**

```sql
-- Add targeted index
CREATE INDEX CONCURRENTLY idx_tasks_user_id_status
ON tasks (user_id, status)
WHERE deleted_at IS NULL;

-- Replace N+1 with join or preload
SELECT tasks.*, users.name
FROM tasks
JOIN users ON users.id = tasks.user_id
WHERE tasks.project_id = $1;
```

**Frontend optimizations:**

```typescript
// Lazy-load heavy components
const Chart = lazy(() => import('./Chart'));

// Memoize expensive computations
const sortedItems = useMemo(() => items.sort(byDate), [items]);

// Virtualize long lists
<VirtualList items={items} height={600} itemSize={50} />
```

**Backend optimizations:**

```typescript
// Add pagination instead of returning all results
const tasks = await db.tasks.findMany({
  where: { projectId },
  take: 50,
  skip: offset,
})

// Cache expensive computations
const stats = await cache.getOrSet(`project:${id}:stats`, () => computeProjectStats(id), { ttl: 300 })
```

### Step 4: Verify

Measure again using the same tool and conditions as Step 1.

```
RESULT:
Metric: [Same metric as baseline]
Before: [Baseline value]
After: [New value]
Improvement: [Percentage or absolute change]
Target met: [Yes/No]
```

If the target isn't met, return to Step 2 and identify the next bottleneck.

## Common Rationalizations

| Rationalization                                | Reality                                                                                                          |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| "I know what's slow — I don't need to profile" | Engineers guess the bottleneck correctly ~20% of the time. Profile first.                                        |
| "Let me optimize everything while I'm here"    | Premature optimization is wasted effort. Fix the measured bottleneck and stop.                                   |
| "It's just a small optimization"               | Small optimizations without measurement are just code changes with unknown impact.                               |
| "Caching will fix everything"                  | Caching hides problems and adds cache invalidation complexity. Fix the root cause when possible.                 |
| "We can optimize later"                        | True, if you're meeting targets. But don't use this as an excuse to skip measurement when users report slowness. |

## Red Flags

- Optimizing without baseline measurements
- "I made it faster" without before/after numbers
- Optimizing code paths that aren't bottlenecks
- Adding complexity (caching, parallelism) before trying simpler fixes (indexes, pagination)
- Premature optimization of code that runs infrequently
- Sacrificing readability for micro-optimization

## Verification

After optimizing:

- [ ] Baseline measurement was taken before any changes
- [ ] The bottleneck was identified with profiling data, not guessing
- [ ] The fix addresses the specific bottleneck
- [ ] After-measurement uses the same tool and conditions as the baseline
- [ ] Performance improvement is quantified (not "feels faster")
- [ ] The target metric is met
- [ ] All existing tests still pass
- [ ] No correctness was sacrificed for performance
