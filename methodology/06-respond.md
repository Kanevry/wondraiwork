# Phase 06: Respond

Handle review feedback professionally, iterate efficiently, and close the loop after merge.

## Response Timeline

| Timeframe | Action |
|-----------|--------|
| Within 24 hours | Acknowledge the review. Even a "Thanks for the review, I'll address these points today/tomorrow" is enough. |
| Within 3 days | Push the requested changes. If you need more time, say so. |
| After 1 week of silence from you | Maintainers assume you've abandoned the PR. They may close it. |

Fast responses signal reliability. Maintainers remember contributors who are responsive.

## Types of Feedback

### Nits (Style / Formatting)

Small style preferences, naming suggestions, or formatting tweaks.

**How to handle:** Just fix them. Don't argue about style. The maintainer knows their codebase better than you.

```bash
# Fix the nit
# ... make the change ...
git add -p
git commit -m "style: rename variable per review feedback"
git push
```

Reply: "Fixed in [commit SHA]." or "Done." Keep it brief.

### Design Disagreements

The maintainer wants a different approach than what you implemented.

**How to handle:**

1. **Understand their perspective first.** Ask clarifying questions if the reasoning isn't clear.
2. **Consider that they're probably right.** They have context about the codebase's direction, past decisions, and future plans that you don't.
3. **If you still disagree**, explain your reasoning once, clearly and concisely. Then accept their decision.

```markdown
> I see your point about extracting this into a helper function.
> My concern was that it adds an abstraction layer for a single call site.
> But you know the codebase direction better -- happy to refactor it.
> Want me to put the helper in `utils/` or keep it module-local?
```

Never argue more than once. The maintainer has final say.

### Request for Changes (RFC)

Substantive changes: different algorithm, additional error handling, more tests, refactored structure.

**How to handle:**

1. Acknowledge each point specifically.
2. Implement the changes as separate commits (so the reviewer can see what changed).
3. Reply to each review comment with what you did.

```markdown
> Good catch -- I've added the error handling for the timeout case
> in abc1234. Also added a test for it.
```

### Requests You Don't Understand

Ask for clarification. There's no shame in it -- it shows you care about getting it right.

```markdown
> Could you help me understand what you mean by "this should
> respect the cancellation token"? I see the token is passed into
> `processAsync()` but I'm not sure where the check should go
> in my change. Should it be before the loop or inside each iteration?
```

## Iteration Workflow

### Push Fixup Commits

During review, push individual commits for each piece of feedback. This makes it easy for the reviewer to see what changed.

```bash
# Address review point 1
git add src/parser.ts
git commit -m "fix: add null check per review"

# Address review point 2
git add tests/parser.test.ts
git commit -m "test: add edge case for empty array input"

# Push all at once
git push
```

### Squash Before Merge (If Required)

Some projects want a clean history. If asked to squash:

```bash
# Squash all your fixup commits into logical units
git rebase -i upstream/main

# Force push (only appropriate when asked to squash)
git push --force-with-lease
```

Only force-push when the maintainer explicitly asks you to squash. Otherwise, let them handle it (most repos squash-merge automatically).

### Keep Your Branch Updated

If the base branch has moved ahead, rebase to resolve conflicts:

```bash
git fetch upstream
git rebase upstream/main

# Resolve any conflicts, then:
git push --force-with-lease
```

`--force-with-lease` is safer than `--force` because it won't overwrite changes you haven't seen.

## Professional Communication

### Do

- Be concise. Maintainers review many PRs.
- Say "thank you" when someone takes time to review your code.
- Respond to every comment, even if just "Done." -- it shows you read it.
- Use code suggestions: "What about [approach]?" instead of "You should do [approach]."
- Admit when you don't know something.

### Don't

- Don't take feedback personally. Code review is about the code, not about you.
- Don't write essays in response to nits. Fix and move on.
- Don't ping maintainers repeatedly. One follow-up after a week is fine.
- Don't argue about subjective preferences. Their repo, their rules.
- Don't disappear. If you're busy, say so. "I'll get to this next week" is infinitely better than silence.

## When to Push Back

Pushing back is appropriate when:

1. **The requested change would introduce a bug.** Explain with evidence (a failing test case).
2. **The feedback contradicts the repo's own documentation or conventions.** Point to the specific doc.
3. **The scope has expanded beyond what's reasonable.** "I'm happy to address X in a follow-up PR."

Pushing back is NOT appropriate when:

1. You just prefer your approach. (Their repo.)
2. The change is more work than you expected. (You committed to this.)
3. You disagree with their architecture. (Not your call in a contribution.)

## When the PR Gets Closed

Sometimes PRs get closed without merge. Reasons:

| Reason | Response |
|--------|----------|
| Duplicate (someone merged a different fix) | "No problem, glad it's resolved." Learn from their approach. |
| Direction change (maintainers decided differently) | Accept gracefully. Note the learning. |
| Stale (you didn't respond in time) | Learn from it. Respond faster next time. |
| Quality issues | Ask what you could improve for next time. |

A closed PR is not a failure. You learned the codebase, practiced the workflow, and made a professional impression. Many maintainers remember good contributors even when specific PRs don't land.

## After Merge

### Document the Contribution

Record it in your contribution log:

- Repo name and URL
- Issue number and PR number
- What you learned
- What went well / what you'd do differently
- Time invested vs. outcome

### Follow Up

- Watch the issue for any follow-up bugs your change might have introduced
- If you enjoyed the project, look for more issues to contribute to
- Building a relationship with a project is more valuable than one-off contributions

### Update Your Profile

If you're building a contribution portfolio:
- Note the contribution in your tracking system
- Save the PR URL as a reference
- Consider writing a brief note about the technical approach for your own learning

## Output of This Phase

A merged (or gracefully closed) PR, with:
- All review feedback addressed
- Professional communication throughout
- Documented learnings for your next contribution

Return to [Phase 01: Discover](./01-discover.md) for the next contribution.
