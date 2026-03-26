# [biome] #5293 -- reactCompiler lint option

| Field         | Value                                                 |
| ------------- | ----------------------------------------------------- |
| Repo          | biomejs/biome (24K stars)                             |
| Issue         | [#5293](https://github.com/biomejs/biome/issues/5293) |
| Language      | Rust                                                  |
| Labels        | enhancement                                           |
| Reactions     | ~10                                                   |
| Assigned      | No                                                    |
| Competing PRs | 0                                                     |
| Status        | Open                                                  |

## Problem

Biome lacks a configuration option to enable React Compiler-specific lint rules. As React Compiler
(formerly React Forget) moves toward stable release, projects adopting it need lint rules that
enforce the constraints the compiler requires (e.g., no mutations during render, stable hook
ordering patterns beyond the basic rules-of-hooks). Biome should offer a `reactCompiler` option
similar to how ESLint has `eslint-plugin-react-compiler`.

## Impact

React Compiler adoption is accelerating. Teams switching from ESLint to Biome currently lose React
Compiler lint coverage, which is a blocker for migration. With 24K stars and positioning as the
ESLint/Prettier replacement, this is a strategic feature gap.

## Repo Health

- Maintainer activity: Very active. Core team ships releases frequently, responsive to issues.
- PR merge speed: Moderate for new features. Requires RFC-level discussion for new lint rules.
- Contributor-friendliness: Good for Rust contributors. Has contributing guide, well-structured
  crate layout, good CI.

## Scoring

- Impact: 7 -- Important for React Compiler adopters migrating to Biome
- Feasibility: 5 -- Requires Rust, understanding Biome's lint rule architecture, and React Compiler
  constraints
- Visibility: 8 -- 24K stars, React Compiler is a hot topic, would be a headline feature
- **Total: 20/30**

## Approach

1. Study Biome's lint rule architecture in `crates/biome_js_analyze/`
2. Review the React Compiler ESLint plugin for the rule set to port
3. Start with the most impactful rule (e.g., no-mutation-during-render)
4. Implement as a new rule category with a `reactCompiler` configuration toggle
5. Add comprehensive test fixtures

## Notes

This requires Rust knowledge. The Biome codebase is well-organized but the learning curve for
implementing a new lint rule category is non-trivial. Consider starting with a single rule as a
proof-of-concept PR rather than the full rule set. Engage with the maintainers on the issue first to
confirm the desired approach.
