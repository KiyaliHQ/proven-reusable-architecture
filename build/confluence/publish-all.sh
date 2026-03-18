#!/bin/bash
# =============================================================================
# publish-all.sh — Publish both FR and EN PRA content to Confluence
# =============================================================================
#
# Usage: ./publish-all.sh
#
# Required environment variables:
#   CONFLUENCE_URL           — Confluence base URL
#   CONFLUENCE_SPACE_KEY     — Confluence space key
#   CONFLUENCE_USER          — Confluence username
#   CONFLUENCE_TOKEN         — Confluence API token
#   CONFLUENCE_ANCESTOR_FR   — Parent page ID for French content
#   CONFLUENCE_ANCESTOR_EN   — Parent page ID for English content
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

: "${CONFLUENCE_ANCESTOR_FR:?CONFLUENCE_ANCESTOR_FR is not set}"
: "${CONFLUENCE_ANCESTOR_EN:?CONFLUENCE_ANCESTOR_EN is not set}"

echo "========================================="
echo "  Publishing PRA Registry to Confluence"
echo "========================================="
echo ""

echo "--- Publishing French content ---"
"$SCRIPT_DIR/publish.sh" fr "$CONFLUENCE_ANCESTOR_FR"
echo ""

echo "--- Publishing English content ---"
"$SCRIPT_DIR/publish.sh" en "$CONFLUENCE_ANCESTOR_EN"
echo ""

echo "========================================="
echo "  All content published successfully"
echo "========================================="
