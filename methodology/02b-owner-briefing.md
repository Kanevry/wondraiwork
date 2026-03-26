# Phase 02b: Owner Briefing

> Before investing hours in codebase mapping and implementation, brief the owner. No work without
> informed approval.

## Why This Phase Exists

The owner must understand every contribution before it reaches a maintainer's inbox. Without this
briefing, the owner cannot perform meaningful quality checks at PR time -- they would be reviewing
code for an issue they never fully understood.

This phase exists because:

1. **Informed quality control.** The owner can only validate a PR if they understood the issue from
   the start.
2. **Early course correction.** The owner may spot risks, competing priorities, or better
   alternatives before hours are invested.
3. **Ownership.** Every contribution carries the owner's name. They must know what they are
   shipping.

The cost of a 10-minute briefing is trivial. The cost of submitting a PR the owner cannot defend in
review is high.

## Position in the Workflow

```
02 EVALUATE ──── Go/No-Go? ──── No ──── [Back to 01]
                     │
                    Yes
                     │
                     v
              +----------------+
              | 02b OWNER      |
              | BRIEFING       |
              | (Mandatory)    |
              +-------+--------+
                      │
               Owner approves?
                /           \
              No             Yes
               │               │
               v               v
         [Adjust or     03 UNDERSTAND
          back to 01]
```

Phase 02b is mandatory. It cannot be skipped. A Go decision in Phase 02 is necessary but not
sufficient -- the owner must explicitly approve before Phase 03 begins.

## Time

10-20 minutes. This includes the briefing presentation and any Q&A.

## How It Works

1. **Claude presents the briefing** in the Claude Code conversation, in German, covering all 7
   mandatory sections (see below).
2. **The owner asks questions.** Claude answers every question fully. No rushing past gaps.
3. **The owner decides:** GO, ADJUST, or REJECT.
4. **Claude logs the outcome** in the target file's Decision Log.

The briefing is a conversation, not a document. It happens live in Claude Code. The target file gets
only a one-line Decision Log entry recording the outcome.

## The 7 Mandatory Sections

Every briefing must cover these sections, in this order:

### Section 1: What Is the Problem?

2-3 sentences in plain language. What is broken or missing? What does the issue reporter expect?
Link to the original upstream issue.

### Section 2: Target Repo at a Glance

Quick context about the repository:

- Repository name, stars, primary language
- Maintainer activity level (active / moderate / low)
- Date of last merged external PR
- CI status (passing / failing)
- Contributor guidelines (exist? key requirements?)

### Section 3: Scoring

The Impact / Feasibility / Visibility scores from Phase 02, with reasoning for each:

| Criterion   | Score | Reasoning          |
| ----------- | ----- | ------------------ |
| Impact      | X/10  | Why this score     |
| Feasibility | X/10  | Why this score     |
| Visibility  | X/10  | Why this score     |
| **Total**   | XX/30 | Overall assessment |

### Section 4: Related Issues

- Are there duplicate or similar issues?
- Are there competing PRs (open, draft, or recently closed)?
- Which areas of the codebase are likely affected?
- Are there upstream or downstream dependencies?

If none exist, state that explicitly. Do not skip the section.

### Section 5: Proposed Approach (High-Level)

3-5 steps describing the planned approach. This is a sketch, not a detailed implementation plan.
Enough for the owner to understand the direction.

### Section 6: Risks

What could go wrong? For each risk:

- What is the risk?
- How likely is it?
- What is the mitigation?

### Section 7: Expected Effort

Time estimate range for the remaining phases:

- Phase 03 (Understand): estimated time
- Phase 04 (Implement): estimated time
- Total: estimated range

## Owner Decision

Three possible outcomes:

**GO** -- Owner understands and approves. Proceed to Phase 03.

- Target file Decision Log entry: `Owner Briefing: GO — [brief reason]`
- Continue to [Phase 03: Understand](./03-understand.md)

**ADJUST** -- Owner wants a different approach or has concerns.

- Address the owner's feedback
- Re-present the adjusted briefing
- Repeat until GO or REJECT

**REJECT** -- Issue is not worth pursuing, or timing is wrong.

- Target file Decision Log entry: `Owner Briefing: REJECT — [reason]`
- Return to [Phase 01: Discover](./01-discover.md)

There is no "probably fine" or "let's just start and see." The owner gives an explicit GO before any
Phase 03 work begins.

## Checklist

Before requesting the owner's decision:

- [ ] All 7 sections presented in the conversation
- [ ] Original issue URL linked (not just a summary)
- [ ] Scoring has specific reasoning, not just numbers
- [ ] Related issues section addressed (even if "none found")
- [ ] Owner's questions answered fully
- [ ] Approach is clear enough for the owner to explain it back

## Common Mistakes

1. **Rushing the briefing.** Listing facts without explanation. The goal is owner _understanding_,
   not information transfer.
2. **Skipping related issues.** Competing PRs are the #1 reason for wasted effort.
3. **Vague approach.** "Fix the bug" is not an approach. The owner needs to understand the
   direction.
4. **Asking for approval before answering questions.** If the owner has questions, the briefing is
   not complete.
5. **Treating this as bureaucracy.** This phase exists because a real PR was submitted for an issue
   the owner did not fully understand. The time investment is minimal, the protection is
   significant.
