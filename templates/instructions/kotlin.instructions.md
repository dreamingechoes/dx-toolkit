---
description: 'Kotlin coding standards. Use when writing or reviewing Kotlin code. Covers null safety, coroutines, Compose patterns, and Kotlin 2.0+ conventions.'
applyTo: '**/*.kt, **/*.kts'
---

# Kotlin Code Standards

## Null Safety

- Never use `!!` — it's a crash waiting to happen
- Use safe calls (`?.`) chained with `?:` (elvis) for defaults: `user?.name ?: "Unknown"`
- Use `lateinit` only for dependency injection or lifecycle-initialized fields — never for general state
- Use `requireNotNull()` or `checkNotNull()` when null is a programmer error
- Prefer `value?.let { ... }` over `if (value != null)` for scoped null handling
- Use `filterNotNull()` on collections instead of manual null checks
- Return `null` from functions only when "nothing found" is a normal outcome — use exceptions for errors

## Coroutines

- Use structured concurrency — launch coroutines inside a `CoroutineScope`
- Never use `GlobalScope` — it leaks coroutines and ignores cancellation
- Use `viewModelScope` in ViewModels, `lifecycleScope` in Activities/Fragments
- Use `Flow` for reactive streams — prefer `StateFlow` for UI state, `SharedFlow` for events
- Use `withContext(Dispatchers.IO)` for blocking calls — don't block `Dispatchers.Main`
- Handle cancellation — check `isActive` in long loops, use `ensureActive()`
- Use `supervisorScope` when child failures shouldn't cancel siblings
- Use `flow { }` builder with `emit()` — never `callbackFlow` unless bridging callbacks

## Jetpack Compose

- Make composables stateless — accept state as parameters, emit events via lambdas
- Hoist state to the nearest common ancestor that needs it
- Use `remember { }` for expensive computations, `rememberSaveable` for surviving config changes
- Use `derivedStateOf { }` for state derived from other state — avoids unnecessary recompositions
- Always pass `Modifier` as the first optional parameter of composable functions
- Don't read state in composables that don't need it — avoid unnecessary recomposition
- Use `LaunchedEffect` for side effects tied to composition, `DisposableEffect` for cleanup
- Extract reusable UI into separate composable functions — keep composables small

## Data Modeling

- Use `data class` for types where equality is by value — get `copy()`, `equals()`, `toString()` free
- Use `sealed class` / `sealed interface` for restricted hierarchies — enforce exhaustive `when`
- Use `value class` (inline class) for type-safe wrappers with zero overhead: `value class UserId(val id: String)`
- Use `enum class` for fixed sets of constants, `sealed` when variants carry different data
- Use `object` for singletons and namespace-like groupings of related functions

## Kotlin Idioms

- Use `let` for null-scoped transformations: `value?.let { transform(it) }`
- Use `run` for scoped computations: `val result = config.run { build() }`
- Use `apply` for object configuration: `val view = TextView(context).apply { text = "Hi" }`
- Use `also` for side effects: `list.also { log.debug("Size: ${it.size}") }`
- Use `with` for calling multiple methods on an object without repeating the receiver
- Use extension functions for adding behavior to types you don't own
- Use `sequence { }` and `yield()` for lazy generation of large datasets
- Prefer `when` over long `if/else` chains — use it as an expression

## Error Handling

- Use `Result<T>` for operations that can fail in an expected way
- Use `runCatching { }` with `.getOrElse { }` or `.onFailure { }` for concise error handling
- Throw exceptions for programmer errors (`IllegalStateException`, `IllegalArgumentException`)
- Use sealed class hierarchies for domain errors when more than success/failure is needed

## Testing

- Use JUnit 5 with descriptive `@DisplayName` annotations
- Use `@Nested` inner classes for grouping related tests
- Use `kotlinx-coroutines-test` with `runTest` for coroutine testing
- Use `Turbine` for testing `Flow` emissions
- Use constructor injection over mocking when possible — mocks hide bad design
- Name tests as behaviors: `fun 'returns error when user not found'()`
