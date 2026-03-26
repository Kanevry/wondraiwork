# Contributing to WondrAIWork

Welcome! WondrAIWork is open to contributions of all kinds — methodology improvements, new
contribution targets, case studies, script enhancements, documentation fixes, and more.

## Getting Started

```bash
# Fork and clone
git clone https://github.com/<your-username>/wondraiwork.git
cd wondraiwork

# Install dependencies
pnpm install

# Run checks
pnpm lint        # shellcheck on scripts
pnpm format:check # prettier on markdown
pnpm markdownlint # markdown linting
```

## Types of Contributions

### Methodology Improvements

The 7-phase methodology in `methodology/` is the core of this project. Improvements could include:

- Clarifying existing phases
- Adding language-specific guidance
- Improving templates in `methodology/templates/`
- Adding decision trees or checklists

### Contribution Targets

Found a high-impact open source issue worth contributing to? Add it:

1. Use the
   [Contribution Target issue template](https://github.com/Kanevry/wondraiwork/issues/new?template=contribution-target.md)
2. Or create a target file in `targets/` following the existing format
3. Score it honestly using the Impact/Feasibility/Visibility matrix

### Case Studies

Completed a contribution using this methodology? Share your experience:

1. Open a
   [Case Study issue](https://github.com/Kanevry/wondraiwork/issues/new?template=case-study.md)
2. Or add a file to `contributions/` documenting what you did, what worked, and what you learned

### Scripts

The automation scripts in `scripts/` must be:

- Compatible with both macOS (BSD) and Linux (GNU)
- Written in Bash with `#!/usr/bin/env bash` and `set -euo pipefail`
- Validated with shellcheck (zero warnings)
- Documented with `--help` output

### Documentation

Typo fixes, broken links, unclear explanations — all welcome. No contribution is too small.

## Development Workflow

1. Create a feature branch: `git checkout -b feat/your-change`
2. Make your changes
3. Run all checks:

   ```bash
   pnpm lint
   pnpm format:check
   pnpm markdownlint
   ```

4. Commit using [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat(methodology): add language-specific guidance for Rust`
   - `fix(scripts): handle spaces in repository names`
   - `docs(targets): add new high-impact TypeScript issue`
5. Push and open a PR

## Pull Request Standards

- Fill out the PR template completely
- Keep PRs focused — one change per PR
- Reference related issues
- Ensure all checks pass locally before pushing

## AI Usage

This project uses AI tools transparently. See our [AI Attribution Policy](./AI-ATTRIBUTION.md).

**TL;DR:** AI assistance is welcome. Disclose it. Take responsibility for the output.

## Code of Conduct

Please read our [Code of Conduct](./CODE_OF_CONDUCT.md). We expect respectful, constructive
interactions.

## Security

Found a security concern? See our [Security Policy](./SECURITY.md).

## Questions?

Open a [GitHub Discussion](https://github.com/Kanevry/wondraiwork/discussions) or file an issue.
We're happy to help.
