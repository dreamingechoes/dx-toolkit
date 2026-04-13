---
description: 'Elixir coding standards. Use when writing or reviewing Elixir code. Covers OTP patterns, error handling, documentation, and testing conventions.'
applyTo: '**/*.ex, **/*.exs'
---

# Elixir Code Standards

## Language Conventions

- Use the pipe operator `|>` for data transformation chains
- Pattern match in function heads instead of conditionals
- Prefer multi-clause functions over `case`/`cond` when dispatching on arguments
- Use `with` for happy-path chains that can fail at each step
- Use guards (`when`) to constrain function clauses
- Prefix unused variables with `_`

## OTP & Processes

- Always use a supervision tree — never start unsupervised processes
- Use `GenServer` for stateful processes, `Task` for fire-and-forget work
- Name processes via the Registry, not atoms (avoids atom table leaks)
- Set timeouts on `GenServer.call/3` — never rely on the default 5s in production
- Use `handle_continue/2` for post-init work instead of `send(self(), ...)`

## Error Handling

- Return `{:ok, result}` / `{:error, reason}` tuples — don't raise for expected failures
- Use `!` suffix functions (e.g., `Repo.get!`) only when you want to crash on failure
- Let processes crash and restart via supervisors — don't over-rescue

## Documentation

- Add `@moduledoc` to every module
- Add `@doc` to public functions
- Use `@spec` for public function typespecs
- Use doctests for simple, demonstrable functions

## Testing (ExUnit)

- Use `describe` blocks to group related tests
- Use `setup` for shared test context
- Use `Mox` for mocking — define behaviours, not concrete modules
- Use `async: true` when tests don't share state
- Name tests as behaviors: `test "returns error when user not found"`
