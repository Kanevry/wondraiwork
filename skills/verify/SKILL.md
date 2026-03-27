---
name: verify
description:
  This skill should be used when the user asks to "verify my changes", "run verification", "check
  before submitting", "run the quality gate", or mentions Phase 04b. Runs the mandatory verification
  gate with kill criteria before PR submission.
argument-hint: "<owner/repo> <issue-number>"
---

# /verify -- Mandatory Pre-Submission Verification Gate

Phase 04b of the WondrAIWork methodology. Execute the five verification checks and evaluate all kill
criteria before any PR submission. This gate is mandatory and cannot be skipped. A PR that bypasses
this gate violates the methodology.

This skill has no backing script. It reads CI commands from the target repo's CODEBASE-MAP.md and
executes them directly via Bash.

## Step 1: Parse Arguments and Locate Target

Parse `$ARGUMENTS` for the target repo and issue number. Expected format:
`<owner/repo> <issue-number>`.

If either argument is missing, ask the user to provide both. Do not proceed without them.

Resolve paths:

- **Target file**: `${CLAUDE_PLUGIN_ROOT}/targets/<owner>-<repo>-<issue-number>.md` (or locate it
  via glob if naming varies)
- **Repo directory**: `${CLAUDE_PLUGIN_ROOT}/repos/<repo>/`
- **Codebase map**: `${CLAUDE_PLUGIN_ROOT}/repos/<repo>/CODEBASE-MAP.md`

Verify all three exist. If the repo directory does not exist, tell the user to run Phase 03/04
first. If CODEBASE-MAP.md does not exist, warn that CI commands must be identified manually.

## Step 2: Load Methodology and Checklist

Read the SSOT and checklist template at runtime:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/methodology/04b-verify.md
cat ${CLAUDE_PLUGIN_ROOT}/methodology/templates/verification-checklist.md
```

Read the target file to extract:

- Feasibility score (initial and current)
- Behavioral assertions from Phase 03
- Decision log entries
- Issue URL (the upstream GitHub issue)

## Step 3: Re-Read the Upstream Issue

Fetch the original issue fresh. Do not rely on cached target file notes -- the issue may have new
comments since Phase 03.

```bash
gh issue view <issue-number> --repo <owner/repo> --json title,body,comments,labels,state
```

Capture:

- The full issue description
- Every maintainer comment (filter by repo members if possible)
- Any new comments since Phase 03
- Current issue state (still open? already closed? competing PR merged?)

If the issue was closed or a competing PR was merged since implementation began, trigger an
immediate STOP.

## Step 4: Run CI Commands

Read CODEBASE-MAP.md to identify the CI commands for the target repo. Look for sections covering
test, lint, typecheck, and build commands.

Execute each command from the repo directory and capture full output:

```bash
cd ${CLAUDE_PLUGIN_ROOT}/repos/<repo>/

# Run each CI command found in CODEBASE-MAP.md, for example:
pnpm test          # or npm test, yarn test, cargo test, etc.
pnpm lint          # or npm run lint, etc.
pnpm tsc --noEmit  # TypeScript check if applicable
pnpm build         # or the repo's build command
```

Adapt commands to whatever the target repo uses. Do not assume pnpm -- use the package manager and
commands documented in CODEBASE-MAP.md.

Record the result of each command: PASS or FAIL with relevant output.

If any command fails, do not stop the verification -- continue through all checks so the full
picture is visible. Failures feed into the kill criteria evaluation in Step 6.

## Step 5: Execute the Five Verification Checks

Walk through each check systematically. Evidence before assertions -- run commands, show output,
then assess.

### Check 1: Issue Alignment

Execute as defined in the methodology (read in Step 2). Compare the upstream issue (fetched in
Step 3) against the actual implementation. Review the diff: `git diff main...HEAD` (or the
appropriate base branch).

### Check 1b: Specification Cross-Reference

Execute as defined in the methodology. Verify every behavioral assertion from the target file
(extracted in Step 2) against actual code behavior.

### Check 1c: Issue Thread Coverage

Execute as defined in the methodology. Review every maintainer comment captured in Step 3.

### Check 2: Visual Validation (UI Only)

Skip if the contribution has no visual component. Execute as defined in the methodology -- capture
before/after screenshots and validate native look and feel.

### Check 3: Honest Assessment ("The Maintainer Test")

Execute as defined in the methodology. Read the full diff as if seeing it for the first time with 50
other PRs in the queue.

## Step 6: Evaluate Kill Criteria

Evaluate every hard kill criterion (K1-K7) and soft kill criterion (S1-S6) from the methodology and
checklist template read in Step 2. Do not skip any. State the verdict for each.

Present results in two tables matching the format from the verification checklist template:

- Hard Kill Criteria table: columns Criterion | Description | Verdict (PASS or KILLED)
- Soft Kill Criteria table: columns Criterion | Description | Verdict (CLEAR or FLAGGED)

Kill criteria are BINARY. No override for convenience. A feasibility of 3/10 is a hard kill even if
tests pass. An overridden checklist is theater.

## Step 7: Render the Final Decision

Fill out the verification checklist from the template with actual results.

### If all checks pass and no kill criteria triggered: GO

Present the completed checklist with all items checked. State:

> **DECISION: GO** -- All five verification checks passed. No kill criteria triggered. Proceed to
> Phase 05 (Submit).
>
> Use `/contribute <owner/repo> <issue-number>` to proceed with PR submission (Phase 05).

### If any hard kill triggered: STOP

State which criterion was triggered and the evidence. Present options:

> **DECISION: STOP** -- Hard kill criterion K{N} triggered: {description}.
>
> Options:
>
> 1. **Abandon** -- The issue is not worth pursuing with this approach
> 2. **Pivot** -- Try a fundamentally different approach (return to Phase 03)
> 3. **Draft PR** -- Submit as Draft with explicit "seeking guidance" framing

Update the target file status to Blocked or Reassessing. Document the kill criterion and evidence in
the target file Decision Log.

### If soft kill triggered but no hard kill: PAUSE

State which soft criterion was flagged and the evidence. Ask the user to decide:

> **DECISION: PAUSE** -- Soft kill criterion S{N} flagged: {description}.
>
> The contribution may still be viable but requires explicit acknowledgment. Review the evidence
> above and decide: proceed with caution, or reassess?

## Important Notes

- This skill references the full methodology at runtime. The SSOT is
  `${CLAUDE_PLUGIN_ROOT}/methodology/04b-verify.md` -- do not duplicate its content into target
  files or journal entries.
- Evidence before assertions. Run the commands. Show the output. THEN make the assessment. Never
  claim "all tests pass" without showing the test output.
- The upstream issue must be re-read fresh (Step 3). Target file notes may have drifted from
  reality, and new comments may have appeared since Phase 03.
- Kill criteria exist to catch cases where subjective confidence diverges from objective signals.
  They are not suggestions. They are gates.
- If CODEBASE-MAP.md is missing, identify CI commands from the repo's package.json, Makefile, CI
  config (.github/workflows/), or CONTRIBUTING.md. The absence of a map is not an excuse to skip CI
  verification.
- There is no middle ground. GO or STOP. No "probably fine" or "good enough."
