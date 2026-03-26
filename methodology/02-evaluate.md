# Phase 02: Evaluate

Before investing hours in a contribution, verify that the repo is healthy, the issue is real, and the path to merge is clear. This phase prevents wasted effort.

## Repo Health Signals

### Maintainer Activity

```bash
REPO="owner/repo"

# Last 10 merged PRs -- check frequency and who merges
gh pr list --repo "$REPO" --state merged --limit 10 \
  --json number,title,mergedAt,mergedBy

# Recent issue responses -- are maintainers engaging?
gh issue list --repo "$REPO" --state closed --limit 10 \
  --json number,title,closedAt,comments

# Contributor diversity -- external contributions being merged?
gh api "repos/$REPO/stats/contributors" --jq '.[].author.login' | head -20
```

| Signal | Healthy | Warning |
|--------|---------|---------|
| Last merged PR | < 2 weeks ago | > 2 months ago |
| Median PR merge time | < 2 weeks | > 2 months |
| Open PRs | < 50 or proportional to activity | 200+ with many stale |
| Maintainer issue replies | Within 1 week | No response for months |
| External contributor PRs merged | Multiple in last 3 months | None in 6+ months |

### CI Status

```bash
# Check if CI exists and is passing on default branch
gh run list --repo "$REPO" --branch main --limit 5

# Look at CI config
gh api "repos/$REPO/contents/.github/workflows" --jq '.[].name' 2>/dev/null
```

A repo with broken CI on the default branch is a red flag. You'll be fighting infrastructure instead of shipping code.

### Contributor Guidelines

```bash
# Check for contribution docs
for f in CONTRIBUTING.md .github/CONTRIBUTING.md docs/CONTRIBUTING.md; do
  gh api "repos/$REPO/contents/$f" --jq '.name' 2>/dev/null && echo "Found: $f"
done

# Check for PR template
gh api "repos/$REPO/contents/.github/PULL_REQUEST_TEMPLATE.md" \
  --jq '.name' 2>/dev/null
```

Projects with clear contribution guidelines signal that they expect and welcome external PRs. No guidelines means higher risk of arbitrary review standards.

## Issue Quality Signals

### Specification Clarity

| Quality | Indicator |
|---------|-----------|
| High | Reproduction steps, expected vs actual behavior, environment details |
| Medium | Problem described but missing steps or context |
| Low | One-liner with no context, "this doesn't work" |

### Acceptance Criteria

Look for explicit or implicit criteria:
- Maintainer comments defining scope ("the fix should only affect X")
- Linked tests that should pass
- References to specific code locations
- Labels like `accepted`, `confirmed`, `triaged`

Issues that have been triaged and labeled by a maintainer are significantly safer targets than untriaged community reports.

### Reproducibility

```bash
# Clone and try to reproduce locally
gh repo clone "$REPO" /tmp/eval-repo
cd /tmp/eval-repo

# Check if you can build it
cat README.md | head -50  # Build instructions
# Follow their setup steps

# Try to reproduce the bug
# Run the failing test case if mentioned in the issue
```

If you can't reproduce the issue, comment on the issue asking for clarification before investing more time.

## Competition Check

### Existing PRs

```bash
# Search for PRs referencing this issue number
ISSUE=1234
gh pr list --repo "$REPO" --state all --search "$ISSUE" --limit 10

# Check for draft PRs or WIP
gh pr list --repo "$REPO" --state open --search "is:draft $ISSUE"
```

### Assignees and Claims

```bash
# Check if issue is assigned
gh issue view "$ISSUE" --repo "$REPO" --json assignees

# Read comments for "I'll work on this" claims
gh issue view "$ISSUE" --repo "$REPO" --json comments \
  --jq '.comments[].body' | grep -i "work on\|working on\|take this\|claim"
```

| Situation | Action |
|-----------|--------|
| No PRs, no assignee, no claims | Proceed |
| Assigned but no activity for 30+ days | Comment asking if it's still being worked on |
| Open PR exists but stale (60+ days, no response) | Check if maintainer requested changes that were never addressed. You may offer to take over. |
| Active PR in progress | Move to another issue |
| Closed PR that was rejected | Read why it was rejected. If the approach was wrong but the issue is valid, you can try a different approach. |

## Go/No-Go Decision Framework

Score each criterion as Pass/Fail:

| # | Criterion | Check |
|---|-----------|-------|
| 1 | Repo merged external PRs in last 3 months | `gh pr list --state merged` |
| 2 | Issue acknowledged by maintainer | Comments from members/owners |
| 3 | No competing active PR | PR search |
| 4 | CI is green on default branch | `gh run list` |
| 5 | You can build the project locally | Clone and build |
| 6 | Scope is estimable (hours, not weeks) | Your judgment |
| 7 | You have the required domain knowledge (or can learn it) | Honest self-assessment |

**Decision rules:**
- All 7 pass: Strong go. Proceed to Phase 03.
- 1-2 fail: Conditional go. Note the risks, decide if they're acceptable.
- 3+ fail: No-go. Return to Phase 01 and pick the next candidate.

## Quick Evaluation Commands

```bash
# One-shot repo health summary
REPO="owner/repo"
echo "=== Repo Stats ==="
gh repo view "$REPO" --json stargazersCount,forkCount,openIssues,hasWikiEnabled,licenseInfo

echo "=== Recent Merged PRs ==="
gh pr list --repo "$REPO" --state merged --limit 5 --json mergedAt,title

echo "=== Open PRs ==="
gh pr list --repo "$REPO" --state open --limit 5 --json createdAt,title,isDraft

echo "=== CI Status ==="
gh run list --repo "$REPO" --branch main --limit 3

echo "=== Labels ==="
gh label list --repo "$REPO" --limit 30
```

## Output of This Phase

A clear go/no-go decision for your top candidate, documented using the [Issue Evaluation Template](./templates/issue-evaluation.md). If no-go, cycle back to Phase 01.

If go, proceed to [Phase 03: Understand](./03-understand.md).
