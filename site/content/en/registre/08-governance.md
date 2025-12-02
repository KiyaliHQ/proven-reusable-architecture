---
title: 08. Governance
description: Governance structure and processes for the PRA registry
---

# PRA Registry Governance

This document defines the governance structure, roles, and processes of the PRA Registry.

## Governance Board

The Governance Board is composed of **5 to 7 senior architects** from different teams.

### Responsibilities

- **Review submissions**: Technical and qualitative evaluation of submitted PRAs
- **Approval**: Decision to transition from Candidate to Approved status
- **Maintenance**: Monitoring the evolution and relevance of PRAs
- **Standards**: Definition and evolution of quality standards

### Composition

- Minimum 5 members, maximum 7
- Cross-team representation
- Annually renewable mandate
- Decisions by consensus or majority vote

## Submission Process

### 1. Preparation

The architect prepares the PRA according to the [provided template](/templates/pra-template.md).

### 2. Submission (Pull Request)

- Fork the repository
- Create the PRA file in `pra/candidates/`
- Pull Request with detailed description

### 3. Automated Validation

GitHub Actions verifies:
- YAML format of frontmatter
- Presence of mandatory sections
- Validity of links
- At least 1 documented proven-in-use

### 4. Review by the Board

- 2-3 Board members review
- Discussion through PR comments
- Requests for clarifications or improvements

### 5. Decision

- **Approved**  Merge as Candidate
- **Rejected**  Feedback and PR closure
- **Revisions needed**  Iterations

## Approval Criteria

### Candidate PRA

 At least **1 proven implementation** in production
 Complete documentation (context, architecture, ADR, examples)
 Demonstrated reusability
 Technical quality validated by the Board

### Approved PRA

 At least **3 proven implementations** in production
 Positive feedback from user teams
 Documentation enriched with learnings
 Validity confirmed across multiple contexts

## Deprecation Process

A PRA may be deprecated if:

-  Obsolete technologies
-  Better alternatives available
-  Repeated negative feedback
-  No maintenance for 12+ months

**Process**:
1. Deprecation proposal by the Board
2. Discussion with contributors
3. Board vote
4. Migration to `deprecated` status
5. Optional: Archiving after 6 months

## Board Meetings

- **Frequency**: Biweekly (every 2 weeks)
- **Duration**: 1 hour maximum
- **Agenda**:
  - Review new submissions
  - Follow-up on candidate PRAs
  - Evolution of standards
  - Miscellaneous items

## Communication

- **Slack Channel**: `#pra-governance`
- **Email**: pra-governance@company.com
- **GitHub Issues**: For public questions and discussions

## Governance Evolution

This governance document may evolve. Any major modification must:

1. Be proposed via PR
2. Be discussed in a Board meeting
3. Be approved unanimously or by 2/3 vote

---

**Recommended path**:
1. [Getting Started with PRAs](/registre/01-getting-started)
2. [Understanding PRAs](/registre/02-understanding-pra)
3. [Roles and Responsibilities](/registre/03-roles-responsibilities)
4. [Lifecycle](/registre/04-lifecycle)
5. [Quality Standards](/registre/05-standards)
6. [Contributing a PRA](/registre/06-contributing)
7. [Promotion Process](/registre/07-promotion-process)
8.  **Governance** (you are here)

---

**Navigation**:
-  **Previous**: [Promotion Process](/registre/07-promotion-process)
-  **Back to start**: [Getting Started with PRAs](/registre/01-getting-started)
