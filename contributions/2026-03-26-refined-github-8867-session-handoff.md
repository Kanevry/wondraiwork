# Session Handoff: refined-github #8867 — React Nav Selectors

## Status: Code-Fixes erledigt, observe()-Refactor ausstehend

**Branch:** `fix/8867-react-nav-selectors` in `repos/refined-github` **Upstream Issue:**
https://github.com/refined-github/refined-github/issues/8867 **Geschlossener PR:**
https://github.com/refined-github/refined-github/pull/9125 (von fregante abgelehnt) **WondrAIWork
Tracking:** https://github.com/Kanevry/wondraiwork/issues/24

---

## Was in dieser Session erledigt wurde

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

### Quality Gates bestanden

- Build: OK
- TSC: 0 Errors
- Lint: 0 Errors (74 pre-existing Warnings)
- Tests: 8 pre-existing Failures, 0 neue

---

## Was noch fehlt (Folgesession)

### Problem: React Re-Render ueberschreibt DOM-Aenderungen

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

## Arbeitspakete fuer Folgesession

### AP-1: clean-repo-tabs auf observe() umstellen

**Aufwand:** Mittel **Dateien:** `source/features/clean-repo-tabs.tsx` **Begruendung:**
`moveRareTabs()` und die `update*Tab()` Funktionen nutzen `elementReady()` und direkte
DOM-Manipulation. React ueberschreibt hidden-Attribute nach Re-Render. CSS-Injection oder observe()
sind noetig.

**Konkrete Aenderungen:**

1. **`features.add()` Registrierung aendern** (Zeile 182-203):
   - AKTUELL: `init: [updateActionsTab, updateWikiTab, updateProjectsTab]` und `init: moveRareTabs`
   - NEU: Eine `init(signal)` Funktion die `observe(repoUnderlineNavUl, ...)` nutzt
   - Referenz-Implementation: `releases-tab.tsx:137-146`

2. **Wrapper-Funktion erstellen:**

   ```tsx
   async function init(signal: AbortSignal): Promise<void> {
     observe(
       repoUnderlineNavUl,
       async (navBar) => {
         // Re-apply hiding on every nav re-render
         await updateActionsTab();
         await updateWikiTab();
         await updateProjectsTab();
         await moveRareTabs();
       },
       { signal },
     );
   }
   ```

3. **onlyShowInDropdown() fuer neue Nav:**
   - AKTUELL: Setzt `hidden=""` Attribut auf `<li>` → wird von React ueberschrieben
   - ALTERNATIVE A: CSS-Injection in `<head>` mit `:has()` Selektor (persistent)
   - ALTERNATIVE B: observe()-Callback setzt hidden nach jedem Re-Render neu
   - EMPFEHLUNG: Alternative B (konsistent mit Codebase-Pattern)

4. **Deduplication pruefen:**
   - AKTUELL: `deduplicate: 'has-rgh'` — muss auf Kompatibilitaet mit observe() geprueft werden
   - observe() markiert Elemente mit einer CSS-Klasse (`seenMark`) — das ist die eingebaute
     Deduplizierung

**Risiken:**

- `updateActionsTab()`, `updateWikiTab()`, `updateProjectsTab()` nutzen `elementReady()` intern →
  muessen evtl. auf `$optional()` umgestellt werden (da Element beim observe()-Callback schon da
  ist)
- `getTabCount()` macht async API-Calls → muss im observe()-Callback korrekt gehandhabt werden
- Die alte Nav darf nicht brechen (Regression)

### AP-2: bugs-tab auf observe() umstellen

**Aufwand:** Hoch **Dateien:** `source/features/bugs-tab.tsx` **Begruendung:** bugs-tab injiziert
ein neues DOM-Element (geklont vom Issues-Tab). React entfernt es beim Re-Render. Nur observe() kann
das zuverlaessig wiederherstellen.

**Konkrete Aenderungen:**

1. **`init()` Signatur aendern** (Zeile 197):
   - AKTUELL: `async function init(): Promise<void | false>`
   - NEU: `async function init(signal: AbortSignal): Promise<void>`

2. **observe() fuer Issues-Tab nutzen:**

   ```tsx
   async function init(signal: AbortSignal): Promise<void> {
     await expectToken();
     observe(
       // Beobachte den Issues-Tab (alten oder neuen Selektor)
       ['a[data-hotkey="g i"]', 'nav[aria-label="Repository"] ul[role="list"] a[href$="/issues"]'],
       async (issuesTab) => {
         await addBugsTab(); // Wird nach jedem Re-Render erneut aufgerufen
         await updateBugsTagHighlighting();
       },
       { signal },
     );
   }
   ```

3. **addBugsTab() anpassen:**
   - Die Funktion muss idempotent sein: pruefen ob `.rgh-bugs-tab` schon existiert
   - AKTUELL: Hat bereits `if (!elementExists('.rgh-bugs-tab'))` Check in init — muss in
     addBugsTab() verschoben werden
   - `elementReady()` Aufrufe in addBugsTab() durch `$optional()` ersetzen (Element ist schon da
     wenn observe() feuert)

