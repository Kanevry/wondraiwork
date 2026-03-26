# [gitui] #495 -- Bad credentials on Windows

| Field | Value |
|-------|-------|
| Repo | extrawurst/gitui (22K stars) |
| Issue | [#495](https://github.com/extrawurst/gitui/issues/495) |
| Language | Rust |
| Labels | bug |
| Reactions | ~30 |
| Assigned | No |
| Competing PRs | 0 |
| Status | Open |

## Problem
GitUI fails to authenticate with remote repositories on Windows, showing "bad credentials" errors when pushing, pulling, or fetching. The issue is related to how GitUI handles credential helpers on Windows. While `git` CLI works fine (using Windows Credential Manager), GitUI's libgit2-based authentication does not correctly interact with the Windows credential store.

## Impact
Affects all GitUI users on Windows who use HTTPS remotes with credential helpers. Since Windows is a major platform for GitUI's target audience (terminal-savvy developers who prefer TUI over GUI), this blocks a core workflow.

## Repo Health
- Maintainer activity: Active. extrawurst maintains the project regularly.
- PR merge speed: Good for bug fixes, especially platform-specific ones.
- Contributor-friendliness: Good. Rust codebase is well-structured, helpful maintainer.

## Scoring
- Impact: 6 -- Blocks remote operations for Windows users
- Feasibility: 5 -- Requires understanding libgit2's credential callback system and Windows Credential Manager integration
- Visibility: 7 -- 22K stars, fixes a platform-blocking bug
- **Total: 18/30**

## Approach
1. Study GitUI's credential handling in the push/pull/fetch code paths
2. Investigate how libgit2's credential callbacks interact with Windows Credential Manager
3. Possible fixes: (a) shell out to `git credential fill` as a fallback, (b) use the `wincred` credential helper directly, (c) fix the libgit2 credential callback chain
4. Test on Windows with HTTPS remotes using various credential configurations

## Notes
Requires Rust knowledge and ideally a Windows development environment for testing. The libgit2 credential system is complex -- the fix likely involves correctly implementing the credential callback to try multiple methods (credential helper, SSH agent, interactive prompt) in the right order on Windows.
