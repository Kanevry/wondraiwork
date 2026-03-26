# Phase 04: Implement

Build the fix. Follow their conventions, test thoroughly, and keep the scope tight.

## Branch Strategy

Always branch from the repo's default branch. Never from a feature branch or an old tag.

```bash
# Fork the repo (if not already forked)
gh repo fork owner/repo --clone

# Make sure you're up to date
git fetch upstream
git checkout main
git merge upstream/main

# Create your feature branch
git checkout -b fix/issue-1234-description
```

**Branch naming:** Follow the repo's convention if documented. If not, use a descriptive name:
- `fix/1234-null-check-in-parser`
- `feat/1234-add-timeout-option`

Keep the issue number in the branch name for traceability.

## Follow Their Conventions

This is the single biggest factor in getting PRs merged. Match everything:

### Code Style

```bash
# Check their formatter/linter config and use it
# Node.js / TypeScript
cat .prettierrc* .eslintrc* 2>/dev/null
npx prettier --check src/your-file.ts
npx eslint src/your-file.ts

# Rust
cat rustfmt.toml 2>/dev/null
cargo fmt -- --check

# Go
# (gofmt is standard, but check for golangci-lint config)
cat .golangci.yml 2>/dev/null
gofmt -d your-file.go

# Python
cat pyproject.toml setup.cfg .flake8 2>/dev/null
# Check for black, ruff, flake8, isort, mypy configs

# C# / .NET
cat .editorconfig *.ruleset 2>/dev/null
dotnet format --check
```

### Commit Messages

Read their recent commits to understand the format:

```bash
git log --oneline -20
```

Common formats:
- Conventional Commits: `fix(parser): handle null input in tokenizer`
- Angular style: `fix(core): resolve race condition in scheduler`
- Plain descriptive: `Fix null pointer when input is empty`
- Prefixed: `[parser] Fix null check`

Match whatever they use. If unclear, use clear imperative mood: "Fix X" not "Fixed X" or "Fixes X".

### Test Framework

```bash
# Identify the test framework
# Node.js: check package.json scripts and devDependencies
cat package.json | grep -E "jest|vitest|mocha|ava|tape"

# Rust: built-in (cargo test), check for proptest/criterion
grep -r "proptest\|criterion" Cargo.toml

# Go: built-in (go test), check for testify
grep -r "testify\|gomock" go.mod

# Python: check for pytest, unittest patterns
cat pyproject.toml | grep -E "pytest|unittest"

# C#: check for xUnit, NUnit, MSTest
grep -r "xunit\|nunit\|mstest" *.csproj
```

## TDD Approach

When applicable, write the test first:

1. **Write a failing test** that demonstrates the bug or expected behavior
2. **Run it** to confirm it fails for the right reason
3. **Implement the fix** -- the minimum code to make the test pass
4. **Run the full test suite** to catch regressions
5. **Refactor** if needed, ensuring tests still pass

This approach works particularly well for bug fixes where there's a clear expected vs actual behavior.

When TDD doesn't fit (refactoring, performance, or when you need to understand the code structure before writing tests), implement first but still write tests before submitting.

## Iteration Loop

```
    +----------+
    | Implement |
    +----+-----+
         |
         v
    +----+-----+
    |   Test    |<--------+
    +----+-----+          |
         |                |
    Pass | Fail           |
         |    |           |
         v    +-----------+
    +----+-----+
    |   Lint    |<--------+
    +----+-----+          |
         |                |
    Pass | Fail           |
         |    |           |
         v    +-----------+
    +----+-----+
    |  Review   |
    | (self)    |
    +----+-----+
         |
         v
    +----+-----+
    |  Commit   |
    +----------+
```

### Run Tests

```bash
# Run the full suite (or the relevant subset)
# Node.js
npm test
npx vitest run src/parser/  # subset

# Rust
cargo test
cargo test parser::  # subset

# Go
go test ./...
go test ./pkg/parser/  # subset

# Python
pytest
pytest tests/test_parser.py  # subset

# C# / .NET
dotnet test
dotnet test --filter "FullyQualifiedName~Parser"  # subset
```

### Run Linters

```bash
# Whatever their CI runs -- check the workflow files
cat .github/workflows/*.yml | grep -A5 "run:"
```

### Self-Review

Before committing, review your own diff:

```bash
git diff
```

Ask yourself:
- Does this change only what's necessary?
- Would I approve this PR if someone else submitted it?
- Are there any leftover debug statements, comments, or TODOs?
- Does every new code path have a test?

## Common Pitfalls

### Breaking Unrelated Tests

Your change might break tests you didn't expect. Always run the full suite, not just "your" tests.

```bash
# Find which tests are affected by your changed files
git diff --name-only | while read f; do
  grep -rn "$(basename $f .ts)" --include="*.test.*" .
done
```

### Style Violations

The number one reason PRs get nit-picked. Run their formatter before every commit:

```bash
# Auto-format (language-dependent)
npx prettier --write src/  # Node.js
cargo fmt                   # Rust
gofmt -w .                 # Go
black .                    # Python
dotnet format              # C#
```

### Scope Creep

You found another bug while fixing the first one. Resist the urge to fix it in the same PR.

- Note it down
- File a separate issue if it doesn't already exist
- Keep your PR focused on one logical change

Maintainers review focused PRs faster and more favorably than sprawling ones.

### Premature Optimization

Don't refactor code that isn't directly related to your fix. Even if it's "obviously better." The maintainers have context you don't.

### Missing Error Handling

If you're adding a new code path, handle errors the same way the surrounding code does. Don't introduce a new error handling pattern.

## Quality Gate: Local CI

Before pushing, replicate what their CI does locally:

```bash
# Example for a TypeScript project
npm run build       # Type check / compile
npm run lint        # Linter
npm test            # Full test suite
npm run format      # Formatter check (if separate)

# Example for a Rust project
cargo check         # Type check
cargo clippy        # Linter
cargo test          # Full test suite
cargo fmt -- --check  # Formatter
```

**Rule: if it doesn't pass locally, don't push it.** CI should confirm your work, not be your first feedback loop. Failing CI wastes maintainer attention and slows down your review.

## Atomic Commits

Structure your commits logically:

```
fix(parser): add null check for empty input       # The actual fix
test(parser): add test for null input handling     # The test
```

If the repo squash-merges (most popular projects do), your individual commit structure matters less for the final history -- but it still helps reviewers understand your thought process.

## Output of This Phase

- A working implementation that passes all local quality gates
- At least one test covering the new/changed behavior
- Clean, focused commits following the repo's conventions

Proceed to [Phase 05: Submit](./05-submit.md).
