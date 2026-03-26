# Issue Evaluation

> Fill this out for each candidate issue before committing to implementation.

## Issue Details

| Field                   | Value        |
| ----------------------- | ------------ |
| Repo                    | `owner/repo` |
| Issue                   | #\_\_\_      |
| Title                   |              |
| URL                     |              |
| Labels                  |              |
| Created                 | YYYY-MM-DD   |
| Maintainer acknowledged | Yes / No     |

## Scoring

### Impact (weight: 40%)

| Metric                  | Value                |
| ----------------------- | -------------------- |
| Reactions               |                      |
| Comments                |                      |
| Linked/duplicate issues |                      |
| Affected functionality  | Core / Common / Edge |
| **Impact Score (1-5)**  |                      |

### Feasibility (weight: 35%)

| Metric                      | Value                  |
| --------------------------- | ---------------------- |
| Estimated scope             | Small / Medium / Large |
| Files to modify (estimate)  |                        |
| Language familiarity        | High / Medium / Low    |
| Clear fix path              | Yes / Partial / No     |
| Similar work done before    | Yes / No               |
| **Feasibility Score (1-5)** |                        |

### Visibility (weight: 25%)

| Metric                     | Value |
| -------------------------- | ----- |
| Repo stars                 |       |
| Org/maintainer reputation  |       |
| Technology relevance       |       |
| **Visibility Score (1-5)** |       |

### Total Score

```
(Impact x 0.40) + (Feasibility x 0.35) + (Visibility x 0.25) = ___
```

| Range   | Verdict             |
| ------- | ------------------- |
| 4.0+    | Strong target       |
| 3.0-3.9 | Worth investigating |
| 2.0-2.9 | Marginal            |
| <2.0    | Skip                |

## Repo Health

| Check                                   | Status              | Notes |
| --------------------------------------- | ------------------- | ----- |
| External PRs merged recently (3 months) | [ ] Pass / [ ] Fail |       |
| Median PR merge time                    | \_\_\_ days         |       |
| CI green on default branch              | [ ] Pass / [ ] Fail |       |
| CONTRIBUTING.md exists                  | [ ] Yes / [ ] No    |       |
| Active maintainer responses             | [ ] Pass / [ ] Fail |       |

## Issue Quality

| Check                                 | Status           | Notes |
| ------------------------------------- | ---------------- | ----- |
| Reproduction steps provided           | [ ] Yes / [ ] No |       |
| Expected vs actual behavior clear     | [ ] Yes / [ ] No |       |
| Maintainer confirmed/triaged          | [ ] Yes / [ ] No |       |
| Acceptance criteria stated or implied | [ ] Yes / [ ] No |       |

## Competition

| Check                        | Status                                         | Notes |
| ---------------------------- | ---------------------------------------------- | ----- |
| Existing PRs for this issue  | [ ] None / [ ] Stale / [ ] Active              |       |
| Issue assigned to someone    | [ ] No / [ ] Yes (inactive) / [ ] Yes (active) |       |
| "I'll work on this" comments | [ ] None / [ ] Stale / [ ] Recent              |       |

## Go / No-Go

| #   | Criterion                        | Pass |
| --- | -------------------------------- | ---- |
| 1   | Repo merges external PRs         | [ ]  |
| 2   | Issue acknowledged by maintainer | [ ]  |
| 3   | No competing active PR           | [ ]  |
| 4   | CI is green on default branch    | [ ]  |
| 5   | Can build the project locally    | [ ]  |
| 6   | Scope is estimable in hours      | [ ]  |
| 7   | Domain knowledge sufficient      | [ ]  |

**Decision:** [ ] GO / [ ] NO-GO

**Reasoning:**

---

**Notes / Concerns:**
