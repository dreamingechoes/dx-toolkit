---
description: 'Write a database migration with safety checks, rollback support, and zero-downtime considerations. Use for schema changes, data migrations, or index creation.'
agent: 'agent'
---

Create a safe database migration based on the user's description.

## Procedure

1. **Detect the migration framework** (Ecto, Prisma, Knex, ActiveRecord, Alembic, etc.)
2. **Follow existing migration patterns** in the project
3. **Generate the migration** with:
   - Clear, descriptive migration name
   - Up/forward migration
   - Down/rollback migration (always reversible)
   - Appropriate column types and constraints

## Safety Rules

- ALWAYS create reversible migrations (rollback must work)
- NEVER drop columns in the same deploy as code removal — use a two-phase approach
- Add indexes concurrently when possible (avoid table locks)
- Use `NOT NULL` with defaults for new required columns on existing tables
- For large tables, consider batched data migrations
- Add foreign key constraints with appropriate ON DELETE behavior
- Use appropriate column types (uuid over serial for PKs, timestamptz over timestamp, text over varchar)

## Zero-Downtime Checklist

- [ ] New columns have defaults or are nullable
- [ ] No column renames (add new → migrate data → remove old)
- [ ] No `NOT NULL` constraints added without defaults on existing columns
- [ ] Indexes created concurrently where supported
- [ ] Rollback tested and verified

## Output

- Migration file(s) ready to run
- Rollback instructions
- Any warnings about data loss or locking
