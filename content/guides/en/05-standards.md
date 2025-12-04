---
title: 05. Quality Standards
description: Criteria and standards for Proven Reusable Architecture
---

# PRA Quality Standards

This document defines the quality standards that all PRAs must meet to be accepted in the registry.

##  Core Principles

A quality PRA must be:

- ** Proven-in-use**: Validated in real production
- ** Reusable**: Applicable to multiple contexts
- ** Well documented**: Clear, complete and maintainable
- ** Maintainable**: Scalable and supported over time

##  Criteria by Status and Scope

### For a Domain PRA Candidate

#### Mandatory Criteria

 **At least 1 documented proven-in-use within the domain**
- Production project (not dev/staging)
- Concrete and measurable feedback from domain context
- Recent date (< 2 years)

 **Complete documentation**
- Context and problem solved
- Solution and architecture
- ADR (Architecture Decision Records)
- Code/configuration examples
- Clearly defined prerequisites

 **Demonstrated reusability**
- Generalizable pattern
- Not specific to a single project
- Configurable for different contexts

 **Technical quality**
- Complies with enterprise technical standards
- Validated security and compliance
- Acceptable performance
- Scalability considered

#### Recommended Criteria

-  Architecture diagrams
-  Comparison with alternatives
-  Migration guide (if applicable)
-  FAQ based on experience

### For a Bank-Wide PRA Candidate

#### Mandatory Criteria

 **At least 1 documented proven-in-use**
- Production project (not dev/staging)
- Concrete and measurable feedback
- Recent date (< 2 years)
- Demonstrated multi-domain applicability

 **Complete documentation** (same as Domain PRA)

 **Demonstrated reusability across domains**
- Generalizable pattern for multiple domains
- Not specific to a single domain context
- Configurable for different domain contexts

 **Technical quality** (same as Domain PRA)

### For a Domain PRA Approved

#### Mandatory Criteria (in addition to Candidate)

 **At least 1 documented proven-in-use within the domain**
- Positive feedback from domain teams (satisfaction > 7/10)
- Confirmed reusability within domain

 **Documentation enriched with domain learnings**
- Domain-specific use cases
- Common pitfalls in domain context
- Domain-specific troubleshooting guide

 **Active maintenance**
- Designated and active maintainer
- Last update < 6 months
- Responses to questions < 1 week

 **Growing adoption within domain**
- Positive usage trend in domain
- No major negative feedback
- Recommended by domain peers

### For a Bank-Wide PRA Approved

#### Mandatory Criteria (in addition to Candidate)

 **At least 3 documented proven-in-use from different domains/teams**
- Different teams from multiple domains
- Different application contexts across domains
- Positive multi-domain feedback (satisfaction > 7/10)

 **Documentation enriched with multi-domain learnings**
- Learnings from implementations across multiple domains
- Varied use cases from different domain contexts
- Common pitfalls documented with multi-domain perspective
- Troubleshooting guide applicable across domains

 **Active maintenance**
- Designated and active maintainer
- Last update < 6 months
- Responses to questions < 1 week
- Multi-domain support capability

 **Growing multi-domain adoption**
- Positive usage trend across multiple domains
- No major negative feedback from any domain
- Recommended by peers across different domains

##  Template and Structure

### Mandatory PRA Structure

Each PRA must contain the following sections:

#### 1. Frontmatter (YAML Metadata)

```yaml
---
id: pra-XXX
name: "Pattern Name"
category: tech | integration | security | business
tags:
  - tag1
  - tag2
status: candidate | approved | deprecated
version: X.Y.Z
author:
  name: "First Last"
  email: "email@company.com"
maintainer:
  name: "First Last"
  email: "email@company.com"
created: YYYY-MM-DD
updated: YYYY-MM-DD
proven_in_use:
  - project: "Project Name"
    team: "Team Name"
    date: "YYYY-MM-DD"
    feedback: "Concrete results"
dependencies: []  # IDs of other required PRAs
replaces: null    # ID of replaced PRA
---
```

#### 2. Mandatory Markdown Sections

```markdown
# PRA-XXX: [Pattern Name]

##  Summary
[2-3 sentences describing the pattern]

##  Application Context

### When to use this PRA?
- [Criterion 1]
- [Criterion 2]

### When NOT to use this PRA?
- [Contraindication 1]
- [Contraindication 2]

##  Problem Solved
[Problem description]

### Typical Symptoms
- [Symptom 1]
- [Symptom 2]

##  Solution
[Solution description]

### Architecture
[Diagram or description]

### Technology Stack
[Table of technologies used]

##  Architecture Decision Records (ADR)
[Links to ADR or summary of key decisions]

##  Prerequisites
- [Technical prerequisite 1]
- [Organizational prerequisite 1]

##  Implementation
[Step-by-step guide]

##  Examples
[Code and configurations]

##  Experience Feedback
[Learnings from proven-in-use]

##  Limitations & Pitfalls
[Known limitations and pitfalls to avoid]

##  Lifecycle & Maintenance
[How to maintain and evolve]

##  References
[Links to official documentation, contacts]
```

