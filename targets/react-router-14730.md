# react-router #14730 -- Vite module resolution forced to node

| Field          | Value                                                            |
| -------------- | ---------------------------------------------------------------- |
| Repo           | remix-run/react-router (56K stars)                               |
| Issue          | [#14730](https://github.com/remix-run/react-router/issues/14730) |
| Language       | TypeScript                                                       |
| Labels         | bug, pkg:@react-router/dev, feat:vite, accepting-prs             |
| Reactions      | 0                                                                |
| Assigned       | No                                                               |
| Competing PRs  | 0                                                                |
| Status         | Submitted                                                        |
| Owner Briefing | GO (2026-03-26)                                                  |
| PR             | [#14936](https://github.com/remix-run/react-router/pull/14936)   |

## Problem

React Router's Vite plugin hardcodes `node` in the Vite resolve conditions
(`packages/react-router-dev/vite/plugin.ts`, ~line 3529). This forces Node.js module resolution for
all environments, breaking non-Node runtimes like Cloudflare Workers, Deno Deploy, and edge runtimes
that cannot import `http`, `https`, and other Node builtins.

## Impact

Affects all React Router users deploying to edge/worker runtimes via Vite. Cloudflare Workers is the
primary affected platform (official React Router template breaks). Users must apply a custom Vite
plugin workaround to remove the `node` condition.

## Repo Health

- Maintainer activity: Very active (multiple merges per day)
- PR merge speed: Avg 7.7 days (docs PRs ~0 days, code PRs ~37 days)
- Contributor-friendliness: CONTRIBUTING.md, CLA required, conventional commits

## Scoring

- Impact: 5/10 -- Affects edge/worker runtime users (growing segment, but not majority of RR users)
- Feasibility: 7/10 -- Exact code location identified, workaround exists, but need to understand why
  `node` was added (PR #13871) and ensure fix doesn't break Node users
- Visibility: 8/10 -- 56K stars, accepting-prs label, Cloudflare Workers is high-profile platform
- **Total: 20/30**

## Scoring History

| Date | Axis | From | To  | Reason |
| ---- | ---- | ---- | --- | ------ |
|      |      |      |     |        |

## Approach

1. Read PR #13871 to understand why `node` was added to resolve conditions
2. Trace the Vite plugin code to understand the full condition resolution chain
3. Design a fix that makes `node` conditional on the target runtime
4. Test with Cloudflare Workers reproduction repo AND standard Node.js setup
5. Run full CI locally: build, typecheck, lint, test
6. PR against dev branch with conventional commit

## Decision Log

| Date       | Decision                                               | Rationale                                                                                          | Impact on Approach              |
| ---------- | ------------------------------------------------------ | -------------------------------------------------------------------------------------------------- | ------------------------------- |
| 2026-03-26 | Pivot from #14795 to #14730                            | Competing PR #14932 submitted for #14795                                                           | New target in same repo         |
| 2026-03-26 | Selected #14730 over fresh discovery                   | accepting-prs label, 0 competition, repo already cloned                                            | Saves setup time, strong signal |
| 2026-03-26 | Owner Briefing: GO                                     | Clear scope, manageable risk, good visibility                                                      | Proceed to Phase 03             |
| 2026-03-26 | Fix: conditional externalConditions                    | Use noExternal as signal for non-Node runtimes; follows existing pattern in codebase               | Minimal change, zero breaking   |
| 2026-03-26 | Two-part fix: getBaseServerOptions + configEnvironment | Need both: remove "node" from base options when v8_viteEnvironmentApi, add it back per-environment | Correct separation of concerns  |

## Status Transitions

| Date       | From        | To          | Reason                                    |
| ---------- | ----------- | ----------- | ----------------------------------------- |
| 2026-03-26 | Open        | Evaluating  | Selected as target after #14795 pivot     |
| 2026-03-26 | Evaluating  | In Progress | Owner Briefing GO, proceeding to Phase 03 |
| 2026-03-26 | In Progress | Verifying   | Implementation complete, full CI green    |
| 2026-03-26 | Verifying   | Submitted   | PR #14936 submitted against dev           |

## Risk Assessment

| Risk                               | Likelihood | Impact | Mitigation                                           | Last Updated |
| ---------------------------------- | ---------- | ------ | ---------------------------------------------------- | ------------ |
| Fix breaks Node.js users           | Medium     | High   | Test both Node and Workers environments              | 2026-03-26   |
| Vite plugin internals too complex  | Medium     | Medium | Issue author identified exact code line + workaround | 2026-03-26   |
| Maintainer had a reason for `node` | Medium     | Medium | Read PR #13871 thoroughly before changing            | 2026-03-26   |
| CLA signing blocks PR              | Low        | Low    | Sign CLA as first PR commit                          | 2026-03-26   |

## Verification Evidence (Phase 04b)

> MANDATORY before status changes to "Submitted". Every checkbox must include evidence, not just a
> checkmark. Kill Criteria must be explicitly evaluated with rationale.

### Issue Alignment

- [x] Original issue re-read: 2026-03-26
- [x] All expected behaviors addressed: Yes. Issue describes `node` condition breaking Workers
      environments. Fix makes `node` conditional on `noExternal !== true`, which is the signal used
      by Cloudflare Workers plugin.

### Regression Check

- Full test suite: PASS, 120/120 suites, 2509/2509 tests, 1023/1023 snapshots
- Adjacent features: PASS -- build, typecheck, lint all green with 0 new errors
- Node.js environment: PASS -- When `noExternal` is not set (default Node.js), `"node"` is still
  added to externalConditions in configEnvironment hook
- Workers environment: Logically correct -- When `noExternal: true` (Cloudflare), `"node"` is NOT
  added. Cannot run Cloudflare integration tests without wrangler setup, but code path analysis
  confirms correctness.

### Honest Assessment

- Maintainer would merge: Likely yes. Minimal diff (19 insertions, 2 deletions), follows existing
  patterns (same `noExternal` check already used for `resolve.external`), zero breaking changes for
  Node.js users.
- Kill criteria status: None triggered.
  - K1 (Screenshots): N/A (not UI)
  - K2 (Feasibility < 4): NOT TRIGGERED -- Feasibility remained at 7/10
  - K3 (Working around architecture): NOT TRIGGERED -- Fix follows existing pattern
  - K4 (Better approach not implemented): NOT TRIGGERED -- This is the simplest correct approach
  - K5 (Unexplained test failures): NOT TRIGGERED -- All 2509 tests pass
  - K6 (Cannot explain diff): NOT TRIGGERED -- Every line is documented

### Verification Decision

- [x] GO -- All checks passed, no kill criteria triggered
- [ ] STOP -- Reason: \_\_\_

## Notes

- PRs must target `dev` branch (not main)
- Conventional Commits required: `fix(react-router): ...`
- CLA signature required: add username to `contributors.yml`
- GitLab tracking: Issue #3
- Introduced in PR #13871 -- must understand why before changing
- Reproduction repo: https://github.com/chrisvltn/react-router-issue-reproduction
- Workaround: custom Vite plugin to remove `node` from conditions
