---
name: briefing
description:
  This skill should be used when the user asks to "create a briefing", "present the owner briefing",
  "brief me on this issue", or mentions Phase 02b. Generates a mandatory German-language owner
  briefing with 7 sections and a GO/ADJUST/REJECT gate.
argument-hint: "<owner/repo> <issue-number>"
---

# /briefing -- Owner Briefing (Phase 02b)

Mandatory gate between evaluation and implementation. Present a German-language briefing to the
owner (Bernhard) covering all 7 sections from the methodology. No implementation work proceeds
without an explicit GO decision.

## Step 1: Parse Arguments and Locate Evaluation Data

Extract `<owner/repo>` and `<issue-number>` from `$ARGUMENTS`. If either is missing, prompt the
user.

Example input: `/briefing vercel/next.js 42846`

Locate the evaluation data from the prior `/evaluate` run. Check for the target file:

```bash
ls ${CLAUDE_PLUGIN_ROOT}/targets/
```

Find the matching target file for the repo and issue. If no target file exists, inform the user that
an evaluation must be completed first and suggest:

> Use `/evaluate <owner/repo> <issue-number>` to run the evaluation before requesting a briefing.

Do not proceed without evaluation data.

## Step 2: Read Methodology and Template

Load the briefing methodology and template for structural guidance:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/methodology/02b-owner-briefing.md
cat ${CLAUDE_PLUGIN_ROOT}/methodology/templates/owner-briefing.md
```

Read the target file to extract the evaluation results (scoring, AI stance, risks, competition
check, issue thread intelligence, Go/No-Go checklist).

## Step 3: Gather Supplementary Data

If the target file lacks detail for any of the 7 sections, fetch missing information directly:

- Use `gh issue view <owner/repo> <issue-number>` for the issue description and comments
- Use `gh repo view <owner/repo> --json stargazersCount,primaryLanguage` for repo metadata
- Use `gh search prs --repo=<owner/repo> --state=open "<issue-number>"` to re-check for competing
  PRs (competition changes between phases)

Do not present stale data. Verify key facts are current.

## Step 4: Present the Briefing in German

Present the briefing directly in the conversation. Use German for all 7 sections. Follow the exact
section order from the methodology:

### Section 1: Was ist das Problem?

2-3 sentences in plain language describing what is broken or missing. Include what the issue
reporter expects. Provide the clickable issue URL.

### Section 2: Ziel-Repo auf einen Blick

Present repo metadata as a table. Use the format from the owner-briefing template read in Step 2.

### Section 3: Scoring

Present Impact / Feasibility / Visibility scores from the evaluation with specific reasoning for
each score. Use the table format from the owner-briefing template read in Step 2.

### Section 4: Verwandte Issues

Address duplicates, competing PRs, affected codebase areas, and upstream/downstream dependencies.
Cover each explicitly, even if the answer is "keine gefunden". See the template for the full
checklist.

### Section 5: Geplanter Ansatz

3-5 numbered steps describing the planned approach at a high level. Enough for the owner to
understand the direction and explain it back.

### Section 6: Risiken

Present risks with likelihood and mitigation as a table. Use the format from the owner-briefing
template read in Step 2.

### Section 7: Erwarteter Aufwand

Present effort estimates per phase as a table. Use the format from the owner-briefing template read
in Step 2.

## Step 5: Verify Completeness

Before requesting the owner's decision, verify against the methodology checklist:

- All 7 sections presented in the conversation
- Original issue URL linked (not just a summary)
- Scoring has specific reasoning, not just numbers
- Related issues section addressed (even if "keine gefunden")
- Approach is clear enough for the owner to explain it back

If any section is incomplete, fill the gap before proceeding.

## Step 6: Request Owner Decision

After presenting all 7 sections, ask the owner for their explicit decision. Present the three
options in German:

> **Deine Entscheidung:**
>
> - **GO** -- Alles verstanden, weiter zu Phase 03
> - **ADJUST** -- Aenderungen am Ansatz noetig (bitte beschreiben)
> - **REJECT** -- Nicht weiterverfolgen

Wait for the owner's response. Do not assume or suggest a decision. If the owner asks questions,
answer them fully before re-requesting the decision.

## Step 7: Process the Decision

### On GO

1. Log the decision in the target file's Decision Log section:
   `Owner Briefing: GO -- [brief reason from owner]`
2. Confirm to the owner and suggest the next phase:

> Entscheidung geloggt. Weiter mit:
>
> `/setup <owner/repo>`

### On ADJUST

1. Ask the owner what needs to change
2. Incorporate the feedback
3. Re-present the adjusted sections (not the entire briefing unless requested)
4. Return to Step 6 to request the decision again

### On REJECT

1. Log the decision in the target file's Decision Log section:
   `Owner Briefing: REJECT -- [reason from owner]`
2. Confirm to the owner and suggest returning to discovery:

> Entscheidung geloggt. Zurueck zur Suche:
>
> `/discover`

## Important Notes

- **This gate is mandatory.** No implementation work begins without an explicit GO. There is no
  "probably fine" or "let's just start and see."
- **The briefing is a conversation, not a document.** Present it live in Claude Code. The target
  file receives only a one-line Decision Log entry recording the outcome.
- **Language is German.** The 7 sections, the decision prompt, and the confirmation are all in
  German. Log entries in the target file remain in English.
- **Answer all questions.** If the owner has questions, the briefing is not complete. Answer every
  question fully before requesting the decision.
- **Do not rush.** Listing facts without explanation defeats the purpose. The goal is owner
  _understanding_, not information transfer.
- **Re-check competition.** Always verify competing PRs are still current -- the situation may have
  changed since the evaluation.
- **Scoring reasoning is mandatory.** Presenting numbers without explaining why each score was
  chosen violates the methodology.
