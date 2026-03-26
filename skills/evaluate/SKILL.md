---
name: evaluate
description:
  Deep-evaluate a GitHub repo and issue for contribution viability. Checks repo health, maintainer
  activity, competing PRs, merge speed, and produces a GO/NO-GO recommendation with scoring.
argument-hint: "<owner/repo> <issue-number>"
---

# /evaluate — Deep Issue Evaluation

You are running the WondrAIWork evaluation phase (Phase 02). Your job is to deeply assess whether a
specific issue is worth contributing to.

## Step 1: Parse Arguments

The user should provide `<owner/repo> <issue-number>`. If missing, ask for them.

Example: `/evaluate vercel/next.js 42846`

## Step 2: Run Evaluation Script

Execute the evaluation script:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/evaluate.sh $ARGUMENTS
```

This produces a structured report with:

- Repository health metrics (stars, forks, language, license, activity)
- Issue details (title, state, labels, assignee, reactions, comments)
- Risk assessment (competing PRs, CLA requirements, archived status)
- Community PR merge speed (average days to merge for external contributors)
- Verdict (VIABLE / CAUTION / SKIP)

## Step 3: Read Evaluation Methodology

Read the full evaluation framework:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/methodology/02-evaluate.md
```

## Step 4: Apply Go/No-Go Framework

Score each criterion as Pass/Fail:

| #   | Criterion                                 | Check                                             |
| --- | ----------------------------------------- | ------------------------------------------------- |
| 1   | Repo merged external PRs in last 3 months | From merge speed report                           |
| 2   | Issue acknowledged by maintainer          | Check issue comments                              |
| 3   | No competing active PR                    | From competing PRs section                        |
| 4   | CI is green on default branch             | `gh run list --repo REPO --branch main --limit 3` |
| 5   | Scope is estimable (hours, not weeks)     | Your judgment based on issue                      |
| 6   | Required domain knowledge is available    | Honest assessment                                 |
| 7   | No disqualifying red flags                | CLA issues, archived, etc.                        |

**Decision rules:**

- All 7 pass → **Strong GO**
- 1-2 fail → **Conditional GO** (note risks)
- 3+ fail → **NO-GO** (return to discovery)

## Step 5: Calculate Weighted Score

Apply the scoring matrix from Phase 01:

- **Impact** (40%): Based on reactions, comments, issue severity
- **Feasibility** (35%): Based on scope, competition, technical complexity
- **Visibility** (25%): Based on repo stars, org reputation

**Note:** This is the Phase 02 preliminary score. It MUST be re-evaluated after Phase 03
(Understand) when the actual codebase complexity is known.

## Step 6: Check for AI Contribution Policy

Check if the target repo has a policy on AI-assisted contributions:

```bash
gh api "repos/$1/contents/CONTRIBUTING.md" --jq '.content' 2>/dev/null | base64 -d | grep -i "ai\|copilot\|llm\|gpt\|claude" || echo "No AI policy found"
```

If they restrict AI contributions, flag this immediately.

## Step 7: Present Evaluation Summary

Present a structured summary:

```
=== EVALUATION SUMMARY ===

Repo:     owner/repo (★ stars)
Issue:    #number — title
Score:    X.X/5.0 (Impact: X | Feasibility: X | Visibility: X)
Verdict:  GO / CONDITIONAL GO / NO-GO

Go/No-Go Checklist:
[x] External PRs merged recently
[x] Issue acknowledged by maintainer
[ ] No competing PRs  ← RISK: 1 open PR found
...

Key Risks:
- ...

Recommendation:
- ...
```

## Step 8: Suggest Next Steps

Based on the verdict:

**If GO:**

> This issue looks viable. The next step is the **Owner Briefing** (Phase 02b). The owner briefing
> presents the evaluation to the human owner for approval before any implementation begins. Use
> `/briefing` to generate the briefing.

**If CONDITIONAL GO:**

> This issue has risks: [list risks]. The owner should decide whether to proceed. Use `/briefing` to
> present the evaluation with these risks highlighted.

**If NO-GO:**

> This issue is not recommended. Reasons: [list]. Use `/discover` to find alternative targets.

## Important Notes

- **Competition check timing:** Always re-check for competing PRs right before Phase 04
  (Implementation), not just here
- **Feasibility re-scoring:** The Phase 02 score is preliminary. After Phase 03 (Understand),
  re-score feasibility based on actual codebase complexity. If it drops below 4/10, abandon the
  target.
- **Owner Briefing is mandatory:** Never proceed to Phase 03 without owner approval (Phase 02b)
