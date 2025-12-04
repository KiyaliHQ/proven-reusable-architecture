---
title: 06. Contribution Guide
description: How to contribute to the PRA registry
---

# Contribution Guide

Would you like to submit a new PRA? Follow this step-by-step guide.

## Prerequisites

Before submitting a PRA, ensure that:

- Your architecture has been **validated in production** in at least **1 real project**
- You have **concrete feedback** (metrics, learnings, feedback)
- The solution is **reusable** and **generalizable** to other contexts
- You can **document** the context, decisions, and examples

## Choosing Your PRA Scope

Before starting, determine which scope applies:

### Domain PRA
Submit a **Domain PRA** if your pattern:
- Is specific to one domain (Retail, Corporate, Wealth Management)
- Contains functional or technical patterns for your domain
- Has at least **1 proven-in-use within your domain**
- Will be reviewed by your **Domain Governance Committee**

### Bank-Wide PRA
Submit a **Bank-Wide PRA** if your pattern:
- Is applicable across **multiple domains**
- Has demonstrated **multi-domain applicability**
- Has at least **1 proven-in-use** (with clear multi-domain potential)
- Will be reviewed by the **Expert Architects Governance Committee**

**Note**: Most PRAs start as Domain PRAs. Bank-Wide PRAs typically come from:
- Cross-cutting teams (Software Engineering, Security, etc.) - [**Flow 2**](/guides/08-governance#-flow-2-top-down-cross-cutting-teams--bank-wide)
- Domain PRAs promoted to Bank-Wide - [**Flow 1**](/guides/08-governance#-flow-1-organic-domain--bank-wide)
- Bootstrap initiative (transitional) - [**Flow 3**](/guides/08-governance#-flow-3-bootstrap-transitional)

## Submission Process

### 1. Fork and Clone

```bash
git clone https://github.com/KiyaliHQ/proven-reusable-architecture.git
cd proven-reusable-architecture
```

### 2. Create a Branch

```bash
git checkout -b feature/pra-your-pra-name
```

### 3. Create Your PRA (Bilingual)

**IMPORTANT**: You must create **two versions** of your PRA (French AND English).

#### Directory Structure

- **Bank-Wide PRA**: `content/pras-{lang}/bank-wide/candidate/{category}/pra-name.md`
- **Domain-Wide PRA**: `content/pras-{lang}/domain-wide/{domain}/candidate/{category}/pra-name.md`

Where:
- `{lang}` = `fr` or `en`
- `{category}` = `tech`, `integration`, `security`, or `business`
- `{domain}` = `particuliers`, `entreprises`, or `gestion-patrimoine` (if domain-wide)

#### Examples

**Bank-Wide Tech PRA** (applicable to all sectors):
```bash
content/pras-fr/bank-wide/candidate/tech/api-gateway-pattern.md
content/pras-en/bank-wide/candidate/tech/api-gateway-pattern.md
```

**Domain-Wide Security PRA** (Retail):
```bash
content/pras-fr/domain-wide/particuliers/candidate/security/kyc-verification.md
content/pras-en/domain-wide/particuliers/candidate/security/kyc-verification.md
```

### 4. Use the Template

Copy the PRA template and fill out all sections:

```yaml
---
title: Your PRA Name
description: Concise description of the PRA
pra:
  name: Your PRA Name
  category: tech|integration|security|business
  status: candidate
  tags: [tag1, tag2, tag3]
  created_at: "YYYY-MM-DD"
  updated_at: "YYYY-MM-DD"
  proven_in_use:
    - project: Project Name
      team: Team Name
      date: "YYYY-MM-DD"
      feedback: "Concrete feedback from experience"
---

## Overview
[Your documentation...]

## Context
[The problem and solution...]

## Architecture
[Diagrams and components...]

## Architecture Decision Records (ADRs)
[Documented architectural decisions...]

## Examples
[Concrete code and configurations...]

## Production Feedback
[Real implementation feedback...]
```

**Required sections**:
- Overview
- Context
- Architecture
- ADRs (Architecture Decision Records)
- Examples
- At least **1 proven-in-use** documented

### 5. Create a Pull Request

```bash
git add content/pras-fr/ content/pras-en/
git commit -m "feat: add PRA - PRA Name (Bank-Wide Tech Candidate)"
git push origin feature/pra-your-pra-name
```

Then create a Pull Request on GitHub.

### 6. Automated Validation ✨

**As soon as your PR is opened**, the automated system will:

1. ✅ **Validate structure**
   - Complete metadata
   - Required sections present
   - At least 1 proven-in-use documented
   - FR and EN versions present

2. ✅ **Assign reviewers**
   - **Bank-Wide** → `@KiyaliHQ/comite-architectes-experts`
   - **Domain-Wide Particuliers** → `@KiyaliHQ/comite-gov-particuliers`
   - **Domain-Wide Entreprises** → `@KiyaliHQ/comite-gov-entreprises`
   - **Domain-Wide Patrimoine** → `@KiyaliHQ/comite-gov-patrimoine`

3. ✅ **Post status comment**
   - Validation checklist
   - Next steps
   - Timeline (2-4 weeks for Bank-Wide, 5-10 days for Domain-Wide)

**⚠️ Framework Protection**: You can only modify files in `content/`. Any modifications outside this directory (`site/`, `.github/`, `docs/`, etc.) will be automatically blocked.

## Review Process

The review process follows these steps:

### 1. Automated Validation (Immediate)

GitHub Actions automatically checks:
- Format and metadata
- Required sections
- Proven-in-use requirement (1+ for Candidate)
- Bilingual requirement (FR + EN)

### 2. Governance Committee Review

**For Domain-Wide PRAs** (Retail, Corporate, Wealth Management):
- 📅 **Committee meeting**: You will be invited to present your PRA
- 🎤 **Presentation**: Explain the context, architecture, and benefits
- 💬 **Discussion**: Committee asks questions and provides feedback
- ✅ **Validation**: Committee validates or requests changes
- 👥 **GitHub Approvals**: 2 approvals required from `@KiyaliHQ/comite-gov-{domain}`
- ⏱️ **Timeline**: 5-10 business days

**For Bank-Wide PRAs** (Cross-cutting):
- 📅 **Expert committee meeting**: You will be invited to present your PRA
- 🎤 **Presentation**: Explain the context, architecture, and benefits
- 💬 **Discussion**: Committee asks questions and validates multi-domain applicability
- ✅ **Validation**: Committee validates or requests changes
- 👥 **GitHub Approvals**: 2 approvals required from `@KiyaliHQ/comite-architectes-experts`
- ⏱️ **Timeline**: 2-4 weeks

### 3. Real-Time Tracking

You will receive automatic notifications at each step:
- ⏳ **0/2 approvals**: Waiting for committee meeting
- ✅ **1/2 approvals**: First approval received (after meeting)
- ✅✅ **2/2 approvals**: PRA approved, ready to merge
- 🔄 **Changes Requested**: Modifications are requested

### 4. Iterations (If Necessary)

If the committee requests changes:
1. You will receive a detailed comment with feedback
2. Make the modifications on your branch
3. Push your changes (`git push`)
4. Validation re-runs automatically
5. Request re-review from the committee

### 5. Merge and Publication

Once **2/2 approvals** received:
- ✅ Your PR can be merged
- 🚀 Your PRA is published on the registry with **Candidate** status
- 📊 It appears in the catalogue and documentation

## Quality Criteria

Your PRA will be evaluated on:

- **Proven-in-use**: At least 1 documented implementation
- **Reusability**: Generalizable to other contexts
- **Clarity**: Clear and complete documentation
- **ADR**: Justified architectural decisions
- **Examples**: Concrete code and configurations

## Transition from Candidate to Approved

The requirements differ by scope:

### Domain PRA: Candidate → Approved

For a Domain Candidate PRA to become **Domain Approved**, it must:

- Have **1+ proven implementation within the domain** (already met for Candidate)
- Positive feedback from domain teams (satisfaction > 7/10)
- Documentation enriched with domain-specific learnings
- Confirmed reusability within the domain
- Review and approval by **Domain Governance Committee**

### Bank-Wide PRA: Candidate → Approved

For a Bank-Wide Candidate PRA to become **Bank-Wide Approved**, it must:

- Have **3+ proven implementations from different domains/teams**
- Positive multi-domain feedback (satisfaction > 7/10)
- Documentation enriched with multi-context learnings
- Validated multi-domain applicability
- Review and approval by **Expert Architects Governance Committee**

## Questions?

Consult:

- [Governance](/guides/08-governance)
- [Lifecycle](/guides/04-lifecycle)
- [Standards](/guides/05-standards)

---

**Recommended Path**:
1. [Getting Started with PRAs](/guides/01-getting-started)
2. [Understanding PRAs](/guides/02-understanding-pra)
3. [Roles and Responsibilities](/guides/03-roles-responsibilities)
4. [Lifecycle](/guides/04-lifecycle)
5. [Quality Standards](/guides/05-standards)
6. **Contributing a PRA** (you are here)
7. [Promotion Process](/guides/07-promotion-process)
8. [Governance](/guides/08-governance)

---

**Navigation**:
- **Previous**: [Quality Standards](/guides/05-standards)
- **Next**: [Promotion Process](/guides/07-promotion-process)

Or open an issue on GitHub.
