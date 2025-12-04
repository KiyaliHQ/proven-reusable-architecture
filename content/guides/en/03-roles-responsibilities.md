---
title: 03. Roles and Responsibilities
description: The different actors in the PRA registry and their responsibilities
---

# Roles and Responsibilities

This document defines the key roles in the PRA registry ecosystem and their respective responsibilities.

##  Roles Overview

```mermaid
graph TD
    GOV_DOM[Domain Governance Committees] --> ARCH[Contributing Architects]
    GOV_BW[Expert Architects Governance Committee] --> ARCH
    INIT[Initiative Team] --> ARCH
    ARCH --> MAIN[PRA Maintainers]
    MAIN --> USERS[PRA Users]

    GOV_DOM -.-> GOV_BW

    style GOV_DOM fill:#60a5fa,stroke:#2563eb,color:#fff
    style GOV_BW fill:#8b5cf6,stroke:#7c3aed,color:#fff
```

##  Domain Governance Committees

### Composition

- **Number**: 3 to 5 architects per domain
- **Profiles**: Solution architects from the domain
- **Representation**: Different teams within the domain (Retail, Corporate, Wealth Management)
- **Term**: Renewable annually
- **Decisions**: By consensus or majority vote

### Responsibilities

#### 1. Review Domain PRAs

- Evaluate new domain PRAs technically and qualitatively
- Verify compliance with standards
- Validate applicability within the domain
- **Timeline**: Initial review within 5 business days

#### 2. Approve Domain PRAs

**For Domain PRAs Approved**:
- Validate compliance with template
- Verify 1+ proven-in-use within the domain
- Approve transition to Approved status (domain level)
- **Threshold**: 2 approvals required in domain committee

#### 3. Identify Bank-Wide Candidates

- Identify domain PRAs reusable outside the domain
- Propose Domain → Bank-Wide promotions
- Provide justification and proof of reusability

#### 4. Local Maintenance

- Quarterly review of domain PRAs
- Identify obsolete PRAs in the domain
- Adapt Bank-Wide standards to domain context

### Meetings

- **Frequency**: Monthly
- **Duration**: 1 hour maximum
- **Typical agenda**:
  - Review new domain submissions (30 min)
  - Candidate domain PRA follow-up (15 min)
  - Bank-Wide candidate identification (10 min)
  - Miscellaneous questions (5 min)

### Expected Commitment

- **Time**: 2-3 hours/month
- **Availability**: PR review within 48h
- **Participation**: 80%+ meetings

##  Expert Architects Governance Committee

### Composition

- **Number**: 5 to 7 expert architects
- **Profiles**: Expert architects close to practice
- **Representation**: Cross-domain and cross-cutting teams
- **Term**: Renewable annually
- **Decisions**: By consensus or 2/3 vote

### Responsibilities

#### 1. Review Bank-Wide PRAs

- Evaluate Bank-Wide standard PRAs (Flow 2: cross-cutting teams)
- Evaluate Domain → Bank-Wide promotions (Flow 1)
- Manage Bootstrap: identify and validate priorities (Flow 3)
- **Timeline**: Review within 2 weeks

#### 2. Approve Bank-Wide PRAs

**For Bank-Wide PRAs Approved**:
- Verify 3+ proven-in-use (different domains/teams)
- Validate multi-domain applicability
- Verify compliance with BNC target architecture
- Approve transition to Bank-Wide Approved status
- **Threshold**: 2 approvals required in committee

#### 3. Strategic Governance

- Approve Domain → Bank-Wide promotions
- Approve Bank-Wide deprecations (with multi-domain consultation)
- Validate new standards from cross-cutting teams
- Arbitrate cross-domain conflicts

#### 4. Bootstrap and Prioritization

- Identify priority Bank-Wide topics
- Search for existing candidates in domains
- Validate direct promotion (bypass standard Domain process)
- **Note**: Transitional flow, will decrease as registry matures

### Meetings

- **Frequency**: Biweekly (every 2 weeks)
- **Duration**: 1.5 hours maximum
- **Typical agenda**:
  - Review Bank-Wide PRAs (Flow 2) (30 min)
  - Review Domain → Bank-Wide promotions (Flow 1) (30 min)
  - Bootstrap and priorities (Flow 3) (20 min)
  - Strategic topics (10 min)

### Expected Commitment

- **Time**: 3-5 hours/month
- **Availability**: PR review within 72h
- **Participation**: 80%+ meetings

##  PRA Initiative Team

### Composition

- **Number**: 2-3 dedicated people
- **Profiles**:
  - 1 Senior Architect (lead)
  - 1 DevOps/Platform Engineer
  - 1 Developer Experience (DX) Specialist (optional)

### Responsibilities

#### 1. Infrastructure & Tooling

- Maintain Git repository and structure
- Manage Fumadocs site and Orama search
- Maintain GitHub Actions workflows
- Manage Confluence sync
- Monitoring and alerts

#### 2. Community Support

- Answer questions on `#pra-registry`
- Help contributors with templates and processes
- Organize training sessions
- Create documentation and guides

#### 3. Continuous Evolution

- Propose process improvements
- Implement new features
- Collect and analyze feedback
- Roadmap and prioritization

#### 4. Communication

- Monthly newsletter
- New PRA announcements
- Sector  transversal promotions
- Adoption stats and metrics

### Expected Commitment

- **Time**: 20-40% work time
- **Availability**: Active community support
- **Proactivity**: Continuous improvement

##  Contributing Architects

### Who are they?

