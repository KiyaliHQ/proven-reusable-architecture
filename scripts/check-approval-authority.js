#!/usr/bin/env node

/**
 * Check Approval Authority Script
 *
 * Verifies that PR reviewers have the proper authority based on PRA scope.
 *
 * Checks:
 * - Retrieves PR reviewers via GitHub API
 * - Verifies team membership
 * - Counts valid approvals according to scope
 * - Returns status: sufficient / insufficient
 *
 * Usage:
 *   GITHUB_TOKEN=xxx node scripts/check-approval-authority.js <pr-number> <repo-owner> <repo-name>
 *
 * Environment Variables:
 *   GITHUB_TOKEN - GitHub Personal Access Token with repo access
 *
 * Exit codes:
 *   0 - Sufficient approvals
 *   1 - Insufficient approvals or error
 */

const https = require('https');

// Required approvals per scope
const APPROVAL_REQUIREMENTS = {
  'domaine': 2,        // Domain PRAs need 2 approvals from domain committee
  'transversale': 2,      // Transversale PRAs need 2 approvals from expert architects
  'promotion': 2       // Promotions need 2 approvals from expert architects
};

// Team slugs for each scope
const AUTHORIZED_TEAMS = {
  'domaine:particuliers': ['comite-gov-particuliers'],
  'domaine:entreprises': ['comite-gov-entreprises'],
  'domaine:gestion-patrimoine': ['comite-gov-patrimoine'],
  'transversale': ['comite-architectes-experts'],
  'promotion': ['comite-architectes-experts']
};

/**
 * Make GitHub API request
 * @param {string} path - API path
 * @param {string} token - GitHub token
 * @returns {Promise<Object>} - Response data
 */
function githubRequest(path, token) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'api.github.com',
      path: path,
      method: 'GET',
      headers: {
        'User-Agent': 'PRA-Registry-Approval-Checker',
        'Authorization': `token ${token}`,
        'Accept': 'application/vnd.github.v3+json'
      }
    };

    https.get(options, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          try {
            resolve(JSON.parse(data));
          } catch (e) {
            reject(new Error(`Failed to parse JSON: ${e.message}`));
          }
        } else {
          reject(new Error(`GitHub API error: ${res.statusCode} - ${data}`));
        }
      });
    }).on('error', (err) => {
      reject(err);
    });
  });
}

/**
 * Get PR labels
 * @param {string} owner - Repository owner
 * @param {string} repo - Repository name
 * @param {number} prNumber - PR number
 * @param {string} token - GitHub token
 * @returns {Promise<Array>} - Array of label names
 */
async function getPRLabels(owner, repo, prNumber, token) {
  const path = `/repos/${owner}/${repo}/issues/${prNumber}/labels`;
  const labels = await githubRequest(path, token);
  return labels.map(label => label.name);
}

/**
 * Get PR reviews
 * @param {string} owner - Repository owner
 * @param {string} repo - Repository name
 * @param {number} prNumber - PR number
 * @param {string} token - GitHub token
 * @returns {Promise<Array>} - Array of reviews
 */
async function getPRReviews(owner, repo, prNumber, token) {
  const path = `/repos/${owner}/${repo}/pulls/${prNumber}/reviews`;
  return await githubRequest(path, token);
}

/**
 * Check if user is member of team
 * @param {string} owner - Repository owner
 * @param {string} teamSlug - Team slug
 * @param {string} username - Username to check
 * @param {string} token - GitHub token
 * @returns {Promise<boolean>} - True if member
 */
async function isTeamMember(owner, teamSlug, username, token) {
  try {
    const path = `/orgs/${owner}/teams/${teamSlug}/memberships/${username}`;
    const membership = await githubRequest(path, token);
    return membership.state === 'active';
  } catch (error) {
    // User not in team or API error
    return false;
  }
}

/**
 * Determine required scope from PR labels
 * @param {Array} labels - PR labels
 * @returns {string} - Scope identifier
 */
