---
name: discover
description:
  Find high-impact open source issues worth contributing to. Uses 5 search strategies (reactions,
  comments, help-wanted, good-first-issue, bugs) with configurable filters for stars, language,
  labels, and age.
argument-hint: "[--stars=N] [--lang=LANG] [--strategy=NAME]"
---

# /discover — Find OSS Contribution Targets

You are running the WondrAIWork discovery phase (Phase 01). Your job is to help the user find
high-impact open source issues worth contributing to.

## Step 1: Understand the Search

Ask the user what they're looking for. If they provided arguments, use those. Otherwise ask:

- **Language preference?** (e.g., TypeScript, Rust, Go, Python — or "any")
- **Minimum stars?** (default: 1000)
- **Strategy?** (reactions, comments, help-wanted, good-first-issue, bugs — or "all")
- **Any specific labels or keywords?**

## Step 2: Run Discovery Script

Execute the discovery script with the user's preferences:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/discover.sh $ARGUMENTS
```

Available options:

- `--stars=N` — Minimum repo stars (default: 1000)
- `--lang=LANG` — Language filter
- `--label=LABEL` — Additional label filter
- `--limit=N` — Results per strategy (default: 5)
- `--max-age=DAYS` — Maximum issue age (default: 90)
- `--strategy=NAME` — Single strategy (reactions|comments|help-wanted|good-first-issue|bugs)

## Step 3: Score the Results

Read the methodology scoring guide:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/methodology/01-discover.md
```

For each promising issue from the results, apply the scoring matrix:

- **Impact** (weight 40%): reactions, user reports, core functionality affected
- **Feasibility** (weight 35%): scope clarity, tech familiarity, approach complexity
- **Visibility** (weight 25%): repo stars, org reputation

**Formula:** `Total = (Impact x 0.40) + (Feasibility x 0.35) + (Visibility x 0.25)`

| Score   | Verdict                             |
| ------- | ----------------------------------- |
| 4.0+    | Strong target — proceed to evaluate |
| 3.0-3.9 | Worth investigating                 |
| 2.0-2.9 | Marginal                            |
| <2.0    | Skip                                |

## Step 4: Present Shortlist

Present a shortlist of 3-5 candidates in a table:

| #   | Issue | Repo | Impact | Feasibility | Visibility | Total | Verdict |
| --- | ----- | ---- | ------ | ----------- | ---------- | ----- | ------- |

For each candidate, include:

- Issue URL
- One-line summary of what the fix involves
- Key risks or concerns

## Step 5: Suggest Next Steps

For the top candidate(s), suggest:

> Use `/evaluate <owner/repo> <issue-number>` to do a deep evaluation before committing to the
> contribution.

## Important Notes

- Scores are **preliminary** at this stage — they get re-evaluated in Phase 02 (Evaluate) and Phase
  03 (Understand)
- Check the "Red Flags to Avoid" section in the methodology for disqualifying signals
- Prefer issues that are: acknowledged by maintainers, less than 6 months old, with no competing PRs
