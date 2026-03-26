# Phase 7: Tracking and Automation

> How WondrAIWork issues are discovered, tracked, and managed across sessions.

## Issue Lifecycle

```
Discovery (manual or Clank cron)
    ↓
GitHub Issue created on Kanevry/wondraiwork
    [label: target, tier-N]
    [body: upstream link, scoring, approach]
    ↓
Evaluation (human reviews, Go/No-Go)
    [label: in-progress or closed]
    ↓
Implementation (clone, fix, test)
    ↓
PR Submitted upstream
    [label: submitted, comment with PR link]
    ↓
PR Merged (or iterated)
    [label: merged, contribution journal entry]
```

## GitHub Issue Convention

Every contribution target is a GitHub Issue on `Kanevry/wondraiwork` with:

### Title Format

```
[Target] <repo-name> #<issue-number> — <short description>
```

### Required Labels

- `target` — always
- `tier-1`, `tier-2`, or `tier-3` — priority tier
- Status: `in-progress` → `submitted` → `merged`

### Body Template

```markdown
## Upstream Issue

<link to the original issue>

## Quick Facts

- **Repo:** owner/repo (NK stars)
- **Language:** <language>
- **Reactions:** N | **Comments:** N
- **Assigned:** Yes/No | **Competing PRs:** description
- **Score:** Impact N + Feasibility N + Visibility N = **total/30**

## Problem

<2-3 sentences>

## Approach

<brief plan>

## References

- Target file: `targets/<name>.md`
```

## Clank Integration (Future — Issue #16)

### Weekly Discovery Cron

- Schedule: Monday 09:00 CET
- Script: `cron/wondraiwork-discover.sh`
- Searches GitHub for issues matching scoring criteria
- Creates issues on Kanevry/wondraiwork automatically
- Posts top 3 picks to Discord #insights

### Event Flow

```
cron → wondraiwork.target.discovered → WondrAIWorkHandler
    → gh issue create (Kanevry/wondraiwork)
    → Discord #insights notification
```

### Deduplication

- Handler checks existing issues before creating new ones
- Match by upstream issue URL in body
- Skip if issue already exists (any status)

### OpenClaw Knowledge

- Clank knows about WondrAIWork targets via workspace skill
- Can answer: "What are our current targets?" "What's the status of #7?"
- Semi-autonomous: discovers and proposes, human decides and acts

## Session Handoff

When closing a session:

1. All active targets must be GitHub Issues (not just target files)
2. In-progress work must be committed or stashed
3. Issue status labels must reflect current state
4. Any new discoveries from the session → new Issues

When starting a session:

1. Check open issues: `gh issue list --repo Kanevry/wondraiwork --label target`
2. Check for stale targets (upstream issue may be closed/assigned)
3. Pick a target and start the workflow

## Stale Target Detection

Targets can become stale when:

- The upstream issue gets closed
- Someone else submits a PR
- The repo becomes inactive
- The issue gets assigned

Check: `bash scripts/evaluate.sh <owner/repo> <issue-number>` re-evaluates a target. Automate: Clank
cron can re-check open targets weekly and flag stale ones.
