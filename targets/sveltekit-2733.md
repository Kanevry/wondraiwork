# [sveltekit] #2733 -- Scroll position not reset

> **Validation Note (2026-03-26):** Competing PR #15521 opened 2026-03-09.

| Field         | Value                                                |
| ------------- | ---------------------------------------------------- |
| Repo          | sveltejs/kit (20K stars)                             |
| Issue         | [#2733](https://github.com/sveltejs/kit/issues/2733) |
| Language      | TypeScript, JavaScript                               |
| Labels        | bug                                                  |
| Reactions     | 56                                                   |
| Assigned      | No                                                   |
| Competing PRs | 0                                                    |
| Status        | Open                                                 |

## Problem

When navigating between pages in SvelteKit, the scroll position is not consistently reset to the top
of the page. Users scroll down on one page, click a link to another page, and find themselves at the
same scroll position instead of the top. This breaks basic navigation expectations and is especially
noticeable on pages with long content.

## Impact

Affects all SvelteKit users building multi-page applications with scrollable content. With 56
reactions and 20K stars, this is a widely experienced and frustrating UX bug.

## Repo Health

- Maintainer activity: Very active. Rich Harris and the Svelte team are highly engaged.
- PR merge speed: Good for well-tested bug fixes. The team is responsive.
- Contributor-friendliness: Excellent. Clear contributing guide, well-structured codebase.

## Scoring

- Impact: 7 -- Affects basic navigation UX for all SvelteKit apps
- Feasibility: 6 -- Scroll behavior interacts with browser APIs, history state, and SvelteKit's
  navigation lifecycle in complex ways
- Visibility: 7 -- 20K stars, 56 reactions, core framework bug
- **Total: 20/30**

## Approach

1. Study SvelteKit's navigation lifecycle in `packages/kit/src/runtime/client/`
2. Identify where `window.scrollTo(0, 0)` should be called during route transitions
3. Check interaction with `afterNavigate`, browser back/forward, and hash links
4. Ensure the fix respects `scrollBehavior` configuration and anchor navigation
5. Test with various navigation patterns: link clicks, `goto()`, back/forward, hash links

## Notes

Scroll behavior in SPAs is notoriously tricky. The fix needs to handle multiple navigation types
correctly: programmatic navigation, link clicks, browser history navigation (which should restore
previous scroll position), and hash-based anchor navigation. SvelteKit may already have scroll
handling logic that needs to be fixed rather than added from scratch.
