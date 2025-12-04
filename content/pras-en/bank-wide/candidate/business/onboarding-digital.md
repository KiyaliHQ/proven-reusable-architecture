---
title: "Promotion: Digital Onboarding"
description: Promotion dossier for Digital Onboarding to Transversal
---

# Promotion Dossier: Digital Onboarding

## Executive Summary

**Proven Reusable Architecture**: Digital Customer Onboarding
**Origin Sector**: Retail Banking
**Status**: Phase 2 - Review (In Progress)
**Submission Date**: September 2024
**Champion**: François Leblanc (francois.leblanc@bnc.ca)

## Phase 1: Proposal ✅ COMPLETED

### Context

Digital Onboarding has been deployed for **12 months** in the Retail Banking sector with **75%** adoption among new customers. The solution has onboarded **170,000+ customers** with an average time of **8.5 minutes** and a completion rate of **68%**.

### Promotion Justification

#### Multi-Sector Applicability

**Target sectors identified**:

1. **Corporate Banking** (SMBs)
   - Business account onboarding
   - Corporate document validation
   - Multi-signing (administrators)
   - **Adaptation**: ~40% (corporate workflows)

2. **Wealth Management**
   - HNW/UHNW client onboarding
   - Enhanced due diligence
   - Investment profile questionnaire
   - **Adaptation**: ~30% (compliance & wealth features)

3. **Young Adults** (18-25 years)
   - Ultra-simplified onboarding
   - Mobile-first
   - Gamification
   - **Adaptation**: ~15% (UX simplification)

#### Demonstrated ROI

**Business Metrics**:
- Cost per acquisition: **-60%** ($25 → $2.50 vs branch)
- Time to account: **< 10 minutes** (vs 2-3 days in branch)
- Customer satisfaction: **4.5/5**
- First month activation: **85%**
- Branch traffic reduction: **-35%**

**Technical Metrics**:
- Availability: **99.8%**
- Completion rate: **68%** (vs 40% industry)
- Identity verification success: **92%**
- Mobile usage: **60%**

#### Proven-in-Use

- **Duration**: 12 months in production
- **Volume**: 170,000+ customers onboarded
- **Critical incidents**: 0 (last 6 months)
- **Support tickets**: ~15/month (all minor)

### Architecture

See full details in [Digital Onboarding - Retail Banking](/registre/secteurs/particuliers/business/onboarding-digital).

**Stack**:
- Frontend: React SPA + React Native
- Backend: Node.js (NestJS)
- Database: PostgreSQL 14
- Queue: RabbitMQ
- Storage: AWS S3

**Integrations**:
- Identity Verification (Jumio)
- Credit Bureau (Equifax/TransUnion)
- eSignature (DocuSign)
- Core Banking System

## Phase 2: Review 🔄 IN PROGRESS

### Technical Assessment (EAC)

**Committee**: Enterprise Architecture Committee
**Start Date**: October 2024
**Estimated End Date**: November 2024

#### Evaluation Criteria

| Criterion | Score | Comment |
|-----------|-------|---------|
| Architecture | 9/10 | Modern, microservices |
| Scalability | 10/10 | Proven at 50k+ customers/month |
| Security | 9/10 | PIPEDA/FINTRAC compliant |
| Costs | 9/10 | Very economical ($2.50/customer) |
| Documentation | 8/10 | Good, can be improved |
| Support | 7/10 | Small but effective team |

**Overall Score**: 8.7/10 ✅

#### Strengths Identified

✅ **Exceptional ROI**: -60% cost vs branch
✅ **User experience**: 4.5/5 satisfaction
✅ **Proven scalability**: 170k+ customers in 12 months
✅ **Mobile-first**: 60% mobile usage
✅ **Quick wins**: < 10 minutes time-to-account

#### Points of Attention

⚠️ **Customization by sector**: Very different workflows (B2C vs B2B)
⚠️ **Compliance**: Different rules by sector (retail vs wealth)
⚠️ **Identity verification**: Different approaches (individuals vs corporate)
⚠️ **Integration complexity**: Each sector has its own Core Banking
⚠️ **Support model**: Requires team scaling

#### EAC Recommendations

**Recommendation**: ✅ **APPROVED with conditions**

**Conditions**:

1. **Modular Architecture**
   - Refactoring into reusable modules
   - Plugin system for sector workflows
   - Shared core + sector plugins

