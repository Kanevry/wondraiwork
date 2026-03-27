---
name: discover
description:
  This skill should be used when the user asks to "find issues", "discover contributions", "search
  for open source issues", or mentions Phase 01.
argument-hint: "[--stars=N] [--lang=LANG] [--strategy=NAME]"
---

# /discover -- Find OSS Contribution Targets

Phase 01 of the WondrAIWork methodology. Search GitHub for high-impact open source issues worth
contributing to, score them against the methodology's scoring matrix, and produce a ranked shortlist
of 3-5 candidates ready for deep evaluation.

## Step 1: Parse Arguments and Gather Preferences

Parse `$ARGUMENTS` for any flags the user provided. Supported flags:

- `--stars=N` -- Minimum repo stars (default: 1000)
- `--lang=LANG` -- Language filter (e.g., typescript, rust, go, python)
- `--label=LABEL` -- Additional label filter (e.g., bug, enhancement)
- `--limit=N` -- Results per strategy (default: 5)
- `--max-age=DAYS` -- Maximum issue age in days (default: 90)
- `--strategy=NAME` -- Single strategy: reactions, comments, help-wanted, good-first-issue, or bugs

If the user provided no arguments or incomplete preferences, ask for:

- Language preference (or "any")
- Minimum stars threshold
- Strategy preference (or "all" for all five strategies)
- Any specific labels or keywords

Do not proceed until preferences are clear.

## Step 2: Run the Discovery Script

Execute the discovery script with the resolved arguments:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/discover.sh $ARGUMENTS
```

The script searches GitHub across up to five strategies (reactions, comments, help-wanted,
good-first-issue, bugs) and outputs a formatted table of candidates with issue URLs, repo names,
reaction counts, comment counts, and labels.

If the script returns no results, adjust the filters (lower the star threshold, broaden the
language, try a different strategy) and re-run. Do not present an empty result set without
attempting at least one retry with relaxed filters.

## Step 3: Read and Apply Scoring Methodology

Read the full discovery methodology:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/methodology/01-discover.md
```

Apply the scoring matrix from the methodology to each promising issue returned by the script. Use
the Impact, Feasibility, and Visibility axes with their defined weights and criteria tables.
Calculate the weighted total for each candidate.

Review the "What Makes a Good Target" checklist and "Red Flags to Avoid" section from the
methodology. Disqualify any issue that triggers a red flag (stale issues, internal-only repos, scope
monsters, claimed issues, repos with no CI, license traps).

Check the blocklist before scoring:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/targets/BLOCKLIST.md
```

Immediately disqualify any repo appearing on the blocklist.

## Step 4: Present the Shortlist

Present a ranked shortlist of 3-5 candidates in this table format:

| #   | Issue | Repo | Impact | Feasibility | Visibility | Total | Verdict |
| --- | ----- | ---- | ------ | ----------- | ---------- | ----- | ------- |

For each candidate, include below the table:

- Issue URL (clickable)
- One-line summary of what the fix involves
- Key risks or concerns (competing PRs, CLA requirements, scope uncertainty)
- Why it scored the way it did (brief reasoning per axis)

Sort by total score descending. Apply the verdict thresholds from the methodology to classify each
candidate.

## Step 5: Suggest Next Steps

For the top-scoring candidate(s), suggest the next phase:

> Use `/evaluate <owner/repo> <issue-number>` to run a deep evaluation before committing to this
> contribution.

If no candidates scored above the methodology's investigation threshold, recommend adjusting search
parameters and re-running discovery with different filters or strategies.

## Important Notes

- Scores at this stage are **preliminary**. They get re-evaluated in Phase 02 (Evaluate) with deeper
  data and again in Phase 03 (Understand) after reading the actual codebase.
- Prefer issues that are: acknowledged by maintainers, less than 6 months old, with no competing
  PRs, and in repos that have merged external PRs recently.
- The `gh search issues` JSON output does NOT include a `reactions` field. Use `commentsCount` as a
  proxy when the script output does not include reaction data.
- Labels with spaces require quoting in gh CLI: `--label="help wanted"`.
- Star/date filters are positional qualifiers, not flags: `gh search issues "stars:>=5000"`.
