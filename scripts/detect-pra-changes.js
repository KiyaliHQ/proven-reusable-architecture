#!/usr/bin/env node

/**
 * Detection Script: PRA Changes
 *
 * Detects the type of changes in a PR and extracts PRA metadata.
 *
 * Detects:
 * - Change type: nouveau-pra, update, promotion, deprecation, status-change
 * - Scope: domaine, transversale
 * - Domaine: particuliers, entreprises, gestion-patrimoine (if applicable)
 * - Category: tech, integration, security, business
 *
 * Usage:
 *   node scripts/detect-pra-changes.js <file-path> [base-file-path]
 *
 * Returns JSON:
 *   {
 *     changeType: string,
 *     scope: string,
 *     domaine: string | null,
 *     category: string,
 *     labels: string[]
 *   }
 *
 * Exit codes:
 *   0 - Detection successful
 *   1 - Detection failed
 */

const fs = require('fs');
const path = require('path');
const matter = require('gray-matter');

// Path patterns for scope detection
// Note: Physical folder structure uses "secteurs/" but terminology is "domaine"
const SCOPE_PATTERNS = {
  'secteurs/particuliers': { scope: 'domaine', domaine: 'particuliers' },
  'secteurs/entreprises': { scope: 'domaine', domaine: 'entreprises' },
  'secteurs/gestion-patrimoine': { scope: 'domaine', domaine: 'gestion-patrimoine' },
  'transversal': { scope: 'transversale', domaine: null },
  'en-promotion': { scope: 'transversale', domaine: null }
};

/**
 * Extract scope and domaine from file path
 * @param {string} filePath - File path
 * @returns {Object} - {scope, domaine}
 */
function extractScopeFromPath(filePath) {
  const normalizedPath = filePath.replace(/\\/g, '/');

  for (const [pattern, result] of Object.entries(SCOPE_PATTERNS)) {
    if (normalizedPath.includes(pattern)) {
      return result;
    }
  }

  // Default to domaine if in /secteurs/ but no specific match
  if (normalizedPath.includes('/secteurs/')) {
    return { scope: 'domaine', domaine: null };
  }

  // Default to transversale if unclear
  return { scope: 'transversale', domaine: null };
}

/**
 * Extract category from file path or metadata
 * @param {string} filePath - File path
 * @param {Object} metadata - PRA metadata
 * @returns {string} - Category
 */
function extractCategory(filePath, metadata) {
  // First try from metadata
  if (metadata?.category) {
    return metadata.category;
  }

  // Then try from path
  const normalizedPath = filePath.replace(/\\/g, '/');
  const categories = ['tech', 'integration', 'security', 'business'];

  for (const category of categories) {
    if (normalizedPath.includes(`/${category}/`)) {
      return category;
    }
  }

  // Default
  return 'tech';
}

/**
 * Detect change type
 * @param {string} filePath - Current file path
 * @param {string|null} baseFilePath - Base file path (for comparison)
 * @param {Object} metadata - Current PRA metadata
 * @param {Object|null} baseMetadata - Base PRA metadata
 * @returns {Object} - {changeType, details}
 */
function detectChangeType(filePath, baseFilePath, metadata, baseMetadata) {
  // Case 1: New file (nouveau-pra)
  if (!baseFilePath || !fs.existsSync(baseFilePath)) {
    return {
      changeType: 'nouveau-pra',
      details: 'New PRA file created'
    };
  }

  // Case 2: File moved from secteurs/* to transversal/* (promotion)
  const currentScope = extractScopeFromPath(filePath);
  const baseScope = extractScopeFromPath(baseFilePath);

  if (baseScope.scope === 'domaine' && currentScope.scope === 'transversale' && !filePath.includes('en-promotion')) {
    return {
      changeType: 'promotion',
      details: `PRA promoted from ${baseScope.domaine || 'domaine'} to transversale`
    };
  }

  // Case 3: Status changed to deprecated
  if (metadata?.status === 'deprecated' && baseMetadata?.status !== 'deprecated') {
    return {
      changeType: 'deprecation',
      details: `PRA status changed to deprecated (was: ${baseMetadata?.status || 'unknown'})`
    };
  }

  // Case 4: Status changed (other)
  if (metadata?.status !== baseMetadata?.status && metadata?.status) {
    return {
      changeType: 'status-change',
      details: `Status changed from ${baseMetadata?.status || 'unknown'} to ${metadata.status}`
    };
  }

  // Case 5: Regular update
  return {
    changeType: 'update',
    details: 'PRA content updated'
  };
}

/**
 * Generate labels based on detection
 * @param {Object} detection - Detection result
 * @returns {Array} - Array of label strings
 */
function generateLabels(detection) {
  const labels = [];

  // Scope label
  labels.push(`scope:${detection.scope}`);

  // Domaine label (if applicable)
  if (detection.domaine) {
    labels.push(`domaine:${detection.domaine}`);
  }

  // Category label
  labels.push(`category:${detection.category}`);

  // Change type label
  labels.push(`type:${detection.changeType}`);

  return labels;
}

/**
 * Main detection function
 * @param {string} filePath - Current file path
 * @param {string|null} baseFilePath - Base file path for comparison
 * @returns {Object} - Detection result
 */
function detectPRAChanges(filePath, baseFilePath = null) {
  try {
    // Read current file
    if (!fs.existsSync(filePath)) {
      throw new Error(`File not found: ${filePath}`);
    }

    const fileContent = fs.readFileSync(filePath, 'utf-8');
    const { data: frontmatter } = matter(fileContent);
    const metadata = frontmatter.pra;

    // Read base file (if exists)
    let baseMetadata = null;
    if (baseFilePath && fs.existsSync(baseFilePath)) {
      const baseContent = fs.readFileSync(baseFilePath, 'utf-8');
      const { data: baseFrontmatter } = matter(baseContent);
      baseMetadata = baseFrontmatter.pra;
    }

    // Extract scope and domaine
    const { scope, domaine } = extractScopeFromPath(filePath);

    // Extract category
    const category = extractCategory(filePath, metadata);

    // Detect change type
    const { changeType, details } = detectChangeType(filePath, baseFilePath, metadata, baseMetadata);

    // Generate labels
    const result = {
      changeType,
      scope,
      domaine,
      category,
      details,
      labels: []
    };

    result.labels = generateLabels(result);

    return {
      success: true,
      result
    };

  } catch (error) {
    return {
      success: false,
      error: error.message
    };
  }
}

// CLI execution
if (require.main === module) {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.error('Usage: node detect-pra-changes.js <file-path> [base-file-path]');
    process.exit(1);
  }

  const filePath = path.resolve(args[0]);
  const baseFilePath = args[1] ? path.resolve(args[1]) : null;

  const detection = detectPRAChanges(filePath, baseFilePath);

  if (detection.success) {
    console.log(JSON.stringify(detection.result, null, 2));
    process.exit(0);
  } else {
    console.error(`Error: ${detection.error}`);
    process.exit(1);
  }
}

module.exports = { detectPRAChanges, extractScopeFromPath, extractCategory };