2. **Compliance Framework**
   - Rules engine abstraction
   - Configuration per sector
   - Centralized audit trail

3. **Testing Strategy**
   - Automated E2E tests (> 80% coverage)
   - Multi-sector load testing
   - Security penetration tests

4. **Documentation**
   - Architecture Decision Records
   - Integration guides per sector
   - Operational runbooks

### Multi-Sector Analysis

#### Sector: Corporate Banking (SMBs)

**Champion**: Jean-François Morin (Corporate Banking sector)

**Use Cases**:
- Business account onboarding (8,000 SMBs)
- Credit line opening
- Merchant services setup
- Corporate online banking activation

**Required Adaptations**:
- Corporate document validation (NEQ, bylaws)
- Multi-signing workflow (2-3 signatories)
- Integration with REQ (Quebec Enterprise Registry)
- Enhanced KYB (Know Your Business)
- Corporate credit check (D&B)

**Estimated Effort**: 5 months, 4 developers

**Expected ROI**:
- Onboarding time: -50% (5 days → 2.5 days)
- Cost per client: -40% ($50 → $30)
- Satisfaction: +25%

**Challenges**:
- Workflow complexity (multi-signing)
- Varied document validation
- REQ/D&B integration

**Decision**: ✅ Recommends adoption (Q1 2025)

#### Sector: Wealth Management

**Champion**: Marie Bouchard (Wealth Management sector)

**Use Cases**:
- HNW/UHNW client onboarding (5,000 clients)
- Investment account opening
- Brokerage services setup
- Enhanced KYC

**Required Adaptations**:
- Enhanced due diligence (EDD)
- Source of funds verification
- Investment profile questionnaire
- Suitability assessment
- PEP/Sanctions screening
- AML enhanced checks

**Estimated Effort**: 6 months, 4 developers

**Expected ROI**:
- Onboarding time: -40% (4 days → 2.4 days)
- Cost per client: -30% ($100 → $70)
- Compliance errors: -60%

**Challenges**:
- Strict regulation (AMF/IIROC)
- Enhanced KYC/AML
- High document requirements

**Decision**: ✅ Recommends adoption (Q2 2025)

#### Sector: Young Adults (18-25)

**Champion**: François Leblanc (Retail Banking sector - segment)

**Use Cases**:
- Ultra-simplified onboarding
- Student account
- First credit card
- Mobile banking

**Required Adaptations**:
- Ultra-simplified UX (< 5 minutes)
- Gamification (rewards, badges)
- Social features (sharing, referrals)
- Minimal documentation
- Student verification

**Estimated Effort**: 3 months, 3 developers

**Expected ROI**:
- Acquisition: +50% (vs current)
- Time to account: < 5 minutes
- Mobile adoption: > 90%

**Challenges**:
- Balance simplicity vs compliance
- Limited credit check (low history)

**Decision**: ✅ Recommends adoption (Q2 2025)

### Generalization Cost Estimation

#### Initial Setup

| Item | Cost |
|------|------|
| Architecture refactoring | $300,000 |
| Modular plugin system | $200,000 |
| Compliance framework | $150,000 |
| Testing automation | $100,000 |
| Documentation | $50,000 |
| **Total Setup** | **$800,000** |

#### Recurring Costs (Annual)

| Item | Retail | Corporate | Wealth Mgmt | Young Adults | Total |
|------|--------|-----------|-------------|--------------|-------|
| Infrastructure (AWS) | $96,000 | $60,000 | $36,000 | $48,000 | $240,000 |
| 3rd-party APIs | $144,000 | $100,000 | $80,000 | $60,000 | $384,000 |
| Support & Ops | $60,000 | $40,000 | $30,000 | $30,000 | $160,000 |
| **Total Recurring** | **$300,000** | **$200,000** | **$146,000** | **$138,000** | **$784,000** |

**Total 3 years**: $800k (setup) + $2.35M (recurring) = **$3.15M**

#### ROI Projection

**Expected Benefits (3 years)**:

| Sector | Customers/year | Savings/customer | Savings 3 years |
|--------|---------------|------------------|-----------------|
| Retail | 144,000 | $22.50 | $9,720,000 |
| Corporate | 2,000 | $20.00 | $120,000 |
| Wealth Management | 1,000 | $30.00 | $90,000 |
| Young Adults | 36,000 | $22.50 | $2,430,000 |
| **Total** | **183,000** | - | **$12,360,000** |

