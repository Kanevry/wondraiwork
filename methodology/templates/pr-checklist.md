# PR Pre-Submission Checklist

> Complete every item before creating the PR. If an item doesn't apply, mark it N/A with a reason.

## Issue Reference

- [ ] Issue is linked (`Fixes #___` or `Relates to #___`)
- [ ] I've re-read the issue to confirm my change addresses it

## Code Quality

- [ ] All changes are directly related to the issue (no scope creep)
- [ ] No debug statements (`console.log`, `print`, `dbg!`, etc.) left in
- [ ] No commented-out code left in
- [ ] No TODO/FIXME/HACK markers left in (unless pre-existing)
- [ ] Error handling follows the repo's existing patterns
- [ ] No new warnings introduced

## Style & Conventions

- [ ] Code formatted with the project's formatter
- [ ] Linter passes with zero new warnings/errors
- [ ] Naming conventions match the surrounding code
- [ ] Import/module organization matches the existing style
- [ ] Commit messages follow the repo's format

## Testing

- [ ] All existing tests pass locally
- [ ] New test(s) added covering the change
- [ ] Edge cases covered (null, empty, boundary values)
- [ ] No flaky test behavior observed

## Build & CI

- [ ] Project builds successfully from clean state
- [ ] All CI checks pass locally (build, lint, test, format)
- [ ] No new dependencies added (or justified if so)

## Branch Hygiene

- [ ] Branch is based on the current default branch
- [ ] No merge conflicts
- [ ] Commits are logically structured (fixup commits squashed)
- [ ] No unrelated files included in the diff

## PR Description

- [ ] Title is concise and descriptive (under 70 chars)
- [ ] Body explains WHAT changed
- [ ] Body explains WHY (root cause / motivation)
- [ ] Body explains HOW (approach, if non-obvious)
- [ ] Test plan included
- [ ] Screenshots/recordings included (if visual change)

## Issue Alignment

- [ ] I have re-read the original issue description (not just my target file notes)
- [ ] Every expected behavior described in the issue is addressed by my change
- [ ] If the issue contains screenshots, my implementation matches the expected outcome
- [ ] If my implementation scope differs from the issue, the difference is explained in the PR body
- [ ] I am not submitting a partial fix disguised as a complete fix

## Visual Evidence (if UI change)

- [ ] Before screenshot captured (showing the broken state)
- [ ] After screenshot captured (showing the working state)
- [ ] Screenshots PROVE the feature works (not just that the code compiles)
- [ ] No visual artifacts, wrong styles, or mismatched spacing visible in screenshots
- [ ] Tested in all required contexts (different pages, states, data conditions)
- [ ] Native look and feel verified: fonts, colors, spacing, hover states match the project

## Decision Trail

- [ ] Target file Decision Log is complete and current
- [ ] All approach changes during implementation are documented with reasons
- [ ] Feasibility score in target file reflects current reality
- [ ] No hard kill criteria are active (see Phase 04b)

## Final Review

- [ ] I've re-read my own diff in full (`git diff main...HEAD`)
- [ ] I would approve this PR if I were the maintainer
- [ ] If the maintainer has rejected similar PRs, mine avoids those specific mistakes
- [ ] My screenshots (if any) survive hostile scrutiny -- they prove the feature works
- [ ] PR template (if any) is filled out completely
- [ ] I am submitting because this is READY, not because I have sunk time into it

## Post-Submit

- [ ] CI is green after push
- [ ] Bot requirements handled (CLA, labels, etc.)
- [ ] Watching for reviewer comments
