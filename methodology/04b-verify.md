# Phase 04b: Verify

> Stop. Step back. Before submitting, prove to yourself that this actually works.

## Why This Phase Exists

PRs get rejected when the screenshots show the feature not working. PRs get rejected when the style
does not match the project's design. PRs get rejected when a "verified" claim contradicts the
visible evidence. This phase exists to catch all of that _before_ you reach the maintainer's inbox.

The cost of submitting a broken PR is high: reputation damage, maintainer trust erosion, and the
"untested AI PR" label that follows you. The cost of spending 30 more minutes verifying is low.

## Position in the Workflow

```
04 IMPLEMENT ──── Pass CI? ──── No ──── [Fix + retry]
                     │
                    Yes
                     │
                     v
              +--------------+
              |  04b VERIFY  |
              | Prove it     |
              | works        |
              +------+-------+
                     │
               Kill criteria?
                /          \
              Yes           No
               │             │
               v             v
         [Stop / Reassess]  05 SUBMIT
```

Phase 04b is mandatory. It cannot be skipped. "Passing CI" is necessary but not sufficient -- a
build that compiles does not mean a feature that works.

## Time

15-60 minutes, depending on whether the contribution has visual components.

## The Five Verification Checks

### Check 1: Issue Alignment

Re-read the _original_ issue. Not your target file summary -- the actual upstream URL. Your notes
may have drifted from what the issue actually describes.

Compare:

- What the issue describes as the **problem**
- What the issue shows in any **screenshots or recordings**
- What your implementation **actually does**

Checklist:

- [ ] I have re-read the original issue (the upstream URL, not my target file notes)
- [ ] Every behavior described in the issue is addressed by my change
- [ ] I have not solved a different problem than what was reported
- [ ] If the issue has screenshots, my implementation matches the expected outcome shown
- [ ] If the issue scope changed during implementation, the change is documented with reasons
- [ ] I am not submitting a partial fix disguised as a complete fix

If your implementation addresses only part of the issue, you have two options:

1. Frame it explicitly as a partial fix in the PR description and get maintainer buy-in
2. Go back to Phase 04 and complete the implementation

Never submit a partial fix as if it were complete.

### Check 2: Visual Validation (UI contributions only)

Skip this check if your contribution has no visual component.

Take screenshots of your implementation in its **actual running state**. Compare them against:

1. The issue's screenshots (the expected/desired state)
2. The current broken state (before your fix)
3. The surrounding UI (does your change look native?)

#### Feature verification

- [ ] Screenshot of the feature BEFORE my fix (broken state)
- [ ] Screenshot of the feature AFTER my fix (working state)
- [ ] Side-by-side comparison shows the issue is actually resolved
- [ ] The fix renders correctly in all states (hover, active, disabled, loading)
- [ ] No visual artifacts, wrong spacing, mismatched fonts, or incorrect colors
- [ ] The change looks like it belongs -- same visual weight, alignment, and rhythm as surrounding
      UI
- [ ] Tested in all required contexts (different pages, different data, edge cases)

#### Native look and feel

The most common reason for PR rejection on UI changes is that the contribution _looks foreign_. It
works, but it does not look like it belongs.

- [ ] Font family matches surrounding elements
- [ ] Font size and weight match the design system
- [ ] Colors use the project's design tokens or variables, not hardcoded values
- [ ] Spacing (padding, margin, gap) is consistent with adjacent elements
- [ ] Hover, focus, and active states follow the project's interaction patterns
- [ ] Border radius, shadows, and other decorative properties match
- [ ] Responsive behavior matches how similar components handle resize
- [ ] Dark mode and light mode both work (if the project supports themes)

#### How to capture evidence

Save screenshots with descriptive names:

```bash
# Before (broken state)
# Use your OS screenshot tool or browser DevTools
# Save as: screenshots/before-feature-name.png

# After (working state)
# Save as: screenshots/after-feature-name.png
```

Reference screenshots in your target file's Verification Evidence section. Include them in the PR.

### Check 3: Decision Log Review

Open your target file. Read the Decision Log section. Ask yourself three questions:

1. Can someone who has never seen this code reconstruct _why_ each choice was made?
2. Are there decisions that seemed obvious at the time but are not documented?
3. Did the approach change during implementation? Is the change logged?

Checklist:

- [ ] Every non-trivial technical decision has a log entry with rationale
- [ ] Scope changes during implementation are documented with reasons
- [ ] Rejected approaches are documented (what was tried, why it failed)
- [ ] Feasibility score reflects current reality, not initial optimism
- [ ] Risk assessment is current (not stale from the evaluation phase)

