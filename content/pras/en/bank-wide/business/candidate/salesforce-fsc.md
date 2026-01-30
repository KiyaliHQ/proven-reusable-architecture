---
title: "Promotion: Salesforce FSC"
description: Salesforce FSC promotion file to Transversal
---

# Promotion File: Salesforce FSC

## Executive Summary

**Proven Reusable Architecture**: Salesforce Financial Services Cloud (FSC)
**Origin Sector**: Wealth Management
**Status**: Phase 2 - Review (In Progress)
**Submission Date**: October 2024
**Owner**: Marie Bouchard (marie.bouchard@bnc.ca)

## Phase 1: Proposal ✅ COMPLETED

### Context

Salesforce FSC has been deployed for **18 months** in the Wealth Management sector with **100%** adoption by 50+ advisors. The solution currently manages **5,000+ HNW/UHNW clients** representing **$15B+ AUM**.

### Promotion Justification

#### Multi-Sector Applicability

**Identified Target Sectors**:

1. **Corporate** (SME & Corporate)
   - Commercial relationship management
   - Financing opportunities
   - Sales pipeline tracking
   - **Adaptation**: ~20% (corporate modules)

2. **Institutional**
   - Institutional investor management
   - Regulatory reporting
   - Event communications
   - **Adaptation**: ~15% (compliance modules)

3. **Retail** (High-touch segments)
   - Premium clients
   - Personalized services
   - Cross-sell opportunities
   - **Adaptation**: ~25% (mass market features)

#### Demonstrated ROI

**Business Metrics**:
- Client onboarding time: **-50%** (4 days → 2 days)
- Client satisfaction: **+15%** (4.0 → 4.6/5)
- Cross-sell rate: **+25%**
- Compliance incidents: **-80%**

**Technical Metrics**:
- User satisfaction: **4.2/5**
- System availability: **99.95%**
- Response time (p95): **< 2s**
- Mobile adoption: **40%**

#### Proven-in-Use

- **Duration**: 18 months in production
- **Critical incidents**: 0 (last 6 months)
- **Uptime**: 99.95%
- **Support tickets**: ~5/month (all minor)

### Architecture

See full details in [Salesforce FSC - Wealth Management](/registre/secteurs/gestion-patrimoine/integration/salesforce-fsc).

**Stack**:
- Salesforce FSC Enterprise
- MuleSoft Anypoint Platform
- Salesforce Data Cloud
- Shield Platform Encryption

**Integrations**:
- Core Banking System
- Portfolio Management (Bloomberg AIM)
- Document Management (OpenText)

## Phase 2: Review 🔄 IN PROGRESS

### Technical Assessment (EAC)

**Committee**: Enterprise Architecture Committee
**Start Date**: November 2024
**Estimated End Date**: December 2024

#### Assessment Criteria

| Criteria | Score | Comment |
|---------|-------|-------------|
| Architecture | 9/10 | Solid, clear patterns |
| Scalability | 8/10 | Tested up to 10k users |
| Security | 10/10 | Shield + HSM compliant |
| Costs | 7/10 | Expensive licensing at scale |
| Documentation | 9/10 | Excellent documentation |
| Support | 8/10 | Competent team |

**Overall Score**: 8.5/10 ✅

#### Identified Strengths

✅ **Mature architecture**: 18 months in production, established patterns
✅ **Robust integrations**: MuleSoft well implemented
✅ **Security**: Shield Encryption + full compliance
✅ **Adoption**: 100% in origin sector
✅ **Mobility**: High-performing mobile app

#### Points of Attention

⚠️ **Costs**: $300/user/month, may be prohibitive at large scale
⚠️ **Vendor lock-in**: Strong dependency on Salesforce ecosystem
⚠️ **Customizations**: Risk of over-customization by sector
⚠️ **Data residency**: Data hosted by Salesforce (CA but US-owned)
⚠️ **Training**: Significant learning curve

#### EAC Recommendations

**Recommendation**: ✅ **APPROVED with conditions**

**Conditions**:

1. **Governance Framework**
   - Create Salesforce Center of Excellence (CoE)
   - Strict customization standards
   - Quarterly architecture review

2. **Cost Optimization**
   - Volume-based licensing negotiation
   - User tiering (full vs limited licenses)
   - ROI monitoring per sector

3. **Technical Standards**
   - Mandatory pattern documentation
   - Code review process
   - Automated testing (80%+ coverage)

4. **Data Governance**
   - Data residency policy
   - Backup/DR strategy
   - PIPEDA compliance review

### Multi-Sector Analysis

#### Sector: Corporate

**Owner**: Jean-François Morin (Corporate sector)

**Use Cases**:
- Commercial relationship management (8,000 clients)
- Financing opportunity pipeline
- Banking product cross-sell
- Commercial activity reporting

**Required Adaptations**:
- Corporate management module
- Client ERP integration (SAP)
- Complex approval workflows
- Multi-currency support

**Estimated Effort**: 4 months, 3 developers

**Expected ROI**:
- Opportunity conversion: +30%
- New client setup time: -40%
- Pipeline visibility: +100%

**Decision**: ✅ Recommends adoption (Q2 2025)

#### Sector: Institutional

**Owner**: Claude Mercier (Institutional sector)

**Use Cases**:
- Institutional investor management
- Regulatory reporting (AMF, IIROC)
- Corporate event communications
- Performance tracking

**Required Adaptations**:
- Compliance modules (AMF/IIROC)
- Advanced reporting
- Enhanced document management
- Improved audit trail

**Estimated Effort**: 5 months, 3 developers

**Expected ROI**:
- Compliance reporting: -60% time
- Client satisfaction: +20%
- Audit findings: -50%

