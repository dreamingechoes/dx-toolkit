---
description: 'Rust coding standards. Use when writing or reviewing Rust code. Covers ownership patterns, error handling, and idiomatic Rust 2024 edition practices.'
applyTo: '**/*.rs'
---

# Rust Code Standards

## Ownership & Borrowing

- Prefer borrowing (`&T` / `&mut T`) over taking ownership — clone only when necessary
- Use references in function parameters unless the function needs to store the value
- Use lifetime elision rules — don't annotate lifetimes explicitly when the compiler can infer
- Prefer `&str` over `&String`, `&[T]` over `&Vec<T>` in function parameters
- Use `Cow<'_, str>` when a function might or might not need to allocate

## Error Handling

- Use `thiserror` for library error types — derive `Error` with `#[error("...")]`
- Use `anyhow` for application code — `Result<T>` with contextual `.context("...")`
- Use the `?` operator for propagation — avoid manual `match` on `Result`
- Never use `.unwrap()` or `.expect()` in production code paths
- Use `.unwrap_or_default()`, `.unwrap_or_else()`, or `let-else` for fallbacks
- Create an error enum per module boundary — keep variants specific
- Use `#[from]` attribute in `thiserror` for automatic error conversion

## Types & Patterns

- Use the newtype pattern to add type safety: `struct UserId(u64)`
- Use the builder pattern for types with many optional fields
- Implement `From`/`Into` for type conversions — avoid `as` for lossy casts
- Use `#[must_use]` on functions where ignoring the return value is a bug
- Prefer `enum` with variants over boolean flags — `enum Status { Active, Inactive }`
- Use `#[non_exhaustive]` on public enums to allow future variants

## Unsafe

- Minimize `unsafe` blocks — isolate them behind safe public APIs
- Document safety invariants with `// SAFETY:` comments above each `unsafe` block
- Never use `unsafe` for performance without benchmarks proving it's necessary
- Prefer safe abstractions: `Vec`, `Box`, `Arc` over raw pointers
- Use `#[deny(unsafe_op_in_unsafe_fn)]` to enforce explicit unsafe in unsafe functions

## Performance

- Use iterators and combinators (`.map()`, `.filter()`, `.collect()`) over manual loops
- Use `Cow<'_, str>` for zero-copy string handling when allocation may be avoidable
- Avoid allocations in hot paths — reuse buffers, prefer `&str` over `String`
- Use `#[inline]` sparingly — only for small functions in library crates across crate boundaries
- Benchmark with `criterion` before and after optimization — never optimize by guessing
- Use `SmallVec` or `ArrayVec` for small, fixed-size collections on the stack

## Clippy & Linting

- Enable `#![deny(clippy::all)]` and `#![warn(clippy::pedantic)]` at crate root
- Address all Clippy warnings — suppress with `#[allow(...)]` only with a justifying comment
- Use `rustfmt` with default settings — check formatting in CI
- Enable `#![deny(missing_docs)]` for library crates

## Concurrency

- Use `Arc<Mutex<T>>` for shared mutable state — prefer `RwLock` for read-heavy workloads
- Use `tokio` for async runtime — don't mix async runtimes
- Use `Send + Sync` bounds explicitly when writing generic concurrent code
- Prefer channels (`mpsc`, `oneshot`) over shared state when possible
- Use `rayon` for CPU-bound parallelism — it handles work-stealing automatically

## Project Structure

- Use a workspace (`Cargo.toml` with `[workspace]`) for multi-crate projects
- Keep `main.rs` thin — delegate to a `lib.rs` for testability
- Feature-gate optional dependencies with `#[cfg(feature = "...")]`
- Use `pub(crate)` for internal visibility — minimize the public API surface
