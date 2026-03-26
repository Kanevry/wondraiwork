# [refined-github] #8867 -- Broken tabs (DOM selectors)

| Field         | Value                                                                        |
| ------------- | ---------------------------------------------------------------------------- |
| Repo          | refined-github/refined-github (31K stars)                                    |
| Issue         | [#8867](https://github.com/refined-github/refined-github/issues/8867)        |
| Language      | TypeScript                                                                   |
| Labels        | bug                                                                          |
| Reactions     | ~5                                                                           |
| Assigned      | No                                                                           |
| Competing PRs | 0                                                                            |
| Status        | Submitted                                                                    |
| PR            | [#9128](https://github.com/refined-github/refined-github/pull/9128) (draft)  |
| Previous PR   | [#9125](https://github.com/refined-github/refined-github/pull/9125) (closed) |

## Problem

GitHub changed their DOM structure, breaking several refined-github features that rely on CSS
selectors to find and modify tab elements. The extension's tab-related features (like hiding certain
tabs or adding counters) stopped working because the selectors no longer match the updated GitHub
markup.

## Impact

Affects all refined-github users who rely on tab-related features. With 31K stars and high daily
active usage as a browser extension, this is a visible regression for a large user base.

## Repo Health

- Maintainer activity: Very active. fregante (sole maintainer) responds within hours and merges
  quickly.
- PR merge speed: Same-day to next-day for clean PRs. Often merged within hours.
- Contributor-friendliness: Excellent. Clear contributing guide, well-structured codebase,
  TypeScript throughout.

## Scoring

- Impact: 6 -- Affects a popular extension but is limited to specific tab features
- Feasibility: 9 -- Straightforward selector updates, small scope
- Visibility: 7 -- Active repo with fast merge cycle, contribution shows up quickly
- **Total: 22/30**

## Approach

1. Inspect current GitHub DOM to identify the new selector paths for tab elements
2. Update the CSS selectors in the affected feature files
3. Test against live GitHub pages to verify tabs work correctly
4. Submit PR with before/after screenshots

## Notes

~~This is a classic quick-win: the fix is mechanical (update selectors to match new DOM).~~

**2026-03-26 Update:** Significantly more complex than initially scored. GitHub's new React
`UnderlineNav` manages overflow via internal state (ResizeObserver + React reconciliation). Simple
selector updates are insufficient for features that manipulate the overflow dropdown
(`clean-repo-tabs`, `more-dropdown-links`). PR #9024 was rejected as "AI spam" — quality bar is very
high.

**Revised Feasibility:** 5/10 (was 9/10). Partial fix implemented: dual selectors, crash fix,
graceful degradation. Full fix requires component takeover or React state access.

**Branch:** `Kanevry/refined-github` `fix/8867-react-nav-selectors` **Tracking:** GitHub #24, GitLab
#2 **PR:** https://github.com/refined-github/refined-github/pull/9125 (Draft)

**2026-03-26 Browser Testing:** Confirmed working on refined-github/refined-github (Bugs 42,
Releases188) and vercel/next.js (Bugs 1k, Releases1k). Key bug found during testing: new React nav
has NO `data-hotkey` attributes on any tabs. Fixed with `href$="/..."` fallback selectors. Also
fixed: `href*=` (contains) changed to `href$=` (ends-with) to prevent false matches on repos named
after tab paths. Li wrapper made conditional per nav type.

**2026-03-26 PR #9125 Rejected:** fregante closed immediately: "screenshot shows features clearly
not working and one of them with the wrong style. Untested AI PRs are not welcome." Issues found:

1. releases-tab Counter hatte kein .Counter CSS-Klasse (klebte am Text)
2. releases-tab `<a>` hatte keine Primer CSS-Klassen (blaue statt weisse Textfarbe)
3. clean-repo-tabs versteckte Insights nicht (href ist /pulse, nicht /insights)
4. React Re-Renders ueberschreiben DOM-Aenderungen (bugs-tab/clean-repo-tabs nutzen nicht observe())

**2026-03-26 Fixes nach Ablehnung:**

- .Counter Klasse hinzugefuegt → Counter als Badge
- Native Primer CSS-Klassen von existierendem Tab kopiert → korrekte Textfarbe/Spacing
- data-tab-item Fallback fuer Insights (href=/pulse)
- triggerRepoNavOverflow() nach Tab-Aenderungen
- OFFEN: observe()-Refactor fuer bugs-tab und clean-repo-tabs (React Re-Render Problem)

**Revised Feasibility:** 3/10 (was 5/10). Selector-Fixes sind erledigt, aber observe()-Refactor ist
noetig fuer stabile Funktion. Siehe contributions/2026-03-26-refined-github-8867-session-handoff.md

## Decision Log

| Datum            | Entscheidung                              | Begruendung                                                                   |
| ---------------- | ----------------------------------------- | ----------------------------------------------------------------------------- |
| 2026-03-26 09:00 | Target gewaehlt (Score 22/30)             | High visibility, help-wanted label, no competing PRs                          |
| 2026-03-26 12:00 | Feasibility downgrade 9→5                 | React UnderlineNav Overflow kann nicht von Content Script kontrolliert werden |
| 2026-03-26 17:13 | Erster Commit gepusht                     | Dual-Selektoren, isNewRepoNav(), graceful degradation                         |
| 2026-03-26 18:10 | Browser-Testing Bug gefunden              | Neue Nav hat kein data-hotkey — href$= Fallback noetig                        |
| 2026-03-26 18:19 | PR #9125 erstellt (Draft)                 | Zu frueh — Screenshots zeigten Bugs statt Erfolg                              |
| 2026-03-26 18:25 | PR #9125 abgelehnt                        | Maintainer sah falsche Styling + nicht funktionierende Features               |
| 2026-03-26 19:00 | Counter + Styling fixes                   | .Counter, native CSS-Klassen, data-tab-item Fallback                          |
| 2026-03-26 19:50 | React Re-Render Problem entdeckt          | DOM-Aenderungen werden von React ueberschrieben                               |
| 2026-03-26 20:00 | Entscheidung: observe()-Refactor noetig   | Pre-existing Problem, aber PR ist unvollstaendig ohne Fix                     |
| 2026-03-26 20:15 | Session-Handoff                           | observe()-Refactor als Folgesession geplant                                   |
| 2026-03-26 20:30 | Session 2: observe()-Refactor gestartet   | bugs-tab + clean-repo-tabs auf observe() umgestellt                           |
| 2026-03-26 20:45 | Browser-Bug: href$="/issues" matcht nicht | Andere Features aendern Issues-href → data-tab-item="issues" stattdessen      |
| 2026-03-26 20:50 | Browser E2E Tests bestanden               | 3 Repos, 5x Reload, Navigation-Stability — alles stabil                       |
| 2026-03-26 21:02 | PR #9128 erstellt (Draft)                 | Sauberer PR mit observe()-Fix, Screenshots in Light Theme                     |
| 2026-03-26 21:10 | CI Lint-Fehler: no-restricted-syntax      | Comma-Selektoren muessen als Array, nicht String uebergeben werden            |
| 2026-03-26 21:12 | Force-Push Fehler                         | Bot flagged: nie force-push auf PRs, repos squashen beim Merge automatisch    |
| 2026-03-26 21:15 | PR eingereicht, warten auf Review         | Screenshots eingefuegt, Draft → Ready for Review                              |
