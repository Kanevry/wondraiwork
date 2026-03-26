# Phase 04b Verification Checklist

> Complete every item before proceeding to Phase 05 (Submit). If any Hard Kill criterion is
> triggered, STOP.

## 1. Issue Alignment

- [ ] Re-read the original issue (upstream URL, not target file notes)
- [ ] Every behavior described in the issue is addressed
- [ ] If issue has screenshots: my implementation matches expected outcome
- [ ] Scope matches issue description (or deviation is documented and justified)
- [ ] Not submitting a partial fix disguised as a complete fix

## 2. Visual Validation (skip if no UI changes)

### Feature works correctly

- [ ] Before screenshot captured (broken state)
- [ ] After screenshot captured (working state)
- [ ] Screenshots PROVE the feature works
- [ ] Tested in all required contexts (different pages, data, states)
- [ ] No visual artifacts or mismatched styles

### Native look and feel

- [ ] Font family matches surrounding elements
- [ ] Font size and weight match the design system
- [ ] Colors use project's design tokens (not hardcoded)
- [ ] Spacing consistent with adjacent elements
- [ ] Hover/focus/active states follow project patterns
- [ ] Dark/light mode both work (if project supports themes)

## 3. Decision Log Review

- [ ] Every non-trivial decision is logged in target file with rationale
- [ ] Approach changes are documented with reasons
- [ ] Rejected approaches are logged (what, why not)
- [ ] Feasibility score reflects current reality
- [ ] Risk assessment is up to date

## 4. Regression Check

- [ ] Full test suite passes
- [ ] Adjacent features tested and working
- [ ] Edge cases tested (empty, max, concurrent)
- [ ] No new console errors or warnings (UI)
- [ ] No performance degradation

## 5. Honest Assessment

- [ ] "Would the maintainer merge this?" -- YES, with evidence
- [ ] Screenshots (if any) survive hostile scrutiny
- [ ] Not submitting due to sunk cost
- [ ] If maintainer rejected similar PRs before, mine avoids those mistakes
- [ ] Can explain every line of my diff

## Kill Criteria Check

### Hard Kill (any one = DO NOT SUBMIT)

- [ ] K1: Screenshots show feature not working -- NOT TRIGGERED
- [ ] K2: Feasibility below 4/10 -- NOT TRIGGERED
- [ ] K3: Working around project architecture -- NOT TRIGGERED
- [ ] K4: Better approach found but not implemented -- NOT TRIGGERED
- [ ] K5: Unexplained test failures -- NOT TRIGGERED
- [ ] K6: Cannot explain every line of diff -- NOT TRIGGERED

### Soft Kill (any one = pause and reassess)

- [ ] S1: Feasibility dropped 3+ points -- NOT TRIGGERED
- [ ] S2: Scope expanded beyond original issue -- NOT TRIGGERED
- [ ] S3: Implementation took more than 2x estimated time -- NOT TRIGGERED
- [ ] S4: Adjacent features broke non-trivially -- NOT TRIGGERED
- [ ] S5: Issue partially addressed by someone else -- NOT TRIGGERED

## Decision

- [ ] **GO** -- All checks pass, no kill criteria triggered. Proceed to Phase 05.
- [ ] **STOP** -- Kill criterion triggered: \_\_\_. See target file for documentation.
