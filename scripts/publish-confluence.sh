#!/bin/bash
# =============================================================================
# publish-confluence.sh — Publish AsciiDoc content to Confluence Cloud
# =============================================================================
# Handles:
#   - Sanitizing broken link: references (link:/, link:../path.ext)
#   - Adding (EN) suffix to EN page titles to avoid Confluence title conflicts
#   - Creating intermediate hierarchy pages (PRAs, Transversale, Par Domaine, etc.)
#   - Publishing each leaf directory under the correct parent page
#
# Required environment variables:
#   CONFLUENCE_URL          — e.g. https://mysite.atlassian.net/wiki
#   CONFLUENCE_SPACE_KEY    — e.g. PRA
#   CONFLUENCE_USER         — e.g. user@example.com
#   CONFLUENCE_TOKEN        — Atlassian API token
#   CONFLUENCE_ANCESTOR_FR  — Page ID for the FR root (e.g. "🇫🇷 Français")
#   CONFLUENCE_ANCESTOR_EN  — Page ID for the EN root (e.g. "🇬🇧 English")
#
# Optional:
#   PUBLISHER_VERSION       — Docker image tag (default: 0.25.0)
#   DRY_RUN                 — Set to "true" to skip actual publishing
# =============================================================================

set -euo pipefail

# --- Config ---
PUBLISHER_VERSION="${PUBLISHER_VERSION:-0.25.0}"
PUBLISHER_IMAGE="confluencepublisher/confluence-publisher:${PUBLISHER_VERSION}"
WORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="${WORK_DIR}/_confluence_tmp"
PLATFORM_FLAG=""

# Detect ARM (macOS Apple Silicon) and add --platform flag
if [[ "$(uname -m)" == "arm64" ]]; then
    PLATFORM_FLAG="--platform linux/amd64"
fi

# --- Validation ---
for var in CONFLUENCE_URL CONFLUENCE_SPACE_KEY CONFLUENCE_USER CONFLUENCE_TOKEN CONFLUENCE_ANCESTOR_FR CONFLUENCE_ANCESTOR_EN; do
    if [[ -z "${!var:-}" ]]; then
        echo "ERROR: $var is not set"
        exit 1
    fi
done

# --- Helpers ---
log() { echo "  [$1] $2"; }

# Create a Confluence page under a parent, return its ID
# If a page with that title already exists, return its ID instead
# Uses python3 for cross-platform reliability (no base64 wrapping issues)
create_or_find_page() {
    local title="$1" parent_id="$2"
    python3 - "$title" "$parent_id" << 'PYEOF'
import json, os, sys, urllib.request, urllib.parse, base64

title = sys.argv[1]
parent_id = sys.argv[2]
url = os.environ["CONFLUENCE_URL"]
space = os.environ["CONFLUENCE_SPACE_KEY"]
user = os.environ["CONFLUENCE_USER"]
token = os.environ["CONFLUENCE_TOKEN"]
auth = base64.b64encode(f"{user}:{token}".encode()).decode()

# Try to create the page
payload = json.dumps({
    "type": "page",
    "title": title,
    "space": {"key": space},
    "ancestors": [{"id": parent_id}],
    "body": {"storage": {"value": "<p></p>", "representation": "storage"}}
}).encode()

req = urllib.request.Request(f"{url}/rest/api/content", data=payload, method="POST")
req.add_header("Authorization", f"Basic {auth}")
req.add_header("Content-Type", "application/json")

try:
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read())
        print(data["id"])
        sys.exit(0)
except urllib.error.HTTPError as e:
    if e.code != 400:
        print("ERROR", file=sys.stderr)
        print("ERROR")
        sys.exit(0)

# Title conflict — find existing page
encoded = urllib.parse.quote(title)
req2 = urllib.request.Request(f"{url}/rest/api/content?title={encoded}&spaceKey={space}&type=page")
req2.add_header("Authorization", f"Basic {auth}")
try:
    with urllib.request.urlopen(req2) as resp:
        data = json.loads(resp.read())
        results = data.get("results", [])
        if results:
            print(results[0]["id"])
        else:
            print("ERROR")
except Exception:
    print("ERROR")
PYEOF
}

