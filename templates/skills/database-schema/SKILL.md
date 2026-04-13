---
name: database-schema
description: 'Design a database schema from requirements. Use when creating new tables, planning schema changes, or reviewing database design. Produces table definitions, indexes, constraints, and migration plans.'
---

# Database Schema Design

## When to Use

- Designing a new database schema
- Adding tables or columns to an existing schema
- Reviewing or optimizing database design
- Planning a data model for a new feature

## Procedure

1. **Extract entities** from the requirements:
   - Identify the main domain objects
   - Map relationships (one-to-one, one-to-many, many-to-many)
   - Identify attributes and their types

2. **Design tables** for each entity:

```sql
CREATE TABLE users (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email      text NOT NULL UNIQUE,
  name       text NOT NULL,
  role       text NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin')),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
```

3. **Apply normalization and constraints**:
   - Normalize to 3NF by default
   - Denormalize intentionally for read performance (document the tradeoff)
   - Add NOT NULL unless the field is genuinely optional
   - Add CHECK constraints for valid value ranges
   - Add UNIQUE constraints for business keys
   - Add foreign key constraints with appropriate ON DELETE behavior

4. **Design indexes**:
   - Primary key (automatic)
   - Foreign keys (always index)
   - Columns used in WHERE clauses
   - Columns used in ORDER BY
   - Composite indexes matching query patterns (column order matters)
   - Partial indexes for filtered queries
   - GIN indexes for JSONB and array columns

5. **Produce the schema**:

```markdown
## Schema: [Feature Name]

### Entity Relationship

[Describe relationships in plain language]

- A User has many Posts (1:N)
- A Post has many Tags through PostTags (M:N)

### Tables

#### `users`

| Column     | Type        | Constraints                   | Notes        |
| ---------- | ----------- | ----------------------------- | ------------ |
| id         | uuid        | PK, DEFAULT gen_random_uuid() |              |
| email      | text        | NOT NULL, UNIQUE              | Business key |
| name       | text        | NOT NULL                      |              |
| created_at | timestamptz | NOT NULL, DEFAULT now()       |              |
| updated_at | timestamptz | NOT NULL, DEFAULT now()       |              |

#### Indexes

- `users_email_idx` UNIQUE on (email)

### Migration Plan

1. Create `users` table
2. Create `posts` table with FK to users
3. Add indexes
4. Seed initial data (if needed)

### Performance Notes

- [Query patterns and expected index usage]
- [Partitioning strategy if table will be large]
```

## Column Type Guidelines (PostgreSQL)

| Use Case    | Recommended              | Avoid                                    |
| ----------- | ------------------------ | ---------------------------------------- |
| Primary key | `uuid` (v7)              | `serial`, `bigserial`                    |
| Timestamps  | `timestamptz`            | `timestamp` (no timezone)                |
| Text        | `text`                   | `varchar(n)` (unless max length matters) |
| Money       | `numeric(12,2)`          | `float`, `money`                         |
| JSON        | `jsonb`                  | `json`                                   |
| Boolean     | `boolean`                | `smallint`                               |
| IP address  | `inet`                   | `text`                                   |
| Ranges      | `tstzrange`, `int4range` | Two separate columns                     |
