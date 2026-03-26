# Codebase Map: [repo-name]

> Fill this out during Phase 03 (Understand) before starting implementation.

## Project Overview

| Field                   | Value        |
| ----------------------- | ------------ |
| Repo                    | `owner/repo` |
| Language(s)             |              |
| Framework(s)            |              |
| Package manager         |              |
| Build tool              |              |
| Minimum runtime version |              |

## Architecture

### High-Level Structure

```
repo-root/
  src/         -- (describe purpose)
  tests/       -- (describe purpose)
  ...          -- (add relevant top-level dirs)
```

### Key Modules (relevant to the issue)

| Module / Directory | Purpose | Key Files |
| ------------------ | ------- | --------- |
|                    |         |           |
|                    |         |           |
|                    |         |           |

### Data Flow

Describe how data flows through the relevant part of the system:

```
[trigger] --> [entry point] --> [processing] --> [output]
```

## Files to Modify

| File | Change Required | Why |
| ---- | --------------- | --- |
|      |                 |     |
|      |                 |     |
|      |                 |     |

## Execution Path (for the issue)

Trace the code path from trigger to the bug/feature:

1. `file.ts:functionA()` -- entry point when ...
2. `file.ts:functionB()` -- calls ... with ...
3. `other.ts:functionC()` -- the bug occurs here because ...

## Test Patterns

| Aspect             | Convention                                       |
| ------------------ | ------------------------------------------------ |
| Test framework     |                                                  |
| Test file location | (co-located / `__tests__/` / `tests/` / etc.)    |
| Test file naming   | (`*.test.ts` / `*_test.go` / `test_*.py` / etc.) |
| Mocking approach   | (jest.mock / testify / unittest.mock / etc.)     |
| Fixture management | (inline / files / factories / etc.)              |
| Assertion style    | (expect / assert / should / etc.)                |

### Existing Tests for Affected Code

| Test File | What It Covers | Relevant to My Change |
| --------- | -------------- | --------------------- |
|           |                |                       |
|           |                |                       |

## CI Pipeline

| Step         | Tool | Config File |
| ------------ | ---- | ----------- |
| Build        |      |             |
| Lint         |      |             |
| Format check |      |             |
| Test         |      |             |
| Type check   |      |             |
| Other        |      |             |

### How to Run Locally

```bash
# Build
___

# Lint
___

# Test (full)
___

# Test (relevant subset)
___

# Format check
___
```

## Conventions

| Aspect                 | Convention                           |
| ---------------------- | ------------------------------------ |
| Commit format          |                                      |
| Branch naming          |                                      |
| PR template            | Yes / No                             |
| Code style config      | (prettier / eslint / rustfmt / etc.) |
| Import ordering        |                                      |
| Error handling pattern |                                      |
| Logging pattern        |                                      |

## Dependencies (relevant)

| Dependency | Version | Why It Matters |
| ---------- | ------- | -------------- |
|            |         |                |
|            |         |                |

## Open Questions

Things I still need to clarify before or during implementation:

- [ ] ***
- [ ] ***

## Notes

Additional context, gotchas, or observations:
