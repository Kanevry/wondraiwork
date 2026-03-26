# [vercel/ai] #7819 -- useChat stale closure bug

> **Validation Note (2026-03-26):** Partial fix merged (#8985 Jan 2026). 2 competing open PRs.
> Remaining scope: transport#body stale state.

| Field         | Value                                             |
| ------------- | ------------------------------------------------- |
| Repo          | vercel/ai (23K stars)                             |
| Issue         | [#7819](https://github.com/vercel/ai/issues/7819) |
| Language      | TypeScript                                        |
| Labels        | bug                                               |
| Reactions     | ~8                                                |
| Assigned      | No                                                |
| Competing PRs | 2 (not merged)                                    |
| Status        | Open                                              |

## Problem

The `useChat` hook from the Vercel AI SDK suffers from a stale closure bug where callback functions
(like `onFinish`, `onError`, or custom `fetch` wrappers) capture outdated state values. When these
callbacks reference React state that has changed since the hook was initialized or last rendered,
they operate on stale data. This is a classic React hooks closure issue.

## Impact

Affects developers building AI chat interfaces with the Vercel AI SDK. Common scenario: using
state-dependent logic in `onFinish` to update UI or trigger side effects based on current app state.
The SDK has 23K stars and is the most popular AI integration library for React.

## Repo Health

- Maintainer activity: Active. Vercel team maintains it, regular releases.
- PR merge speed: Moderate. Two existing PRs for this issue have not been merged, suggesting the
  team wants a specific approach.
- Contributor-friendliness: Good. Clear issue templates, TypeScript throughout, good test coverage.

## Scoring

- Impact: 8 -- Affects core functionality (chat callbacks) of a popular SDK
- Feasibility: 6 -- Stale closure fixes require careful React hook design; 2 prior PRs failed to
  merge
- Visibility: 8 -- 23K stars, AI/LLM space is high-profile
- **Total: 22/30**

## Approach

1. Study the 2 existing unmerged PRs to understand what approaches were tried and why they were not
   accepted
2. Investigate the `useChat` implementation in `packages/react/src/use-chat.ts`
3. Apply the standard React pattern: use `useRef` to hold the latest callback references, updated
   via `useEffect`
4. Ensure the fix does not break the streaming behavior or introduce unnecessary re-renders
5. Add tests reproducing the stale closure scenario

## Notes

The existence of 2 unmerged PRs is a risk factor. Before starting work, it would be worth commenting
on the issue to ask the maintainers what approach they prefer. The stale closure pattern is
well-understood (`useRef` + `useEffect` to sync latest values), but the challenge may be in how it
interacts with the streaming/abort logic.
