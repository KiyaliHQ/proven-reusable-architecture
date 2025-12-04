# PRA Registry - Scripts

Utility scripts for setting up and maintaining the PRA Registry.

## Available Scripts

### `setup-branch-protection.sh`

Automatically configures GitHub Branch Protection Rules for the PRA Registry.

**Purpose**: Enforces CODEOWNERS file protection by configuring branch protection rules via GitHub API.

**Usage**:
```bash
# For current repository (KiyaliHQ/proven-reusable-architecture)
./scripts/setup-branch-protection.sh

# For a different repository (e.g., after migration to bank GitHub)
./scripts/setup-branch-protection.sh BankOrg/pra-registry
```

**Prerequisites**:
- GitHub CLI (`gh`) installed
- Authenticated with `gh auth login`
- Admin permissions on the target repository

**What it does**:
1. Validates GitHub CLI setup
2. Creates branch protection configuration
3. Applies protection rules to `main` branch
4. Verifies successful application

**Configuration Applied**:
- ✅ Required status checks (workflows must pass)
- ✅ Required pull request reviews (1 minimum)
- ✅ Require review from CODEOWNERS
- ✅ Enforce admins (no bypass)
- ✅ Required conversation resolution

**See Also**: `docs/BRANCH_PROTECTION_SETUP.md` for detailed documentation

---

## Adding New Scripts

When adding new scripts to this directory:

1. **Make it executable**: `chmod +x scripts/your-script.sh`
2. **Add shebang**: Start with `#!/bin/bash`
3. **Add documentation**: Include header comments explaining purpose and usage
4. **Update this README**: Add entry in "Available Scripts" section
5. **Error handling**: Use `set -e` to exit on errors
6. **User feedback**: Use colored output for clarity (see examples in existing scripts)

---

**Maintained By**: PRA Development Team
