# WondrAIWork Methodology: Overview

A systematic 6-phase process for making meaningful open-source contributions. Each phase has a clear purpose, defined inputs/outputs, and specific tools. AI assists throughout, but the human leads every decision.

## The 6 Phases

| Phase | Name | Purpose | Time |
|-------|------|---------|------|
| 01 | [Discover](./01-discover.md) | Find high-impact issues worth solving | 30-60 min |
| 02 | [Evaluate](./02-evaluate.md) | Assess repo health and issue quality | 15-30 min |
| 03 | [Understand](./03-understand.md) | Map the codebase systematically | 1-3 hours |
| 04 | [Implement](./04-implement.md) | Build the fix with quality gates | 2-8 hours |
| 05 | [Submit](./05-submit.md) | Create a professional PR | 30-60 min |
| 06 | [Respond](./06-respond.md) | Handle review feedback and iterate | Ongoing |
| 07 | [Tracking](./07-tracking.md) | Issue lifecycle, Clank automation, session handoff | Continuous |

## Flow Diagram

```
                    +-------------+
                    |  01 DISCOVER |
                    |  Find issues |
                    +------+------+
                           |
                           v
                    +-------------+
                    | 02 EVALUATE  |
                    | Repo + issue |
                    +------+------+
                           |
                      Go / No-Go
                     /           \
                   No             Yes
                   |               |
                   v               v
             [Back to 01]   +-------------+
                            | 03 UNDERSTAND|
                            | Map codebase |
                            +------+------+
                                   |
                                   v
                            +-------------+
                            | 04 IMPLEMENT |
                            | Build + test |
                            +------+------+
                                   |
                              Pass CI?
                             /        \
                           No          Yes
                           |            |
                           v            v
                     [Fix + retry] +-------------+
                                   | 05 SUBMIT   |
                                   | Create PR   |
                                   +------+------+
                                          |
                                          v
                                   +-------------+
                                   | 06 RESPOND  |
                                   | Review cycle|
                                   +------+------+
                                          |
                                     Merged / Closed
```

## How AI Fits In

AI (Claude Code or similar) is a force multiplier, not the driver.

| Phase | AI Role | Human Role |
|-------|---------|------------|
| Discover | Surface candidates, calculate scores | Decide what's worth pursuing |
| Evaluate | Analyze repo health metrics | Make the go/no-go call |
| Understand | Rapid codebase navigation, explain patterns | Build mental model, verify understanding |
| Implement | Draft code, run tests, catch regressions | Design approach, review every line, own quality |
| Submit | Draft PR description, check formatting | Write the narrative, ensure accuracy |
| Respond | Suggest response wording, implement fixes | Communicate with maintainers, make judgment calls |

## Key Principles

1. **Quality over quantity.** One merged PR to a high-impact project beats ten drive-by typo fixes.
2. **Respect the maintainers.** Their time is more valuable than yours. Do the homework.
3. **Follow their conventions.** Adapt to the project, not the other way around.
4. **Test everything locally.** Never let CI be your first feedback loop.
5. **Communicate clearly.** Write PR descriptions that respect the reader's time.
6. **Know when to walk away.** Not every issue is worth the investment. The evaluate phase exists for a reason.

## Templates

Ready-to-use templates for each phase:

- [Issue Evaluation Template](./templates/issue-evaluation.md) -- Structured scoring for phases 01-02
- [PR Checklist](./templates/pr-checklist.md) -- Pre-submission verification for phase 05
- [Codebase Map](./templates/codebase-map.md) -- Documentation template for phase 03

## Getting Started

1. Read through each phase document once to understand the full process.
2. Pick a project or technology area you care about.
3. Start at phase 01 and work through sequentially.
4. Use the templates to stay organized.
5. After your first contribution, refine your process.
