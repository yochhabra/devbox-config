# Design Quality Standards

## Design Before Code

Before writing any implementation:
1. **Identify responsibilities** — what distinct things does this code need to do? Each one becomes a class or method.
2. **Read surrounding code** — look at 2-3 similar classes in the same package. Match their patterns: naming, structure, abstractions, dependency injection style.
3. **Choose the right pattern** — don't default to the simplest implementation. Ask: will this need to change? Will there be more variants? (see patterns below)
4. **Sketch the structure** — which classes, which interfaces, where do they live in the package hierarchy?

Only then start writing code.

## Core Principles

### Single Responsibility (strictly enforced)
- One class = one reason to change
- If a class name needs "And" or "Manager" or "Helper" or "Utils" → split it
- A method should do ONE thing. If you can describe it as "does X and then Y" → two methods.

### Open for Extension, Closed for Modification
- New behavior = new class implementing an interface, not modifying an existing class
- Use strategy pattern, not if/else chains that grow over time
- Enums with behavior → consider polymorphism instead

### Dependency Inversion
- Depend on interfaces, not implementations
- Constructor injection over field injection
- No static method calls to other services — inject the dependency

### Interface Segregation
- Small, focused interfaces over fat ones
- A class should not be forced to implement methods it doesn't need

## When to Use Which Pattern

| Situation | Pattern | Not This |
|-----------|---------|----------|
| Multiple ways to do the same thing | Strategy | if/else chain or switch |
| Building complex objects | Builder | Constructor with 5+ params |
| Creating objects without specifying exact class | Factory | Direct `new` with conditionals |
| One-to-many notifications | Observer/Event | Direct method calls to all dependents |
| Adding behavior without modifying | Decorator | Modifying the original class |
| Complex object transformation | Mapper class | Inline conversion at call site |
| State-dependent behavior | State pattern | Boolean flags + conditionals |

## Code Structure Rules

### Package/File Organization
- Group by feature, not by layer (not `controllers/`, `services/`, `models/` — instead `notifications/`, `approvals/`)
- One public class per file
- Related private/package-private classes can be in same package but separate files

### Method Design
- Max 15 lines per method (hard limit for worker Claudes). Extract sub-methods.
- Method names tell what it does: `calculateDiscountForPremiumUser()` not `process()`
- No boolean parameters — use two methods with clear names, or an enum
- Return early for edge cases, keep the happy path unindented

### Class Design
- Max 200 lines per class. If larger → split by responsibility.
- Constructor should only assign fields. No logic, no I/O.
- Prefer composition over inheritance
- If you're inheriting just to reuse code → use composition with a delegate

### Naming
- Classes: noun that describes the responsibility (`NotificationRouter`, `ApprovalValidator`)
- Methods: verb that describes the action (`routeToSlack`, `validateApproverAccess`)
- Variables: describe what it holds, not how it's used (`eligibleApprovers` not `list`)
- No abbreviations unless universally understood (`url`, `id`, `config`)

## Matching Existing Codebase

Before writing new code in a package:
1. `ls` the package — understand existing file organization
2. Read 1-2 existing classes — note their structure (constructor style, method length, naming conventions)
3. Check if there's a base class or interface you should implement
4. Use the SAME patterns (if existing code uses Builder, use Builder. If it uses Factory, use Factory.)
5. If existing code violates these principles, match it anyway — consistency > perfection in someone else's code. Flag in `decisions_made` that you matched existing (suboptimal) patterns.
