# Phase 05: Submit

Create a PR that respects the maintainer's time and makes the review process as smooth as possible.

## PR Title

The title is the first (and sometimes only) thing a maintainer reads in their notification feed.

**Rules:**

- Under 70 characters
- Imperative mood ("Fix X" not "Fixed X" or "Fixing X")
- Reference the issue number if the repo convention includes it
- Describe the change, not the problem

**Good:**

- `Fix null pointer in parser when input is empty (#1234)`
- `Add timeout option to HTTP client`
- `Handle edge case in date formatting for leap years`

**Bad:**

- `Update parser.ts` (what did you change?)
- `Fixes #1234` (what does the fix do?)
- `Resolve the issue where the parser throws a null pointer exception when the input string is empty which causes a crash`
  (too long)
- `WIP: maybe fix parser` (not ready, don't submit)

## PR Body

A well-structured body answers three questions: What changed? Why? How should I test it?

### Structure

```markdown
## What

Brief description of the change. 1-3 sentences.

Fixes #1234

## Why

Context on why this change is needed. Link to the issue, explain the root cause if it's a bug fix.
For features, explain the use case.

## How

Technical summary of the approach. What files were changed and why. If there were alternative
approaches, briefly mention why you chose this one.

## Test Plan

- [ ] Added unit test for null input case
- [ ] Verified existing tests pass
- [ ] Manually tested with reproduction case from issue

## Screenshots / Recordings

(Include if the change has visual impact. Delete this section otherwise.)
```

### Tips for the Body

- **Link the issue.** Use `Fixes #1234` (auto-closes on merge) or `Relates to #1234` (doesn't
  auto-close).
- **Keep it scannable.** Maintainers review dozens of PRs. Bullet points and headers help.
- **Show your work.** If you investigated multiple approaches, mention why you picked this one.
- **Be honest about trade-offs.** If your fix has limitations, say so upfront. Maintainers respect
  transparency.

If the repo has a PR template, use it instead. Fill out every section.

## Commit Messages

### Check the Repo's Convention First

```bash
# See what format they use
git log --oneline -20
```

### When in Doubt

Use conventional format with the issue reference:

```
fix(module): description of the fix

Detailed explanation if needed. Wrap at 72 characters.

Fixes #1234
```

### Commit Hygiene

- Separate the fix commit from the test commit (if reviewers prefer it)
- No "fix typo" or "oops" commits in the final PR (squash them)
- Each commit should compile and pass tests independently

```bash
# Squash fixup commits before submitting
git rebase -i HEAD~3  # Interactive rebase to clean up
```

If the project squash-merges (check their merge settings), individual commit cleanliness matters
less -- but it still shows professionalism.

## Screenshots and Recordings

Include visual evidence when:

- The change affects UI
- The bug had visible symptoms
- A terminal output demonstrates the fix

Tools:

- Screenshots: OS built-in, or `gh` can attach images
- Terminal recordings: [asciinema](https://asciinema.org/) or screen recordings
- Before/after comparisons are highly effective

## Pre-Submit Checklist

Use the full [PR Checklist Template](./templates/pr-checklist.md). Quick version:

- [ ] All local tests pass
- [ ] All local linters pass
- [ ] Code follows the repo's style conventions
- [ ] No unrelated changes included
- [ ] No debug statements, commented-out code, or TODOs left in
- [ ] PR title is concise and descriptive
- [ ] PR body explains what, why, and how
- [ ] Issue is linked
- [ ] Branch is up to date with the default branch
- [ ] Self-reviewed the diff one final time

## Submitting

```bash
# Push your branch
git push origin fix/issue-1234-description

# Create the PR via CLI
gh pr create \
  --title "Fix null pointer in parser when input is empty" \
  --body "$(cat <<'EOF'
## What

Add null check in `Parser.tokenize()` to handle empty string input
gracefully instead of throwing a NullPointerException.

Fixes #1234

## Why

When users pass an empty string to `parse()`, the tokenizer attempts
to access index 0 of a null character array, causing a crash. This
affects any caller that doesn't pre-validate input.

## How

- Added null/empty check at the start of `tokenize()`
- Returns empty token array for empty input (consistent with whitespace-only input behavior)
- Added unit test covering empty and null inputs

## Test Plan

- [x] Added `test_tokenize_empty_input` and `test_tokenize_null_input`
- [x] All 847 existing tests pass
- [x] Manually verified with reproduction case from #1234
EOF
)"
```

## Common Mistakes

### Force-Pushing After Review

Never force-push after a reviewer has commented. It destroys their review context. Push new commits
instead.

```bash
# After addressing review feedback, push additional commits
git add .
git commit -m "fix: address review feedback -- extract helper function"
git push origin fix/issue-1234-description
```

### Incomplete Description

"Fixes the bug" tells the reviewer nothing. Always explain the root cause and your approach.

### No Issue Reference

Orphan PRs with no linked issue make maintainers suspicious. If there's no existing issue, create
one first and reference it.

### Requesting Review Too Aggressively

Don't @-mention maintainers in the PR body unless the repo's contributing guide says to. The PR
itself is the request for review. If there's no response after 1-2 weeks, a polite comment is fine.

### Submitting During Weekends or Holidays

Not a hard rule, but PRs submitted during business hours (for the maintainers' timezone) tend to get
faster initial responses.

## After Submitting

1. **Watch CI.** If it fails, fix it immediately. A PR with failing CI signals carelessness.
2. **Respond to the bot.** Some repos have automated checks (CLA signing, label requirements).
   Handle these promptly.
3. **Be patient.** Maintainers are often volunteers. Give them at least a week before following up.

## Output of This Phase

A submitted PR with:

- Clean, descriptive title
- Structured body with what/why/how/test plan
- All CI checks passing
- Issue linked

Proceed to [Phase 06: Respond](./06-respond.md).
