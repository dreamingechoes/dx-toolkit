---
description: 'Database migration standards. Use when writing migrations, schema changes, or data transformations. Covers safety, rollback, and zero-downtime patterns.'
applyTo: '**/migrations/**, **/priv/repo/migrations/**, **/db/migrate/**, **/prisma/migrations/**'
---

# Migration Standards

## Safety Rules

- ALWAYS write reversible migrations — every `up` has a `down`
- Test rollback before merging
- Never modify an already-deployed migration — create a new one

## Zero-Downtime Patterns

### Adding a Column

- Make it nullable OR provide a default value
- Never add `NOT NULL` without a default on an existing table with data

### Removing a Column

1. Deploy: stop reading the column in application code
2. Deploy: remove the column in a migration

- Never drop a column and remove code in the same deploy

### Renaming a Column

1. Add new column with correct name
2. Deploy: write to both columns, read from new
3. Migrate data from old to new
4. Deploy: read/write only new column
5. Drop old column

### Adding an Index

- Use `CREATE INDEX CONCURRENTLY` (PostgreSQL) to avoid table locks
- In Ecto: `create index(:table, [:column], concurrently: true)` with `@disable_ddl_transaction true`

## Column Types (PostgreSQL)

- Primary keys: `uuid` (v7 preferred) over `serial`/`bigserial`
- Timestamps: `timestamptz` (never `timestamp` without timezone)
- Text: `text` over `varchar` (no performance difference in PostgreSQL)
- Money: `numeric`/`decimal` (never `float` or `money` type)
- JSON: `jsonb` (never `json` — jsonb is faster for queries)
- Enums: PostgreSQL enums or string columns with check constraints

## Constraints

- Always add foreign key constraints
- Set appropriate `ON DELETE` behavior (CASCADE, SET NULL, RESTRICT)
- Add check constraints for data integrity
- Consider partial unique indexes for conditional uniqueness
