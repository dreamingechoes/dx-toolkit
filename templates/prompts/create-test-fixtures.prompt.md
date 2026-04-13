---
description: 'Generate test fixtures, factories, or seed data for the project. Creates realistic test data matching the schema and relationships.'
agent: 'agent'
---

Generate test fixtures, factories, or seed data for this project.

## Procedure

1. **Identify data models**: Read schema files, migrations, type definitions, or ORM models
2. **Detect existing patterns**: Check for existing factories, fixtures, or seed files
3. **Generate factories/fixtures** for each model:
   - Realistic default values (not "test" or "string")
   - Proper relationships between models (foreign keys, associations)
   - Trait/variant support for different test scenarios
   - Sequence generators for unique fields (emails, usernames)
4. **Add seed script** if needed for development database setup

## Rules

- Match the project's existing factory pattern (FactoryBot, Fishery, ex_machina, factory_boy, etc.)
- Use realistic values: "jane.doe@example.com" not "test@test.com"
- Handle unique constraints with sequences or UUIDs
- Include edge cases as named traits/variants (admin user, deleted record, expired subscription)
- Don't generate more data than tests need — keep fixtures minimal
- Respect required fields and validations in the schema
