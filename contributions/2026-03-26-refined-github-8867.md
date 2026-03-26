# refined-github #8867 — Broken Tabs (DOM Selectors)

**Target File:** targets/refined-github-8867.md **Upstream Issue:**
https://github.com/refined-github/refined-github/issues/8867 **PR:**
https://github.com/refined-github/refined-github/pull/9128 **Previous PR:**
https://github.com/refined-github/refined-github/pull/9125 (rejected) **Branch:**
`fix/8867-react-nav-selectors` **Status:** PR #9128 submitted, awaiting review

---

## Session 1: Selector Fixes

### Commit-Historie (6 Commits, 7 Dateien, 178 Insertions)

1. `1d13711` — Initiales Dual-Selector-Support (isNewRepoNav, dual selectors, get-tab-count,
   releases-tab dual markup, more-dropdown-links graceful disable)
2. `a8267b1` — href-Fallback fuer bugs-tab/clean-repo-tabs (neue Nav hat kein data-hotkey)
3. `aaee60e` — href$= statt href\*=, konditionaler li-Wrapper
4. `573d5a0` — .Counter Klasse auf releases-tab Counter, onlyShowInDropdown href$= Selektoren
5. `6067321` — Native Primer CSS-Klassen auf releases-tab kopiert, data-tab-item Fallback fuer
   Insights
6. `83deb84` — triggerRepoNavOverflow() nach Tab-Aenderungen

### Geaenderte Dateien

| Datei                                     | Was geaendert wurde                                                                                        |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `source/features/releases-tab.tsx`        | Dual-Markup (alte/neue Nav), native CSS-Klassen kopiert, .Counter auf Counter-Span, triggerRepoNavOverflow |
| `source/features/bugs-tab.tsx`            | href$= Fallback-Selektoren, isNewRepoNav Import, konditionaler li-Wrapper                                  |
| `source/features/clean-repo-tabs.tsx`     | onlyShowInDropdown mit href$= + data-tab-item, moveRareTabs aufgeraeumt, triggerRepoNavOverflow            |
| `source/features/more-dropdown-links.tsx` | Graceful disable auf neuer Nav (React managed overflow)                                                    |
| `source/github-helpers/index.ts`          | isNewRepoNav() Helper hinzugefuegt                                                                         |
| `source/github-helpers/selectors.ts`      | Dual-Selektoren fuer alte/neue Nav                                                                         |
| `source/github-helpers/get-tab-count.ts`  | [data-component="counter"] Selektor fuer neue Nav                                                          |

### Quality Gates

- Build: OK
- TSC: 0 Errors
- Lint: 0 Errors (74 pre-existing Warnings)
- Tests: 8 pre-existing Failures, 0 neue

### Problem identifiziert: React Re-Render ueberschreibt DOM-Aenderungen

**Symptom:** Nach Page-Load erscheinen alle Features korrekt (Bugs-Tab, versteckte Tabs), dann
re-rendert React die gesamte Nav und ueberschreibt alles. Ergebnis: Flackern zwischen "korrekt" und
"kaputt".

**Root Cause:** `bugs-tab` und `clean-repo-tabs` nutzen einmalige DOM-Manipulation
(`elementReady()` + direktes Einfuegen/Verstecken). React baut die Nav aus seinem internen State neu
auf und weiss nichts von unseren Aenderungen.

**Beweis:** `releases-tab` nutzt `observe()` und funktioniert stabil — gleiche Nav, gleiche
React-Renders, aber keine Flicker weil `observe()` nach jedem Re-Render erneut feuert.

**Das korrekte Pattern (aus der Codebase, 126/194 Features nutzen es):**

```tsx
// selector-observer.tsx nutzt CSS-Animations um neue DOM-Elemente zu detektieren
// 1. Injiziert <style> mit @keyframes in <head> (ueberlebt Re-Renders)
// 2. CSS-Regel triggert Animation auf neue Elemente
// 3. Globaler animationstart Listener feuert Callback
// 4. React re-rendert → neue Elemente → Animation triggert erneut → Callback laeuft
```

---

## Session 2: observe() Refactoring

### Kern-Refactoring

1. **bugs-tab.tsx** — observe() statt elementReady()
   - `init()` akzeptiert jetzt `AbortSignal`
   - `addBugsTab()` bekommt `repoNavigationBar` als Parameter
   - `$optional(['a[data-hotkey="g i"]', 'a[data-tab-item="issues"]'], ...)` statt `elementReady()`
   - `data-tab-item="issues"` statt `href$="/issues"` (andere Features modifizieren die href)

