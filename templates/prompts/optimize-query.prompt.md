---
description: 'Optimize a slow database query. Analyzes the query plan, suggests indexes, rewrites for performance, and measures improvement. Works with any ORM or raw SQL.'
agent: 'agent'
---

Optimize the provided database query for better performance.

## Procedure

1. **Understand the query** — what data is it fetching and why?
2. **Analyze the current approach** — look for common performance anti-patterns
3. **Suggest optimizations** in order of impact

## Common Optimizations

### Query Structure

- Replace `SELECT *` with specific columns
- Use `EXISTS` instead of `COUNT` for existence checks
- Replace subqueries with JOINs where appropriate
- Use CTEs for readability without sacrificing performance
- Add `LIMIT` for paginated results
- Use `LATERAL JOIN` for correlated subqueries

### Indexing

- Add indexes for `WHERE`, `JOIN`, and `ORDER BY` columns
- Use composite indexes matching the query's column order
- Consider partial indexes for filtered queries
- Use covering indexes (`INCLUDE`) to avoid table lookups
- Use GIN indexes for JSONB and array columns

### N+1 Queries

- Detect N+1 patterns in ORM code
- Replace with eager loading / preloading / includes
- Use batch queries instead of loops

### Data Access Patterns

- Add pagination (cursor-based preferred over offset)
- Use materialized views for complex aggregations
- Consider denormalization for read-heavy patterns
- Cache results that don't change frequently

## Output

- Optimized query with explanation of each change
- Recommended indexes with `CREATE INDEX` statements
- Expected performance impact
- Any tradeoffs introduced
