# [next.js] #42846 -- AppType parameter fix

| Field | Value |
|-------|-------|
| Repo | vercel/next.js (138K stars) |
| Issue | [#42846](https://github.com/vercel/next.js/issues/42846) |
| Language | TypeScript |
| Labels | good first issue |
| Reactions | ~10 |
| Assigned | No |
| Competing PRs | 0-1 (stale) |
| Status | Open |

## Problem
The `AppType` type exported from `next/app` does not correctly type its generic parameter, making it difficult to use custom App components with proper type safety. The parameter is either ignored or incorrectly applied, forcing developers to use type assertions or `any` casts when wrapping their App component.

## Impact
Affects TypeScript users of Next.js who use custom `_app.tsx` with the App Router or who need typed page props. Given Next.js has 138K stars and TypeScript is the default for new projects, this is a broadly relevant type fix.

## Repo Health
- Maintainer activity: Extremely active. Vercel team and community contributors merge dozens of PRs weekly.
- PR merge speed: Small type fixes can merge within days. Larger changes may sit longer due to volume.
- Contributor-friendliness: Good. "good first issue" label is actively maintained. Contributing guide is thorough. Test suite is extensive but slow.

## Scoring
- Impact: 6 -- Type-only fix, improves DX but no runtime behavior change
- Feasibility: 9 -- Small, well-scoped type change in a single file
- Visibility: 8 -- 138K stars, "good first issue" label, visible in changelog
- **Total: 23/30**

## Approach
1. Locate the `AppType` definition in `packages/next/shared/lib/utils.ts` or related types file
2. Fix the generic parameter to properly flow through to page props
3. Add or update type tests to verify the fix
4. Run the existing type test suite to ensure no regressions

## Notes
Labeled "good first issue" by the Next.js team, indicating they expect this to be approachable for external contributors. The main risk is that the Next.js PR queue is very busy, so the PR may take time to get reviewed. Keep the change minimal and well-tested.
