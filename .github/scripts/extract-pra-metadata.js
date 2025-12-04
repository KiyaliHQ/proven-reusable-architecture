#!/usr/bin/env node

/**
 * Extract PRA metadata from MDX file
 *
 * Usage: node extract-pra-metadata.js <file-path>
 *
 * Extracts:
 * - Metadata from YAML frontmatter (pra.*)
 * - Scope, domain, status, category from file path
 * - Language from path
 * - Proven-in-use count
 */

const fs = require('fs');
const matter = require('gray-matter');
const path = require('path');

function extractMetadata(filePath) {
  // Read file content
  const content = fs.readFileSync(filePath, 'utf8');

  // Parse frontmatter
  const { data } = matter(content);

  // Extract path components
  // Format: content/pras-{lang}/{scope}/{status}/{category}/pra-name.md
  // OR:     content/pras-{lang}/domain-wide/{domain}/{status}/{category}/pra-name.md
  const pathParts = filePath.split('/');

  // Extract language (pras-fr -> fr, pras-en -> en)
  const langDir = pathParts.find(part => part.startsWith('pras-'));
  const lang = langDir ? langDir.split('-')[1] : null;

  // Find index of pras-* directory
  const prasIndex = pathParts.findIndex(part => part.startsWith('pras-'));

  // Extract scope (bank-wide or domain-wide)
  const scope = pathParts[prasIndex + 1];

  // Extract domain if domain-wide
  let domain = null;
  let statusIndex = prasIndex + 2;

  if (scope === 'domain-wide') {
    domain = pathParts[prasIndex + 2]; // particuliers, entreprises, gestion-patrimoine
    statusIndex = prasIndex + 3;
  }

  // Extract status and category
  const status = pathParts[statusIndex];
  const category = pathParts[statusIndex + 1];

  // Get PRA metadata
  const praMetadata = data.pra || {};

  // Count proven-in-use
  const provenCount = (praMetadata.proven_in_use || []).length;

  // Build result
  const result = {
    lang,
    scope,
    domain,
    status,
    category,
    metadata: praMetadata,
    proven_count: provenCount,
    file_path: filePath
  };

  return result;
}

// Main execution
if (require.main === module) {
  const filePath = process.argv[2];

  if (!filePath) {
    console.error('Usage: node extract-pra-metadata.js <file-path>');
    process.exit(1);
  }

  if (!fs.existsSync(filePath)) {
    console.error(`File not found: ${filePath}`);
    process.exit(1);
  }

  try {
    const metadata = extractMetadata(filePath);
    console.log(JSON.stringify(metadata, null, 2));
  } catch (error) {
    console.error(`Error extracting metadata: ${error.message}`);
    process.exit(1);
  }
}

module.exports = { extractMetadata };
