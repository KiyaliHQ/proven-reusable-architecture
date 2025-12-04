# Branch Protection Setup Guide

This guide explains how to configure GitHub Branch Protection Rules to enforce framework file protections using CODEOWNERS.

## Overview

The PRA Registry uses **CODEOWNERS** to protect framework files from unauthorized modifications. This approach is:
- ✅ Native GitHub feature (no custom code)
- ✅ Secure and auditable
- ✅ Enterprise-ready (no PAT or hardcoded lists)
- ✅ Automatically enforced by GitHub

## CODEOWNERS Configuration

The `.github/CODEOWNERS` file defines which team must approve changes to specific directories:

```
# Framework files - Require approval from pra-development-team
/.github/                   @KiyaliHQ/pra-development-team
/site/                      @KiyaliHQ/pra-development-team
/docs/                      @KiyaliHQ/pra-development-team
/scripts/                   @KiyaliHQ/pra-development-team
/templates/                 @KiyaliHQ/pra-development-team

# Content files - Open to all contributors
/content/
```

## Quick Setup (Automated Script)

**⚡ Fastest way to set up branch protection:**

```bash
# Run the automated setup script
./scripts/setup-branch-protection.sh

# Or for a different repository:
./scripts/setup-branch-protection.sh YourOrg/your-repo
```

The script will:
1. ✅ Verify GitHub CLI is installed and authenticated
2. ✅ Show the configuration that will be applied
3. ✅ Ask for confirmation
4. ✅ Apply all branch protection rules automatically
5. ✅ Verify the setup was successful

**Prerequisites:**
- GitHub CLI (`gh`) installed: https://cli.github.com/
- Authenticated: `gh auth login`
- Admin permissions on the repository

---

## Manual Setup (Step-by-Step)

If you prefer to configure manually or the automated script doesn't work:

### Required Branch Protection Rules

To enforce CODEOWNERS, you must configure Branch Protection Rules on the `main` branch.

### Step-by-Step Instructions

1. **Navigate to Repository Settings**
   - Go to: `https://github.com/KiyaliHQ/proven-reusable-architecture/settings`
   - Click on **Branches** in the left sidebar

2. **Add Branch Protection Rule**
   - Click **Add rule** button
   - Branch name pattern: `main`

3. **Configure Protection Rules**

   Enable the following settings:

   #### ✅ Require a pull request before merging
   - Check: **Require a pull request before merging**
   - Recommended: **Require approvals: 1** (for content PRAs)
   - Check: **Require review from Code Owners** ⬅️ **CRITICAL**

   This ensures that any PR modifying framework files MUST be approved by `@KiyaliHQ/pra-development-team`.

   #### ✅ Require status checks to pass before merging
   - Check: **Require status checks to pass before merging**
   - Add required checks:
     - `Detect & Validate PRA Candidate` ⬅️ From `pra-candidate-validate-submission.yml`
     - `Count Governance Approvals` ⬅️ From `pra-candidate-review-for-approval.yml`

   #### ✅ Require conversation resolution before merging
   - Check: **Require conversation resolution before merging**
   - Ensures all review comments are addressed

   #### ✅ Do not allow bypassing the above settings
   - Check: **Do not allow bypassing the above settings**
   - Prevents admins from accidentally bypassing protections

4. **Save Changes**
   - Click **Create** or **Save changes**

## How It Works

### For Content PRs (PRA Submissions)

When a contributor submits a PR with only `/content/` changes:

1. ✅ No CODEOWNERS approval needed (content is open)
2. ✅ Workflow validates PRA structure
3. ✅ Governance committee reviews via workflow
4. ✅ Requires 2 approvals from appropriate governance team
5. ✅ PR can be merged after approvals

**Example PR**: Adding a new PRA in `/content/pras-fr/bank-wide/candidate/tech/`
- No framework files touched
- Workflow assigns `@KiyaliHQ/comite-architectes-experts`
- Committee approves via GitHub reviews
- Merge allowed after 2/2 approvals

### For Framework PRs (Development Team)

When a member of `@KiyaliHQ/pra-development-team` modifies framework files:

1. ⚠️ CODEOWNERS triggers automatic review request to `@KiyaliHQ/pra-development-team`
2. ✅ Workflow validates changes
3. ✅ Requires approval from team member
4. ✅ PR can be merged after approval

**Example PR**: Updating workflow `.github/workflows/...`
- Framework files touched
- GitHub automatically requests review from `@KiyaliHQ/pra-development-team`
- Team member reviews and approves
- Merge allowed after approval

### For Mixed PRs (Content + Framework)

