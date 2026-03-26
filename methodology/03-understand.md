# Phase 03: Understand

Systematically explore an unfamiliar codebase until you know enough to implement the fix confidently. Resist the urge to start coding before you understand the terrain.

## First Steps (15 minutes)

Every repo, regardless of language or framework, has the same essential documents. Read them in this order:

### 1. README

Build instructions, architecture overview, prerequisites. If you can't build the project, nothing else matters.

### 2. CONTRIBUTING.md

Commit conventions, branch naming, test requirements, code style. These are the rules you must follow.

### 3. CI Configuration

```bash
# GitHub Actions
ls .github/workflows/

# Or check for other CI systems
ls -la Makefile Justfile Taskfile.yml .gitlab-ci.yml Jenkinsfile \
  .circleci/config.yml .travis.yml 2>/dev/null
```

The CI config tells you exactly what the maintainers enforce: which linters, which test suites, which checks must pass. This is the objective quality bar.

### 4. Architecture Docs

```bash
# Common locations
ls docs/ doc/ ARCHITECTURE.md DESIGN.md 2>/dev/null
find . -name "ARCHITECTURE*" -o -name "DESIGN*" -o -name "OVERVIEW*" \
  2>/dev/null | head -10
```

Not all repos have these. When they do, they save hours.

## Code Navigation Strategy

### Find the Entry Points

Every codebase has a small number of entry points. Start there and trace inward.

```bash
# Package entry points
cat package.json | grep -E '"main"|"exports"|"bin"'    # Node.js/TypeScript
cat Cargo.toml | grep -E '\[lib\]|\[\[bin\]\]'         # Rust
cat setup.py pyproject.toml | grep -E 'entry_points|scripts'  # Python
cat go.mod                                               # Go (then find main.go)
cat *.csproj | grep -E 'OutputType|RootNamespace'       # C#/.NET
```

### Trace the Call Chain

For the specific issue you're fixing, trace the code path:

1. **Find the error or behavior** described in the issue
2. **Search for it** in the codebase (error messages, function names, variable names)
3. **Trace upstream** -- who calls this function? What triggers this code path?
4. **Trace downstream** -- what does this function call? What side effects does it have?

```bash
# Search for the error message or key term from the issue
grep -rn "the exact error message" src/
grep -rn "functionName" --include="*.ts" src/

# Find all callers of a function
grep -rn "functionName(" --include="*.ts" src/
```

### Understand the Test Patterns

Tests are the best documentation of intended behavior.

```bash
# Find test files related to the area you're working on
find . -name "*test*" -o -name "*spec*" | grep -i "module-name"

# Check test framework and patterns
head -30 $(find . -name "*.test.*" | head -1)

# Run existing tests for the affected area
# (varies by project -- check CI config for the exact command)
```

## Codebase Mapping Technique

Build a mental (and written) map of the relevant parts. Use the [Codebase Map Template](./templates/codebase-map.md).

### Layer 1: Directory Structure

```bash
# Get a high-level view (2 levels deep, ignore noise)
find . -maxdepth 2 -type d \
  -not -path '*/node_modules/*' \
  -not -path '*/.git/*' \
  -not -path '*/vendor/*' \
  -not -path '*/target/*' \
  -not -path '*/__pycache__/*' \
  -not -path '*/dist/*' \
  -not -path '*/.next/*' \
  | sort
```

### Layer 2: Key Files

Identify the files that matter for your specific issue:

```bash
# Files recently modified (likely active development)
git log --oneline --name-only -20 | grep -E '\.(ts|rs|go|py|cs)$' | sort -u

# Files touched by the area you care about
git log --oneline --all --follow -- "path/to/relevant/file"

# Largest files (often the core logic)
find src/ -name "*.ts" -exec wc -l {} + | sort -rn | head -20
```

### Layer 3: Dependencies

```bash
# What does this module import?
grep -E "^import|^from|^use |^require" src/relevant-file.ts

# What imports this module?
grep -rn "from.*relevant-file" --include="*.ts" src/
```

### Layer 4: Configuration

```bash
# Linter config
ls .eslintrc* .prettierrc* rustfmt.toml .editorconfig \
  pyproject.toml setup.cfg .rubocop.yml 2>/dev/null

# TypeScript / compiler config
ls tsconfig*.json Cargo.toml go.mod *.csproj 2>/dev/null
```

## Using AI for Rapid Understanding

AI tools excel at codebase exploration. Use them as an accelerator, not a replacement for your own understanding.

### Effective AI prompts for codebase exploration:

- "Explain the architecture of this module in 5 bullet points"
- "What is the execution flow when [specific trigger from the issue] happens?"
- "List all the places where [function/variable] is used and why"
- "What are the invariants this module maintains?"
- "How does this project handle [error handling / logging / configuration]?"

### Keep the human in the loop:

- **Verify claims.** AI can hallucinate function names, file paths, or behaviors. Spot-check by reading the actual code.
- **Build your own mental model.** Don't just relay AI's summary. Redraw the call chain in your own words.
- **Ask "why" not just "what."** Understanding the design rationale helps you make changes that fit the codebase's philosophy.

### Anti-patterns:

- Asking AI to "fix the issue" before you understand the codebase. You'll get code that compiles but doesn't fit.
- Trusting AI's architectural summary without verifying key claims. Models compress and simplify -- sometimes incorrectly.
- Skipping the test suite. AI might not mention that your change area has 200 tests with subtle assertions.

## Language-Agnostic Checklist

Regardless of the language, answer these questions before moving to implementation:

- [ ] Can I build the project from scratch? (clean clone, install, build)
- [ ] Can I run the full test suite? (or at least the relevant subset)
- [ ] Do I know which files I'll need to modify?
- [ ] Do I understand the code path from trigger to the bug/feature?
- [ ] Do I know how they handle errors in this area?
- [ ] Do I know the test patterns they use? (mocking strategy, fixtures, assertions)
- [ ] Have I read the existing tests for the affected code?
- [ ] Do I understand their commit and PR conventions?

If any answer is "no", keep exploring before you start implementing.

## Time Boxing

Set a hard limit of 3 hours for this phase. If you can't understand enough to start implementing within 3 hours, the issue might be too complex for a first contribution to this repo. Consider:

1. Picking a simpler issue in the same repo first (build familiarity)
2. Asking a clarifying question on the issue
3. Moving to a different candidate from Phase 01

## Output of This Phase

A completed [Codebase Map](./templates/codebase-map.md) covering:
- Files you'll modify
- The execution path of the fix
- Test files you'll add to or create
- Conventions you need to follow

Proceed to [Phase 04: Implement](./04-implement.md).
