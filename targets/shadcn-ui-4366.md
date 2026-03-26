# [shadcn/ui] #4366 -- Calendar breakage with react-day-picker v9

> **Validation Note (2026-03-26):** 4+ competing open PRs. Original rdp v9 PR #4371 closed without
> merge. Crowded space.

| Field         | Value                                                |
| ------------- | ---------------------------------------------------- |
| Repo          | shadcn-ui/ui (111K stars)                            |
| Issue         | [#4366](https://github.com/shadcn-ui/ui/issues/4366) |
| Language      | TypeScript                                           |
| Labels        | bug                                                  |
| Reactions     | ~40                                                  |
| Assigned      | No                                                   |
| Competing PRs | 4 (competing, none merged)                           |
| Status        | Open                                                 |

## Problem

The shadcn/ui Calendar component breaks when used with react-day-picker (rdp) v9. The v9 release
introduced breaking API changes (renamed props, changed component structure, different styling
approach) that are incompatible with the current Calendar component implementation, which was built
for rdp v8.

## Impact

Affects shadcn/ui users who upgrade react-day-picker to v9 (or install it fresh, since v9 is now the
latest). The Calendar and DatePicker components are commonly used. With 111K stars, shadcn/ui is the
dominant component library for React/Next.js projects.

## Repo Health

- Maintainer activity: Active. shadcn maintains the project, regular updates.
- PR merge speed: Moderate. 4 competing PRs exist for this issue, indicating the maintainer has not
  found a satisfactory approach yet.
- Contributor-friendliness: Good. Component library with clear patterns, well-documented.

## Scoring

- Impact: 7 -- Breaks a commonly used component in a 111K-star library
- Feasibility: 6 -- The migration from rdp v8 to v9 is well-documented, but 4 competing PRs suggest
  there are design disagreements
- Visibility: 8 -- 111K stars, high-profile component library
- **Total: 21/30**

## Approach

1. Study the 4 existing PRs to understand what approaches were tried and feedback received
2. Review react-day-picker v9 migration guide for the full list of breaking changes
3. Update the Calendar component to use the v9 API while maintaining backward compatibility
4. Ensure DatePicker, DateRangePicker, and any other rdp-dependent components also work
5. Test with both v8 and v9 if possible, or document the minimum version requirement

## Notes

RISKY: 4 competing PRs is a strong signal that the maintainer either wants a specific approach not
yet proposed, or is waiting for rdp v9 to stabilize further before committing to a migration. Before
investing time, check the PR discussions to understand why none were merged. Consider commenting on
the issue to ask the maintainer's preferred direction. The risk of wasted effort is higher than
average here.
