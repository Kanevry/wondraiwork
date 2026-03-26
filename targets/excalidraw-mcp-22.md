# [excalidraw-mcp] #22 -- Export drops text elements

| Field | Value |
|-------|-------|
| Repo | nichochar/excalidraw-mcp (3.5K stars) |
| Issue | [#22](https://github.com/nichochar/excalidraw-mcp/issues/22) |
| Language | TypeScript |
| Labels | bug |
| Reactions | ~3 |
| Assigned | No |
| Competing PRs | 0 |
| Status | Open |

## Problem
When exporting Excalidraw diagrams through the MCP server, text elements are dropped from the output. Diagrams that contain text labels, annotations, or standalone text blocks lose that content during export, resulting in incomplete diagram representations.

## Impact
Affects users of the Excalidraw MCP integration who rely on text in their diagrams. Since the MCP server is used for AI-assisted diagramming workflows, losing text defeats much of the purpose.

## Repo Health
- Maintainer activity: Moderate. nichochar is responsive but this is a smaller project.
- PR merge speed: Fast for small fixes. Smaller project means less review queue.
- Contributor-friendliness: Good. Small codebase, easy to understand and contribute to.

## Scoring
- Impact: 5 -- Smaller user base but critical bug for those affected
- Feasibility: 8 -- Likely a straightforward fix in the export logic (missing element type handling)
- Visibility: 5 -- 3.5K stars, growing MCP ecosystem
- **Total: 18/30**

## Approach
1. Review the export function to find where element types are iterated
2. Identify why text elements are filtered out or not serialized
3. Add text element handling to the export pipeline
4. Test with diagrams containing various text configurations (labels, standalone text, multi-line)

## Notes
MCP (Model Context Protocol) servers are a growing ecosystem. Contributing to this project provides visibility in the emerging AI tooling space. The fix is likely small -- probably a missing case in a switch/if-else that handles element types during export.
