---
name: refactoring-catalog
description: 'Catalog of safe refactoring patterns with before/after examples. Use when code works but structure needs improvement. Each pattern includes safety checklist and test requirements.'
---

# Refactoring Catalog

## Overview

Refactoring changes code structure without changing behavior. The word "without" is doing all the heavy lifting — if behavior changes, it's not a refactoring, it's a rewrite. This skill provides a catalog of safe, repeatable refactoring patterns with clear before/after examples and safety checklists.

Every refactoring in this catalog follows the same cycle: verify tests exist → apply the transformation → run tests → commit. If tests don't exist, write them first. Refactoring without tests is just editing code and hoping.

## When to Use

- Code works correctly but is hard to read, modify, or extend
- You spot a code smell during code review
- Before adding a new feature to code that's tangled
- During dedicated refactoring time (tech debt sprints)
- After a bug fix, to prevent the same bug pattern from recurring

**When NOT to use:** Code that doesn't work yet. Fix the bug first, then refactor. Don't refactor and change behavior in the same commit.

## Process

### Step 1 — Identify the Smell

Code smells are symptoms, not problems. Match the smell to a refactoring.

| Smell                   | Symptoms                                           | Suggested Refactoring                                        |
| ----------------------- | -------------------------------------------------- | ------------------------------------------------------------ |
| Long function           | Function > 20 lines, does multiple things          | Extract Function                                             |
| Duplicated logic        | Same code in 2+ places                             | Extract Function, Pull Up Method                             |
| Magic numbers / strings | Unexplained literals in logic                      | Replace Magic Number with Constant                           |
| Long parameter list     | Function takes > 3 parameters                      | Introduce Parameter Object                                   |
| Feature envy            | Method uses another class's data more than its own | Move Function                                                |
| Nested conditionals     | 3+ levels of if/else nesting                       | Decompose Conditional, Replace Conditional with Polymorphism |
| Temp variable overuse   | Variable assigned, used once, obscures intent      | Replace Temp with Query                                      |
| Data clump              | Same group of fields passed together repeatedly    | Extract Class, Introduce Parameter Object                    |
| Primitive obsession     | Using strings/ints where a domain type fits        | Extract Class, Replace Primitive with Object                 |
| Shotgun surgery         | One change requires editing many files             | Move Function, Extract Class                                 |
| God class               | One class does everything                          | Extract Class                                                |
| Loop with logic         | Loops that filter, transform, and accumulate       | Replace Loop with Pipeline                                   |

### Step 2 — Select the Refactoring

Use the catalog below. Each entry includes the pattern, when to use it, and before/after examples.

---

#### Catalog

##### 1. Extract Function

**When:** A code block can be grouped under a descriptive name.

```
// Before
function processOrder(order) {
  // validate
  if (!order.items.length) throw new Error("Empty order")
  if (!order.customer) throw new Error("No customer")

  // calculate total
  let total = 0
  for (const item of order.items) {
    total += item.price * item.quantity
  }
  // ...
}

// After
function processOrder(order) {
  validateOrder(order)
  const total = calculateTotal(order.items)
  // ...
}

function validateOrder(order) {
  if (!order.items.length) throw new Error("Empty order")
  if (!order.customer) throw new Error("No customer")
}

function calculateTotal(items) {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0)
}
```

##### 2. Inline Function

**When:** A function body is as clear as its name, or a function is just a thin wrapper.

```
// Before
function isAdult(age) { return age >= 18 }
if (isAdult(user.age)) { ... }

// After
if (user.age >= 18) { ... }
```

##### 3. Extract Variable

**When:** A complex expression is hard to understand.

```
// Before
if (order.total > 100 && order.customer.tier === "gold" && !order.hasDiscount) {

// After
const isEligibleForDiscount = order.total > 100
  && order.customer.tier === "gold"
  && !order.hasDiscount
if (isEligibleForDiscount) {
```

##### 4. Rename (Variable, Function, Class)

**When:** The name doesn't communicate purpose.

```
// Before
const d = new Date() - startTime
function proc(u) { ... }

// After
const elapsedMs = new Date() - startTime
function processUserRegistration(user) { ... }
```

##### 5. Move Function

**When:** A function uses more data from another module than its current one.

```
// Before — calculateShipping lives in OrderUtils but only uses Address fields
OrderUtils.calculateShipping(address)

// After — moved to where the data lives
Address.calculateShipping()
```

##### 6. Pull Up Method

**When:** Subclasses share identical method implementations.

```
// Before
class Dog { getName() { return this.name } }
class Cat { getName() { return this.name } }

// After
class Animal { getName() { return this.name } }
class Dog extends Animal {}
class Cat extends Animal {}
```

##### 7. Replace Conditional with Polymorphism

**When:** A switch/case or if/else chain selects behavior based on type.

```
// Before
function calculatePay(employee) {
  switch (employee.type) {
    case "hourly": return employee.hours * employee.rate
    case "salaried": return employee.salary / 24
    case "contractor": return employee.hours * employee.rate * 1.2
  }
}

// After
class HourlyEmployee {
  calculatePay() { return this.hours * this.rate }
}
class SalariedEmployee {
  calculatePay() { return this.salary / 24 }
}
class Contractor {
  calculatePay() { return this.hours * this.rate * 1.2 }
}
```

##### 8. Replace Magic Number with Constant

**When:** A literal number or string appears in logic without explanation.

