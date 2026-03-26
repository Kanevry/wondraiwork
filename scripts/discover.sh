#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────────────
# discover.sh — Find high-impact OSS issues worth contributing to
#
# Searches GitHub for issues across multiple strategies (reactions,
# comments, help-wanted, good-first-issue, bugs) and outputs a
# formatted table of candidates.
#
# Usage:
#   bash scripts/discover.sh [OPTIONS]
#
# Options:
#   --stars=N        Minimum repo stars (default: 1000)
#   --lang=LANG      Language filter (e.g., typescript, rust, go)
#   --label=LABEL    Additional label filter (e.g., bug, enhancement)
#   --limit=N        Results per strategy (default: 5)
#   --max-age=DAYS   Maximum issue age in days (default: 90)
#   --strategy=NAME  Run only one strategy (reactions|comments|help-wanted|good-first-issue|bugs)
#   -h, --help       Show this help text
# ──────────────────────────────────────────────────────────────────────

MIN_STARS=1000
LANGUAGE=""
EXTRA_LABEL=""
LIMIT=5
MAX_AGE_DAYS=90
STRATEGY=""

usage() {
  sed -n '/^# Usage:/,/^# ─/p' "$0" | sed '$d' | sed 's/^# //' | sed 's/^#//'
  exit 0
}

die() { echo "ERROR: $1" >&2; exit 1; }

# ── Parse arguments ──────────────────────────────────────────────────
for arg in "$@"; do
  case "$arg" in
    --stars=*)         MIN_STARS="${arg#*=}" ;;
    --lang=*)          LANGUAGE="${arg#*=}" ;;
    --label=*)         EXTRA_LABEL="${arg#*=}" ;;
    --limit=*)         LIMIT="${arg#*=}" ;;
    --max-age=*)       MAX_AGE_DAYS="${arg#*=}" ;;
    --strategy=*)      STRATEGY="${arg#*=}" ;;
    -h|--help)         usage ;;
    *)                 die "Unknown argument: $arg (use --help for usage)" ;;
  esac
done

# ── Validate dependencies ───────────────────────────────────────────
command -v gh >/dev/null 2>&1 || die "gh CLI is required but not found. Install: https://cli.github.com"
gh auth status >/dev/null 2>&1 || die "gh CLI is not authenticated. Run: gh auth login"

# ── Date filter ──────────────────────────────────────────────────────
if [[ "$(uname)" == "Darwin" ]]; then
  SINCE_DATE=$(date -v-"${MAX_AGE_DAYS}"d +%Y-%m-%d)
else
  SINCE_DATE=$(date -d "-${MAX_AGE_DAYS} days" +%Y-%m-%d)
fi

# ── Build base flags ───────────────────────────────────────────────
# gh search issues uses flags (--state, --label, --language) not inline qualifiers
BASE_FLAGS=(--state=open --limit="$LIMIT" --json "title,repository,commentsCount,createdAt,url,labels")
if [[ -n "$LANGUAGE" ]]; then
  BASE_FLAGS+=(--language="$LANGUAGE")
fi
if [[ -n "$EXTRA_LABEL" ]]; then
  BASE_FLAGS+=(--label="$EXTRA_LABEL")
fi
# Stars and date filters are passed as search qualifiers (positional)
SEARCH_QUALIFIERS="stars:>=${MIN_STARS} created:>=${SINCE_DATE}"

# ── Formatting ───────────────────────────────────────────────────────
SEPARATOR="+---------------------------------------------------------+-----------------------------+----------+------------+"
HEADER=$(printf "| %-55s | %-27s | %-8s | %-10s |" "ISSUE" "REPO" "COMMENTS" "CREATED")

print_header() {
  local strategy_name="$1"
  echo ""
  echo "=== Strategy: ${strategy_name} ==="
  echo "$SEPARATOR"
  echo "$HEADER"
  echo "$SEPARATOR"
}

print_row() {
  local title="$1" repo="$2" reactions="$3" comments="$4" created="$5" url="$6"
  # Truncate title to 55 chars
  if [[ ${#title} -gt 52 ]]; then
    title="${title:0:52}..."
  fi
  printf "| %-55s | %-27s | %8s | %8s | %-8s |\n" "$title" "$repo" "$reactions" "$comments" "$created"
  printf "|   %s\n" "$url"
}

print_footer() {
  echo "$SEPARATOR"
}

# ── Search execution ─────────────────────────────────────────────────
run_search() {
  local strategy_name="$1"
  shift
  local -a extra_flags=("$@")

  print_header "$strategy_name"

  local results
  results=$(gh search issues $SEARCH_QUALIFIERS "${BASE_FLAGS[@]}" "${extra_flags[@]}" 2>/dev/null) || {
    echo "| (search failed or returned no results)"
    print_footer
    return
  }

  local count
  count=$(echo "$results" | python3 -c "import sys,json; print(len(json.load(sys.stdin)))" 2>/dev/null || echo "0")

  if [[ "$count" == "0" || -z "$results" || "$results" == "[]" ]]; then
    echo "| (no results)"
    print_footer
    return
  fi

  echo "$results" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for item in data:
    title = item.get('title', '(no title)')
    repo_data = item.get('repository', {})
    repo = repo_data.get('nameWithOwner', repo_data.get('name', '?'))
    comments = item.get('commentsCount', 0)
    created = item.get('createdAt', '?')[:10]
    url = item.get('url', '')
    labels = ', '.join(l.get('name', '') for l in item.get('labels', []))
    if len(title) > 52:
        title = title[:52] + '...'
    if len(repo) > 27:
        repo = repo[:24] + '...'
    print(f'| {title:<55} | {repo:<27} | {comments:>8} | {created:<10} |')
    print(f'|   {url}')
    if labels:
        print(f'|   Labels: {labels}')
" 2>/dev/null || echo "| (failed to parse results)"

  print_footer
}

# ── Strategies ───────────────────────────────────────────────────────
strategies_to_run=("reactions" "comments" "help-wanted" "good-first-issue" "bugs")
if [[ -n "$STRATEGY" ]]; then
  strategies_to_run=("$STRATEGY")
fi

echo "WondrAIWork Issue Discovery"
echo "Config: stars>=${MIN_STARS}, max_age=${MAX_AGE_DAYS}d, lang=${LANGUAGE:-any}, label=${EXTRA_LABEL:-any}, limit=${LIMIT}/strategy"
echo "Date filter: created >= ${SINCE_DATE}"

for strat in "${strategies_to_run[@]}"; do
  case "$strat" in
    reactions)
      run_search "Most Reacted (high community demand)" \
        --sort=reactions --order=desc
      ;;
    comments)
      run_search "Most Commented (active discussion)" \
        --sort=comments --order=desc
      ;;
    help-wanted)
      run_search "Help Wanted (maintainer-approved)" \
        --label="help wanted" --sort=reactions --order=desc
      ;;
    good-first-issue)
      run_search "Good First Issue (onboarding-friendly)" \
        --label="good first issue" --sort=reactions --order=desc
      ;;
    bugs)
      run_search "Bugs (high-visibility fixes)" \
        --label=bug --sort=reactions --order=desc
      ;;
    *)
      die "Unknown strategy: $strat (valid: reactions, comments, help-wanted, good-first-issue, bugs)"
      ;;
  esac
done

echo ""
echo "Done. Use 'bash scripts/evaluate.sh <owner/repo> <issue-number>' to evaluate a candidate."
