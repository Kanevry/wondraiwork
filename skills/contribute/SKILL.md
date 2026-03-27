---
name: contribute
description:
  This skill should be used when the user asks to "contribute to an issue", "start a contribution",
  "implement a fix", "submit a PR", or mentions the full contribution workflow. Orchestrates the
  complete 7-phase methodology, dispatching to sub-skills and handling Phase 04 (implement) and
  Phase 05 (submit) directly.
argument-hint: "[<owner/repo> <issue-number>]"
---

# /contribute -- Full Contribution Workflow

Main entry point for the WondrAIWork contribution methodology. Detect the current workflow state,
dispatch to the appropriate sub-skill for phases 01-03 and 04b, and orchestrate phases 04
(implement) and 05 (submit) directly.

## Step 1: Parse Arguments and Detect State

Parse `$ARGUMENTS` for `<owner/repo>` and `<issue-number>`. Both are optional -- the skill adapts
based on what is provided and what state already exists.

Determine current workflow state by checking for existing artifacts:

```bash
ls ${CLAUDE_PLUGIN_ROOT}/targets/
```

If `<owner/repo>` and `<issue-number>` were provided, locate the matching target file. Read it to
determine which phases are complete by examining:

- **Status field** -- Open, Evaluating, In Progress, Verifying, Submitted, Merged, Abandoned,
  Blocked, Reassessing
- **Owner Briefing field** -- Not started, Completed, Rejected
- **Decision Log** -- Look for "Owner Briefing: GO" entry
- **Verification Evidence section** -- Filled out or empty
- **PR field** -- Empty or contains a PR URL

If no arguments were provided, list available target files and ask the user which contribution to
work on. If no target files exist, suggest starting from discovery.

## Step 2: Dispatch to Sub-Skills (Phases 01-03)

Based on the detected state, guide the user to the correct phase. Check each gate in order and
suggest the first incomplete phase:

**No target selected:**

> No target issue identified. Start with discovery:
>
> `/discover`

**Target identified but not evaluated (no target file or Status is "Open"):**

> Issue not yet evaluated. Run the evaluation:
>
> `/evaluate <owner/repo> <issue-number>`

**Evaluated but no owner briefing (no "Owner Briefing: GO" in Decision Log):**

> Evaluation complete, but the owner briefing has not been done. This gate is mandatory:
>
> `/briefing <owner/repo> <issue-number>`

**Briefed but repo not set up (no CODEBASE-MAP.md in repos/<repo-name>/):**

Check for the codebase map:

```bash
ls ${CLAUDE_PLUGIN_ROOT}/repos/*/CODEBASE-MAP.md 2>/dev/null
```

> Owner approved. Set up the target repository:
>
> `/setup <owner/repo>`

If the correct phase is identified, stop here and wait for the user to run the suggested sub-skill.
Do not proceed to Phase 04 until all prior phases are confirmed complete.

## Step 3: Pre-Implementation Checks (Phase 04 Gate)

Before starting implementation, verify all prerequisites are met.

**Read the target file** to confirm status and scoring:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/targets/<target-file>.md
```

**Confirm CODEBASE-MAP.md** exists and contains the required sections:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/repos/<repo-name>/CODEBASE-MAP.md
```

**Re-check for competing PRs** (competition may have changed since Phase 02):

```bash
gh search prs --repo=<owner/repo> --state=open "<issue-number>"
```

If new competing PRs are found, present them to the user and ask whether to continue, pivot, or
abandon. Log the decision in the target file Decision Log.

**Update target file status** to "In Progress" and add a Decision Log entry recording the start of
implementation.

## Step 4: Implement (Phase 04)

Read the implementation methodology at runtime:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/methodology/04-implement.md
```

Follow the methodology's prescribed sequence. Use the CODEBASE-MAP.md as the primary reference for
conventions, file locations, test patterns, and CI commands.

### 4a. Branch Setup

Navigate to the target repo and create a feature branch:

```bash
cd ${CLAUDE_PLUGIN_ROOT}/repos/<repo-name>
git fetch upstream
git checkout <default-branch>
git merge upstream/<default-branch>
git checkout -b fix/<issue-number>-<short-description>
```

Use the branch naming convention from CODEBASE-MAP.md if the repo documents one. Otherwise, use
`fix/<issue-number>-<description>` for bug fixes or `feat/<issue-number>-<description>` for
features. Keep the issue number in the branch name for traceability.

### 4b. Follow Their Conventions

Read the conventions section of CODEBASE-MAP.md. Match everything:

- **Commit format** -- Use whatever format the repo uses (conventional, angular, plain, prefixed).
  When unclear, use imperative mood: "Fix X" not "Fixed X."
- **Code style** -- Run their formatter before every commit. Check their linter config.
- **Test patterns** -- Write tests that match their existing style (framework, assertions, mocking,
  file naming, location).
- **Error handling** -- Handle errors the same way surrounding code does. Do not introduce new
  patterns.

### 4c. TDD Approach

When applicable (especially bug fixes with clear expected vs actual behavior):

1. Write a failing test that demonstrates the bug or expected behavior
2. Run it to confirm it fails for the right reason
3. Implement the minimum code to make the test pass
4. Run the full test suite to catch regressions
5. Refactor if needed, ensuring tests still pass

When TDD does not fit (refactoring, performance, exploratory work), implement first but write tests
before committing.

### 4d. Iteration Loop

Repeat this cycle until the implementation is complete:

1. **Implement** -- Write the code change. Keep scope tight to the issue.
2. **Test** -- Run the relevant test subset, then the full suite. Use the exact commands from
   CODEBASE-MAP.md.
3. **Lint** -- Run the repo's linter and formatter. Fix all violations before proceeding.
4. **Self-Review** -- Run `git diff` and review every line. Check for: scope creep, debug
   statements, leftover TODOs, missing test coverage, style violations.
5. **Commit** -- Make atomic commits following the repo's format.

### 4e. Scope Discipline

- Change only what is necessary to address the issue
- If another bug is found during implementation, note it down and file a separate issue later
- Do not refactor unrelated code, even if it is "obviously better"
- If scope needs to expand, log the reason in the Decision Log and inform the user

### 4f. Local CI Gate

Before pushing, replicate what their CI does. Run every command from the CODEBASE-MAP.md CI Pipeline
section:

```bash
# Example -- actual commands come from CODEBASE-MAP.md
<build-command>
<lint-command>
<test-command>
<format-check-command>
```

If anything fails, fix it before pushing. CI should confirm work, not be the first feedback loop.
Failing CI wastes maintainer attention.

### 4g. Push and Verify

After all local checks pass:

```bash
cd ${CLAUDE_PLUGIN_ROOT}/repos/<repo-name>
git push origin fix/<issue-number>-<short-description>
```

Update the target file Decision Log with implementation notes (approach taken, alternatives
considered, any surprises encountered).

## Step 5: Invoke Verification (Phase 04b)

Verification is mandatory before submission. Invoke the verification skill:

> Implementation complete. Running the mandatory verification gate:
>
> `/verify <owner/repo> <issue-number>`

Do NOT proceed to Step 6 until `/verify` returns a GO decision. If `/verify` returns STOP, follow
its instructions (fix issues, reassess, or abandon) and re-run verification after resolving the
blockers.

## Step 6: Submit (Phase 05)

Only proceed here after `/verify` returns GO. Read the submission methodology and PR checklist at
runtime:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/methodology/05-submit.md
cat ${CLAUDE_PLUGIN_ROOT}/methodology/templates/pr-checklist.md
```

