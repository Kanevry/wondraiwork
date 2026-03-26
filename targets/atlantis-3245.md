# [atlantis] #3245 -- Drift detection

| Field         | Value                                                        |
| ------------- | ------------------------------------------------------------ |
| Repo          | runatlantis/atlantis (9K stars)                              |
| Issue         | [#3245](https://github.com/runatlantis/atlantis/issues/3245) |
| Language      | Go                                                           |
| Labels        | enhancement                                                  |
| Reactions     | 230                                                          |
| Assigned      | No                                                           |
| Competing PRs | 0                                                            |
| Status        | Open                                                         |

## Problem

Atlantis (Terraform Pull Request Automation) lacks built-in drift detection. When infrastructure
state drifts from the Terraform configuration (e.g., someone makes a manual change in the cloud
console), Atlantis has no way to detect or report this. Teams discover drift only when they run
`terraform plan` for an unrelated change, often leading to unexpected plan output and confusion.

## Impact

Affects all Atlantis users managing infrastructure with Terraform. Drift detection is a critical
operational concern -- undetected drift can cause outages when Terraform attempts to reconcile
state. With 230 reactions and 9K stars, this is one of the most requested Atlantis features.

## Repo Health

- Maintainer activity: Active. Community-maintained with regular releases.
- PR merge speed: Moderate for features. Requires design discussion.
- Contributor-friendliness: Good for Go developers. Clear codebase, good test coverage.

## Scoring

- Impact: 8 -- 230 reactions, addresses a critical operational gap
- Feasibility: 5 -- Requires scheduled plan runs, state comparison logic, and a
  notification/reporting system. Non-trivial Go work.
- Visibility: 7 -- 9K stars, DevOps/IaC space, highly requested
- **Total: 20/30**

## Approach

1. Add a scheduled drift detection mode that runs `terraform plan` periodically on configured
   projects
2. Parse plan output to detect changes (drift = non-empty plan when no PR is open)
3. Report drift via configurable channels (GitHub/GitLab comments, webhooks, Slack)
4. Add configuration options: schedule interval, projects to monitor, notification targets
5. Handle state locking conflicts with concurrent plan/apply operations

## Notes

This is a substantial feature. The 230 reactions make it compelling, but the implementation is
non-trivial. Requires Go knowledge and understanding of Terraform's plan/state model. Consider
starting with an RFC or design doc PR to get maintainer buy-in before implementing. A minimal first
version (periodic plan + webhook notification) would be a good starting point.
