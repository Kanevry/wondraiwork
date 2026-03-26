# [prettier] #5287 -- prettier-ignore-start/end

> **Validation Note (2026-03-26):** 2 stale PRs (#8926 since 2020, #9818 WIP). Maintainers seem
> hesitant on this feature.

| Field         | Value                                                     |
| ------------- | --------------------------------------------------------- |
| Repo          | prettier/prettier (52K stars)                             |
| Issue         | [#5287](https://github.com/prettier/prettier/issues/5287) |
| Language      | JavaScript                                                |
| Labels        | type:feature                                              |
| Reactions     | 436                                                       |
| Assigned      | No                                                        |
| Competing PRs | 0 (historical attempts exist, none merged)                |
| Status        | Open                                                      |

## Problem

Prettier only supports `// prettier-ignore` to ignore a single line/node. There is no way to ignore
a range of lines. Developers want `// prettier-ignore-start` and `// prettier-ignore-end` comments
(similar to ESLint's `eslint-disable`/`eslint-enable`) to exclude entire blocks of code from
formatting. Common use cases: complex data structures, ASCII art, matrix definitions, or manually
formatted code that Prettier would destroy.

## Impact

With 436 reactions, this is one of the most requested Prettier features. Affects any developer who
has sections of code that should not be formatted. The workaround (wrapping each line in
prettier-ignore) is impractical for multi-line blocks.

## Repo Health

- Maintainer activity: Moderate. Prettier releases are less frequent than they used to be, but the
  team is still active.
- PR merge speed: Slow for features. The maintainers have expressed mixed feelings about this
  feature in the past.
- Contributor-friendliness: Moderate. The codebase is well-structured but the formatting engine is
  complex.

## Scoring

- Impact: 9 -- 436 reactions, one of the top feature requests
- Feasibility: 5 -- Requires changes to the core formatting engine's comment handling. Prior
  attempts have not been merged.
- Visibility: 8 -- 52K stars, would be a headline feature in a Prettier release
- **Total: 22/30**

## Approach

1. Study how `prettier-ignore` currently works in the formatter core
2. Review prior discussions and PRs for this feature to understand objections
3. Implement range-based ignore using start/end comment markers
4. Handle edge cases: nested ranges, overlapping with prettier-ignore, different comment syntaxes
   per language
5. Add tests for multiple languages (JS, TS, CSS, HTML, Markdown)

## Notes

The Prettier team has been hesitant about this feature because it adds complexity to the comment
handling system and potentially encourages overuse of formatting exceptions. Any PR should address
these concerns directly. The 436 reactions provide strong community backing, but maintainer buy-in
is the real challenge. Consider opening a discussion issue first to confirm the team is now open to
this.
