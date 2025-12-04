# GitHub Workflow Scripts

Utility scripts used by GitHub Actions workflows for PRA validation and approval.

**Date**: 2025-12-03

---

## Scripts Overview

### 1. `extract-pra-metadata.js`

**Purpose**: Extract metadata from PRA MDX files

**Usage**:
```bash
node extract-pra-metadata.js <file-path>
```

**What it extracts**:
- YAML frontmatter metadata (`pra.*`)
- Path-based metadata (scope, domain, status, category, language)
- Proven-in-use count

**Output**: JSON object with extracted metadata

**Example**:
```bash
node extract-pra-metadata.js content/pras-fr/bank-wide/candidate/tech/api-gateway.md
```

**Output**:
```json
{
  "lang": "fr",
  "scope": "bank-wide",
  "domain": null,
  "status": "candidate",
  "category": "tech",
  "metadata": {
    "name": "API Gateway Pattern",
    "category": "tech",
    "status": "candidate",
    "tags": ["api", "gateway"],
    "created_at": "2025-12-03",
    "updated_at": "2025-12-03",
    "proven_in_use": [...]
  },
  "proven_count": 1,
  "file_path": "content/pras-fr/bank-wide/candidate/tech/api-gateway.md"
}
```

---

### 2. `validate-pra-structure.sh`

**Purpose**: Validate PRA structure, metadata, and content requirements

**Usage**:
```bash
./validate-pra-structure.sh <file-path> <required-proven-count>
```

**Parameters**:
- `file-path`: Path to PRA MDX file
- `required-proven-count`: Minimum proven-in-use implementations (default: 1)

**Validations performed**:
1. **Required sections**: Overview, Context, Architecture, ADRs, Examples
2. **Metadata completeness**: All required fields in `pra.*`
3. **Proven-in-use count**: Meets minimum requirement

**Exit codes**:
- `0`: Validation passed
- `1`: Validation failed

**Example**:
```bash
# Validate candidate PRA (1+ proven-in-use)
./validate-pra-structure.sh content/pras-fr/bank-wide/candidate/tech/api-gateway.md 1

# Validate approved PRA (3+ proven-in-use)
./validate-pra-structure.sh content/pras-fr/bank-wide/approved/tech/api-gateway.md 3
```

**Output**:
```
Validating PRA structure: content/pras-fr/bank-wide/candidate/tech/api-gateway.md
Required proven-in-use count: 1

Checking required sections...
  ✅ Found: Overview
  ✅ Found: Context
  ✅ Found: Architecture
  ✅ Found: ADR
  ✅ Found: Example

Validating metadata...
  ✅ Metadata extracted successfully
  Proven-in-use count: 1 (required: 1)
  ✅ Proven-in-use requirement met
  ✅ Found metadata: pra.name
  ✅ Found metadata: pra.category
  ...

================================
✅ Validation PASSED
================================
```

---

### 3. `validate-bilingual.sh`

**Purpose**: Validate that both FR and EN versions of a PRA exist

**Usage**:
```bash
./validate-bilingual.sh <file-path>
```

**Validation**:
- If given `pras-fr/...`, checks for matching `pras-en/...`
- If given `pras-en/...`, checks for matching `pras-fr/...`

**Exit codes**:
- `0`: Both versions exist
- `1`: Missing translation

**Example**:
```bash
./validate-bilingual.sh content/pras-fr/bank-wide/candidate/tech/api-gateway.md
```

**Output (success)**:
```
Validating bilingual requirement for: content/pras-fr/bank-wide/candidate/tech/api-gateway.md
  Current version: FR (content/pras-fr/bank-wide/candidate/tech/api-gateway.md)
  Expected counterpart: EN (content/pras-en/bank-wide/candidate/tech/api-gateway.md)

✅ Bilingual requirement met
  Both FR and EN versions exist
```

**Output (failure)**:
```
Validating bilingual requirement for: content/pras-fr/bank-wide/candidate/tech/api-gateway.md
  Current version: FR (content/pras-fr/bank-wide/candidate/tech/api-gateway.md)
  Expected counterpart: EN (content/pras-en/bank-wide/candidate/tech/api-gateway.md)

❌ Bilingual requirement NOT met
  Missing EN version: content/pras-en/bank-wide/candidate/tech/api-gateway.md

Please create the missing translation file with the same structure.
```

---

## Usage in Workflows

### Workflow 1: `validate-pra-candidate-submission.yml`

Uses all three scripts:

```yaml
- name: Extract metadata
  run: |
    METADATA=$(node .github/scripts/extract-pra-metadata.js "$PRA_FILE")
    PROVEN_COUNT=$(echo "$METADATA" | jq -r '.proven_count')

- name: Validate structure
  run: |
    .github/scripts/validate-pra-structure.sh "$PRA_FILE" 1

- name: Validate bilingual
  run: |
    .github/scripts/validate-bilingual.sh "$PRA_FILE"
```

### Workflow 2: `review-pra-candidate-for-approval.yml`

Uses metadata extraction:

```yaml
- name: Detect PRA scope
  run: |
    METADATA=$(node .github/scripts/extract-pra-metadata.js "$PRA_FILE")
    SCOPE=$(echo "$METADATA" | jq -r '.scope')
    DOMAIN=$(echo "$METADATA" | jq -r '.domain')
```

---

## Dependencies

These scripts require:
- **Node.js 18+** (`extract-pra-metadata.js`)
- **gray-matter** npm package (for YAML frontmatter parsing)
- **js-yaml** npm package (for YAML parsing)
- **jq** (for JSON parsing in bash scripts)
- **bash** (for shell scripts)

Installed in workflows via:
```yaml
- uses: actions/setup-node@v4
  with:
    node-version: '18'

- run: npm install -g gray-matter js-yaml
```

---

## Development

### Testing Locally

```bash
# Make scripts executable
chmod +x .github/scripts/*.sh

# Test metadata extraction
node .github/scripts/extract-pra-metadata.js content/pras-fr/bank-wide/candidate/tech/test-workflow.md

# Test structure validation
.github/scripts/validate-pra-structure.sh content/pras-fr/bank-wide/candidate/tech/test-workflow.md 1

# Test bilingual validation
.github/scripts/validate-bilingual.sh content/pras-fr/bank-wide/candidate/tech/test-workflow.md
```

### Adding New Scripts

When adding new scripts:
1. Add script to `.github/scripts/`
2. Make it executable: `chmod +x .github/scripts/new-script.sh`
3. Document usage in this README
4. Update workflows if needed

---

## Troubleshooting

### Script Not Found

Make sure scripts are executable:
```bash
chmod +x .github/scripts/*.sh
```

### Node Modules Not Found

Install dependencies:
```bash
npm install -g gray-matter js-yaml
```

### jq Not Found

Install jq:
```bash
# macOS
brew install jq

# Ubuntu/Debian
apt-get install jq
```

---

**Last Updated**: 2025-12-03
