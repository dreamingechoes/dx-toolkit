---
description: 'Python coding standards. Use when writing or reviewing Python code. Covers type hints, async patterns, project structure, and modern Python 3.12+ conventions.'
applyTo: '**/*.py'
---

# Python Code Standards

## Code Style

- Format with `ruff` — enforce `ruff check` and `ruff format` in CI
- Use f-strings for interpolation — never `%` or `.format()`
- Use the walrus operator (`:=`) to reduce redundant calls in conditions
- Prefer list/dict/set comprehensions over `map()`/`filter()` with lambdas
- Use `pathlib.Path` instead of `os.path` for file operations
- Use `from __future__ import annotations` for forward references (pre-3.12)
- Keep functions under 30 lines — extract helpers when logic branches

## Type Hints

- Annotate all public functions (parameters and return types)
- Use `X | Y` union syntax instead of `Union[X, Y]` (3.10+)
- Use `list[str]` lowercase generics instead of `List[str]` (3.9+)
- Use `Pydantic` BaseModel for data validation and serialization
- Use `TypeAlias` or `type` statement (3.12+) for complex type aliases
- Use `@overload` when a function's return type depends on input types
- Use `Protocol` for structural subtyping instead of ABCs when possible

## Error Handling

- Catch specific exceptions — never bare `except:` or `except Exception:`
- Create custom domain exceptions inheriting from a base app exception
- Use `raise ... from err` to chain exceptions and preserve tracebacks
- Use `contextlib.suppress()` instead of empty `except` blocks
- Validation errors should be raised at system boundaries, not deep in logic
- Never silence `KeyboardInterrupt` or `SystemExit`

## Project Structure

- Use `src/` layout: `src/mypackage/` with `pyproject.toml` at root
- Define public API in `__init__.py` — keep it minimal
- Use `pyproject.toml` for all project metadata, deps, and tool config
- Pin dependencies in `requirements.lock` or `uv.lock` — ranges in `pyproject.toml`
- One class per file when the class is substantial — group small related classes

## Async Patterns

- Use `async def` / `await` — never `loop.run_until_complete()` in async code
- Use `asyncio.TaskGroup` (3.11+) for concurrent tasks with proper cancellation
- Use `async with` for context managers that manage async resources
- Use `asyncio.timeout()` (3.11+) instead of `asyncio.wait_for()` where possible
- Never block the event loop — offload CPU work with `run_in_executor()`

## Testing (pytest)

- Use `pytest` — never `unittest.TestCase` for new tests
- Use fixtures for setup/teardown — prefer factory fixtures over shared state
- Use `@pytest.mark.parametrize` for testing multiple inputs
- Name tests as behaviors: `test_returns_error_when_user_not_found`
- Use `tmp_path` fixture for file operations — never hardcode paths
- Use `monkeypatch` for environment variables and module-level patches
- Mock at system boundaries (HTTP, DB, filesystem) — not internal functions

## Constants & Configuration

- Use `enum.StrEnum` (3.11+) for string constants
- Use `dataclasses` for simple data containers, `Pydantic` when validation is needed
- Load config from environment using `pydantic-settings` or `os.environ` with defaults
- Use `functools.cache` or `functools.lru_cache` for expensive pure computations

## Imports

- Order: stdlib → third-party → local (enforced by `ruff` isort rules)
- Use absolute imports — avoid relative imports except within packages
- Use `import module` over `from module import *`
- Use `TYPE_CHECKING` block for import-only-for-types to avoid circular imports
