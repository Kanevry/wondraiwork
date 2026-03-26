# [uptime-kuma] #646 -- Notification templating

| Field | Value |
|-------|-------|
| Repo | louislam/uptime-kuma (85K stars) |
| Issue | [#646](https://github.com/louislam/uptime-kuma/issues/646) |
| Language | JavaScript, Vue.js |
| Labels | feature-request |
| Reactions | ~80 |
| Assigned | No |
| Competing PRs | 0 |
| Status | Open |

## Problem
Uptime Kuma notifications use a fixed message format. Users cannot customize the notification content with templates or variables. When a monitor goes down, the notification says something generic. Users want to include custom context, formatted messages, specific variable interpolation (monitor name, URL, status code, response time, downtime duration), and per-notification-channel formatting.

## Impact
Affects all Uptime Kuma users who send notifications to Slack, Discord, Telegram, email, or other channels. With 85K stars and being the most popular self-hosted monitoring tool, this would benefit a huge user base. ~80 reactions confirm strong demand.

## Repo Health
- Maintainer activity: Active. louislam is responsive, regular releases.
- PR merge speed: Moderate. Features need discussion and may take weeks to merge.
- Contributor-friendliness: Good. JavaScript/Vue.js stack is approachable, clear project structure.

## Scoring
- Impact: 8 -- 85K stars, affects core notification functionality
- Feasibility: 6 -- Requires designing a template syntax, adding a template engine, and updating the notification UI
- Visibility: 8 -- Extremely popular project, frequently requested feature
- **Total: 22/30**

## Approach
1. Design a simple template syntax using `{{variable}}` interpolation (Mustache-like)
2. Define available variables: `{{name}}`, `{{url}}`, `{{status}}`, `{{statusCode}}`, `{{responseTime}}`, `{{downDuration}}`, `{{msg}}`
3. Add a template input field to the notification settings UI (Vue.js)
4. Implement template rendering in the notification dispatch logic
5. Provide sensible defaults that match current behavior for backward compatibility

## Notes
The key design decision is the template syntax. Mustache/Handlebars-style `{{var}}` is the most intuitive for non-technical users. Avoid introducing a full template engine dependency -- simple string interpolation is sufficient. Should also consider per-notification-type templates (Slack may want different formatting than email).