**Decision**: ✅ Recommends adoption (Q3 2025)

#### Sector: Retail

**Owner**: François Leblanc (Retail sector)

**Use Cases**:
- Premium clients (high-end segment)
- Personalized services
- Complex product cross-sell
- Relationship management

**Required Adaptations**:
- Mass-market features (vs. high-touch)
- Mobile banking integration
- Self-service portal
- Cost optimization (licensing)

**Estimated Effort**: 6 months, 4 developers

**Expected ROI**:
- Premium segment growth: +25%
- Cross-sell: +20%
- Customer churn: -15%

**Decision**: ⏸️ Phase 2 (after Corporate and Institutional)

### Generalization Cost Estimates

#### Initial Setup

| Item | Cost |
|-------|------|
| Salesforce CoE setup | $200,000 |
| Architecture review | $50,000 |
| Migration tooling | $100,000 |
| Training program | $150,000 |
| **Total Setup** | **$500,000** |

#### Recurring Costs (Annual)

| Item | Wealth Management | Corporate | Institutional | Total |
|-------|-------------------|-------------|----------------|-------|
| User licenses (50/100/25) | $180,000 | $360,000 | $90,000 | $630,000 |
| Data Cloud | $60,000 | $100,000 | $40,000 | $200,000 |
| Shield Encryption | $45,000 | $90,000 | $22,500 | $157,500 |
| MuleSoft | $120,000 | $180,000 | $80,000 | $380,000 |
| Support & Training | $60,000 | $80,000 | $40,000 | $180,000 |
| **Total Recurring** | **$465,000** | **$810,000** | **$272,500** | **$1,547,500** |

**Total 3 years**: $500k (setup) + $4.6M (recurring) = **$5.1M**

#### ROI Projection

**Expected Benefits (3 years)**:

| Benefit | Annual Value | 3 Years |
|----------|----------------|-------|
| Productivity gains | $800,000 | $2,400,000 |
| Revenue increase (cross-sell) | $1,200,000 | $3,600,000 |
| Cost reduction (ops) | $400,000 | $1,200,000 |
| Compliance savings | $300,000 | $900,000 |
| **Total Benefits** | **$2,700,000** | **$8,100,000** |

**ROI**: ($8.1M - $5.1M) / $5.1M = **59%**
**Payback period**: **~22 months**

## Phase 3: Migration 📅 PLANNED (Q1 2025)

### Governance Validation

**Committee**: Transversal Governance Committee
**Expected Date**: January 2025

### Migration Plan

#### Workstreams

1. **Salesforce CoE Setup** (8 weeks)
   - Recruit CoE team (5 people)
   - Setup governance and standards
   - Create base template

2. **Corporate Sector** (16 weeks)
   - Corporate customizations
   - SAP integration
   - UAT with 10 pilot clients
   - Rollout 100 users

3. **Institutional Sector** (20 weeks)
   - Compliance modules
   - Advanced reporting
   - UAT with 5 pilot clients
   - Rollout 25 users

### Identified Risks

| Risk | Impact | Probability | Mitigation |
|--------|--------|-------------|------------|
| Licensing budget overrun | High | Medium | Salesforce volume negotiation |
| Adoption resistance | Medium | High | Strong change management |
| Integration complexity | High | Medium | Phased approach, PoCs |
| Data migration issues | High | Low | Automated tools + validation |
| Performance at scale | Medium | Low | Load testing before rollout |

## Phase 4: Adoption 📅 PLANNED (Q2 2025)

### Rollout Plan

#### Corporate (Q2 2025)

- **Week 1-2**: Training 20 early adopters
- **Week 3-8**: Pilot with 20 users, 50 clients
- **Week 9-16**: Rollout 80 remaining users
- **Week 17+**: Stabilization, support

#### Institutional (Q3 2025)

- **Week 1-2**: Training 10 early adopters
- **Week 3-6**: Pilot with 10 users, 20 clients
- **Week 7-12**: Rollout 15 remaining users
- **Week 13+**: Stabilization, support

### Success Metrics

**Adoption**:
- User adoption: > 80% @ 3 months
- Active usage: > 60% daily active users
- Mobile adoption: > 30%

**Business**:
- Cross-sell rate: +20% vs. baseline
- Client satisfaction: > 4.0/5
- Productivity gain: +25% vs. legacy tools

**Technical**:
- Availability: > 99.9%
- Performance: p95 < 2s
- Incident rate: < 5/month

### Support Model

**Salesforce CoE**:
- 2 Architects
- 3 Developers
- 2 Admins
- 1 Product Owner

**Support Tiers**:
- L1: Sector teams (basic questions)
- L2: CoE (configuration, bugs)
- L3: Salesforce support (platform issues)

## Current Status

**Current Phase**: Phase 2 - Review
**Next Milestone**: EAC Validation (December 2024)
**Phase 3 Expected Date**: January 2025
**Phase 4 Expected Date**: Q2-Q3 2025

## Reference Documents

- [Salesforce FSC - Wealth Management Sector](/registre/secteurs/gestion-patrimoine/integration/salesforce-fsc)
- [Architecture Decision Record (ADR)](https://docs.bnc.ca/adr/salesforce-fsc-transversal)
- [Cost-Benefit Analysis](https://docs.bnc.ca/cba/salesforce-fsc)
- [Risk Assessment](https://docs.bnc.ca/risks/salesforce-fsc)

## Contacts

**File Owner**: Marie Bouchard (marie.bouchard@bnc.ca)
**EAC Lead**: Alain Lefebvre (alain.lefebvre@bnc.ca)
**CoE Lead**: Luc Tremblay (luc.tremblay@bnc.ca)
**Governance**: architecture-transversale@bnc.ca
