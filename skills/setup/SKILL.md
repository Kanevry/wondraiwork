---
name: setup
description:
  This skill should be used when the user asks to "set up a target repo", "clone a repo for
  contribution", "prepare for contribution", "map the codebase", or mentions Phase 03.
argument-hint: "<owner/repo>"
---

# /setup -- Set Up and Understand a Target Repo

Phase 03 of the WondrAIWork methodology. Clone a target repository, explore its structure, extract
behavioral specifications from documentation, complete the language-agnostic understanding
checklist, and produce a CODEBASE-MAP.md ready for implementation.

## Step 1: Parse Arguments

Parse `$ARGUMENTS` for the repository identifier in `owner/repo` format.

If the argument is missing or malformed, ask the user:

- Which repository to set up (must be `owner/repo` format)

Do not proceed until a valid `owner/repo` identifier is provided.

## Step 2: Run the Setup Script

Execute the setup script to clone the repository and gather initial metadata:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/setup-target.sh $ARGUMENTS
```

The script handles:

- Cloning the repo into `repos/<repo-name>/` (or pulling latest if already cloned)
- Fetching repo metadata (language, default branch, stars)
- Displaying the first 80 lines of CONTRIBUTING.md
- Checking recent CI run status on the default branch
- Detecting build system and package manager
- Creating a CODEBASE-MAP.md stub in the repo directory

Review the script output carefully. Note the detected language, build system, default branch, CI
status, and any contributing guidelines displayed.

## Step 3: Read the Methodology

Read the full Phase 03 methodology to guide the exploration:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/methodology/03-understand.md
```

Read the codebase map template for the required structure:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/methodology/templates/codebase-map.md
```

Follow the methodology's prescribed order: README first, then CONTRIBUTING.md, then CI config, then
architecture docs. Do not skip ahead to code until these documents are read.

## Step 4: Explore the Repository

Navigate to the cloned repository and systematically explore. Work through these areas in order:

### 4a. README and Documentation

Read the project README in full. Identify:

- Build prerequisites and instructions
- Architecture overview (if present)
- Feature descriptions relevant to the contribution
- Links to additional documentation

Check for architecture docs:

```bash
ls repos/<repo-name>/docs/ repos/<repo-name>/doc/ \
  repos/<repo-name>/ARCHITECTURE.md repos/<repo-name>/DESIGN.md 2>/dev/null
```

### 4b. Behavioral Specification Extraction

This step is mandatory, not optional. After reading the README and docs, extract testable behavioral
assertions for every feature the contribution will touch.

For each feature:

1. Find the feature description in the README, docs, or feature index
2. Extract the verb (moves, hides, adds, replaces, disables, filters, transforms)
3. Write a testable assertion mapping the verb to a concrete DOM, API, or behavior outcome

Example:

- README says: "Moves the Security and Insights tabs to the repository navigation dropdown"
- Assertion: After the code runs, Security/Insights tab elements must exist inside the dropdown menu
  container, NOT be hidden via CSS `hidden` attribute or `display: none`
- Verification: Inspect the dropdown, confirm the elements are children of the overflow menu

Document assertions in this table format for inclusion in the target file:

| #   | Source          | Assertion                          | Verified in 04b |
| --- | --------------- | ---------------------------------- | --------------- |
| 1   | README line 105 | Tabs moved to dropdown, not hidden | [ ]             |

These assertions become mandatory verification items in Phase 04b. Every assertion must be checked
off before a PR can be submitted.

### 4c. Contributing Guidelines

Read the full CONTRIBUTING.md (the setup script only showed the first 80 lines). Identify:

- Commit message format and conventions
- Branch naming requirements
- Required tests for contributions
- Code style rules and linter configuration
- CLA requirements (check for CLA.md, contributors.yml, or CLA bot references in recent PRs)
- PR template requirements

### 4d. CI Configuration

Examine the CI setup to understand the quality bar:

```bash
ls repos/<repo-name>/.github/workflows/ 2>/dev/null
ls repos/<repo-name>/Makefile repos/<repo-name>/Justfile \
  repos/<repo-name>/.gitlab-ci.yml repos/<repo-name>/.circleci/config.yml 2>/dev/null