function determineScope(labels) {
  // Check for promotion first (highest priority)
  if (labels.includes('type:promotion')) {
    return 'promotion';
  }

  // Check for transversale
  if (labels.includes('scope:transversale')) {
    return 'transversale';
  }

  // Check for domain-specific
  if (labels.includes('scope:domaine')) {
    if (labels.includes('domaine:particuliers')) return 'domaine:particuliers';
    if (labels.includes('domaine:entreprises')) return 'domaine:entreprises';
    if (labels.includes('domaine:gestion-patrimoine')) return 'domaine:gestion-patrimoine';
    return 'domaine'; // Generic domain
  }

  // Default to transversale if unclear
  return 'transversale';
}

/**
 * Check approval authority
 * @param {number} prNumber - PR number
 * @param {string} owner - Repository owner
 * @param {string} repo - Repository name
 * @param {string} token - GitHub token
 * @returns {Object} - Check result
 */
async function checkApprovalAuthority(prNumber, owner, repo, token) {
  try {
    // Get PR labels
    const labels = await getPRLabels(owner, repo, prNumber, token);
    console.log(`Labels: ${labels.join(', ')}`);

    // Determine scope
    const scope = determineScope(labels);
    console.log(`Scope: ${scope}`);

    // Get required approvals
    const requiredApprovals = APPROVAL_REQUIREMENTS[scope.split(':')[0]] || 2;
    console.log(`Required approvals: ${requiredApprovals}`);

    // Get authorized teams for this scope
    const authorizedTeams = AUTHORIZED_TEAMS[scope] || AUTHORIZED_TEAMS['transversale'];
    console.log(`Authorized teams: ${authorizedTeams.join(', ')}`);

    // Get PR reviews
    const reviews = await getPRReviews(owner, repo, prNumber, token);

    // Filter for approved reviews only (latest review per user)
    const userReviews = {};
    reviews.forEach(review => {
      const username = review.user.login;
      const submittedAt = new Date(review.submitted_at);

      if (!userReviews[username] || new Date(userReviews[username].submitted_at) < submittedAt) {
        userReviews[username] = review;
      }
    });

    const approvedReviews = Object.values(userReviews).filter(
      review => review.state === 'APPROVED'
    );

    console.log(`Total approved reviews: ${approvedReviews.length}`);

    // Check team membership for each approver
    let validApprovals = 0;
    const validApprovers = [];

    for (const review of approvedReviews) {
      const username = review.user.login;

      // Check if user is in any of the authorized teams
      let isMember = false;
      for (const teamSlug of authorizedTeams) {
        if (await isTeamMember(owner, teamSlug, username, token)) {
          isMember = true;
          break;
        }
      }

      if (isMember) {
        validApprovals++;
        validApprovers.push(username);
        console.log(`✓ Valid approval from ${username}`);
      } else {
        console.log(`✗ Invalid approval from ${username} (not in authorized teams)`);
      }
    }

    // Check if sufficient
    const sufficient = validApprovals >= requiredApprovals;

    return {
      success: true,
      sufficient,
      validApprovals,
      requiredApprovals,
      validApprovers,
      scope,
      message: sufficient
        ? `✅ Sufficient approvals: ${validApprovals}/${requiredApprovals}`
        : `❌ Insufficient approvals: ${validApprovals}/${requiredApprovals} (need ${requiredApprovals - validApprovals} more)`
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

  if (args.length < 3) {
    console.error('Usage: GITHUB_TOKEN=xxx node check-approval-authority.js <pr-number> <repo-owner> <repo-name>');
    process.exit(1);
  }

  const prNumber = parseInt(args[0], 10);
  const owner = args[1];
  const repo = args[2];
  const token = process.env.GITHUB_TOKEN;

  if (!token) {
    console.error('Error: GITHUB_TOKEN environment variable is required');
    process.exit(1);
  }

  checkApprovalAuthority(prNumber, owner, repo, token).then(result => {
    if (result.success) {
      console.log(result.message);
      console.log(`Valid approvers: ${result.validApprovers.join(', ') || 'none'}`);

      process.exit(result.sufficient ? 0 : 1);
    } else {
      console.error(`Error: ${result.error}`);
      process.exit(1);
    }
  }).catch(error => {
    console.error(`Unexpected error: ${error.message}`);
    process.exit(1);
  });
}

module.exports = { checkApprovalAuthority, determineScope, APPROVAL_REQUIREMENTS, AUTHORIZED_TEAMS };
