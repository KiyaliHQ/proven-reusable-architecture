#!/bin/bash

# Validate bilingual requirement for PRA
#
# Usage: ./validate-bilingual.sh <file-path>
#
# Validates that both FR and EN versions exist
#
# Exit codes:
# 0 - Both versions exist
# 1 - Missing translation

set -e

FILE_PATH=$1

if [ -z "$FILE_PATH" ]; then
  echo "Usage: ./validate-bilingual.sh <file-path>"
  exit 1
fi

if [ ! -f "$FILE_PATH" ]; then
  echo "Error: File not found: $FILE_PATH"
  exit 1
fi

echo "Validating bilingual requirement for: $FILE_PATH"

# Determine which version we have and compute the other
if [[ "$FILE_PATH" == */pras-fr/* ]]; then
  # We have FR, check for EN
  COUNTERPART=$(echo "$FILE_PATH" | sed 's/pras-fr/pras-en/')
  CURRENT_LANG="FR"
  REQUIRED_LANG="EN"
elif [[ "$FILE_PATH" == */pras-en/* ]]; then
  # We have EN, check for FR
  COUNTERPART=$(echo "$FILE_PATH" | sed 's/pras-en/pras-fr/')
  CURRENT_LANG="EN"
  REQUIRED_LANG="FR"
else
  echo "Error: File is not in a pras-fr/ or pras-en/ directory"
  exit 1
fi

echo "  Current version: $CURRENT_LANG ($FILE_PATH)"
echo "  Expected counterpart: $REQUIRED_LANG ($COUNTERPART)"

# Check if counterpart exists
if [ -f "$COUNTERPART" ]; then
  echo ""
  echo "✅ Bilingual requirement met"
  echo "  Both $CURRENT_LANG and $REQUIRED_LANG versions exist"
  exit 0
else
  echo ""
  echo "❌ Bilingual requirement NOT met"
  echo "  Missing $REQUIRED_LANG version: $COUNTERPART"
  echo ""
  echo "Please create the missing translation file with the same structure."
  exit 1
fi
