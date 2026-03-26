# [sandbox-runtime] #74 -- bwrap fails Ubuntu 24.04

| Field | Value |
|-------|-------|
| Repo | anthropics/anthropic-quickstarts (3.5K stars) |
| Issue | [#74](https://github.com/anthropics/anthropic-quickstarts/issues/74) |
| Language | Python, Shell |
| Labels | bug |
| Reactions | ~5 |
| Assigned | No |
| Competing PRs | 0 |
| Status | Open |

## Problem
The sandbox runtime (computer-use demo) uses `bubblewrap` (bwrap) for sandboxing, which fails on Ubuntu 24.04 due to changes in the kernel's unprivileged user namespace restrictions. Ubuntu 24.04 introduced AppArmor restrictions that prevent unprivileged `bwrap` from creating user namespaces, breaking the sandbox setup.

## Impact
Affects developers trying to run Anthropic's computer-use demo on Ubuntu 24.04 (the current LTS). Since 24.04 is the default for new Ubuntu installations and cloud VMs, this blocks a significant portion of potential users.

## Repo Health
- Maintainer activity: Moderate. Anthropic maintains the repo but it is more of a demo/quickstart than a core product.
- PR merge speed: Moderate. PRs are reviewed but not on a fixed schedule.
- Contributor-friendliness: Good for a demo repo. Clear structure, relatively small codebase.

## Scoring
- Impact: 6 -- Blocks usage on current Ubuntu LTS, affects demo adoption
- Feasibility: 7 -- Fix involves either adjusting AppArmor profiles, using a different sandboxing approach, or documenting the workaround
- Visibility: 7 -- Anthropic's official repo, AI/LLM space visibility
- **Total: 20/30**

## Approach
1. Reproduce on Ubuntu 24.04 to confirm the exact AppArmor restriction
2. Options: (a) Add AppArmor profile that permits bwrap namespaces, (b) use `--disable-userns` bwrap flag with alternative isolation, (c) document the `sudo sysctl kernel.apparmor_restrict_unprivileged_userns=0` workaround
3. Prefer option (a) as it maintains security while enabling functionality
4. Test the fix on both 24.04 and 22.04 to ensure backward compatibility

## Notes
Contributing to an Anthropic repo has strategic value. The fix involves Linux sandboxing knowledge. The most pragmatic approach may be a combination: a proper AppArmor profile for the ideal case, plus documentation for users who cannot modify system settings.
