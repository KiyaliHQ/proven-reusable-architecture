#!/bin/bash
# =============================================================================
# publish.sh — Publish AsciiDoc content to Confluence via Docker
# =============================================================================
#
# Usage: ./publish.sh <lang> <ancestor-id>
# Example: ./publish.sh fr 123456
#
# Required environment variables:
#   CONFLUENCE_URL    — Confluence base URL (e.g., https://mycompany.atlassian.net/wiki)
#   CONFLUENCE_SPACE_KEY — Confluence space key
#   CONFLUENCE_USER   — Confluence username or email
#   CONFLUENCE_TOKEN  — Confluence API token
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# --- Arguments ---
LANG="${1:?Usage: $0 <lang> <ancestor-id>}"
ANCESTOR_ID="${2:?Usage: $0 <lang> <ancestor-id>}"

# --- Validate environment ---
: "${CONFLUENCE_URL:?CONFLUENCE_URL is not set}"
: "${CONFLUENCE_SPACE_KEY:?CONFLUENCE_SPACE_KEY is not set}"
: "${CONFLUENCE_USER:?CONFLUENCE_USER is not set}"
: "${CONFLUENCE_TOKEN:?CONFLUENCE_TOKEN is not set}"

# --- Validate content directory ---
CONTENT_DIR="$ROOT_DIR/content/pras/$LANG"
if [ ! -d "$CONTENT_DIR" ]; then
    echo "ERROR: Content directory not found: $CONTENT_DIR"
    exit 1
fi

echo "=== Publishing PRA content to Confluence ==="
echo "  Language:    $LANG"
echo "  Ancestor ID: $ANCESTOR_ID"
echo "  Content:     $CONTENT_DIR"
echo "  URL:         $CONFLUENCE_URL"
echo "  Space:       $CONFLUENCE_SPACE_KEY"
echo ""

docker run --rm \
    -v "$ROOT_DIR:/workspace" \
    confluencepublisher/confluence-publisher:latest \
    --asciidoc-root-folder "/workspace/content/pras/$LANG" \
    --root-confluence-url "$CONFLUENCE_URL" \
    --space-key "$CONFLUENCE_SPACE_KEY" \
    --ancestor-id "$ANCESTOR_ID" \
    --username "$CONFLUENCE_USER" \
    --password "$CONFLUENCE_TOKEN" \
    --publishing-strategy REPLACE_ANCESTOR

echo ""
echo "=== Publication complete for $LANG ==="