When a PR contains both content AND framework changes:

1. ⚠️ CODEOWNERS triggers review from `@KiyaliHQ/pra-development-team` (for framework files)
2. ⚠️ Workflow triggers review from governance committee (for PRA content)
3. ✅ Requires approvals from BOTH teams
4. ✅ PR can be merged only after all approvals

**Example PR**: Adding PRA + updating workflow
- Both content and framework files touched
- Requires approval from `pra-development-team` + governance committee
- Merge allowed after all approvals

## Testing the Setup

### Test 1: Content-Only PR

Create a test PR with only `/content/` changes:

```bash
# Create test branch
git checkout -b test/content-only
echo "test" >> content/pras-fr/test.md
git add content/
git commit -m "test: content-only change"
git push origin test/content-only
```

**Expected Behavior**:
- ✅ No automatic review request from `pra-development-team`
- ✅ Workflow assigns governance committee
- ✅ Can merge after governance approvals

### Test 2: Framework-Only PR

Create a test PR with only framework changes:

```bash
# Create test branch
git checkout -b test/framework-only
echo "# comment" >> .github/workflows/test.yml
git add .github/
git commit -m "test: framework change"
git push origin test/framework-only
```

**Expected Behavior**:
- ⚠️ Automatic review request from `@KiyaliHQ/pra-development-team`
- ❌ Cannot merge without approval from team member
- ✅ Can merge after team approval

### Test 3: Mixed PR

Create a test PR with both content and framework changes:

```bash
# Create test branch
git checkout -b test/mixed
echo "test" >> content/pras-fr/test.md
echo "# comment" >> .github/workflows/test.yml
git add .
git commit -m "test: mixed changes"
git push origin test/mixed
```

**Expected Behavior**:
- ⚠️ Automatic review request from `@KiyaliHQ/pra-development-team`
- ⚠️ Workflow assigns governance committee
- ❌ Cannot merge without approvals from BOTH teams
- ✅ Can merge after all approvals

## Troubleshooting

### Issue: CODEOWNERS not triggering review requests

**Symptoms**: PRs with framework changes don't automatically request review from `pra-development-team`

**Solutions**:
1. Verify `.github/CODEOWNERS` file exists and is committed to `main` branch
2. Check that paths in CODEOWNERS match modified files (use `/` prefix for root paths)
3. Verify team slug is correct: `@KiyaliHQ/pra-development-team`
4. Ensure "Require review from Code Owners" is enabled in Branch Protection Rules

### Issue: Can merge without CODEOWNERS approval

**Symptoms**: PRs can be merged even though framework files were modified

**Solutions**:
1. Verify "Require review from Code Owners" is **checked** in Branch Protection Rules
2. Check "Do not allow bypassing the above settings" is **checked**
3. Ensure user is not a repository admin (admins can bypass by default unless explicitly blocked)

### Issue: Workflow not assigning governance reviewers

**Symptoms**: Content PRs don't get assigned to governance committees

**Solutions**:
1. Check workflow is running: `pra-candidate-validate-submission.yml`
2. Verify modified files are in `/content/pras-*/` paths
3. Check GitHub Actions logs for errors
4. Ensure governance teams exist:
   - `@KiyaliHQ/comite-architectes-experts`
   - `@KiyaliHQ/comite-gov-particuliers`
   - `@KiyaliHQ/comite-gov-entreprises`
   - `@KiyaliHQ/comite-gov-patrimoine`

## Migration to Bank GitHub

When migrating this repository to the bank's GitHub Enterprise:

### 1. Update Organization Name

Replace `KiyaliHQ` with your bank's organization name in:
- `.github/CODEOWNERS`
- `.github/workflows/pra-candidate-validate-submission.yml`
- `.github/workflows/pra-candidate-review-for-approval.yml`

### 2. Create Required Teams

Create these teams in the bank's GitHub organization:
- `pra-development-team` - Framework developers
- `comite-architectes-experts` - Expert architects committee (Bank-Wide PRAs)
- `comite-gov-particuliers` - Retail banking governance
- `comite-gov-entreprises` - Corporate banking governance
- `comite-gov-patrimoine` - Wealth management governance

### 3. Configure Branch Protection

Follow the steps in "Required Branch Protection Rules" section above.

### 4. Test

Run all three test scenarios (content-only, framework-only, mixed) to verify setup.

## Support

For questions or issues:
- **Technical Issues**: Open an issue on GitHub
- **Governance Questions**: Contact PRA governance committee
- **Access Issues**: Contact GitHub admins

---

**Last Updated**: 2025-12-04
**Maintained By**: PRA Development Team