### Optional but Recommended Sections

```markdown
##  Migration
[Migration guide from previous solution]

##  Testing
[Recommended testing strategy]

##  Metrics
[KPIs and success metrics]

##  Multi-environment
[Dev/staging/prod considerations]

##  Costs
[Cost estimation (infrastructure, licenses)]

##  FAQ
[Frequently asked questions]
```

##  Quality Criteria by Section

### Application Context

**Excellent**:
- Precise and actionable usage criteria
- Clear contraindications
- Examples of applicable contexts
- Explicit trade-offs

**Insufficient**:
- Vague or generic criteria
- No contraindications
- Applicable "everywhere"

### Solution

**Excellent**:
- Clear architecture with diagrams
- Justified technologies
- Alternatives considered
- Scalability and performance addressed

**Insufficient**:
- Text description only
- No justification for technical choices
- No alternative considerations

### ADR (Architecture Decision Records)

**Excellent**:
- Each major decision documented
- Context, options, decision, consequences
- Links to detailed ADRs if necessary
- Revision history

**Insufficient**:
- No ADR
- Incomplete or vague ADRs
- No decision justification

### Proven-in-use

**Excellent**:
- Named production projects
- Concrete metrics (time, costs, quality)
- Specific learnings
- Team contact available

**Insufficient**:
- Anonymous or fictitious projects
- Generic feedback "it works well"
- No metrics
- Dev/POC projects

### Examples

**Excellent**:
- Complete and executable code
- Multiple examples (simple + complex cases)
- Commented configurations
- Example repository available

**Insufficient**:
- Incomplete snippets
- Non-executable pseudo-code
- No context
- Trivial examples

##  Validation Checklist

Before submitting a PRA, verify:

### Documentation

- [ ] All mandatory sections are present
- [ ] Valid YAML metadata
- [ ] No major spelling errors
- [ ] Functional links
- [ ] Readable diagrams

### Technical

- [ ] Solution tested in production
- [ ] Compliance with enterprise security standards
- [ ] Validated performance
- [ ] Scalability considered
- [ ] Dependencies identified

### Proven-in-use

- [ ] Required minimum documented:
  - Domain PRA: 1+ for Candidate and Approved
  - Bank-Wide PRA: 1+ for Candidate, 3+ (multi-domain) for Approved
- [ ] Real named projects
- [ ] Feedback with metrics
- [ ] Recent dates (< 2 years)

### Reusability

- [ ] Generalizable pattern
- [ ] Configurable parameters
- [ ] Adapted to multiple contexts
- [ ] No single-project specificities

##  Quality Metrics

PRAs are evaluated on:

### Completeness (40%)

- Complete documentation
- ADRs provided
- Examples present
- Proven-in-use documented

### Clarity (30%)

- Easily understandable
- Clear diagrams
- Actionable instructions
- Logical structure

### Usefulness (20%)

- Solves a real problem
- Demonstrated time savings
- Growing adoption
- Positive feedback

### Maintenance (10%)

- Active maintainer
- Regular updates
- Responses to questions
- Continuous evolution

##  Reasons for Rejection

A PRA may be rejected for:

### Insufficient Quality

-  Incomplete or confusing documentation
-  No credible proven-in-use
-  Solution not tested in production
-  Lack of concrete examples

### Non-Reusability

-  Too specific to a single project
-  Not generalizable
-  Non-recurring problem

### Non-Compliance

-  Violation of security standards
-  Unapproved technologies
-  Non-compliance with enterprise guidelines

### Duplication

-  Similar PRA already exists
-  No added value vs. existing
-  Merge recommended with existing PRA

##  Continuous Improvement

### Annual Review

All Approved PRAs undergo an annual review:

-  Technical relevance
-  Adoption level
-  Documentation quality
-  Maintenance activity

Possible outcomes:
- **Maintain**: PRA remains approved
- **Improve**: Requires updates
- **Deprecate**: Obsolete or superseded

### Community Feedback

Users can:
- Propose improvements (PR)
- Report errors (Issues)
- Suggest clarifications
- Share new learnings

##  Quality Support

For questions about standards:

- **Teams Channel**: `#pra-quality`
- **Domain Committees**: Contact your domain governance committee
- **Expert Architects Committee Email**: pra-governance@company.com
- **Template Documentation**: [Link to template]

---

**Recommended path**:
1. [Getting Started with PRAs](/guides/01-getting-started)
2. [Understanding PRAs](/guides/02-understanding-pra)
3. [Roles and Responsibilities](/guides/03-roles-responsibilities)
4. [Lifecycle](/guides/04-lifecycle)
5.  **Quality Standards** (you are here)
6. [Contributing a PRA](/guides/06-contributing)
7. [Promotion Process](/guides/07-promotion-process)
8. [Governance](/guides/08-governance)

---

**Navigation**:
-  **Previous**: [Lifecycle](/guides/04-lifecycle)
-  **Next**: [Contributing a PRA](/guides/06-contributing)

---

**Last updated**: 2025-12-02
**Next review**: 2026-06-02