Update the GitLab tracking issue with any decisions made during this verification phase.

### Check 4: Regression Check

Your fix might break something adjacent. Test beyond the happy path.

- [ ] Full test suite passes (not just the tests I wrote or modified)
- [ ] Adjacent features that share the same code path still work
- [ ] Edge cases tested (empty state, max values, concurrent operations)
- [ ] No console errors, warnings, or unhandled exceptions in the browser (for UI)
- [ ] Performance is not noticeably degraded

```bash
# Run the full test suite
pnpm test        # or npm test, yarn test -- whatever the project uses

# Check for TypeScript errors
pnpm tsc --noEmit

# Run the linter
pnpm lint

# Build from clean
pnpm build
```

### Check 5: Honest Assessment ("The Maintainer Test")

This is the most important check. It requires brutal honesty.

Read your diff as if you are the maintainer seeing it for the first time. You do not know the
contributor. You have 50 other PRs in your queue. You have 30 seconds to form a first impression.

- [ ] Does the PR solve the stated issue completely, or is it a partial fix disguised as complete?
- [ ] If I attach my screenshots to the PR, do they PROVE the feature works? Or do they show
      problems?
- [ ] Would I trust this code in production?
- [ ] Is this the quality bar I would want associated with my name and project?
- [ ] If the maintainer has rejected similar PRs before (check issue history), does mine avoid those
      exact mistakes?
- [ ] Am I submitting this because it is READY, or because I have spent time on it and want to show
      something?

If the answer to any of these is uncomfortable, STOP. Go back to Phase 04 or invoke the kill
criteria below.

## Kill Criteria

Explicit conditions under which you MUST stop and NOT submit.

### Hard Kill -- do not submit under any circumstances

| ID  | Criterion                                                       | Why                                                         |
| --- | --------------------------------------------------------------- | ----------------------------------------------------------- |
| K1  | Screenshots show the feature visibly not working                | The maintainer will see the same thing                      |
| K2  | Feasibility score dropped below 4/10 during implementation      | The approach is fundamentally struggling                    |
| K3  | The approach requires working around the project's architecture | You are fighting the codebase, not extending it             |
| K4  | A better approach was discovered but not implemented            | Submit the right fix, not the sunk-cost fix                 |
| K5  | Test suite has failures you cannot explain                      | Unexplained failures signal uncontrolled side effects       |
| K6  | You cannot explain every line of your diff                      | You do not own this code well enough to defend it in review |

### Soft Kill -- pause, reassess, document before continuing

| ID  | Criterion                                                   | Action                                                         |
| --- | ----------------------------------------------------------- | -------------------------------------------------------------- |
| S1  | Feasibility score dropped 3+ points from initial evaluation | Log the reasons, reassess if partial submission is appropriate |
| S2  | Scope expanded beyond original issue description            | Split into multiple PRs or discuss scope with maintainer first |
| S3  | Implementation required more than 2x estimated time         | Document why, reassess value/effort ratio                      |
| S4  | Adjacent features broke and the fix is non-trivial          | Might indicate the approach is wrong, not just incomplete      |
| S5  | The issue has been partially addressed by someone else      | Re-scope to avoid overlap                                      |

### Kill Decision Process

When kill criteria are triggered:

1. Document in the target file Decision Log: which criterion, what evidence
2. Update target file status to "Blocked" or "Reassessing"
3. Comment on the GitLab tracking issue with the decision and reasoning
4. Options:
   - **Abandon** -- the issue is not worth pursuing with the current approach
   - **Pivot** -- try a fundamentally different approach (go back to Phase 03)
   - **Draft PR** -- submit as Draft with explicit "seeking guidance" framing
5. NEVER submit a non-Draft PR when hard kill criteria are active

## Output of This Phase

One of two outcomes:

**GO** -- All five checks passed, no kill criteria triggered.

- Target file Verification Evidence section is filled out
- Decision log is current
- Screenshots (if applicable) are captured and referenced
- Proceed to [Phase 05: Submit](./05-submit.md)

**STOP** -- Kill criterion triggered or checks failed.

- Target file updated with the reason
- GitLab issue commented with the decision
- Status set to Blocked, Reassessing, or Abandoned
- Do not proceed to Phase 05

There is no middle ground. GO or STOP. No "probably fine" or "good enough."