2. **clean-repo-tabs.tsx** — observe() fuer neuen React-Nav
   - Neue `handleNewNavTabs()` Funktion: alle Tab-Operationen in einem observe-Callback
   - Neue `initNewNav()` mit `observe(repoUnderlineNavUl, ...)`
   - Bestehende update-Funktionen mit `isNewRepoNav()` Early-Return gegated
   - `deduplicate: 'has-rgh'` entfernt (observe handled Deduplication via seenMark)

### Browser E2E Tests (via Claude in Chrome)

| Repo                          | Bugs             | Releases | Security      | Insights | Wiki |
| ----------------------------- | ---------------- | -------- | ------------- | -------- | ---- |
| refined-github/refined-github | 42               | 188      | hidden (0)    | hidden   | 9    |
| vercel/next.js                | 1k               | 1k       | 36 (sichtbar) | hidden   | --   |
| refined-github/yolo           | -- (kein Issues) | --       | --            | --       | --   |
| 5x Reload Stability           | 100%             | 100%     | 100%          | 100%     | 100% |

### Build Verification

- TypeScript: 0 Errors
- Lint: 0 neue Errors (pre-existing only)
- Tests: features.test.ts 294/294 passed

---

## Key Learnings

### Technical

1. **observe() Pattern ist der Goldstandard** — CSS @keyframes Animation + globaler animationstart
   Listener. Ueberlebt React Re-Renders. 126/194 Features nutzen es. Referenz:
   `source/helpers/selector-observer.tsx`.

2. **`href$="/issues"` ist instabil** — Andere refined-github Features (sort-conversations) haengen
   Query-Parameter an die Issues-Tab href. `data-tab-item="issues"` ist stabil.

3. **`no-restricted-syntax` Lint-Regel** — Comma-separierte CSS-Selektoren muessen als Array mit
   Kommentaren uebergeben werden, nicht als einzelner String. CI faengt das, lokales xo auch.

4. **`deduplicate` + `observe()` sind inkompatibel** — features.test.ts prueft: wenn eine Datei
   `observe()` nutzt, darf sie kein `deduplicate:` haben. observe() handled Deduplication via
   seenMark CSS-Klasse.

5. **observe() Pattern funktioniert ohne React-Props-Zugriff** — Maintainer fregante dachte, #8793
   (getReactProps) waere noetig. Der existierende observe()-Pattern (CSS @keyframes Animations)
   reicht aus.

### Process

6. **Nie force-push auf PR-Branches** — refined-github (und die meisten OSS-Repos) squashen beim
   Merge automatisch. Force-Push zerstoert den Review-Diff. Bot flaggt das automatisch.

7. **Immer neue Commits oben drauf** — Statt squash + force-push einfach neue Commits pushen. Auch
   Lint-Fixes als separater Commit.

8. **CI lokal vollstaendig simulieren ist schwierig** — `no-restricted-syntax` wurde lokal von xo
   nicht als Error gemeldet (nur in CI mit `npm run lint`). Lesson: vor dem Push `npm run lint`
   (nicht `npx xo`) ausfuehren.

9. **Phase 04b haette den force-push verhindert** — "Honest Assessment" Check 5 fragt: "Am I
   submitting because it is ready?" — Ein Check haette den Squash-Impuls hinterfragt.

### Relevante Selektoren

```
Neue Nav Container: nav[aria-label="Repository"] ul[role="list"]
Alte Nav Container: .js-responsive-underlinenav ul.UnderlineNav-body
Issues-Tab (neu): a[data-tab-item="issues"] (nicht href$="/issues"!)
Insights-Tab (neu): a[data-tab-item="insights"] (href ist /pulse, nicht /insights!)
Counter (neu): [data-component="counter"] span[aria-hidden]
Counter (alt): .Counter
```

### Key Files

```
source/features/releases-tab.tsx    — REFERENZ: korrekte observe() Nutzung
source/features/bugs-tab.tsx        — Refactored auf observe() in Session 2
source/features/clean-repo-tabs.tsx — Refactored auf observe() in Session 2
source/helpers/selector-observer.tsx — observe() Implementation
source/feature-manager.tsx          — Feature Lifecycle
source/github-helpers/selectors.ts  — Shared Nav Selektoren
```

---

## Next Steps

- [ ] Warten auf Maintainer-Review
- [ ] Requested Changes als neue Commits pushen (nie force-push!)
- [ ] Bei Merge: Target-Status auf "Merged" setzen, Journal finalisieren
- [ ] Bei Ablehnung: Gruende analysieren, ggf. Ansatz ueberdenken