```
// Before
if (password.length < 8) { ... }
if (retries > 3) { ... }

// After
const MIN_PASSWORD_LENGTH = 8
const MAX_RETRIES = 3
if (password.length < MIN_PASSWORD_LENGTH) { ... }
if (retries > MAX_RETRIES) { ... }
```

##### 9. Introduce Parameter Object

**When:** Multiple parameters are always passed together.

```
// Before
function searchEvents(startDate, endDate, lat, lng, radius) { ... }

// After
function searchEvents(dateRange, location) { ... }
// where dateRange = { start, end }
// where location = { lat, lng, radius }
```

##### 10. Extract Class

**When:** A class has multiple responsibilities or groups of fields that belong together.

```
// Before
class User {
  name; email; street; city; zip; country;
  fullAddress() { return `${this.street}, ${this.city}, ${this.zip}` }
}

// After
class User {
  name; email; address;
}
class Address {
  street; city; zip; country;
  full() { return `${this.street}, ${this.city}, ${this.zip}` }
}
```

##### 11. Replace Loop with Pipeline

**When:** A loop filters, maps, and/or reduces data.

```
// Before
const result = []
for (const user of users) {
  if (user.active) {
    result.push(user.name.toUpperCase())
  }
}

// After
const result = users
  .filter(user => user.active)
  .map(user => user.name.toUpperCase())
```

##### 12. Decompose Conditional

**When:** A complex conditional obscures what's being checked.

```
// Before
if (date >= SUMMER_START && date <= SUMMER_END) {
  charge = quantity * summerRate
} else {
  charge = quantity * winterRate
}

// After
if (isSummer(date)) {
  charge = summerCharge(quantity)
} else {
  charge = winterCharge(quantity)
}
```

##### 13. Consolidate Conditional

**When:** Multiple conditions lead to the same result.

```
// Before
if (age < 18) return 0
if (!isActive) return 0
if (isBanned) return 0

// After
if (isIneligible(age, isActive, isBanned)) return 0
```

##### 14. Replace Temp with Query

**When:** A temporary variable holds a value that could be a function call.

```
// Before
const basePrice = quantity * itemPrice
if (basePrice > 1000) { ... }

// After
if (basePrice(quantity, itemPrice) > 1000) { ... }
function basePrice(quantity, itemPrice) { return quantity * itemPrice }
```

##### 15. Encapsulate Record

**When:** Raw data structures are accessed directly throughout the codebase.

```
// Before
const name = userData["name"]
userData["email"] = newEmail

// After
class User {
  #data
  get name() { return this.#data.name }
  set email(value) { this.#data.email = value }
}
```

### Step 3 — Verify Test Coverage

Before applying any refactoring:

1. Run existing tests — they must all pass
2. Check coverage for the code you're about to change
3. If coverage is insufficient, write characterization tests first:
   - Call the function with known inputs
   - Assert the current outputs (even if you don't understand why)
   - These tests lock in existing behavior

### Step 4 — Apply the Refactoring

Make the mechanical change. One refactoring per commit.

**Rules:**

- Change structure only — never change behavior in the same commit
- If you spot a bug during refactoring, note it and fix it in a separate commit
- Keep changes small — if a refactoring touches > 10 files, break it into smaller steps
- Use your IDE's refactoring tools when available (rename, extract method)

### Step 5 — Run Tests

All tests must pass after the refactoring. If any test fails:

1. The refactoring changed behavior — revert and try again
2. The test was testing implementation details, not behavior — fix the test
3. You found a pre-existing bug — note it, revert, fix the bug first

### Step 6 — Commit

Commit with a message that describes the refactoring, not the smell.

```
Good: refactor: extract calculateTotal from processOrder
Good: refactor: replace magic numbers with named constants in auth module
Bad:  refactor: cleanup
Bad:  refactor: improve code quality
```

## Common Rationalizations

| Rationalization                                   | Reality                                                                                                                                      |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| "I'll refactor and add the feature in one PR"     | Mixing refactoring and behavior changes makes review harder and bugs easier to introduce. Separate commits at minimum, separate PRs ideally. |
| "The tests are too slow to run after every step"  | That's a test infrastructure problem, not a reason to skip verification. Fix the test speed separately.                                      |
| "This code is so bad it needs a rewrite"          | Incremental refactoring is almost always safer than a rewrite. Rewrite only when the interface is also wrong.                                |
| "I don't need tests — it's a simple rename"       | Renames are safe. Everything else needs tests. And even renames should be verified with a test run.                                          |
| "Let me refactor the whole module while I'm here" | Refactor only the code in the path of your current task. Drive-by refactoring causes merge conflicts and review fatigue.                     |

## Red Flags

- Refactoring code without existing tests
- Changing behavior during a refactoring (that's a rewrite)
- Refactoring and feature work in the same commit
- Touching files unrelated to the current task ("while I'm here...")
- Spending more time refactoring than the feature work requires
- Refactoring code that's about to be deleted or replaced
- No clear smell — refactoring because of style preference, not structural issue

## Verification

- [ ] Code smell was identified before selecting the refactoring
- [ ] Tests existed (or were written) before the refactoring started
- [ ] All tests pass after the refactoring
- [ ] Behavior is unchanged — no functional differences
- [ ] Refactoring is in its own commit, separate from feature work
- [ ] Commit message names the specific refactoring applied
- [ ] The code is measurably easier to read, modify, or extend
