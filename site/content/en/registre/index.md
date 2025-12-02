---
title: PRA Registry - National Bank
description: Library of proven architectures to accelerate your projects with quality and consistency
---

# Welcome to the PRA Registry

## Don't reinvent the wheel, reuse what works

Starting a new project? Looking for the best way to implement authentication, CI/CD, or Salesforce integration? **The PRA Registry is your library of production-validated architectures.**

##  What is a PRA?

A **PRA (Proven Reusable Architecture)** is a **proven solution** that has already been validated in real projects at the National Bank.

```mermaid
graph LR
    A[Recurring problem] --> B[Documented solution]
    B --> C[Production validated]
    C --> D[Reusable]
    D --> E[PRA]
```

### In 4 key points

 **Production proven**: Validated in at least 3 real implementations at BNC
 **Reusable**: Generalizable across different contexts and projects
 **Documented**: With context, architectural decisions (ADRs), code examples, and feedback from experience
 **Maintained**: Versioned and supported by the BNC architecture community

### Simple analogy

Think of PRAs as **proven cooking recipes**:

- The recipe (the PRA) has been tested multiple times
- It works in different kitchens (contexts)
- It documents the ingredients (tech stack), steps (implementation), and pitfalls to avoid
- You can adapt it to your taste (your context)

##  Quick Start

### Are you a developer?

**Need: "I need to implement authentication"**

1.  Go to [Transversal > Security](/registre/transversal)
2.  Find the "Authentication & SSO" PRA
3.  Check if your context matches
4.  Follow the implementation guide
5.  Document your feedback

### Are you an architect?

**Need: "I want to contribute a validated architecture"**

1.  Review the [Quality Standards](/registre/05-standards)
2.  Prepare your documentation (ADRs, examples, proven-in-use)
3.  Follow the [Contribution Guide](/registre/06-contributing)
4.  Submit your PRA to the Governance Table

### Are you discovering PRAs?

**Need: "I want to understand the PRA system"**

Follow our **8-step guided journey**:

1. [Getting Started with PRAs](/registre/01-getting-started) - Introduction and first steps
2. [Understanding PRAs](/registre/02-understanding-pra) - Detailed anatomy
3. [Roles and Responsibilities](/registre/03-roles-responsibilities) - Who does what
4. [Lifecycle](/registre/04-lifecycle) - From Candidate to Approved
5. [Quality Standards](/registre/05-standards) - Criteria for excellence
6. [Contributing a PRA](/registre/06-contributing) - Submission process
7. [Promotion Process](/registre/07-promotion-process) - Sectoral  Transversal
8. [Governance](/registre/08-governance) - Structure and decisions

##  Registry Organization

The registry is organized into **3 scopes** based on their reach:

###  Transversal

**For whom?** All sectors of the National Bank
**Maturity**: Validated by the Transversal Governance Table
**Examples**: SSO Authentication, GitOps CI/CD, API Gateway, RBAC/ABAC

 [Explore Transversal PRAs](/registre/transversal)

###  Sectors

**For whom?** Teams from a specific sector (Retail, Corporate, Wealth Management)
**Maturity**: Validated within their sector, awaiting transversal promotion
**Examples**: Digital Onboarding (Retail), SAP ERP Integration (Corporate)

 [Explore Sectoral PRAs](/registre/secteurs)

###  In Promotion

**For whom?** Everyone (under observation)
**Status**: Sectoral patterns proposed to become transversal
**Purpose**: See emerging patterns before their generalization

 [Explore PRAs in Promotion](/registre/en-promotion)

##  PRA Categories

Regardless of scope, PRAs are organized into 4 categories:

###  Tech

Infrastructure and platform patterns

**Examples**: CI/CD, Observability (Prometheus/Grafana), Infrastructure as Code (Terraform), Orchestration (Kubernetes)

###  Integration

Inter-system integration patterns

**Examples**: API Gateway, Message Broker (Kafka/RabbitMQ), Event-Driven Architecture, Data Synchronization

###  Security

Security and compliance patterns

**Examples**: RBAC/ABAC, Secrets Management (Vault), Network Security (Zero Trust), Audit & Compliance

###  Business

Reusable business patterns

**Examples**: Customer Onboarding, Payment Processing, Notification System, Workflow Orchestration

##  Why use PRAs?

###  Time Savings

- No need to reinvent the wheel
- Ready-to-use solutions with code examples
- Documented feedback = fewer trial-and-error iterations

**Concrete example**: Implementing GitOps CI/CD with ArgoCD takes 2 days instead of 2 weeks of research and POCs.

###  Quality

- Solutions validated in real production
- Built-in best practices
- Common pitfalls documented and avoided

**Concrete example**: The "RBAC with CASL" PRA includes edge cases for permission management that you would have discovered after several bugs.

###  Consistency

- Architectural alignment across teams
- Common vocabulary (fewer misunderstandings)
- Shared standards (easier to maintain)

**Concrete example**: All projects use the same observability stack  a new architect can quickly understand any project.

###  Measurable ROI

- **40-60% reduction** in architecture design time
- **+30%** code and component reuse
- **-50%** production incidents (thanks to documented learnings)

##  Frequently Asked Questions

### Must I use a PRA?

**No.** PRAs are **recommendations**, not obligations.

**But**: If an applicable PRA exists and you don't use it, you'll need to justify why during architecture reviews (to avoid duplication of efforts).

### Can I adapt a PRA to my context?

**Yes, absolutely!** PRAs are **patterns**, not frozen code.

**Important**: Document your adaptations and share your learnings to enrich the PRA.

### How many PRAs are there currently?

The registry currently contains:
- **~15 Transversal PRAs** (validated for everyone)
- **~20 Sectoral PRAs** (specific to a sector)
- **~5 PRAs in Promotion** (undergoing transversal validation)

### How are PRAs validated?

Each PRA goes through a rigorous process:

1. **Submission**  Technical review by the Governance Table
2. **Candidate**  Validated with 1+ proven-in-use
3. **Approved**  Validated with 3+ proven-in-use from different teams

[Learn more about the Lifecycle](/registre/04-lifecycle)

### Who decides if a sectoral PRA becomes transversal?

The **Transversal Governance Table** (5-7 senior cross-team architects).

[Learn more about Governance](/registre/08-governance)

##  Next Steps

### Are you in a hurry?

 [Explore the Transversal catalog](/registre/transversal) and find a PRA for your needs

### Do you have 15 minutes?

 Follow the [Getting Started Guide](/registre/01-getting-started) for a complete introduction

### Do you want to understand everything?

 Go through the [8 numbered guides](/registre/01-getting-started) in order

##  Need Help?

- **Teams Channel**: `#pra-registry`
- **Email**: pra-support@company.com
- **GitHub Issues**: [Open an issue](https://github.com/org/pra-registry/issues)
- **Governance Table**: pra-governance@company.com

---

**Last updated**: 2025-11-28
**Active contributors**: 45+ BNC architects
**Validated PRAs**: 40+ proven patterns
