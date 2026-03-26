# [next.js] #56398 -- Middleware matcher template literals

| Field         | Value                                                    |
| ------------- | -------------------------------------------------------- |
| Repo          | vercel/next.js (138K stars)                              |
| Issue         | [#56398](https://github.com/vercel/next.js/issues/56398) |
| Language      | TypeScript                                               |
| Labels        | Middleware                                               |
| Reactions     | ~15                                                      |
| Assigned      | No                                                       |
| Competing PRs | 0                                                        |
| Status        | Open                                                     |

## Problem

Next.js middleware `matcher` configuration does not support template literals or string
interpolation. Developers must use plain string literals for route patterns, which prevents dynamic
or computed matcher patterns. This forces duplication when the same path segments are used across
multiple matchers or when paths are generated from a shared constant.

## Impact

Affects Next.js developers using middleware with route matching, especially those with complex
routing configurations that share path segments. With 138K stars and middleware being a key Next.js
feature, this is a meaningful DX improvement.

## Repo Health

- Maintainer activity: Extremely active. Vercel team ships frequently.
- PR merge speed: Variable. Middleware-related changes need careful review due to edge runtime
  implications.
- Contributor-friendliness: Good. Large contributor community, clear issue templates.

## Scoring

- Impact: 6 -- DX improvement for middleware users, reduces route duplication
- Feasibility: 6 -- Requires changes to the matcher config parsing, which runs at build time. Need
  to evaluate template literals at compile time or document the limitation.
- Visibility: 8 -- 138K stars, middleware is a prominent Next.js feature
- **Total: 20/30**

## Approach

1. Locate the matcher config parsing in `packages/next/src/build/`
2. Investigate how matcher strings are currently processed (likely static analysis at build time)
3. Options: (a) Support template literals by evaluating them at build time, (b) Support arrays of
   string constants that are joined, (c) Support a function-based matcher config
4. Ensure the change works with both Edge and Node.js runtimes
5. Add test cases for template literal matchers

## Notes

The core challenge is that Next.js analyzes middleware config statically at build time. Template
literals with dynamic expressions cannot be evaluated statically. The fix may be limited to
supporting template literals with only static expressions (no runtime variables), or the approach
may need to shift to supporting shared constants via a different mechanism.
