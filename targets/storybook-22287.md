# [storybook] #22287 -- forwardRef shows wrong display name

| Field | Value |
|-------|-------|
| Repo | storybookjs/storybook (90K stars) |
| Issue | [#22287](https://github.com/storybookjs/storybook/issues/22287) |
| Language | TypeScript |
| Labels | bug |
| Reactions | ~15 |
| Assigned | No |
| Competing PRs | 0 |
| Status | Open |

## Problem
When a component uses `React.forwardRef()`, Storybook displays the wrong component name in the sidebar and docs. Instead of showing the actual component name, it shows "ForwardRef" or a mangled internal name. This makes it hard to navigate stories for component libraries that heavily use forwardRef (which is common for design systems and UI kits).

## Impact
Affects anyone building a component library with Storybook who uses forwardRef -- a very common pattern for design system components that need to expose DOM refs. With 90K stars, Storybook is the dominant component development tool.

## Repo Health
- Maintainer activity: Active. Core team is responsive, regular releases.
- PR merge speed: Moderate. Well-tested PRs can merge in 1-2 weeks. The codebase is large and complex.
- Contributor-friendliness: Good. Has contributing guide, uses changesets, good test infrastructure.

## Scoring
- Impact: 7 -- Affects component library developers, a core Storybook use case
- Feasibility: 6 -- Requires understanding Storybook's component introspection pipeline
- Visibility: 8 -- 90K stars, common pain point, would be a welcome fix
- **Total: 21/30**

## Approach
1. Investigate how Storybook resolves component display names in `@storybook/react`
2. Trace the code path for forwardRef components specifically
3. Ensure the fix extracts `displayName` from the wrapped component or uses the variable name
4. Test with various forwardRef patterns (named, anonymous, with displayName set manually)

## Notes
This is a well-known pain point in the Storybook community. The fix likely involves updating the component name resolution logic in the React renderer or docs addon. Check if there is a `displayName` heuristic that needs to unwrap the forwardRef wrapper.
