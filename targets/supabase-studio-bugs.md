# [supabase] Studio UI Bugs

| Field | Value |
|-------|-------|
| Repo | supabase/supabase (100K stars) |
| Issue | Various Studio UI bugs (see below) |
| Language | TypeScript, React, Next.js |
| Labels | bug, studio |
| Reactions | Varies |
| Assigned | Mixed |
| Competing PRs | Varies per issue |
| Status | Open |

## Problem
Supabase Studio (the dashboard UI) has a steady stream of UI bugs ranging from layout glitches, broken form states, incorrect error messages, and edge cases in the table editor. These are typically well-scoped React/Next.js bugs in a monorepo using Radix UI and Tailwind CSS. The Studio codebase is in `apps/studio/` within the main Supabase monorepo.

## Impact
Supabase has over 100K GitHub stars and a massive user base of developers who interact with Studio daily. UI bugs directly degrade the developer experience for database management, SQL editing, and project configuration.

## Repo Health
- Maintainer activity: Extremely active. Supabase team has dozens of engineers, multiple merges per day.
- PR merge speed: Same-day for small, well-tested fixes. Larger changes may take 2-3 days for review.
- Contributor-friendliness: Good. Has contributing guide, uses conventional commits, Studio issues are often labeled clearly.

## Scoring
- Impact: 7 -- 100K-star project, fixes improve daily workflow for many developers
- Feasibility: 8 -- React/Next.js bugs are approachable, Studio is a standard web app
- Visibility: 9 -- One of the highest-profile open source projects, contributions are highly visible
- **Total: 24/30**

## Approach
1. Filter Studio issues by `bug` label and recent activity
2. Pick issues with clear reproduction steps and no assigned contributor
3. Set up local Studio dev environment (pnpm, turbo monorepo)
4. Fix, test locally, submit PR with screenshots demonstrating the fix

## Notes
Rather than targeting a single issue, this entry tracks the opportunity of contributing Studio UI fixes to Supabase. The project's size and activity mean there is always a fresh supply of approachable bugs. The React/Next.js/Tailwind stack is a direct match. Focus on issues that have been open 1-2 weeks without a PR -- fresh enough to be relevant, old enough that the team may welcome outside help.
