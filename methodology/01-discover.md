# Phase 01: Discover

Find high-impact issues that are worth solving, likely to get merged, and aligned with your skills.

## Searching for Issues

### GitHub CLI Commands

Search for issues labeled "good first issue" or "help wanted" in active repos:

```bash
# Good first issues in repos with 500+ stars, sorted by reactions
gh search issues --label="good first issue" --state=open --sort=reactions \
  --limit=30 -- "language:typescript"

# Help wanted across a specific org
gh search issues --label="help wanted" --state=open --sort=reactions \
  --limit=30 --repo="vercel/next.js"

# Bug reports with many reactions (high community impact)
gh search issues --label="bug" --state=open --sort=reactions \
  --limit=20 -- "repo:facebook/react"

# Recently created issues (less competition)
gh search issues --label="help wanted" --state=open --sort=created \
  --limit=20 -- "language:rust created:>2026-01-01"

# Issues with no assignee (open for contribution)
gh search issues --label="good first issue" --state=open --sort=reactions \
  --no-assignee --limit=30 -- "language:go"

# Search by keyword in specific repos
gh search issues "memory leak" --state=open --sort=reactions \
  --limit=20 --repo="denoland/deno"
```

### Search Strategies

**Strategy 1: Follow the stars.** Pick 5-10 repos you use daily. Watch their issue trackers. You already understand the domain.

**Strategy 2: Keyword hunting.** Search for specific problem types you're good at solving: "race condition", "memory leak", "accessibility", "type error", "performance regression".

**Strategy 3: New releases.** After a major release, repos get flooded with bug reports. Many are legitimate, well-scoped, and the maintainers want help triaging.

**Strategy 4: Ecosystem gaps.** Libraries that just got popular but lack polish (docs, error messages, edge cases). High impact, lower competition.

## Scoring Matrix

Score each candidate on three axes (1-5 scale):

### Impact (weight: 40%)

| Score | Criteria |
|-------|----------|
| 5 | 50+ reactions, affects core functionality, many users reporting |
| 4 | 20-50 reactions, affects common workflow |
| 3 | 10-20 reactions, quality-of-life improvement |
| 2 | 5-10 reactions, edge case fix |
| 1 | <5 reactions, cosmetic or niche |

### Feasibility (weight: 35%)

| Score | Criteria |
|-------|----------|
| 5 | Clear fix, small scope, you've done similar work before |
| 4 | Straightforward approach, moderate scope, familiar tech |
| 3 | Requires investigation, medium scope, some new territory |
| 2 | Unclear approach, large scope, unfamiliar codebase patterns |
| 1 | Massive scope, requires deep domain knowledge, architectural change |

### Visibility (weight: 25%)

| Score | Criteria |
|-------|----------|
| 5 | 50K+ stars, top-tier org (Meta, Google, Vercel, etc.) |
| 4 | 10K-50K stars, well-known project |
| 3 | 1K-10K stars, respected in its niche |
| 2 | 100-1K stars, growing project |
| 1 | <100 stars, unknown project |

### Calculating the Score

```
Total = (Impact x 0.40) + (Feasibility x 0.35) + (Visibility x 0.25)
```

| Total | Verdict |
|-------|---------|
| 4.0+ | Strong target. Proceed to Evaluate. |
| 3.0-3.9 | Worth investigating. Evaluate carefully. |
| 2.0-2.9 | Marginal. Only if nothing better is available. |
| <2.0 | Skip. |

### Example Scoring

**Issue:** "TypeError when using dynamic imports with custom loader" in `nodejs/node` (45 reactions, 12 comments, labeled `help wanted`)

| Axis | Score | Reasoning |
|------|-------|-----------|
| Impact | 4 | 45 reactions, affects Node.js module loading |
| Feasibility | 3 | Requires understanding loader pipeline, medium scope |
| Visibility | 5 | nodejs/node is a top-tier repo |
| **Total** | **3.85** | **(4x0.40 + 3x0.35 + 5x0.25) = Proceed to Evaluate** |

## What Makes a Good Target

- [ ] Issue has been acknowledged by a maintainer (not just community)
- [ ] Clear reproduction steps or well-defined feature request
- [ ] No existing PR addressing it (check linked PRs)
- [ ] Issue is less than 6 months old (or recently re-confirmed)
- [ ] Repo has merged external PRs in the last 3 months
- [ ] Scope is bounded -- you can estimate the work in hours, not weeks

## Red Flags to Avoid

**Stale issues.** Open for 2+ years with no maintainer comment. Likely deprioritized or blocked on something unstated.

**Internal-only repos.** Some projects accept external contributions in theory but never merge them. Check the contributor graph.

**Controversial RFCs.** Design-level disagreements that have been going back and forth for months. You'll spend more time in discussion than in code.

**Scope monsters.** Issues that start small but touch 15 files across 4 subsystems. If the maintainer says "this is tricky", believe them.

**Claimed issues.** Someone already commented "I'll work on this" within the last 2 weeks. Move on unless they've gone silent for 30+ days.

**Repos with no CI.** If they don't test their own code, they're unlikely to review yours carefully.

**License traps.** CLA requirements you're not comfortable with, or repos that require copyright assignment.

## Quick Discovery Checklist

```bash
# Get a fast overview of any repo's contribution health
REPO="owner/repo"
gh repo view "$REPO" --json stargazersCount,openIssues,updatedAt
gh issue list --repo "$REPO" --label "help wanted" --state open --limit 10
gh pr list --repo "$REPO" --state merged --limit 5 --json mergedAt,author
```

## Output of This Phase

A shortlist of 3-5 candidate issues, each with:
- Issue URL
- Preliminary score (Impact x Feasibility x Visibility)
- One-line summary of what the fix involves
- Any initial concerns

Take the top candidate into [Phase 02: Evaluate](./02-evaluate.md).