**ROI**: ($12.36M - $3.15M) / $3.15M = **292%** 🎯
**Payback period**: **~9 months**

## Phase 3: Migration 📋 PLANNED (Q1 2025)

### Governance Validation

**Committee**: Transversal Governance Committee
**Planned Date**: December 2024

### Migration Plan

#### Workstreams

1. **Architecture Refactoring** (12 weeks)
   - Modular plugin system
   - Shared core extraction
   - Sector-specific plugins

2. **Compliance Framework** (8 weeks)
   - Rules engine abstraction
   - Configurable workflows
   - Centralized audit trail

3. **Corporate Banking Sector** (20 weeks)
   - Corporate onboarding plugin
   - REQ integration
   - Multi-signing workflow
   - UAT with 50 SMB pilots
   - Rollout

4. **Wealth Management Sector** (24 weeks)
   - Wealth onboarding plugin
   - Enhanced KYC/AML
   - Investment profiling
   - UAT with 20 pilot clients
   - Rollout

5. **Young Adults Segment** (12 weeks)
   - Simplified UX
   - Gamification features
   - Student verification
   - UAT with 500 students
   - Rollout

### Identified Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Refactoring breaks existing | High | Medium | Feature flags, gradual rollout |
| Sector compliance gaps | High | Medium | Legal review per sector |
| Performance degradation | Medium | Low | Load testing, optimization |
| User confusion (multi-sector UX) | Medium | Medium | User testing, iterations |
| Integration failures | High | Low | Extensive testing, mocks |

## Phase 4: Adoption 🚀 PLANNED (Q1-Q2 2025)

### Rollout Plan

#### Corporate Banking (Q1 2025)

- **Week 1-2**: Pilot 10 SMBs
- **Week 3-8**: Pilot expansion (50 SMBs)
- **Week 9-16**: Gradual rollout (500 SMBs)
- **Week 17+**: Full rollout (8,000 SMBs)

#### Wealth Management (Q2 2025)

- **Week 1-2**: Pilot 5 HNW clients
- **Week 3-6**: Pilot expansion (20 clients)
- **Week 7-12**: Gradual rollout (100 clients)
- **Week 13+**: Full rollout (5,000 clients)

#### Young Adults (Q2 2025)

- **Week 1-2**: Pilot 100 students (1 university)
- **Week 3-6**: Expansion (3 universities, 500 students)
- **Week 7-12**: Full rollout (marketing campaign)

### Success Metrics

**Adoption**:
- Completion rate: > 60% (all sectors)
- Time to account: < 15 minutes (Corporate/Wealth), < 5 min (Young Adults)
- Mobile adoption: > 50% (Corporate), > 90% (Young Adults)

**Business**:
- Cost reduction: > 40% vs current methods
- Customer satisfaction: > 4.0/5 (all sectors)
- First month activation: > 80%

**Technical**:
- Availability: > 99.9%
- Performance: p95 < 3s (all sectors)
- Security incidents: 0

### Support Model

**Core Team** (Transversal):
- 1 Product Owner
- 2 Backend Developers
- 2 Frontend Developers
- 1 DevOps Engineer
- 1 QA Engineer

**Sector Teams** (Local Support):
- 1 Business Analyst per sector
- Compliance SMEs
- User training & support

## Current Status

**Current Phase**: Phase 2 - Review
**Next Milestone**: EAC Validation (November 2024)
**Planned Phase 3 Date**: December 2024
**Planned Phase 4 Date**: Q1-Q2 2025

## Reference Documents

- [Digital Onboarding - Retail Banking Sector](/registre/secteurs/particuliers/business/onboarding-digital)
- [Architecture Decision Record (ADR)](https://docs.bnc.ca/adr/onboarding-digital-transversal)
- [Cost-Benefit Analysis](https://docs.bnc.ca/cba/onboarding-digital)
- [Risk Assessment](https://docs.bnc.ca/risks/onboarding-digital)
- [Compliance Framework](https://docs.bnc.ca/compliance/onboarding-framework)

## Contacts

**Dossier Champion**: François Leblanc (francois.leblanc@bnc.ca)
**Tech Lead**: Amélie Gagnon (amelie.gagnon@bnc.ca)
**EAC Lead**: Alain Lefebvre (alain.lefebvre@bnc.ca)
**Compliance**: Marc Dupuis (marc.dupuis@bnc.ca)
**Governance**: architecture-transversale@bnc.ca