# Sanitize .adoc files: strip broken links, optionally add (EN) suffix
sanitize_dir() {
    local src_dir="$1" dest_dir="$2" add_en_suffix="${3:-false}"

    mkdir -p "$dest_dir"
    for f in "$src_dir"/*.adoc; do
        [[ -f "$f" ]] || continue
        local basename
        basename=$(basename "$f")

        # Skip index.adoc (contains link:*.html references)
        [[ "$basename" == "index.adoc" ]] && continue

        if [[ "$add_en_suffix" == "true" ]]; then
            # Add (EN) to title AND strip broken links
            sed -E \
                -e 's/^(= .+)$/\1 (EN)/' \
                -e 's|link:/[a-zA-Z0-9/_.-]+\[([^]]+)\]|\1|g' \
                -e 's|link:\.\.[a-zA-Z0-9/_.-]+\[([^]]+)\]|\1|g' \
                "$f" > "$dest_dir/$basename"
        else
            # Strip broken links only
            sed -E \
                -e 's|link:/[a-zA-Z0-9/_.-]+\[([^]]+)\]|\1|g' \
                -e 's|link:\.\.[a-zA-Z0-9/_.-]+\[([^]]+)\]|\1|g' \
                "$f" > "$dest_dir/$basename"
        fi
    done
}

# Publish a directory to Confluence under a given ancestor
publish_dir() {
    local src_dir="$1" ancestor_id="$2" label="$3"

    # Check if directory has .adoc files
    local count
    count=$(find "$src_dir" -maxdepth 1 -name "*.adoc" ! -name "index.adoc" 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$count" -eq 0 ]]; then
        log "SKIP" "$label (no .adoc files)"
        return
    fi

    log "PUB " "$label ($count files) → ancestor $ancestor_id"

    if [[ "${DRY_RUN:-false}" == "true" ]]; then
        log "DRY " "Would publish $count files"
        return
    fi

    docker run --rm $PLATFORM_FLAG \
        -e ROOT_CONFLUENCE_URL="${CONFLUENCE_URL}" \
        -e SPACE_KEY="${CONFLUENCE_SPACE_KEY}" \
        -e ANCESTOR_ID="${ancestor_id}" \
        -e USERNAME="${CONFLUENCE_USER}" \
        -e PASSWORD="${CONFLUENCE_TOKEN}" \
        -e PUBLISHING_STRATEGY="REPLACE_ANCESTOR" \
        -v "$src_dir:/var/asciidoc-root-folder" \
        "$PUBLISHER_IMAGE" 2>&1 | grep -E "^(Added|Updated|Deleted|Documentation)" || true
}

# =============================================================================
# MAIN
# =============================================================================
echo "=== Confluence Publisher ==="
echo "  URL: ${CONFLUENCE_URL}"
echo "  Space: ${CONFLUENCE_SPACE_KEY}"
echo "  FR ancestor: ${CONFLUENCE_ANCESTOR_FR}"
echo "  EN ancestor: ${CONFLUENCE_ANCESTOR_EN}"
echo "  Publisher: ${PUBLISHER_IMAGE}"
echo ""

# --- Clean temp ---
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

# --- Step 1: Create hierarchy pages ---
echo "--- Step 1: Create/find hierarchy pages ---"

# FR hierarchy
FR_PRAS=$(create_or_find_page "PRAs — FR" "$CONFLUENCE_ANCESTOR_FR")
log "PAGE" "PRAs — FR → $FR_PRAS"
FR_BW=$(create_or_find_page "Transversale — FR" "$FR_PRAS")
log "PAGE" "  Transversale — FR → $FR_BW"
FR_BW_APP=$(create_or_find_page "Application — FR" "$FR_BW")
FR_BW_DEV=$(create_or_find_page "DevOps — FR" "$FR_BW")
FR_BW_TECH=$(create_or_find_page "Technology — FR" "$FR_BW")
log "PAGE" "    Application=$FR_BW_APP DevOps=$FR_BW_DEV Technology=$FR_BW_TECH"
FR_DW=$(create_or_find_page "Par Domaine — FR" "$FR_PRAS")
log "PAGE" "  Par Domaine — FR → $FR_DW"
FR_DW_ENT=$(create_or_find_page "Entreprises — FR" "$FR_DW")
FR_DW_GP=$(create_or_find_page "Gestion Patrimoine — FR" "$FR_DW")
FR_DW_PART=$(create_or_find_page "Particuliers — FR" "$FR_DW")
log "PAGE" "    Entreprises=$FR_DW_ENT GP=$FR_DW_GP Particuliers=$FR_DW_PART"
FR_GUIDES=$(create_or_find_page "Guides — FR" "$CONFLUENCE_ANCESTOR_FR")
log "PAGE" "Guides — FR → $FR_GUIDES"

# EN hierarchy
EN_PRAS=$(create_or_find_page "PRAs — EN" "$CONFLUENCE_ANCESTOR_EN")
log "PAGE" "PRAs — EN → $EN_PRAS"
EN_BW=$(create_or_find_page "Transversal — EN" "$EN_PRAS")
log "PAGE" "  Transversal — EN → $EN_BW"
EN_BW_APP=$(create_or_find_page "Application — EN" "$EN_BW")
EN_BW_DEV=$(create_or_find_page "DevOps — EN" "$EN_BW")
EN_BW_TECH=$(create_or_find_page "Technology — EN" "$EN_BW")
log "PAGE" "    Application=$EN_BW_APP DevOps=$EN_BW_DEV Technology=$EN_BW_TECH"
EN_DW=$(create_or_find_page "By Domain — EN" "$EN_PRAS")
log "PAGE" "  By Domain — EN → $EN_DW"
EN_DW_ENT=$(create_or_find_page "Entreprises — EN" "$EN_DW")
EN_DW_GP=$(create_or_find_page "Gestion Patrimoine — EN" "$EN_DW")
EN_DW_PART=$(create_or_find_page "Particuliers — EN" "$EN_DW")
log "PAGE" "    Entreprises=$EN_DW_ENT GP=$EN_DW_GP Particuliers=$EN_DW_PART"
EN_GUIDES=$(create_or_find_page "Guides — EN" "$CONFLUENCE_ANCESTOR_EN")
log "PAGE" "Guides — EN → $EN_GUIDES"

echo ""

# --- Step 2: Sanitize content ---
echo "--- Step 2: Sanitize content ---"

# FR PRAs (strip broken links only)
sanitize_dir "$WORK_DIR/content/pras/fr/transversale/application"        "$TMP_DIR/fr/bw-app"
sanitize_dir "$WORK_DIR/content/pras/fr/transversale/devops"             "$TMP_DIR/fr/bw-dev"
sanitize_dir "$WORK_DIR/content/pras/fr/transversale/technology"         "$TMP_DIR/fr/bw-tech"
sanitize_dir "$WORK_DIR/content/pras/fr/par-domaine/entreprises"      "$TMP_DIR/fr/dw-ent"
sanitize_dir "$WORK_DIR/content/pras/fr/par-domaine/gestion-patrimoine" "$TMP_DIR/fr/dw-gp"
sanitize_dir "$WORK_DIR/content/pras/fr/par-domaine/particuliers"     "$TMP_DIR/fr/dw-part"
sanitize_dir "$WORK_DIR/content/guides/fr"                            "$TMP_DIR/fr/guides"

# EN PRAs (strip broken links + add EN suffix to titles)
sanitize_dir "$WORK_DIR/content/pras/en/transversal/application"        "$TMP_DIR/en/bw-app"    true
sanitize_dir "$WORK_DIR/content/pras/en/transversal/devops"             "$TMP_DIR/en/bw-dev"    true
sanitize_dir "$WORK_DIR/content/pras/en/transversal/technology"         "$TMP_DIR/en/bw-tech"   true
sanitize_dir "$WORK_DIR/content/pras/en/by-domain/entreprises"      "$TMP_DIR/en/dw-ent"    true
sanitize_dir "$WORK_DIR/content/pras/en/by-domain/gestion-patrimoine" "$TMP_DIR/en/dw-gp"   true
sanitize_dir "$WORK_DIR/content/pras/en/by-domain/particuliers"     "$TMP_DIR/en/dw-part"   true
sanitize_dir "$WORK_DIR/content/guides/en"                            "$TMP_DIR/en/guides"    true

log "DONE" "Content sanitized in $TMP_DIR"
echo ""

# --- Step 3: Publish ---
echo "--- Step 3: Publish content ---"

# FR PRAs
publish_dir "$TMP_DIR/fr/bw-app"  "$FR_BW_APP"  "FR/Transversale/Application"
publish_dir "$TMP_DIR/fr/bw-dev"  "$FR_BW_DEV"  "FR/Transversale/DevOps"
publish_dir "$TMP_DIR/fr/bw-tech" "$FR_BW_TECH" "FR/Transversale/Technology"
publish_dir "$TMP_DIR/fr/dw-ent"  "$FR_DW_ENT"  "FR/Par Domaine/Entreprises"
publish_dir "$TMP_DIR/fr/dw-gp"   "$FR_DW_GP"   "FR/Par Domaine/Gestion Patrimoine"
publish_dir "$TMP_DIR/fr/dw-part" "$FR_DW_PART" "FR/Par Domaine/Particuliers"
publish_dir "$TMP_DIR/fr/guides"  "$FR_GUIDES"  "FR/Guides"

# EN PRAs
publish_dir "$TMP_DIR/en/bw-app"  "$EN_BW_APP"  "EN/Transversal/Application"
publish_dir "$TMP_DIR/en/bw-dev"  "$EN_BW_DEV"  "EN/Transversal/DevOps"
publish_dir "$TMP_DIR/en/bw-tech" "$EN_BW_TECH" "EN/Transversal/Technology"
publish_dir "$TMP_DIR/en/dw-ent"  "$EN_DW_ENT"  "EN/By Domain/Entreprises"
publish_dir "$TMP_DIR/en/dw-gp"   "$EN_DW_GP"   "EN/By Domain/Gestion Patrimoine"
publish_dir "$TMP_DIR/en/dw-part" "$EN_DW_PART" "EN/By Domain/Particuliers"
publish_dir "$TMP_DIR/en/guides"  "$EN_GUIDES"  "EN/Guides"

echo ""

# --- Cleanup ---
rm -rf "$TMP_DIR"

echo "=== Confluence publish complete ==="
