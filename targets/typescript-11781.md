# [TypeScript] #11781 -- Service Worker typings

| Field         | Value                                                          |
| ------------- | -------------------------------------------------------------- |
| Repo          | microsoft/TypeScript (108K stars)                              |
| Issue         | [#11781](https://github.com/microsoft/TypeScript/issues/11781) |
| Language      | TypeScript                                                     |
| Labels        | Suggestion, Domain: lib.d.ts                                   |
| Reactions     | 94                                                             |
| Assigned      | No                                                             |
| Competing PRs | 0 (historical discussion, no active PRs)                       |
| Status        | Open                                                           |

## Problem

TypeScript does not provide built-in type definitions for the Service Worker API
(`ServiceWorkerGlobalScope`). Developers writing service workers in TypeScript must use
`/// <reference lib="webworker" />` which provides Web Worker types but not the full Service Worker
API surface (e.g., `FetchEvent`, `ExtendableEvent`, `clients`, `registration`, `skipWaiting()`). The
`webworker` lib types are incomplete for the service worker context.

## Impact

Affects all TypeScript developers writing service workers, which includes anyone building PWAs,
offline-first applications, or using frameworks like Workbox. With 94 reactions and 108K stars, this
is a well-known gap in TypeScript's standard library types.

## Repo Health

- Maintainer activity: Extremely active. Microsoft's TypeScript team ships regular releases.
- PR merge speed: Slow for lib.d.ts changes. Requires careful review and compatibility analysis.
- Contributor-friendliness: Mixed for type definition changes. High standards, extensive review
  process.

## Scoring

- Impact: 7 -- Affects PWA/service worker developers, a growing segment
- Feasibility: 5 -- The types themselves are straightforward to define, but getting them accepted
  into lib.d.ts requires navigating the TypeScript team's process for new global types
- Visibility: 8 -- 108K stars, 94 reactions, would appear in release notes
- **Total: 20/30**

## Approach

1. Audit the current `webworker` lib types to identify what Service Worker-specific APIs are missing
2. Cross-reference with the W3C Service Worker spec and MDN documentation
3. Add missing types (`FetchEvent`, `ExtendableEvent`, `ExtendableMessageEvent`,
   `ServiceWorkerGlobalScope` extensions)
4. Either extend the existing `webworker` lib or propose a new `serviceworker` lib target
5. Include tests verifying common service worker patterns type-check correctly

## Notes

The TypeScript team has discussed this issue multiple times without reaching a resolution. The main
question is whether to extend `lib.webworker.d.ts` or create a separate `lib.serviceworker.d.ts`. A
successful contribution here requires understanding the TypeScript team's lib management strategy.
Consider reviewing the issue thread history carefully and possibly opening a discussion before
submitting code.
