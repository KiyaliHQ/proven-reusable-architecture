#!/bin/bash
# Setup Branch Protection Rules for PRA Registry
# This script configures GitHub Branch Protection Rules using the GitHub CLI (gh)
#
# Prerequisites:
# - GitHub CLI (gh) installed: https://cli.github.com/
# - Authenticated with gh: gh auth login
# - Admin permissions on the repository
#
# Usage:
#   ./scripts/setup-branch-protection.sh [OWNER/REPO]
#
# Example:
#   ./scripts/setup-branch-protection.sh KiyaliHQ/proven-reusable-architecture
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default repository (can be overridden by argument)
REPO="${1:-KiyaliHQ/proven-reusable-architecture}"
BRANCH="main"

echo -e "${BLUE}===================================================${NC}"
echo -e "${BLUE}  PRA Registry - Branch Protection Setup${NC}"
echo -e "${BLUE}===================================================${NC}"
echo ""

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ Error: GitHub CLI (gh) is not installed${NC}"
    echo -e "${YELLOW}Install it from: https://cli.github.com/${NC}"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}❌ Error: Not authenticated with GitHub CLI${NC}"
    echo -e "${YELLOW}Run: gh auth login${NC}"
    exit 1
fi

echo -e "${GREEN}✅ GitHub CLI is installed and authenticated${NC}"
echo -e "${BLUE}Repository: ${REPO}${NC}"
echo -e "${BLUE}Branch: ${BRANCH}${NC}"
echo ""

# Create temporary JSON configuration file
TEMP_CONFIG=$(mktemp)
cat > "$TEMP_CONFIG" << 'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "Detect & Validate PRA Candidate",
      "Count Governance Approvals"
    ]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": false,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "required_conversation_resolution": true
}
EOF

echo -e "${YELLOW}📋 Branch Protection Configuration:${NC}"
cat "$TEMP_CONFIG"
echo ""

# Confirm before applying
read -p "Apply this configuration to ${REPO}:${BRANCH}? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}❌ Cancelled${NC}"
    rm "$TEMP_CONFIG"
    exit 0
fi

# Apply branch protection rules
echo -e "${BLUE}🚀 Applying branch protection rules...${NC}"
if gh api \
    --method PUT \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/${REPO}/branches/${BRANCH}/protection" \
    --input "$TEMP_CONFIG" > /dev/null 2>&1; then

    echo -e "${GREEN}✅ Branch protection rules successfully applied!${NC}"
    echo ""
    echo -e "${GREEN}Enabled protections:${NC}"
    echo -e "  ✅ Required status checks:"
    echo -e "     - Detect & Validate PRA Candidate"
    echo -e "     - Count Governance Approvals"
    echo -e "  ✅ Required pull request reviews (1 minimum)"
    echo -e "  ✅ Require review from CODEOWNERS"
    echo -e "  ✅ Enforce admins (no bypass)"
    echo -e "  ✅ Required conversation resolution"
    echo ""
    echo -e "${BLUE}View protection rules:${NC}"
    echo -e "  https://github.com/${REPO}/settings/branches"
else
    echo -e "${RED}❌ Failed to apply branch protection rules${NC}"
    echo -e "${YELLOW}Check that you have admin permissions on the repository${NC}"
    rm "$TEMP_CONFIG"
    exit 1
fi

# Cleanup
rm "$TEMP_CONFIG"

echo ""
echo -e "${GREEN}===================================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${GREEN}===================================================${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Verify CODEOWNERS file exists: .github/CODEOWNERS"
echo "2. Ensure required GitHub teams exist:"
echo "   - pra-development-team"
echo "   - comite-architectes-experts"
echo "   - comite-gov-particuliers"
echo "   - comite-gov-entreprises"
echo "   - comite-gov-patrimoine"
echo "3. Test with a test PR"
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo "  docs/BRANCH_PROTECTION_SETUP.md"
echo ""
