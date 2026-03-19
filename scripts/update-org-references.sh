#!/bin/bash
# =============================================================================
# update-org-references.sh — Update all hardcoded org/repo references
# =============================================================================
# Reads org and repo from pra-registry.config.yml and replaces all hardcoded
# references across the codebase. Run this once after transferring the repo
# to a new GitHub organization.
#
# Usage:
#   ./scripts/update-org-references.sh                    # Read from config
#   ./scripts/update-org-references.sh NewOrg new-repo    # Override config
#   ./scripts/update-org-references.sh --dry-run          # Preview changes
#
# What it updates:
#   - .github/CODEOWNERS          (team references)
#   - .github/workflows/*.yml     (org references in JS)
#   - content/guides/**/*.adoc    (clone URLs, team references)
#   - docs/*.md                   (clone URLs, issue URLs)
#   - scripts/*.sh                (default repo references)
#   - CLAUDE.md                   (URLs)
#   - CHANGELOG.md                (URLs)
#   - README.md                   (URLs)
#   - DEPLOYMENT_READINESS.md     (URLs, instructions)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG="$ROOT_DIR/pra-registry.config.yml"
DRY_RUN=false

# --- Parse args ---
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    shift
fi

# --- Read current values from config (no Python dependency) ---
CFG_ORG=$(grep '^\s*org:' "$CONFIG" | head -1 | sed 's/.*org:\s*//')
CFG_REPO=$(grep '^\s*repo:' "$CONFIG" | head -1 | sed 's/.*repo:\s*//')

# --- Target values (from args or config) ---
NEW_ORG="${1:-$CFG_ORG}"
NEW_REPO="${2:-$CFG_REPO}"

if [[ -z "$NEW_ORG" || -z "$NEW_REPO" ]]; then
    echo "ERROR: Could not determine org/repo from config or arguments."
    echo "Usage: $0 [NewOrg] [new-repo]"
    exit 1
fi

echo "=== Update Organization References ==="
echo "  Config: $CONFIG"
echo "  Target org:  $NEW_ORG"
echo "  Target repo: $NEW_REPO"
echo ""

# --- Detect current org/repo from existing references ---
# We scan CODEOWNERS to find the current org (most reliable source)
CURRENT_ORG=$(grep '@.*/' "$ROOT_DIR/.github/CODEOWNERS" 2>/dev/null | head -1 | sed 's/.*@\([^/]*\)\/.*/\1/')
CURRENT_REPO="$CFG_REPO"

if [[ -z "$CURRENT_ORG" ]]; then
    echo "ERROR: Could not detect current org from .github/CODEOWNERS"
    exit 1
fi

echo "  Current org:  $CURRENT_ORG"
echo "  Current repo: $CURRENT_REPO"
echo ""

if [[ "$CURRENT_ORG" == "$NEW_ORG" && "$CURRENT_REPO" == "$NEW_REPO" ]]; then
    echo "Nothing to change — org and repo already match."
    exit 0
fi

# --- Replace function ---
replace_in_file() {
    local file="$1" old="$2" new="$3"
    if [[ ! -f "$file" ]]; then return; fi
    if grep -q "$old" "$file" 2>/dev/null; then
        local count
        count=$(grep -c "$old" "$file")
        if [[ "$DRY_RUN" == "true" ]]; then
            echo "  [DRY] $file ($count occurrences of '$old')"
        else
            sed -i '' "s|${old}|${new}|g" "$file"
            echo "  [UPD] $file ($count replacements)"
        fi
    fi
}

# --- Step 1: Update pra-registry.config.yml ---
echo "--- Step 1: Update config ---"
replace_in_file "$CONFIG" "org: $CURRENT_ORG" "org: $NEW_ORG"
replace_in_file "$CONFIG" "repo: $CURRENT_REPO" "repo: $NEW_REPO"

# --- Step 2: Update CODEOWNERS ---
echo "--- Step 2: Update CODEOWNERS ---"
replace_in_file "$ROOT_DIR/.github/CODEOWNERS" "@$CURRENT_ORG/" "@$NEW_ORG/"

# --- Step 3: Update GitHub workflows ---
echo "--- Step 3: Update workflows ---"
for f in "$ROOT_DIR"/.github/workflows/*.yml; do
    replace_in_file "$f" "$CURRENT_ORG" "$NEW_ORG"
done

# --- Step 4: Update documentation ---
echo "--- Step 4: Update documentation ---"
for f in \
    "$ROOT_DIR/CLAUDE.md" \
    "$ROOT_DIR/CHANGELOG.md" \
    "$ROOT_DIR/README.md" \
    "$ROOT_DIR/DEPLOYMENT_READINESS.md" \
    "$ROOT_DIR/docs/QUICK_START.md" \
    "$ROOT_DIR/docs/DEVELOPER_GUIDE.md" \
    "$ROOT_DIR/docs/BRANCH_PROTECTION_SETUP.md" \
    "$ROOT_DIR/scripts/README.md" \
    "$ROOT_DIR/scripts/setup-branch-protection.sh"; do
    replace_in_file "$f" "$CURRENT_ORG/$CURRENT_REPO" "$NEW_ORG/$NEW_REPO"
    replace_in_file "$f" "@$CURRENT_ORG/" "@$NEW_ORG/"
    replace_in_file "$f" "$CURRENT_ORG" "$NEW_ORG"
done

# --- Step 5: Update content (guides) ---
echo "--- Step 5: Update content ---"
for f in "$ROOT_DIR"/content/guides/fr/*.adoc "$ROOT_DIR"/content/guides/en/*.adoc; do
    [[ -f "$f" ]] || continue
    replace_in_file "$f" "$CURRENT_ORG/$CURRENT_REPO" "$NEW_ORG/$NEW_REPO"
    replace_in_file "$f" "@$CURRENT_ORG/" "@$NEW_ORG/"
done

# --- Step 6: Update GitHub Pages base URL if repo name changed ---
if [[ "$CURRENT_REPO" != "$NEW_REPO" ]]; then
    echo "--- Step 6: Update GitHub Pages base URL ---"
    replace_in_file "$CONFIG" "base_url: /$CURRENT_REPO" "base_url: /$NEW_REPO"
fi

echo ""
if [[ "$DRY_RUN" == "true" ]]; then
    echo "=== Dry run complete — no files modified ==="
    echo "Run without --dry-run to apply changes."
else
    echo "=== All references updated: $CURRENT_ORG → $NEW_ORG ==="
    echo ""
    echo "Next steps:"
    echo "  1. Review changes: git diff"
    echo "  2. Commit: git add -A && git commit -m 'chore: update org references to $NEW_ORG'"
    echo "  3. Push to new remote"
fi
