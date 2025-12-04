#!/bin/bash

# Validate PRA structure and content
#
# Usage: ./validate-pra-structure.sh <file-path> <expected-proven-count>
#
# Validates:
# - Required sections present
# - Metadata completeness
# - Proven-in-use count meets requirement
#
# Exit codes:
# 0 - Validation passed
# 1 - Validation failed

set -e

FILE_PATH=$1
REQUIRED_PROVEN_COUNT=${2:-1}

if [ -z "$FILE_PATH" ]; then
  echo "Usage: ./validate-pra-structure.sh <file-path> <expected-proven-count>"
  exit 1
fi

if [ ! -f "$FILE_PATH" ]; then
  echo "Error: File not found: $FILE_PATH"
  exit 1
fi

echo "Validating PRA structure: $FILE_PATH"
echo "Required proven-in-use count: $REQUIRED_PROVEN_COUNT"

ERRORS=()

# 1. Validate required sections
echo ""
echo "Checking required sections..."

REQUIRED_SECTIONS=(
  "Overview"
  "Context"
  "Architecture"
  "ADR"
  "Example"
)

for section in "${REQUIRED_SECTIONS[@]}"; do
  if ! grep -qiE "^##\s+.*${section}" "$FILE_PATH"; then
    ERRORS+=("Missing required section: $section")
    echo "  ❌ Missing: $section"
  else
    echo "  ✅ Found: $section"
  fi
done

# 2. Extract and validate metadata using Node.js script
echo ""
echo "Validating metadata..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
METADATA_JSON=$(node "$SCRIPT_DIR/extract-pra-metadata.js" "$FILE_PATH")

if [ $? -ne 0 ]; then
  ERRORS+=("Failed to extract metadata")
  echo "  ❌ Failed to extract metadata"
else
  echo "  ✅ Metadata extracted successfully"

  # Check proven-in-use count
  PROVEN_COUNT=$(echo "$METADATA_JSON" | jq -r '.proven_count')
  echo "  Proven-in-use count: $PROVEN_COUNT (required: $REQUIRED_PROVEN_COUNT)"

  if [ "$PROVEN_COUNT" -lt "$REQUIRED_PROVEN_COUNT" ]; then
    ERRORS+=("Insufficient proven-in-use: found $PROVEN_COUNT, required $REQUIRED_PROVEN_COUNT")
    echo "  ❌ Insufficient proven-in-use implementations"
  else
    echo "  ✅ Proven-in-use requirement met"
  fi

  # Check required metadata fields
  REQUIRED_FIELDS=("name" "category" "status" "tags" "created_at" "updated_at")

  for field in "${REQUIRED_FIELDS[@]}"; do
    VALUE=$(echo "$METADATA_JSON" | jq -r ".metadata.$field")
    if [ "$VALUE" == "null" ] || [ -z "$VALUE" ]; then
      ERRORS+=("Missing required metadata field: pra.$field")
      echo "  ❌ Missing metadata: pra.$field"
    else
      echo "  ✅ Found metadata: pra.$field"
    fi
  done
fi

# 3. Report results
echo ""
echo "================================"

if [ ${#ERRORS[@]} -eq 0 ]; then
  echo "✅ Validation PASSED"
  echo "================================"
  exit 0
else
  echo "❌ Validation FAILED"
  echo ""
  echo "Errors found:"
  for error in "${ERRORS[@]}"; do
    echo "  - $error"
  done
  echo "================================"
  exit 1
fi