### 6a. Draft the PR Title

- Under 70 characters
- Imperative mood ("Fix X" not "Fixed X" or "Fixing X")
- Describe the change, not the problem
- Include the issue number if the repo convention includes it in titles

Present the draft title to the user for review before submission.

### 6b. Draft the PR Body

Structure the body with these sections:

- **What** -- 1-3 sentences describing the change. Include `Fixes #<issue-number>` or
  `Relates to #<issue-number>`.
- **Why** -- Root cause (bug fix) or use case (feature). Link to the issue.
- **How** -- Technical summary of the approach. Mention alternatives if relevant.
- **Test Plan** -- Checklist of what was tested (unit tests, manual verification, edge cases).
- **Screenshots / Recordings** -- Include if the change has visual impact. Omit this section
  otherwise.

If the repo has a PR template (check `.github/PULL_REQUEST_TEMPLATE.md` or
`.github/PULL_REQUEST_TEMPLATE/`), use their template instead. Fill out every section.

Present the draft body to the user for review before submission.

### 6c. AI Attribution

Check the target file's AI Contribution Stance section. Follow the repo's policy:

- **Explicit welcome / No policy** -- Include attribution per AI-ATTRIBUTION.md if the methodology
  requires it
- **Restrict** -- Follow the repo's specific restrictions on AI disclosure
- **Ban** -- This should have been caught in Phase 02. Do not submit.

Read the attribution guidance:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/AI-ATTRIBUTION.md
```

### 6d. Final Pre-Submit Checklist

Walk through the full PR checklist from the template. Confirm every item. If any item fails, fix it
before submitting.

### 6e. Submit the PR

After user approval of the title and body:

```bash
cd ${CLAUDE_PLUGIN_ROOT}/repos/<repo-name>
gh pr create \
  --title "<approved-title>" \
  --body "$(cat <<'EOF'
<approved-body>
EOF
)"
```

Capture the PR URL from the output. Update the target file:

- Set the **PR** field to the PR URL
- Set the **Status** to "Submitted"
- Add a Decision Log entry: "PR submitted: <PR-URL>"

### 6f. Post-Submit

1. Watch CI status on the PR. If CI fails, fix immediately and push a new commit (never force-push).
2. Handle any bot requirements (CLA signing, label requirements).
3. Inform the user that the PR is submitted and provide the URL.

Suggest monitoring for reviewer feedback:

> PR submitted: <PR-URL>
>
> Watch for reviewer comments and CI status. When feedback arrives, respond within 24 hours.

## Important Notes

- **Phase gates are mandatory.** Every phase must complete before the next begins. The dispatcher
  checks state, not assumptions.
- **Phase 04b (/verify) is non-negotiable.** Never skip verification. "Tests pass" is necessary but
  not sufficient. The verification gate catches issues that CI cannot (issue alignment, visual
  correctness, behavioral spec compliance, kill criteria).
- **Kill criteria are binary.** If a hard kill criterion (K1-K7) is triggered during implementation
  or verification, do NOT submit. Document the reason and stop.
- **Decision Log is a living document.** Every non-trivial decision during implementation must be
  logged with a timestamp and rationale. This includes approach changes, scope adjustments, and
  discovered risks.
- **Scoring may change.** If feasibility drops 2+ points during implementation, log it in the
  Decision Log. If it drops below 4/10, trigger K2 hard kill and stop.
- **Never force-push PR branches.** Target repos squash on merge. Force-pushing destroys review
  diffs and reviewer context.
- **Follow THEIR conventions, not ours.** Commit format, code style, test patterns, branch naming --
  everything comes from CODEBASE-MAP.md, not from the WondrAIWork methodology.
- **AI attribution follows the target repo's policy.** Check the AI Contribution Stance section in
  the target file and follow accordingly.
- **Resumption is first-class.** If the user returns mid-workflow, this skill detects the current
  state from the target file and resumes from the correct phase. No re-work required.