**All architects** in the organization can contribute:
- Enterprise architects
- Solution architects
- Technical architects
- Sector architects

### Responsibilities

#### 1. Identify Reusable Patterns

- Observe recurring patterns in projects
- Identify proven production solutions
- Evaluate reusability and generalization

#### 2. Document PRAs

- Use official template
- Provide complete context and ADRs
- Include examples and proven-in-use
- Respect quality standards

#### 3. Maintain their PRAs

- Answer user questions
- Integrate feedback and learnings
- Update documentation
- Propose evolutions

#### 4. Review PRAs

- Participate in PR reviews
- Provide constructive feedback
- Validate applicability in their context
- Share similar experience

### Rights

-  **Free choice**: No obligation to use a PRA
-  **Full access**: All approved and candidate PRAs
-  **Support**: Initiative team assistance
-  **Visibility**: Contribution recognition

### Duties

-  **Justification**: Explain if not using an applicable PRA
-  **Feedback**: Share feedback on used PRAs
-  **Documentation**: Document proven-in-use
-  **Respect**: Follow processes and standards

##  PRA Maintainers

### Who are they?

Architects designated as responsible for one or more specific PRAs.

### Responsibilities

#### 1. PRA Ownership

- Ensure quality and currency
- Decide evolutions and modifications
- Validate PRs from external contributions

#### 2. Documentation

- Keep documentation up to date
- Enrich with new learnings
- Clarify ambiguous points
- Add examples

#### 3. User Support

- Answer questions about the PRA
- Help adoption in new projects
- Unblock implementation issues
- Collect feedback

#### 4. Evolution

- Propose improvements based on feedback
- Adapt to new technology versions
- Identify deprecation needs
- Create successor versions if necessary

### Commitment Duration

- **Minimum**: 1 year
- **Transfer**: Possible with Governance Table validation
- **Rotation**: Encouraged every 2-3 years

##  PRA Users

### Who are they?

- **Developers**: Implement PRAs in code
- **Architects**: Use PRAs in designs
- **Product Owners**: Reference PRAs in specs
- **Tech Leads**: Recommend PRAs to their teams

### Responsibilities

#### 1. Appropriate Use

- Understand PRA application context
- Respect guidelines and best practices
- Adapt to project specificities (with justification)

#### 2. Feedback

- Document implementation (proven-in-use)
- Report problems or limitations
- Propose improvements
- Share learnings

#### 3. Contribution

- Enrich examples and use cases
- Correct documentation errors
- Propose clarifications
- Help other users

### Rights

-  **Free access**: All PRAs without restriction
-  **Support**: Help from maintainers and community
-  **Adaptation**: Flexibility in implementation (justified)
-  **Contribution**: Propose modifications via PR

##  RACI Matrix

| Activity | Domain Committees | Expert Committee | Init. Team | Contributors | Maintainers | Users |
|----------|-------------------|------------------|------------|--------------|-------------|-------|
| Submit Domain PRA | C | I | I | **R** | I | I |
| Review Domain PRA | **R/A** | I | C | C | I | I |
| Approve Domain PRA | **A** | I | I | I | C | I |
| Submit Bank-Wide PRA | I | C | I | **R** | I | I |
| Review Bank-Wide PRA | I | **R/A** | C | C | I | I |
| Approve Bank-Wide PRA | I | **A** | I | I | C | I |
| Propose Domain→BW promotion | **R** | C | I | C | C | I |
| Approve Domain→BW promotion | C | **A** | I | C | C | I |
| Bootstrap (identify priorities) | C | **R/A** | C | I | I | I |
| Maintain infrastructure | I | I | **R/A** | I | I | I |
| Maintain PRA | I | I | C | I | **R/A** | C |
| Use PRA | I | I | I | I | C | **R/A** |
| Deprecate Domain PRA | **A** | I | C | C | R | C |
| Deprecate Bank-Wide PRA | C | **A** | C | C | R | C |
| Train community | I | I | **R/A** | C | C | I |

**Legend**:
- **R**: Responsible (does the work)
- **A**: Accountable (makes decisions)
- **C**: Consulted (provides input)
- **I**: Informed (receives notification)

##  Contacts

### Domain Governance Committees
- **Retail**: `#pra-retail` | pra-retail@company.com
- **Corporate**: `#pra-corporate` | pra-corporate@company.com
- **Wealth Management**: `#pra-wm` | pra-wm@company.com

### Expert Architects Governance Committee
- **Teams Channel**: `#pra-governance`
- **Email**: pra-governance@company.com
- **Members**: See [Governance Page](/guides/08-governance)

### Initiative Team
- **Teams Channel**: `#pra-initiative`
- **Email**: pra-team@company.com
- **Lead**: [Team Lead Name]

### Community Support
- **Teams Channel**: `#pra-registry`
- **Email**: pra-support@company.com
- **GitHub Issues**: [Repository Link]

---

**Recommended Path**:
1. [Getting Started with PRAs](/guides/01-getting-started)
2. [Understanding PRAs](/guides/02-understanding-pra)
3.  **Roles and Responsibilities** (you are here)
4. [Lifecycle](/guides/04-lifecycle)
5. [Quality Standards](/guides/05-standards)
6. [Contributing a PRA](/guides/06-contributing)
7. [Promotion Process](/guides/07-promotion-process)
8. [Governance](/guides/08-governance)

---

**Navigation**:
-  **Previous**: [Understanding PRAs](/guides/02-understanding-pra)
-  **Next**: [Lifecycle](/guides/04-lifecycle)

---

**Last updated**: 2025-12-02
**Next review**: 2026-06-02
