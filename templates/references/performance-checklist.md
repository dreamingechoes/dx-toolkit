# Performance Checklist Reference

Measure-first approach. Every optimization must have a before/after number.

## Core Web Vitals Targets

| Metric                          | Good    | Needs Work | Poor     |
| ------------------------------- | ------- | ---------- | -------- |
| LCP (Largest Contentful Paint)  | ≤ 2.5s  | ≤ 4.0s     | > 4.0s   |
| INP (Interaction to Next Paint) | ≤ 200ms | ≤ 500ms    | > 500ms  |
| CLS (Cumulative Layout Shift)   | ≤ 0.1   | ≤ 0.25     | > 0.25   |
| TTFB (Time to First Byte)       | ≤ 800ms | ≤ 1800ms   | > 1800ms |

## Frontend Checklist

### Loading

- [ ] Images lazy-loaded below the fold
- [ ] Images served in WebP/AVIF with proper sizing
- [ ] Critical CSS inlined, rest deferred
- [ ] JavaScript code-split by route
- [ ] Third-party scripts loaded async or deferred
- [ ] Fonts preloaded with `font-display: swap`
- [ ] Bundle size monitored (set budget: < 200KB JS gzipped)

### Rendering

- [ ] No layout shifts from dynamic content (reserve space)
- [ ] Lists virtualized when > 100 items
- [ ] Heavy computations moved to Web Workers
- [ ] Animations use `transform`/`opacity` (GPU-accelerated)
- [ ] React: memoize expensive renders, avoid unnecessary re-renders
- [ ] No synchronous `localStorage` reads in render path

### Network

- [ ] API responses cached appropriately (HTTP cache headers)
- [ ] Static assets on CDN with long cache (1 year + content hash)
- [ ] Gzip/Brotli compression enabled
- [ ] Prefetch critical resources (`<link rel="prefetch">`)
- [ ] Connection pooling for API calls

## Backend Checklist

### Database

- [ ] Queries have appropriate indexes (check `EXPLAIN ANALYZE`)
- [ ] No N+1 queries (use batch loading / eager loading)
- [ ] Connection pooling configured (pool size = CPU cores × 2 + disk spindles)
- [ ] Slow query logging enabled (threshold: 100ms)
- [ ] Large tables partitioned if > 10M rows
- [ ] Read replicas for read-heavy workloads

### API

- [ ] Response time P95 < 500ms, P99 < 1s
- [ ] Pagination on all list endpoints (default: 25, max: 100)
- [ ] Heavy operations run async (background jobs)
- [ ] Response compression enabled
- [ ] Caching layer (Redis/Memcached) for hot data
- [ ] Rate limiting prevents abuse

### Application

- [ ] No blocking I/O in request path
- [ ] Memory leaks monitored (heap snapshots for Node.js)
- [ ] Timeouts set on all external calls (default: 5s)
- [ ] Circuit breakers for downstream dependencies
- [ ] Logging at appropriate levels (not DEBUG in production)

## Measurement Tools

| Category             | Tools                                                |
| -------------------- | ---------------------------------------------------- |
| Frontend             | Lighthouse, WebPageTest, Chrome DevTools Performance |
| Backend              | `EXPLAIN ANALYZE`, APM (Datadog, New Relic), pprof   |
| Load testing         | k6, Artillery, wrk                                   |
| Real user monitoring | Web Vitals library, Sentry Performance               |

## Optimization Process

1. **Measure** — Get baseline numbers. No gut feelings.
2. **Identify** — Find the bottleneck. Use profilers, not guesses.
3. **Fix** — Change one thing at a time.
4. **Verify** — Compare before/after. If no measurable improvement, revert.
5. **Document** — Record what changed and the measured improvement.

## Common Wins (Sorted by Impact)

1. Add missing database index → 10-100x query speedup
2. Fix N+1 queries → 5-50x reduction in query count
3. Add caching for hot data → 10-100x read speedup
4. Code-split JavaScript → 30-70% smaller initial bundle
5. Optimize images → 40-80% bandwidth reduction
6. Enable compression → 60-80% smaller responses
