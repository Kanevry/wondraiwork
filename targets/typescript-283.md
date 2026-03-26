# [TypeScript] #283 -- cloneNode returns Node not subtype

> **Validation Note (2026-03-26):** Open since 2014 (12+ years). Multiple historical attempts
> failed. Likely intentionally deferred. Aspirational target only.

| Field         | Value                                                      |
| ------------- | ---------------------------------------------------------- |
| Repo          | microsoft/TypeScript (108K stars)                          |
| Issue         | [#283](https://github.com/microsoft/TypeScript/issues/283) |
| Language      | TypeScript                                                 |
| Labels        | Suggestion, Domain: lib.d.ts                               |
| Reactions     | ~150                                                       |
| Assigned      | No                                                         |
| Competing PRs | 0 (multiple historical attempts, none merged)              |
| Status        | Open                                                       |

## Problem

`cloneNode()` in the DOM typings always returns `Node` regardless of the type it is called on. If
you call `element.cloneNode(true)` where `element` is an `HTMLDivElement`, the return type is
`Node`, not `HTMLDivElement`. This forces developers to cast the result every time, which is both
tedious and error-prone. The issue has been open since 2014 (over 12 years).

## Impact

Affects every TypeScript developer who uses `cloneNode()` in DOM manipulation code. This is one of
the oldest open issues on the TypeScript repo and has accumulated significant community interest
over the years.

## Repo Health

- Maintainer activity: Extremely active. Microsoft's TypeScript team ships regular releases.
- PR merge speed: Slow for lib.d.ts changes due to compatibility concerns. Requires design approval.
- Contributor-friendliness: Mixed. The team is responsive but has very high standards for type
  changes that affect the global DOM typings.

## Scoring

- Impact: 8 -- Affects all TS DOM developers, 12-year-old pain point
- Feasibility: 4 -- Multiple prior attempts failed. The challenge is that `cloneNode(deep)` cannot
  safely return `this` type due to the deep clone potentially having different child types. Requires
  a design-level decision from the TS team.
- Visibility: 9 -- 108K stars, iconic issue, would be a landmark fix
- **Total: 21/30**

## Approach

1. Study prior discussions and attempts on the issue thread
2. The most viable approach: change `cloneNode()` return type to `this` using polymorphic `this`
   types in lib.dom.d.ts
3. Evaluate the soundness concern: `cloneNode(false)` (shallow clone) returning `this` is sound for
   element types, but `cloneNode(true)` (deep clone) technically clones children too
4. Prepare a PR with the type change plus a detailed analysis of potential breakage
5. Engage the TypeScript design team before submitting

## Notes

This is a "white whale" issue. The technical fix is simple (change return type to `this`), but the
TypeScript team has not merged it due to soundness concerns and the risk of breaking existing code
that relies on the `Node` return type. A successful contribution here would require building
consensus on the design issue first. High reward but uncertain outcome.
