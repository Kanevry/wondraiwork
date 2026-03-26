# WondrAIWork

**Systematic AI-assisted open source contribution framework.**

Human leads. AI assists. Open source benefits.

## The Problem

The open source contribution space has a massive gap:

- **Beginner tutorials** teach you how to fork and make your first PR
- **Autonomous AI agents** try to replace human contributors entirely
- **Nothing in between** — no systematic, human-led, AI-assisted methodology for making meaningful contributions to any repo, in any language, at any complexity level

WondrAIWork fills that gap.

## What This Is

A complete, repeatable workflow for finding high-impact open source issues and delivering quality fixes — fast. It's language-agnostic, complexity-independent, and designed for contributors who want to solve real problems, not just collect "good first issue" badges.

The framework pairs a human lead with AI pair programming (Claude Code) to:

1. **Discover** — Find issues that matter (not just what's labeled)
2. **Evaluate** — Score repo health, maintainer responsiveness, issue quality
3. **Understand** — Systematically explore unfamiliar codebases
4. **Implement** — Fix it right, following the target repo's conventions
5. **Submit** — PRs that maintainers want to merge
6. **Respond** — Handle reviews professionally, iterate fast

## Quick Start

```bash
# Clone this repo
git clone https://github.com/Kanevry/wondraiwork.git
cd wondraiwork

# Find high-impact issues
bash scripts/discover.sh

# Evaluate a specific issue
bash scripts/evaluate.sh <owner/repo> <issue-number>

# Set up a target repo for contribution
bash scripts/setup-target.sh <owner/repo>
```

## Methodology

The full methodology is documented in [`methodology/`](./methodology/):

| Phase | Doc | What |
|-------|-----|------|
| Overview | [00-overview.md](./methodology/00-overview.md) | The complete process at a glance |
| Discover | [01-discover.md](./methodology/01-discover.md) | Finding issues: criteria, scoring, queries |
| Evaluate | [02-evaluate.md](./methodology/02-evaluate.md) | Assessing repo health and issue quality |
| Understand | [03-understand.md](./methodology/03-understand.md) | Codebase exploration playbook |
| Implement | [04-implement.md](./methodology/04-implement.md) | Standards, testing, iteration loops |
| Submit | [05-submit.md](./methodology/05-submit.md) | PR craft: commits, descriptions, etiquette |
| Respond | [06-respond.md](./methodology/06-respond.md) | Review feedback and iteration |

## Contribution Targets

Active targets are tracked in [`targets/`](./targets/). Each file documents:
- The issue and its context
- Repo health assessment
- Complexity and impact scoring
- Current status

## Contribution Journal

Completed contributions are documented in [`contributions/`](./contributions/). Each entry records what was done, what was learned, and the outcome.

## Philosophy

- **Human judgment, AI speed** — The human decides what to work on and validates the approach. AI handles the tedious parts: searching, reading, drafting.
- **Repo-native standards** — We follow the target repo's conventions, not our own. Their linter, their commit format, their test framework.
- **Quality over quantity** — One well-crafted PR beats ten sloppy ones. Every contribution should be something the maintainer is glad to receive.
- **Learn in public** — The methodology, the targets, the journal — it's all here. Copy it, improve it, make it yours.

## License

MIT — use it however you want.

---

Built by [Bernhard Goetzendorfer](https://github.com/Kanevry) with [Claude Code](https://claude.ai/code).
