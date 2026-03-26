# react-router #14795 -- Replace deprecated FormEvent type with SubmitEvent for React 19

| Field          | Value                                                            |
| -------------- | ---------------------------------------------------------------- |
| Repo           | remix-run/react-router (56K stars)                               |
| Issue          | [#14795](https://github.com/remix-run/react-router/issues/14795) |
| Language       | TypeScript                                                       |
| Labels         | bug, pkg:react-router, feat:typescript                           |
| Reactions      | 2 (thumbs up)                                                    |
| Assigned       | No                                                               |
| Competing PRs  | 1 (PR #14932 submitted 2026-03-26)                               |
| Status         | Blocked                                                          |
| Owner Briefing | Not started                                                      |
| PR             |                                                                  |

## Problem

React Router's Form component uses the deprecated `FormEvent<HTMLFormElement>` type from
`@types/react` v19.2.13. In React 19, `FormEvent` was deprecated in favor of native `SubmitEvent`
(DefinitelyTyped#74383). Users see TypeScript deprecation warnings when using Form's onSubmit
handler.

## Impact

Every React Router user on React 19 + TypeScript sees deprecation warnings when typing form event
handlers. Affects a core API (`<Form>`, `<fetcher.Form>`) in a 56K-star project.

## Repo Health

- Maintainer activity: Very active (multiple merges per day, 2026-03-26)
- PR merge speed: Community PRs merged within days (check evaluate.sh output)
- Contributor-friendliness: CONTRIBUTING.md exists, CLA required, conventional commits

## Scoring

- Impact: 6/10 -- Deprecation warning (not runtime bug), but affects core Form API used by most RR
  users
- Feasibility: 8/10 -- Well-scoped type change, TypeScript is our strength, clear migration path
- Visibility: 8/10 -- 56K stars, official React ecosystem, TypeScript fix noticed by framework
  engineers
- **Total: 22/30**

## Scoring History

> Track score changes during the contribution lifecycle. Log when any axis changes by 2+ points.

| Date | Axis | From | To  | Reason |
| ---- | ---- | ---- | --- | ------ |

## Approach

1. Clone repo, checkout dev branch
2. Trace all `FormEvent` and `FormEventHandler` usage
3. Determine correct replacement type (SubmitEvent or conditional)
4. Update type signatures maintaining React 18.3+ compat
5. Run full CI locally: build, typecheck, lint, test
6. PR against dev branch with conventional commit

## Decision Log

> Timestamped entries for every non-trivial technical decision, scope change, approach pivot, and
> risk update. Newest entries at the top. Mirror key decisions as comments on the GitLab tracking
> issue.

| Date       | Decision                                      | Rationale                                                                   | Impact on Approach            |
| ---------- | --------------------------------------------- | --------------------------------------------------------------------------- | ----------------------------- |
| 2026-03-26 | Target branch: dev (not main)                 | CONTRIBUTING.md specifies dev for code changes, main for docs only          | Must configure PR against dev |
| 2026-03-26 | Selected react-router #14795 as second target | Best risk/reward: no competition, TypeScript expertise match, bounded scope | Proceed to evaluation         |

## Status Transitions

| Date       | From | To         | Reason                                                  |
| ---------- | ---- | ---------- | ------------------------------------------------------- |
| 2026-03-26 | Open | Evaluating | Selected as contribution target after discovery scoring |

Valid statuses: Open, Evaluating, In Progress, Verifying, Submitted, Merged, Abandoned, Blocked,
Reassessing.

## Risk Assessment

| Risk                                          | Likelihood | Impact | Mitigation                                            | Last Updated |
| --------------------------------------------- | ---------- | ------ | ----------------------------------------------------- | ------------ |
| React 18/19 compat more complex than expected | Medium     | Medium | Phase 03 traces actual usage, approach decided after  | 2026-03-26   |
| CLA signing blocks PR                         | Low        | Low    | Check CLA early in Wave 2                             | 2026-03-26   |
| Maintainer prefers different approach         | Medium     | Low    | Submit as Draft, seek early feedback                  | 2026-03-26   |
| Low reaction count = lower priority           | Low        | Medium | Well-crafted PR for real bug gets reviewed regardless | 2026-03-26   |

## Verification Evidence (Phase 04b)

> MANDATORY before status changes to "Submitted". Every checkbox must include evidence, not just a
> checkmark. Kill Criteria must be explicitly evaluated with rationale.

### Issue Alignment

- [ ] Original issue re-read: [date]
- [ ] All expected behaviors addressed: [yes/no, details]

### Visual Validation (if UI)

- Before screenshot: [reference/path]
- After screenshot: [reference/path]
- Native look and feel: [pass/fail, notes]

### Regression Check

- Full test suite: [pass/fail, N tests]
- Adjacent features: [pass/fail, what was tested]

### Honest Assessment

- Maintainer would merge: [yes/no, reasoning]
- Kill criteria status: [none triggered / soft kill SN / hard kill KN]

### Verification Decision

- [ ] GO -- All checks passed, no kill criteria triggered
- [ ] STOP -- Reason: \_\_\_

## Notes

- PRs must target `dev` branch (not main)
- Conventional Commits required: `fix(react-router): ...`
- `import type` enforced by ESLint
- CLA signature required before merge
- GitLab tracking: Issue #3
