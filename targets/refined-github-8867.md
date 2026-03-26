# [refined-github] #8867 -- Broken tabs (DOM selectors)

| Field         | Value                                                                 |
| ------------- | --------------------------------------------------------------------- |
| Repo          | refined-github/refined-github (31K stars)                             |
| Issue         | [#8867](https://github.com/refined-github/refined-github/issues/8867) |
| Language      | TypeScript                                                            |
| Labels        | bug                                                                   |
| Reactions     | ~5                                                                    |
| Assigned      | No                                                                    |
| Competing PRs | 0                                                                     |
| Status        | Open                                                                  |

## Problem

GitHub changed their DOM structure, breaking several refined-github features that rely on CSS
selectors to find and modify tab elements. The extension's tab-related features (like hiding certain
tabs or adding counters) stopped working because the selectors no longer match the updated GitHub
markup.

## Impact

Affects all refined-github users who rely on tab-related features. With 31K stars and high daily
active usage as a browser extension, this is a visible regression for a large user base.

## Repo Health

- Maintainer activity: Very active. fregante (sole maintainer) responds within hours and merges
  quickly.
- PR merge speed: Same-day to next-day for clean PRs. Often merged within hours.
- Contributor-friendliness: Excellent. Clear contributing guide, well-structured codebase,
  TypeScript throughout.

## Scoring

- Impact: 6 -- Affects a popular extension but is limited to specific tab features
- Feasibility: 9 -- Straightforward selector updates, small scope
- Visibility: 7 -- Active repo with fast merge cycle, contribution shows up quickly
- **Total: 22/30**

## Approach

1. Inspect current GitHub DOM to identify the new selector paths for tab elements
2. Update the CSS selectors in the affected feature files
3. Test against live GitHub pages to verify tabs work correctly
4. Submit PR with before/after screenshots

## Notes

This is a classic quick-win: the fix is mechanical (update selectors to match new DOM), the
maintainer merges fast, and the repo is well-known. Good first contribution to build rapport with
the project.
