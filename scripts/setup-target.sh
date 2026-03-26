#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────────────
# setup-target.sh — Clone and prepare a target repo for contribution
#
# Clones the repo into repos/<repo-name>/, displays contribution
# guidelines, checks CI status, and creates a codebase-map stub.
#
# Usage:
#   bash scripts/setup-target.sh <owner/repo>
#
# Examples:
#   bash scripts/setup-target.sh vercel/next.js
#   bash scripts/setup-target.sh facebook/react
# ──────────────────────────────────────────────────────────────────────

usage() {
  echo "Usage: bash scripts/setup-target.sh <owner/repo>"
  echo ""
  echo "Clones the repository into repos/<repo-name>/ and prepares it"
  echo "for contribution work."
  exit 1
}

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "[info] $1"; }
warn() { echo "[warn] $1"; }

# ── Validate ─────────────────────────────────────────────────────────
[[ $# -lt 1 ]] && usage

REPO="$1"
[[ "$REPO" == *"/"* ]] || die "Repository must be in owner/repo format (got: $REPO)"

command -v gh >/dev/null 2>&1 || die "gh CLI is required but not found"
gh auth status >/dev/null 2>&1 || die "gh CLI is not authenticated"
command -v git >/dev/null 2>&1 || die "git is required but not found"

OWNER="${REPO%%/*}"
REPO_NAME="${REPO##*/}"

# Resolve project root (where this script lives: <root>/scripts/)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPOS_DIR="${PROJECT_ROOT}/repos"
TARGET_DIR="${REPOS_DIR}/${REPO_NAME}"

# ── Clone ────────────────────────────────────────────────────────────
if [[ -d "$TARGET_DIR" ]]; then
  info "Directory already exists: ${TARGET_DIR}"
  info "Pulling latest changes..."
  git -C "$TARGET_DIR" pull --ff-only 2>/dev/null || {
    warn "Pull failed (may have local changes). Skipping pull."
  }
else
  info "Cloning ${REPO} into ${TARGET_DIR}..."
  mkdir -p "$REPOS_DIR"
  gh repo clone "$REPO" "$TARGET_DIR" -- --depth=50 || die "Failed to clone ${REPO}"
  info "Clone complete."
fi

echo ""

# ── Repo metadata ───────────────────────────────────────────────────
info "Fetching repo metadata..."

REPO_DATA=$(gh api "repos/${REPO}" 2>/dev/null) || warn "Could not fetch repo metadata"

if [[ -n "${REPO_DATA:-}" ]]; then
  LANGUAGE=$(echo "$REPO_DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('language','unknown'))" 2>/dev/null || echo "unknown")
  DEFAULT_BRANCH=$(echo "$REPO_DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('default_branch','main'))" 2>/dev/null || echo "main")
  STARS=$(echo "$REPO_DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('stargazers_count',0))" 2>/dev/null || echo "?")

  echo "  Language:       ${LANGUAGE}"
  echo "  Default branch: ${DEFAULT_BRANCH}"
  echo "  Stars:          ${STARS}"
  echo ""
fi

# ── CONTRIBUTING.md ──────────────────────────────────────────────────
CONTRIBUTING_FILE=""
for candidate in CONTRIBUTING.md contributing.md CONTRIBUTING.rst docs/CONTRIBUTING.md .github/CONTRIBUTING.md; do
  if [[ -f "${TARGET_DIR}/${candidate}" ]]; then
    CONTRIBUTING_FILE="${TARGET_DIR}/${candidate}"
    break
  fi
done

if [[ -n "$CONTRIBUTING_FILE" ]]; then
  echo "============================================================"
  echo "  CONTRIBUTING GUIDELINES (${CONTRIBUTING_FILE##*/})"
  echo "============================================================"
  echo ""
  # Show first 80 lines to keep output manageable
  head -n 80 "$CONTRIBUTING_FILE"
  LINE_COUNT=$(wc -l < "$CONTRIBUTING_FILE" | tr -d ' ')
  if [[ "$LINE_COUNT" -gt 80 ]]; then
    echo ""
    echo "  ... (${LINE_COUNT} lines total, showing first 80)"
    echo "  Full file: ${CONTRIBUTING_FILE}"
  fi
  echo ""
else
  warn "No CONTRIBUTING.md found. Check the README for contribution instructions."
  echo ""
fi

# ── Recent CI / Actions status ───────────────────────────────────────
info "Checking recent CI status..."

CI_RUNS=$(gh api "repos/${REPO}/actions/runs?per_page=5&branch=${DEFAULT_BRANCH:-main}" \
  --jq '.workflow_runs[] | "\(.conclusion // "in_progress")\t\(.name)\t\(.created_at[:10])"' \
  2>/dev/null || echo "")

if [[ -n "$CI_RUNS" ]]; then
  echo ""
  echo "-- Recent CI Runs (${DEFAULT_BRANCH:-main}) --"
  echo ""
  printf "  %-15s %-40s %s\n" "STATUS" "WORKFLOW" "DATE"
  printf "  %-15s %-40s %s\n" "------" "--------" "----"
  echo "$CI_RUNS" | while IFS=$'\t' read -r status name date; do
    printf "  %-15s %-40s %s\n" "$status" "${name:0:40}" "$date"
  done
  echo ""
else
  info "No GitHub Actions runs found (repo may use external CI)."
  echo ""
fi

# ── Package manager detection ────────────────────────────────────────
info "Detecting package manager and build system..."
echo ""

declare -a DETECTED=()
[[ -f "${TARGET_DIR}/package-lock.json" ]]   && DETECTED+=("npm")
[[ -f "${TARGET_DIR}/pnpm-lock.yaml" ]]      && DETECTED+=("pnpm")
[[ -f "${TARGET_DIR}/yarn.lock" ]]            && DETECTED+=("yarn")
[[ -f "${TARGET_DIR}/bun.lockb" ]]            && DETECTED+=("bun")
[[ -f "${TARGET_DIR}/Cargo.toml" ]]           && DETECTED+=("cargo (Rust)")
[[ -f "${TARGET_DIR}/go.mod" ]]               && DETECTED+=("go modules")
[[ -f "${TARGET_DIR}/Makefile" ]]             && DETECTED+=("make")
[[ -f "${TARGET_DIR}/CMakeLists.txt" ]]       && DETECTED+=("cmake")
[[ -f "${TARGET_DIR}/build.gradle" ]]         && DETECTED+=("gradle")
[[ -f "${TARGET_DIR}/build.gradle.kts" ]]     && DETECTED+=("gradle (kotlin)")
[[ -f "${TARGET_DIR}/pom.xml" ]]              && DETECTED+=("maven")
[[ -f "${TARGET_DIR}/pyproject.toml" ]]       && DETECTED+=("python (pyproject)")
[[ -f "${TARGET_DIR}/setup.py" ]]             && DETECTED+=("python (setup.py)")
[[ -f "${TARGET_DIR}/Gemfile" ]]              && DETECTED+=("bundler (Ruby)")
[[ -f "${TARGET_DIR}/docker-compose.yml" || -f "${TARGET_DIR}/docker-compose.yaml" ]] && DETECTED+=("docker-compose")
[[ -f "${TARGET_DIR}/Dockerfile" ]]           && DETECTED+=("docker")

if [[ ${#DETECTED[@]} -gt 0 ]]; then
  echo "  Build systems: ${DETECTED[*]}"
else
  echo "  Build systems: (none detected)"
fi
echo ""

# ── Codebase map stub ───────────────────────────────────────────────
MAP_FILE="${TARGET_DIR}/CODEBASE-MAP.md"

if [[ -f "$MAP_FILE" ]]; then
  info "Codebase map already exists: ${MAP_FILE}"
else
  info "Creating codebase map stub: ${MAP_FILE}"

  # Count top-level dirs and files for the stub
  TOP_LEVEL=$(ls -1 "$TARGET_DIR" | head -n 30)

  cat > "$MAP_FILE" << MAPEOF
# Codebase Map: ${REPO}

> Auto-generated stub by WondrAIWork setup-target.sh
> Fill in as you explore the codebase.

## Top-Level Structure

\`\`\`
${TOP_LEVEL}
\`\`\`

## Key Directories

| Directory | Purpose |
|-----------|---------|
| src/      | TODO    |
| tests/    | TODO    |
| docs/     | TODO    |

## Entry Points

- Main: TODO
- Tests: TODO
- Config: TODO

## Build & Test Commands

\`\`\`bash
# Install dependencies
TODO

# Run tests
TODO

# Build
TODO

# Lint
TODO
\`\`\`

## Notes

- Contributing guide: ${CONTRIBUTING_FILE:-"not found"}
- Default branch: ${DEFAULT_BRANCH:-main}
MAPEOF

  info "Codebase map created. Fill it in as you explore."
fi

echo ""
echo "============================================================"
echo "  SETUP COMPLETE"
echo "============================================================"
echo ""
echo "  Repo cloned to: ${TARGET_DIR}"
echo "  Codebase map:   ${MAP_FILE}"
echo ""
echo "  Next steps:"
echo "    1. cd ${TARGET_DIR}"
echo "    2. Read the README and CONTRIBUTING guide"
echo "    3. Install dependencies and run tests"
echo "    4. Fill in CODEBASE-MAP.md as you explore"
echo "    5. Create a feature branch for your contribution"
echo ""
