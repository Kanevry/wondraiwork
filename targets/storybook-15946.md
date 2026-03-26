# [storybook] #15946 -- build-storybook watch mode

| Field | Value |
|-------|-------|
| Repo | storybookjs/storybook (90K stars) |
| Issue | [#15946](https://github.com/storybookjs/storybook/issues/15946) |
| Language | TypeScript |
| Labels | feature request |
| Reactions | 57 |
| Assigned | No |
| Competing PRs | 0 |
| Status | Open |

## Problem
`build-storybook` does not support a `--watch` mode. When building Storybook for static hosting or integration testing, developers must manually re-run the full build after every change. This is slow and disruptive. A watch mode would rebuild only changed stories, similar to how `storybook dev` watches for changes.

## Impact
Affects teams using static Storybook builds for CI, deployment previews, or visual regression testing. With 57 reactions, this is a highly requested feature. Particularly painful for large component libraries where a full build takes minutes.

## Repo Health
- Maintainer activity: Active. Regular releases, responsive core team.
- PR merge speed: Moderate for features. New features need RFC or design discussion.
- Contributor-friendliness: Good. Monorepo with clear package boundaries, contributing guide available.

## Scoring
- Impact: 7 -- Addresses a common workflow pain point for Storybook users
- Feasibility: 5 -- Requires integrating file watching into the build pipeline, potentially complex with the builder abstraction layer
- Visibility: 8 -- 90K stars, 57 reactions, frequently requested
- **Total: 20/30**

## Approach
1. Study the `build-storybook` command implementation in `code/lib/cli/src/`
2. Investigate how `storybook dev` implements watching (likely via the builder's watch API)
3. Add a `--watch` flag to the build command that reuses the builder's incremental compilation
4. Handle static file re-generation (manager, preview iframe) on rebuild
5. Test with webpack and vite builders (both need to work)

## Notes
The main challenge is that `build-storybook` is designed as a one-shot process. Adding watch mode means refactoring it to keep the process alive and incrementally rebuild. The builder abstraction (webpack/vite) adds complexity since both need to support watch. Consider reaching out on Discord or the issue thread to gauge maintainer interest before investing significant effort.
