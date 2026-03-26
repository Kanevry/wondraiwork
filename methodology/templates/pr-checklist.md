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

## Final Review

- [ ] I've re-read my own diff in full (`git diff main...HEAD`)
- [ ] I would approve this PR if I were the maintainer
- [ ] PR template (if any) is filled out completely

## Post-Submit

- [ ] CI is green after push
- [ ] Bot requirements handled (CLA, labels, etc.)
- [ ] Watching for reviewer comments
