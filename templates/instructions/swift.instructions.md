---
description: 'Swift coding standards. Use when writing or reviewing Swift code. Covers SwiftUI patterns, concurrency, and Swift 6+ conventions for iOS/macOS development.'
applyTo: '**/*.swift'
---

# Swift Code Standards

## SwiftUI

- Keep views small — extract subviews into separate structs when a body exceeds ~30 lines
- Use `@State` for local view state, `@Binding` for child-to-parent communication
- Use `@Environment` for dependency injection from the environment
- Use `@Observable` (Observation framework) instead of `ObservableObject` (Swift 5.9+)
- Move business logic into a dedicated model or view model — views are for layout only
- Use `ViewModifier` for reusable styling — avoid deeply nested modifier chains
- Prefer `LazyVStack` / `LazyHStack` inside `ScrollView` for long lists
- Use `@ViewBuilder` for functions that return conditional view hierarchies

## Concurrency

- Use `async` / `await` for all asynchronous work — never completion handlers in new code
- Use `actor` for shared mutable state — replaces manual locking
- Mark UI-updating code with `@MainActor` — either on the function or the whole type
- Ensure all types passed across concurrency boundaries are `Sendable`
- Use `TaskGroup` for dynamic fan-out concurrency
- Use `Task.detached` only when you explicitly need to escape the current actor
- Use `AsyncStream` for converting callback-based APIs to async sequences
- Use `withCheckedThrowingContinuation` to bridge legacy completion handlers

## Types & Protocols

- Prefer `struct` over `class` — use classes only for identity semantics or Objective-C interop
- Use protocols with default implementations in extensions for shared behavior
- Use `enum` with associated values for modeling variants — avoid stringly-typed APIs
- Use `Codable` for serialization — custom `CodingKeys` only when JSON keys differ
- Use `@frozen` on public enums only when you guarantee no future cases

## Error Handling

- Use typed `throws` (Swift 6+) to declare specific error types: `func load() throws(NetworkError)`
- Use `Result<T, E>` for errors in callback-based or stored contexts
- Use `guard let` / `guard else` for early exits — avoid nested `if let` pyramids
- Use `do/catch` with pattern matching on specific error cases
- Mark functions `rethrows` when they only throw if a closure parameter throws

## Naming (Swift API Design Guidelines)

- Clarity at the point of use — name methods for how they read at the call site
- Omit needless words: `removeItem(at:)` not `removeItem(atIndex:)`
- Use grammatical English phrasing: `x.insert(y, at: z)` reads as "x, insert y at z"
- Boolean properties read as assertions: `isEmpty`, `hasContent`, `canSendMessage`
- Factory methods start with `make`: `makeIterator()`, `makeBody()`
- Protocols describing capability use `-able`/`-ible`: `Equatable`, `Sendable`

## Code Organization

- Use `// MARK: -` to organize sections within a file
- Use extensions to separate protocol conformances: `extension User: Codable { ... }`
- Keep one primary type per file — helper types can live alongside if tightly coupled
- Use `@testable import` in test targets to access internal members
- Use Swift Package Manager for dependencies — prefer it over CocoaPods/Carthage

## Access Control

- Default to the most restrictive access level — use `private` unless a wider scope is needed
- Use `internal` (the default) for module-internal APIs
- Use `public` for framework/library APIs — `open` only when subclassing is intended
- Use `package` access (Swift 5.9+) for multi-module packages sharing internals
