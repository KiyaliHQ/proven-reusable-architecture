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
git clone https://github.com/your-org/pra-registry.git
cd pra-registry
```

### 2. Create a Branch

```bash
git checkout -b pra/your-pra-name
```

### 3. Use the Template

Copy the PRA template:

```bash
cp templates/pra-template.md pra/candidates/pra-XXX-pra-name.md
```

### 4. Complete the PRA

Fill out all sections of the template:

- **Metadata** (YAML frontmatter)
- **Overview**
- **Context**
- **Architecture** (diagrams, components)
- **ADR** (Architecture Decision Records)
- **Examples** (code, configurations)
- **Proven-in-use** (real implementations with feedback)

### 5. Local Validation

Before submitting, verify:

```bash
# Validate metadata
pnpm validate:metadata

# Validate links
pnpm validate:links

# Preview the site
pnpm dev
```

### 6. Create a Pull Request

```bash
git add .
git commit -m "feat: add PRA-XXX - PRA Name"
git push origin pra/your-pra-name
```

Then create a Pull Request on GitHub with:

- **Title**: `[PRA] PRA Name`
- **Description**: Summary of the PRA and submission context

## Review Process

The review process depends on your PRA scope:

### Domain PRA Review

1. **Automated Validation**: GitHub Actions checks format, links, metadata
2. **Review by Domain Governance Committee**: 2 approvals required from your domain committee
3. **Iterations**: You will receive feedback and requests for clarification
4. **Approval**: Once approved, the PRA is merged as a **Domain Candidate**
5. **Timeline**: 5-10 business days

### Bank-Wide PRA Review

1. **Automated Validation**: GitHub Actions checks format, links, metadata
2. **Review by Expert Architects Governance Committee**: 2 approvals required from expert architects
3. **Multi-domain Validation**: Verification of applicability across domains
4. **Iterations**: You will receive feedback and requests for clarification
5. **Approval**: Once approved, the PRA is merged as a **Bank-Wide Candidate**
6. **Timeline**: 2-4 weeks

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
