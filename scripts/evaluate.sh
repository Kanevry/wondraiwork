#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────────────
# evaluate.sh — Evaluate a repo + issue for contribution viability
#
# Fetches repo health metrics, community PR merge patterns, and issue
# competition to produce a structured evaluation report.
#
# Usage:
#   bash scripts/evaluate.sh <owner/repo> <issue-number>
#
# Examples:
#   bash scripts/evaluate.sh vercel/next.js 12345
#   bash scripts/evaluate.sh facebook/react 28901
# ──────────────────────────────────────────────────────────────────────

usage() {
  echo "Usage: bash scripts/evaluate.sh <owner/repo> <issue-number>"
  echo ""
  echo "Arguments:"
  echo "  owner/repo     GitHub repository (e.g., vercel/next.js)"
  echo "  issue-number   Issue number to evaluate"
  exit 1
}

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "[info] $1"; }
warn() { echo "[warn] $1"; }

# ── Validate ─────────────────────────────────────────────────────────
[[ $# -lt 2 ]] && usage

REPO="$1"
ISSUE_NUM="$2"

[[ "$REPO" == *"/"* ]] || die "Repository must be in owner/repo format (got: $REPO)"
[[ "$ISSUE_NUM" =~ ^[0-9]+$ ]] || die "Issue number must be numeric (got: $ISSUE_NUM)"

command -v gh >/dev/null 2>&1 || die "gh CLI is required but not found"
gh auth status >/dev/null 2>&1 || die "gh CLI is not authenticated"
command -v jq >/dev/null 2>&1 || die "jq is required but not found"

OWNER="${REPO%%/*}"
REPO_NAME="${REPO##*/}"

# ── Fetch repo data ─────────────────────────────────────────────────
info "Fetching repository data for ${REPO}..."

REPO_DATA=$(gh api "repos/${REPO}" 2>/dev/null) || die "Failed to fetch repo: ${REPO}"

STARS=$(echo "$REPO_DATA" | jq -r '.stargazers_count // 0')
FORKS=$(echo "$REPO_DATA" | jq -r '.forks_count // 0')
OPEN_ISSUES=$(echo "$REPO_DATA" | jq -r '.open_issues_count // 0')
LANGUAGE=$(echo "$REPO_DATA" | jq -r '.language // "unknown"')
LICENSE=$(echo "$REPO_DATA" | jq -r '.license.spdx_id // "none"')
ARCHIVED=$(echo "$REPO_DATA" | jq -r '.archived')
PUSHED_AT=$(echo "$REPO_DATA" | jq -r '.pushed_at // "unknown"')
DESCRIPTION=$(echo "$REPO_DATA" | jq -r '.description // "(no description)"')
HAS_WIKI=$(echo "$REPO_DATA" | jq -r '.has_wiki')
DEFAULT_BRANCH=$(echo "$REPO_DATA" | jq -r '.default_branch // "main"')

# ── Recent commit activity ──────────────────────────────────────────
info "Checking recent commit activity..."

if [[ "$(uname)" == "Darwin" ]]; then
  FOUR_WEEKS_AGO=$(date -v-28d +%Y-%m-%dT%H:%M:%SZ)
else
  FOUR_WEEKS_AGO=$(date -d "-28 days" +%Y-%m-%dT%H:%M:%SZ)
fi

COMMIT_ACTIVITY=$(gh api "repos/${REPO}/commits?since=${FOUR_WEEKS_AGO}&per_page=1" \
  --jq 'length' 2>/dev/null || echo "0")
RECENT_COMMITS_LABEL="active"
if [[ "$COMMIT_ACTIVITY" == "0" ]]; then
  RECENT_COMMITS_LABEL="inactive (0 commits in 4 weeks)"
fi

# ── Fetch issue data ────────────────────────────────────────────────
info "Fetching issue #${ISSUE_NUM}..."

ISSUE_DATA=$(gh api "repos/${REPO}/issues/${ISSUE_NUM}" 2>/dev/null) || die "Failed to fetch issue #${ISSUE_NUM}"

ISSUE_TITLE=$(echo "$ISSUE_DATA" | jq -r '.title // "(no title)"')
ISSUE_STATE=$(echo "$ISSUE_DATA" | jq -r '.state')
ISSUE_LABELS=$(echo "$ISSUE_DATA" | jq -r '[.labels[].name] | join(", ") // "none"')
ISSUE_ASSIGNEE=$(echo "$ISSUE_DATA" | jq -r '.assignee.login // "none"')
ISSUE_COMMENTS=$(echo "$ISSUE_DATA" | jq -r '.comments // 0')
ISSUE_REACTIONS=$(echo "$ISSUE_DATA" | jq -r '.reactions.total_count // 0')
ISSUE_CREATED=$(echo "$ISSUE_DATA" | jq -r '.created_at[:10]')
ISSUE_UPDATED=$(echo "$ISSUE_DATA" | jq -r '.updated_at[:10]')
ISSUE_AUTHOR=$(echo "$ISSUE_DATA" | jq -r '.user.login // "unknown"')
ISSUE_BODY_LEN=$(echo "$ISSUE_DATA" | jq -r '.body | length // 0')
IS_PR=$(echo "$ISSUE_DATA" | jq -r 'has("pull_request")')

if [[ "$IS_PR" == "true" ]]; then
  warn "Issue #${ISSUE_NUM} is a pull request, not an issue."
fi

# ── Check for competing PRs ─────────────────────────────────────────
info "Checking for competing pull requests..."

# Search for PRs that reference this issue
LINKED_PRS=$(gh api "repos/${REPO}/pulls?state=open&per_page=100" \
  --jq "[.[] | select(.body != null) | select(.body | test(\"#${ISSUE_NUM}[^0-9]\") or test(\"#${ISSUE_NUM}$\") or test(\"${REPO}/issues/${ISSUE_NUM}\"))] | length" \
  2>/dev/null || echo "?")

# ── Check CONTRIBUTING.md existence ──────────────────────────────────
info "Checking for CONTRIBUTING.md..."

HAS_CONTRIBUTING="no"
gh api "repos/${REPO}/contents/CONTRIBUTING.md" >/dev/null 2>&1 && HAS_CONTRIBUTING="yes"

# ── Merged community PRs (last 5) — merge speed ─────────────────────
info "Analyzing community PR merge speed (last 5 merged)..."

MERGED_PRS=$(gh api "repos/${REPO}/pulls?state=closed&sort=updated&direction=desc&per_page=30" 2>/dev/null || echo "[]")

MERGE_SPEED_REPORT=$(echo "$MERGED_PRS" | python3 -c "
import sys, json
from datetime import datetime

data = json.load(sys.stdin)
merged = []
for pr in data:
    if pr.get('merged_at') and pr.get('user', {}).get('type') != 'Bot':
        # Skip if author is a repo collaborator (heuristic: author_association)
        assoc = pr.get('author_association', '')
        if assoc in ('FIRST_TIMER', 'FIRST_TIME_CONTRIBUTOR', 'CONTRIBUTOR', 'NONE'):
            created = datetime.fromisoformat(pr['created_at'].replace('Z', '+00:00'))
            merged_at = datetime.fromisoformat(pr['merged_at'].replace('Z', '+00:00'))
            delta = merged_at - created
            days = delta.total_seconds() / 86400
            merged.append({
                'number': pr['number'],
                'title': pr['title'][:50],
                'author': pr['user']['login'],
                'days': round(days, 1),
                'association': assoc,
            })
    if len(merged) >= 5:
        break

if not merged:
    print('  (no recent community PRs found)')
else:
    total_days = 0
    for m in merged:
        total_days += m['days']
        print(f\"  PR #{m['number']} by @{m['author']} ({m['association']}): {m['days']}d to merge\")
        title = m['title']
        if len(title) > 50:
            title = title[:47] + '...'
        print(f\"    {title}\")
    avg = round(total_days / len(merged), 1)
    print(f'  ---')
    print(f'  Average merge time: {avg} days ({len(merged)} PRs sampled)')
" 2>/dev/null || echo "  (failed to analyze merge speed)")

# ── Produce report ───────────────────────────────────────────────────
echo ""
echo "============================================================"
echo "  CONTRIBUTION EVALUATION REPORT"
echo "============================================================"
echo ""
echo "-- Repository: ${REPO} --"
echo ""
echo "  Description:    ${DESCRIPTION}"
echo "  Language:        ${LANGUAGE}"
echo "  License:         ${LICENSE}"
echo "  Stars:           ${STARS}"
echo "  Forks:           ${FORKS}"
echo "  Open issues:     ${OPEN_ISSUES}"
echo "  Default branch:  ${DEFAULT_BRANCH}"
echo "  Last push:       ${PUSHED_AT}"
echo "  Recent activity: ${RECENT_COMMITS_LABEL}"
echo "  Archived:        ${ARCHIVED}"
echo "  CONTRIBUTING.md: ${HAS_CONTRIBUTING}"
echo ""
echo "-- Issue #${ISSUE_NUM} --"
echo ""
echo "  Title:           ${ISSUE_TITLE}"
echo "  State:           ${ISSUE_STATE}"
echo "  Author:          @${ISSUE_AUTHOR}"
echo "  Labels:          ${ISSUE_LABELS}"
echo "  Assignee:        ${ISSUE_ASSIGNEE}"
echo "  Reactions:       ${ISSUE_REACTIONS}"
echo "  Comments:        ${ISSUE_COMMENTS}"
echo "  Created:         ${ISSUE_CREATED}"
echo "  Last updated:    ${ISSUE_UPDATED}"
echo "  Body length:     ${ISSUE_BODY_LEN} chars"
echo ""

# ── Risk assessment ──────────────────────────────────────────────────
echo "-- Risk Assessment --"
echo ""

RISKS=0

if [[ "$ISSUE_STATE" != "open" ]]; then
  echo "  [HIGH] Issue is ${ISSUE_STATE} (not open)"
  RISKS=$((RISKS + 1))
fi

if [[ "$ISSUE_ASSIGNEE" != "none" ]]; then
  echo "  [MEDIUM] Issue is assigned to @${ISSUE_ASSIGNEE}"
  RISKS=$((RISKS + 1))
fi

if [[ "$LINKED_PRS" != "?" && "$LINKED_PRS" -gt 0 ]]; then
  echo "  [MEDIUM] ${LINKED_PRS} open PR(s) may already address this issue"
  RISKS=$((RISKS + 1))
fi

if [[ "$ARCHIVED" == "true" ]]; then
  echo "  [HIGH] Repository is archived (no PRs accepted)"
  RISKS=$((RISKS + 1))
fi

if [[ "$HAS_CONTRIBUTING" == "no" ]]; then
  echo "  [LOW] No CONTRIBUTING.md found (contribution process unclear)"
  RISKS=$((RISKS + 1))
fi

if [[ "$ISSUE_BODY_LEN" -lt 100 ]]; then
  echo "  [LOW] Issue body is short (${ISSUE_BODY_LEN} chars) -- may lack detail"
  RISKS=$((RISKS + 1))
fi

if [[ "$RISKS" -eq 0 ]]; then
  echo "  No significant risks identified."
fi

echo ""
echo "-- Community PR Merge Speed --"
echo ""
echo "$MERGE_SPEED_REPORT"
echo ""
echo "-- Competing PRs --"
echo ""
if [[ "$LINKED_PRS" == "?" ]]; then
  echo "  Could not determine competing PRs."
elif [[ "$LINKED_PRS" -eq 0 ]]; then
  echo "  No open PRs found referencing issue #${ISSUE_NUM}."
else
  echo "  ${LINKED_PRS} open PR(s) reference issue #${ISSUE_NUM}."
fi

echo ""
echo "============================================================"
echo "  VERDICT"
echo "============================================================"
echo ""

if [[ "$ARCHIVED" == "true" ]]; then
  echo "  SKIP -- Repository is archived."
elif [[ "$ISSUE_STATE" != "open" ]]; then
  echo "  SKIP -- Issue is already ${ISSUE_STATE}."
elif [[ "$LINKED_PRS" != "?" && "$LINKED_PRS" -gt 2 ]]; then
  echo "  CAUTION -- Multiple competing PRs (${LINKED_PRS}). High risk of wasted effort."
elif [[ "$ISSUE_ASSIGNEE" != "none" && "$LINKED_PRS" != "?" && "$LINKED_PRS" -gt 0 ]]; then
  echo "  CAUTION -- Assigned and has competing PRs. Consider reaching out first."
else
  echo "  VIABLE -- Issue appears open for contribution."
  if [[ "$HAS_CONTRIBUTING" == "yes" ]]; then
    echo "  Next step: bash scripts/setup-target.sh ${REPO}"
  else
    echo "  Next step: Review repo README, then bash scripts/setup-target.sh ${REPO}"
  fi
fi

echo ""
echo "  Issue URL: https://github.com/${REPO}/issues/${ISSUE_NUM}"
echo ""
