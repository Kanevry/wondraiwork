# WondrAIWork — Internal Agent Guide

> This file is GitLab-only. It is excluded from the public GitHub repo.

## Overview

WondrAIWork is a systematic OSS contribution framework. Human (Bernhard) leads, Claude Code assists.
The public repo contains methodology, targets, scripts, and contribution journal.
This file contains internal AI agent instructions.

## Agent Rules

1. **Never expose internal configs** — CLAUDE.md, .claude/, .gitignore.internal stay on GitLab
2. **Follow target repo conventions** — When working in repos/, adapt to their linter, commit format, test framework
3. **Quality gate before every PR** — Typecheck, lint, test must pass in the target repo's CI
4. **Document learnings** — Every contribution gets a journal entry in contributions/
5. **Verify before claiming done** — Run the target repo's full test suite, not just the changed tests

## Workflow

See methodology/ docs for the full 7-phase process. Key internal notes:

### Discovery (Phase 1)
- Use `gh search issues` with scoring matrix
- Prefer: high reactions, "help wanted"/"bug" labels, no assignee, no competing PRs
- Scoring: Impact (0-10) x Feasibility (0-10) x Visibility (0-10)

### Evaluation (Phase 2)
- Check last 10 merged community PRs for merge speed
- Verify maintainer is active (commits in last 7 days)
- Red flags: competing PRs, "wontfix" history, internal-only merge pattern

### Understanding (Phase 3)
- Clone to repos/ (gitignored)
- Read CONTRIBUTING.md, .github/, CI config first
- Map the relevant code path before touching anything
- Understand their test patterns

### Implementation (Phase 4)
- Branch from their default branch
- Follow THEIR commit conventions (not ours)
- Write tests that match their existing test style
- Run their full CI locally before pushing

### Submission (Phase 5)
- PR title: concise, under 70 chars
- PR body: What, Why, How, Test Plan
- Reference the issue number
- Follow AI attribution per target repo's policy (see AI-ATTRIBUTION.md)

### Response (Phase 6)
- Respond to reviews within 24h
- Accept feedback gracefully
- Push requested changes as fixup commits, then squash

### Tracking (Phase 7)
- Update GitHub issue status after each phase transition
- Document outcomes in contributions/ journal
- Session handoff: commit WIP, document state, next steps

## Commands

```bash
pnpm discover      # Run issue discovery script
pnpm evaluate      # Evaluate a specific issue
pnpm setup-target  # Clone and prepare a target repo
pnpm lint          # shellcheck on all scripts
pnpm format        # prettier --write on all markdown
pnpm format:check  # prettier --check on all markdown
pnpm markdownlint  # markdownlint on all markdown
pnpm test          # shellcheck + validation
```

## Conventions

- Commits: `{type}({scope}): {description}` (Conventional Commits)
- Types: feat, fix, docs, chore, scripts
- Scopes: methodology, targets, contributions, scripts, repo

## Path-Scoped Rules

| Rule | Path | Purpose |
|------|------|---------|
| development.md | `*` | Tool requirements, pnpm, dual-remote workflow, encoding |
| security.md | `*` | Secret scanning, .env handling, GitLab-only files |
| scripts.md | `scripts/**` | Shell script standards, gh CLI usage, macOS compat |
| methodology.md | `methodology/**`, `targets/**`, `contributions/**` | Content standards, target file format, scoring |
| contribution-workflow.md | `repos/**` | Target repo conventions, PR standards, git hygiene |
| quality-gate.md | `repos/**` | AI-slop detection, PR quality checklist, convention adherence |

## GitLab ↔ GitHub Sync

GitLab is SSOT. GitHub gets selective pushes excluding:
- CLAUDE.md
- .claude/
- .gitignore.internal
- .npmrc (internal registry reference)
- Any internal tracking files

### Sync Command
```bash
# Push to GitHub (excludes private files via .gitignore)
git push github main

# Push to GitLab (full, including private files — requires separate tracking branch or force-include)
git push gitlab main
```

## Key Pitfalls

- `head -n -1` does NOT work on macOS (BSD). Use `sed '$d'` instead.
- `gh search issues` JSON fields: NO `reactions` field. Use `commentsCount` instead.
- `gh search issues` labels with spaces: use `--label="help wanted"` (quoted).
- Stars/date filters are positional qualifiers, not flags: `gh search issues "stars:>=5000"`.