4. **highlightBugsTab() mit observe() absichern:**
   - Wird aufgerufen bei URL-Aenderungen (Zeile 169-193)
   - Muss die gleiche Dual-Selektor-Logik nutzen

**Risiken:**

- `addBugsTab()` ist komplex (~80 Zeilen) mit GraphQL-Call, Counter-Update, Icon-Tausch
- Die GraphQL-Query (CountBugs.gql) wird bei jedem Re-Render erneut gefeuert → Caching pruefen
- `cacheByRepo` existiert bereits fuer den Bug-Count — sollte Re-Fetch verhindern
- Alte Nav darf nicht brechen

### AP-3: Browser-Testing Checkliste komplett durchgehen

**Aufwand:** Klein **Begruendung:** Nach AP-1 und AP-2 muss die gesamte Checkliste nochmal
durchlaufen werden.

**Checkliste:**

Fuer jedes der 3 Test-Repos (refined-github/refined-github, vercel/next.js, ein Repo mit alter Nav):

releases-tab:

- [ ] Counter als Badge (nicht am Text klebend)
- [ ] Text weiss (nicht blau), korrektes Spacing
- [ ] Tab klickbar, fuehrt zu Releases
- [ ] Stabil nach 5x Reload (kein Flackern)

bugs-tab:

- [ ] Tab erscheint nach Issues mit Counter
- [ ] Bug-Icon, nicht Issues-Icon
- [ ] Stabil nach 5x Reload (kein Flackern)
- [ ] Highlighting korrekt (Bugs-Tab highlighted auf Bug-Seite)

clean-repo-tabs:

- [ ] Insights VERSTECKT (stabil nach Reload)
- [ ] Security VERSTECKT wenn 0 Advisories (stabil nach Reload)
- [ ] Wiki/Actions bleiben wenn Inhalte vorhanden
- [ ] Stabil nach 5x Reload (kein Flackern)

Global:

- [ ] Keine Console-Errors
- [ ] Keine Tab-Duplikate
- [ ] Alte Nav: Regression-Check

**Screenshot-Anforderungen (aus Contributing Wiki):**

- GitHub LIGHT Theme (nicht Dark!)
- Zoom 200% oder Retina 100%
- Fokussiert auf die Aenderung mit genug Kontext
- Before/After Vergleich wenn moeglich

### AP-4: PR erstellen oder reopenen

**Aufwand:** Klein **Begruendung:** Nach erfolgreichem Testing muss ein neuer PR erstellt werden
(oder der alte reopened).

**Entscheidung:** Neuer PR empfohlen (sauberer Start nach Ablehnung).

**PR-Anforderungen (aus refined-github Wiki + Template):**

- `Closes #8867`
- Test URLs mit echten Repos
- Screenshots in LIGHT Theme, 200% Zoom
- Before/After Vergleich
- Draft oeffnen, selbst reviewen, dann Ready
- Squash on Merge ist enabled — Commit-Historie muss nicht sauber sein
- AI-Attribution: `Assisted-By: Claude Code`
- KEIN "Ready for Review" bis die komplette Checkliste (AP-3) abgehakt ist

---

## Technische Referenzen

### observe() Pattern (Goldstandard)

```
Datei: source/helpers/selector-observer.tsx
Mechanismus: CSS @keyframes Animation + globaler animationstart Listener
Beispiel: source/features/releases-tab.tsx:137-146
```

### Feature-Manager Lifecycle

```
Datei: source/feature-manager.tsx:188-219
Loop: do { init(signal) } while (await oneEvent('turbo:render'))
Signal: AbortController pro Feature-Iteration
```

### Relevante Selektoren

```
Neue Nav Container: nav[aria-label="Repository"] ul[role="list"]
Alte Nav Container: .js-responsive-underlinenav ul.UnderlineNav-body
Issues-Tab (neu): a[href$="/issues"] (kein data-hotkey!)
Insights-Tab (neu): a[data-tab-item="insights"] (href ist /pulse, nicht /insights!)
Counter (neu): [data-component="counter"] span[aria-hidden]
Counter (alt): .Counter
```

### Key Files

```
source/features/releases-tab.tsx    — REFERENZ: korrekte observe() Nutzung
source/features/bugs-tab.tsx        — TODO: auf observe() umstellen (AP-2)
source/features/clean-repo-tabs.tsx — TODO: auf observe() umstellen (AP-1)
source/helpers/selector-observer.tsx — observe() Implementation
source/feature-manager.tsx          — Feature Lifecycle
source/github-helpers/selectors.ts  — Shared Nav Selektoren
```

---

## Offene Fragen fuer Folgesession

1. **Neuer PR oder Reopen?** — Empfehlung: Neuer PR nach vollstaendigem Fix
2. **Soll der observe()-Refactor im gleichen PR sein?** — Ja, sonst ist der PR unvollstaendig
   (Flackern sichtbar fuer Maintainer)
3. **Kommentar auf Issue #8867?** — Ja, nach erfolgreichem Testing mit dem Hinweis dass ein
   vollstaendiger Fix kommt