```

Read the CI workflow files to extract the exact lint, test, build, and type-check commands the
maintainers enforce. These are the commands that must pass locally before submission.

### 4e. Code Navigation

Follow the methodology's layered approach:

**Layer 1 -- Directory Structure:** Get the high-level layout (2 levels deep, excluding noise
directories like node_modules, .git, vendor, target, dist).

**Layer 2 -- Key Files:** Identify entry points, recently modified files, and the largest source
files in the relevant area.

**Layer 3 -- Dependencies:** Trace imports into and out of the modules relevant to the issue. Map
what the affected code depends on and what depends on it.

**Layer 4 -- Configuration:** Identify linter config, compiler/transpiler config, editor config, and
any code generation setup.

### 4f. Test Patterns

Examine the existing test suite for the affected area:

- Identify the test framework (jest, vitest, pytest, go test, cargo test, etc.)
- Find test file naming conventions and locations (co-located, `__tests__/`, `tests/`, etc.)
- Understand the mocking strategy, fixture management, and assertion style
- Read existing tests for the code area being modified
- Note the exact commands to run tests (full suite and relevant subset)

### 4g. Issue Thread Intelligence

Read ALL comments in the issue thread, not just the description. Capture every maintainer statement
about requirements, expected behavior, rejected approaches, or implementation hints. Document these
in the target file under "Issue Thread Intelligence."

## Step 5: Complete the Checklist

Verify every item on the 14-item language-agnostic checklist from the methodology read in Step 3.
All 14 items must be checked off before proceeding to Phase 04. If any item cannot be satisfied,
continue exploring until it can, or flag it and determine whether the issue is still feasible.

Do not advance to implementation with gaps in understanding.

## Step 6: Complete the Codebase Map

Fill in the CODEBASE-MAP.md stub created by the setup script with all information gathered during
exploration. Use the full template structure from
`${CLAUDE_PLUGIN_ROOT}/methodology/templates/codebase-map.md`:

- **Project Overview:** Repo, language, framework, package manager, build tool, minimum runtime
- **Architecture:** High-level structure, key modules, data flow diagram
- **Files to Modify:** Specific files, what changes are needed, and why
- **Execution Path:** Step-by-step trace from trigger to the bug/feature
- **Test Patterns:** Framework, file location, naming, mocking, fixtures, assertion style
- **CI Pipeline:** Each CI step with tool and config file, plus exact local run commands
- **Conventions:** Commit format, branch naming, PR template, code style, imports, error handling
- **Dependencies:** Relevant dependencies with versions and why they matter
- **Open Questions:** Anything still unclear before implementation

Present the completed codebase map to the user for review.

## Step 7: Suggest Next Steps

After presenting the completed codebase map, suggest the next phase:

> Use `/contribute <owner/repo> <issue-number>` to begin implementation for this contribution.

If open questions remain that block implementation, recommend resolving them first (ask on the issue
thread, pick a simpler issue, or investigate further).

## Important Notes

- **3-hour time box.** The methodology enforces a hard limit of 3 hours for this phase. If the
  codebase cannot be understood enough to start implementing within 3 hours, the issue may be too
  complex for a first contribution to this repo. Pick a simpler issue first to build familiarity.
- **All 14 checklist items must be answered "yes" before Phase 04.** This is a hard gate. Do not
  proceed with gaps in understanding.
- **CODEBASE-MAP.md is mandatory output.** Phase 04 cannot start without a completed codebase map
  saved to `repos/<repo-name>/CODEBASE-MAP.md`.
- **Behavioral specs are mandatory, not optional.** Every feature being modified must have testable
  assertions extracted from documentation. These become Phase 04b verification items. Skipping this
  step is the root cause of PRs that "work" but violate the documented behavior contract.
- **Read the issue thread in full.** Maintainer comments in the issue often contain critical
  requirements, rejected approaches, or implementation hints that are not in the issue description.
  Missing these leads to wasted work and rejected PRs.
- **Do not start coding during this phase.** The purpose is understanding, not implementation.
  Resist the urge to make "quick fixes" before the terrain is mapped.
