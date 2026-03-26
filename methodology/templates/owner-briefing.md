# Owner Briefing Template

> Reference template for Phase 02b. Claude uses this as a checklist when presenting the briefing in
> the Claude Code conversation. The briefing itself is delivered in German as a conversation -- this
> template is the structural guide.

## Required Sections

### 1. Was ist das Problem?

_2-3 sentences in plain language. Link to the original upstream issue._

- What is broken or missing?
- What does the issue reporter expect to happen?
- Issue URL: `https://github.com/owner/repo/issues/NNN`

### 2. Ziel-Repo auf einen Blick

| Field                   | Value                           |
| ----------------------- | ------------------------------- |
| Repo                    | owner/repo (Xk stars, Language) |
| Maintainer activity     | active / moderate / low         |
| Last merged external PR | YYYY-MM-DD                      |
| CI status               | passing / failing               |
| Contributor guidelines  | yes/no + key requirements       |

### 3. Scoring

| Criterion   | Score | Reasoning |
| ----------- | ----- | --------- |
| Impact      | X/10  | ...       |
| Feasibility | X/10  | ...       |
| Visibility  | X/10  | ...       |
| **Total**   | XX/30 |           |

### 4. Verwandte Issues

- Duplicate or similar issues: _list or "none found"_
- Competing PRs (open, draft, recently closed): _list or "none"_
- Affected codebase areas: _which files/modules are likely touched_
- Upstream/downstream dependencies: _list or "none"_

### 5. Geplanter Ansatz

1. Step 1
2. Step 2
3. Step 3
4. ...

### 6. Risiken

| Risk          | Likelihood   | Mitigation            |
| ------------- | ------------ | --------------------- |
| _description_ | low/med/high | _what we do about it_ |

### 7. Erwarteter Aufwand

| Phase         | Estimate      |
| ------------- | ------------- |
| 03 Understand | X-Y hours     |
| 04 Implement  | X-Y hours     |
| **Total**     | **X-Y hours** |

## After Presenting

- [ ] All 7 sections covered
- [ ] Original issue URL provided
- [ ] Owner questions answered
- [ ] Owner gave explicit GO / ADJUST / REJECT
- [ ] Decision logged in target file
