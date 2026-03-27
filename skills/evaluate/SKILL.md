---
name: evaluate
description:
  This skill should be used when the user asks to "evaluate an issue", "check if an issue is
  viable", "assess a repository", or mentions Phase 02.
argument-hint: "<owner/repo> <issue-number>"
---

# /evaluate — Deep Issue Evaluation

Evaluate whether a specific GitHub issue is worth contributing to. This is Phase 02 of the
WondrAIWork methodology. The evaluation produces a GO / CONDITIONAL GO / NO-GO recommendation based
on repo health, maintainer activity, competition, AI stance, and a weighted score.

## Step 1: Parse Arguments

Extract `<owner/repo>` and `<issue-number>` from `$ARGUMENTS`. If either is missing, prompt the
user.

Example input: `/evaluate vercel/next.js 42846`

## Step 2: Check Blocklist

Before any evaluation work, verify the target repo is not blocked.

```bash
cat ${CLAUDE_PLUGIN_ROOT}/targets/BLOCKLIST.md
```

If the repo appears on the blocklist, stop immediately with a **HARD NO-GO** and suggest `/discover`
to find an alternative target.

## Step 3: Run Evaluation Script

Execute the automated evaluation script:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/evaluate.sh $ARGUMENTS
```

This produces a structured report covering:

- Repository health metrics (stars, forks, language, license, recent activity)
- Issue details (title, state, labels, assignee, reactions, comments)
- Risk assessment (competing PRs, CLA requirements, archived status)
- Community PR merge speed (average days to merge for external contributors)
- Script verdict (VIABLE / CAUTION / SKIP)

Capture and review the full output before proceeding.

## Step 4: Read and Apply the Evaluation Methodology

Read the full evaluation framework:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/methodology/02-evaluate.md
```

Apply every section of the methodology document systematically:

- **Repo health signals** -- maintainer activity, CI status, contributor guidelines
- **AI contribution stance** -- run all checks from the methodology's "Check Sequence" section. This
  is a hard gate: if the repo bans AI contributions, the evaluation ends as a HARD NO-GO regardless
  of all other signals.
- **Issue quality signals** -- specification clarity, acceptance criteria, reproducibility
- **Full issue thread analysis** -- read EVERY comment in the issue thread. Extract maintainer
  requirements, warnings, technical constraints, prior attempt analysis, and sentiment signals.
  Document all findings.
- **Competition check** -- search for existing PRs, assignees, and "I'll work on this" claims.
  Perform rejection triage on any closed/rejected PRs for this issue.

## Step 5: Apply Go/No-Go Framework

Apply the Go/No-Go decision framework from the methodology document. Score each of the 8 criteria as
Pass or Fail using evidence gathered in the previous steps.

Apply the decision rules from the methodology. The framework defines clear thresholds for GO,
CONDITIONAL GO, and NO-GO based on how many criteria pass and which specific criteria fail.

## Step 6: Calculate Weighted Score

Apply the weighted scoring matrix from the methodology read in Step 4. Score each of the three
dimensions 0-10 and compute the weighted total as a score out of 5.0.

Mark this score as **preliminary**. It must be re-evaluated after Phase 03 (Understand) when actual
codebase complexity is known.

## Step 7: Present Evaluation Summary

Present the results using this example format (adapt as needed):

```
=== EVALUATION SUMMARY ===

Repo:     owner/repo (stars)
Issue:    #number -- title
Score:    X.X/5.0 (Impact: X | Feasibility: X | Visibility: X)
Verdict:  GO / CONDITIONAL GO / NO-GO

Go/No-Go Checklist (8 criteria from methodology):
[x] 1. External PRs merged recently
[x] 2. Issue acknowledged by maintainer
[ ] 3. No competing PRs  <-- RISK
[x] 4. CI green on default branch
[x] 5. Can build locally
[x] 6. Scope estimable
[x] 7. Required domain knowledge available
[x] 8. Repo does not ban AI contributions

AI Stance: No policy / Explicit welcome / Explicit ban / Implicit hostility
Key Risks: ...
Issue Thread Intelligence: ...
```

## Step 8: Suggest Next Steps

Based on the verdict:

**If GO or CONDITIONAL GO:**

> Recommend proceeding to the Owner Briefing (Phase 02b). The owner must review and approve the
> evaluation before any implementation begins. Suggest:
>
> `/briefing <owner/repo> <issue-number>`
>
> For CONDITIONAL GO, highlight the specific risks the owner needs to accept.

**If NO-GO:**

> State the reasons clearly. Suggest returning to discovery:
>
> `/discover`

## Important Notes

- **Blocklist is absolute.** Repos on `targets/BLOCKLIST.md` are hard no-go. Do not evaluate
  further.
- **AI stance is a hard gate.** If the repo bans AI contributions, no amount of code quality changes
  the outcome. Stop evaluation and return NO-GO.
- **Competition check timing.** Always re-check for competing PRs again before Phase 04
  (Implementation), not just here. Situations change.
- **Feasibility re-scoring.** The Phase 02 score is preliminary. After Phase 03 (Understand),
  re-score feasibility based on actual codebase complexity. If it drops below 4/10, abandon the
  target.
- **Owner Briefing is mandatory.** Never proceed to Phase 03 without owner approval via Phase 02b.
  The `/briefing` skill generates the briefing for owner review.
- **Full thread analysis is mandatory.** Skimming the issue description is not sufficient. Every
  maintainer comment may contain implicit acceptance criteria or rejection signals.
