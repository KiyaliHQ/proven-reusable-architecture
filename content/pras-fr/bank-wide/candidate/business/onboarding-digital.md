---
title: "Promotion: Onboarding Digital"
description: Dossier de promotion de l'Onboarding Digital vers Transversal
---

# Dossier de Promotion : Onboarding Digital

## Résumé Exécutif

**Proven Reusable Architecture** : Onboarding Client Digital
**Secteur d'origine** : Particuliers
**Statut** :  Phase 2 - Review (En cours)
**Date de soumission** : Septembre 2024
**Porteur** : François Leblanc (francois.leblanc@bnc.ca)

## Phase 1 : Proposition  COMPLÉTÉE

### Contexte

L'Onboarding Digital est déployé depuis **12 mois** dans le secteur Particuliers avec une adoption de **75%** des nouveaux clients. La solution a permis d'onboarder **170,000+ clients** avec un temps moyen de **8.5 minutes** et un taux de complétion de **68%**.

### Justification de la Promotion

#### Applicabilité Multi-Secteurs

**Secteurs cibles identifiés** :

1. **Entreprises** (PME)
   - Onboarding comptes business
   - Validation documents corporatifs
   - Multi-signing (administrateurs)
   - **Adaptation** : ~40% (corporate workflows)

2. **Gestion de Patrimoine**
   - Onboarding clients HNW/UHNW
   - Enhanced due diligence
   - Investment profile questionnaire
   - **Adaptation** : ~30% (compliance & wealth features)

3. **Jeunes Adultes** (18-25 ans)
   - Onboarding ultra-simplifié
   - Mobile-first
   - Gamification
   - **Adaptation** : ~15% (UX simplification)

#### ROI Démontré

**Métriques Business** :
- Cost per acquisition : **-60%** ($25  $2.50 vs succursale)
- Time to account : **< 10 minutes** (vs 2-3 jours en succursale)
- Customer satisfaction : **4.5/5**
- First month activation : **85%**
- Branch traffic reduction : **-35%**

**Métriques Techniques** :
- Availability : **99.8%**
- Completion rate : **68%** (vs 40% industrie)
- Identity verification success : **92%**
- Mobile usage : **60%**

#### Proven-in-Use

- **Durée** : 12 mois en production
- **Volume** : 170,000+ clients onboardés
- **Incidents critiques** : 0 (6 derniers mois)
- **Support tickets** : ~15/mois (tous mineurs)

### Architecture

Voir détails complets dans [Onboarding Digital - Particuliers](/registre/secteurs/particuliers/business/onboarding-digital).

**Stack** :
- Frontend : React SPA + React Native
- Backend : Node.js (NestJS)
- Database : PostgreSQL 14
- Queue : RabbitMQ
- Storage : AWS S3

**Intégrations** :
- Identity Verification (Jumio)
- Credit Bureau (Equifax/TransUnion)
- eSignature (DocuSign)
- Core Banking System

## Phase 2 : Review  EN COURS

### Évaluation Technique (CAE)

**Comité** : Comité Architecture Entreprise
**Date début** : Octobre 2024
**Date fin estimée** : Novembre 2024

#### Critères d'Évaluation

| Critère | Score | Commentaire |
|---------|-------|-------------|
| Architecture | 9/10 | Moderne, microservices |
| Scalabilité | 10/10 | Prouvé à 50k+ clients/mois |
| Sécurité | 9/10 | Conforme PIPEDA/FINTRAC |
| Coûts | 9/10 | Très économique ($2.50/client) |
| Documentation | 8/10 | Bonne, peut être améliorée |
| Support | 7/10 | Équipe petite mais efficace |

**Score global** : 8.7/10 

#### Points Forts Identifiés

 **ROI exceptionnel** : -60% coût vs succursale
 **User experience** : 4.5/5 satisfaction
 **Scalabilité prouvée** : 170k+ clients en 12 mois
 **Mobile-first** : 60% usage mobile
 **Quick wins** : < 10 minutes time-to-account

#### Points d'Attention

 **Customization par secteur** : Workflows très différents (B2C vs B2B)
 **Compliance** : Règles différentes par secteur (retail vs wealth)
 **Identity verification** : Approches différentes (individus vs corporatif)
 **Integration complexity** : Chaque secteur a son propre Core Banking
 **Support model** : Nécessite scaling de l'équipe

#### Recommandations CAE

**Recommandation** :  **APPROUVÉ avec conditions**

**Conditions** :

1. **Modular Architecture**
   - Refactoring en modules réutilisables
   - Plugin system pour workflows sectoriels
   - Shared core + sector plugins

2. **Compliance Framework**
   - Abstraction rules engine
   - Configuration par secteur
   - Audit trail centralisé

3. **Testing Strategy**
   - Automated E2E tests (> 80% coverage)
   - Load testing multi-secteurs
   - Security penetration tests

4. **Documentation**
   - Architecture Decision Records
   - Integration guides par secteur
   - Runbooks opérationnels

### Analyse Multi-Secteurs

#### Secteur : Entreprises (PME)

**Porteur** : Jean-François Morin (secteur Entreprises)

**Use Cases** :
- Onboarding comptes business (8,000 PME)
- Ouverture lignes de crédit
- Setup services marchands
- Activation banque en ligne corporative

**Adaptations nécessaires** :
- Validation documents corporatifs (NEQ, statuts)
- Multi-signing workflow (2-3 signataires)
- Intégration REQ (Registre entreprises Québec)
- Enhanced KYB (Know Your Business)
- Credit check corporate (D&B)

**Effort estimé** : 5 mois, 4 développeurs

**ROI attendu** :
- Onboarding time : -50% (5 jours  2.5 jours)
- Cost per client : -40% ($50  $30)
- Satisfaction : +25%

**Challenges** :
- Complexité workflow (multi-signing)
- Validation documents variés
- Integration REQ/D&B

**Décision** :  Recommande adoption (Q1 2025)

#### Secteur : Gestion de Patrimoine

**Porteur** : Marie Bouchard (secteur Gestion de Patrimoine)

**Use Cases** :
- Onboarding clients HNW/UHNW (5,000 clients)
- Ouverture comptes investissement
- Setup services de courtage
- KYC renforcé

**Adaptations nécessaires** :
- Enhanced due diligence (EDD)
- Source of funds verification
- Investment profile questionnaire
- Suitability assessment
- PEP/Sanctions screening
- AML enhanced checks

**Effort estimé** : 6 mois, 4 développeurs

**ROI attendu** :
- Onboarding time : -40% (4 jours  2.4 jours)
- Cost per client : -30% ($100  $70)
- Compliance errors : -60%

**Challenges** :
- Règlementation stricte (AMF/IIROC)
- Enhanced KYC/AML
- Document requirements élevés

**Décision** :  Recommande adoption (Q2 2025)

#### Secteur : Jeunes Adultes (18-25)

**Porteur** : François Leblanc (secteur Particuliers - segment)

**Use Cases** :
- Onboarding ultra-simplifié
- Compte étudiant
- Première carte de crédit
- Mobile banking

**Adaptations nécessaires** :
- UX ultra-simplifiée (< 5 minutes)
- Gamification (rewards, badges)
- Social features (partage, referrals)
- Minimal documentation
- Student verification

**Effort estimé** : 3 mois, 3 développeurs

**ROI attendu** :
- Acquisition : +50% (vs actuel)
- Time to account : < 5 minutes
- Mobile adoption : > 90%

**Challenges** :
- Balance simplicité vs compliance
- Credit check limité (historique faible)

**Décision** :  Recommande adoption (Q2 2025)

### Estimation Coûts de Généralisation

#### Setup Initial

| Poste | Coût |
|-------|------|
| Architecture refactoring | $300,000 |
| Modular plugin system | $200,000 |
| Compliance framework | $150,000 |
| Testing automation | $100,000 |
| Documentation | $50,000 |
| **Total Setup** | **$800,000** |

#### Coûts Récurrents (Annual)

| Poste | Particuliers | Entreprises | Gestion Patrimoine | Jeunes | Total |
|-------|--------------|-------------|-------------------|--------|-------|
| Infrastructure (AWS) | $96,000 | $60,000 | $36,000 | $48,000 | $240,000 |
| 3rd-party APIs | $144,000 | $100,000 | $80,000 | $60,000 | $384,000 |
| Support & Ops | $60,000 | $40,000 | $30,000 | $30,000 | $160,000 |
| **Total Recurring** | **$300,000** | **$200,000** | **$146,000** | **$138,000** | **$784,000** |

**Total 3 ans** : $800k (setup) + $2.35M (recurring) = **$3.15M**

#### ROI Projection

**Bénéfices attendus (3 ans)** :

| Secteur | Clients/an | Économie/client | Économie 3 ans |
|---------|-----------|----------------|---------------|
| Particuliers | 144,000 | $22.50 | $9,720,000 |
| Entreprises | 2,000 | $20.00 | $120,000 |
| Gestion Patrimoine | 1,000 | $30.00 | $90,000 |
| Jeunes Adultes | 36,000 | $22.50 | $2,430,000 |
| **Total** | **183,000** | - | **$12,360,000** |

**ROI** : ($12.36M - $3.15M) / $3.15M = **292%** 
**Payback period** : **~9 mois**

## Phase 3 : Migration  PLANIFIÉE (Q1 2025)

### Validation Gouvernance

**Comité** : Comité de Gouvernance Transversal
**Date prévue** : Décembre 2024

### Plan de Migration

#### Workstreams

1. **Architecture Refactoring** (12 semaines)
   - Modular plugin system
   - Shared core extraction
   - Sector-specific plugins

2. **Compliance Framework** (8 semaines)
   - Rules engine abstraction
   - Configurable workflows
   - Audit trail centralisé

3. **Secteur Entreprises** (20 semaines)
   - Corporate onboarding plugin
   - REQ integration
   - Multi-signing workflow
   - UAT avec 50 PME pilotes
   - Rollout

4. **Secteur Gestion Patrimoine** (24 semaines)
   - Wealth onboarding plugin
   - Enhanced KYC/AML
   - Investment profiling
   - UAT avec 20 clients pilotes
   - Rollout

5. **Segment Jeunes Adultes** (12 semaines)
   - Simplified UX
   - Gamification features
   - Student verification
   - UAT avec 500 étudiants
   - Rollout

### Risques Identifiés

| Risque | Impact | Probabilité | Mitigation |
|--------|--------|-------------|------------|
| Refactoring breaks existing | High | Medium | Feature flags, gradual rollout |
| Compliance gaps sectoriels | High | Medium | Legal review par secteur |
| Performance degradation | Medium | Low | Load testing, optimization |
| User confusion (multi-secteur UX) | Medium | Medium | User testing, iterations |
| Integration failures | High | Low | Extensive testing, mocks |

## Phase 4 : Adoption  PLANIFIÉE (Q1-Q2 2025)

### Plan de Rollout

#### Entreprises (Q1 2025)

- **Week 1-2** : Pilot 10 PME
- **Week 3-8** : Pilot expansion (50 PME)
- **Week 9-16** : Gradual rollout (500 PME)
- **Week 17+** : Full rollout (8,000 PME)

#### Gestion de Patrimoine (Q2 2025)

- **Week 1-2** : Pilot 5 clients HNW
- **Week 3-6** : Pilot expansion (20 clients)
- **Week 7-12** : Gradual rollout (100 clients)
- **Week 13+** : Full rollout (5,000 clients)

#### Jeunes Adultes (Q2 2025)

- **Week 1-2** : Pilot 100 étudiants (1 université)
- **Week 3-6** : Expansion (3 universités, 500 étudiants)
- **Week 7-12** : Full rollout (campagne marketing)

### Success Metrics

**Adoption** :
- Completion rate : > 60% (tous secteurs)
- Time to account : < 15 minutes (Entreprises/Wealth), < 5 min (Jeunes)
- Mobile adoption : > 50% (Entreprises), > 90% (Jeunes)

**Business** :
- Cost reduction : > 40% vs méthodes actuelles
- Customer satisfaction : > 4.0/5 (tous secteurs)
- First month activation : > 80%

**Technical** :
- Availability : > 99.9%
- Performance : p95 < 3s (tous secteurs)
- Security incidents : 0

### Support Model

**Core Team** (Transversal) :
- 1 Product Owner
- 2 Backend Developers
- 2 Frontend Developers
- 1 DevOps Engineer
- 1 QA Engineer

**Sector Teams** (Support local) :
- 1 Business Analyst par secteur
- Compliance SMEs
- User training & support

## Statut Actuel

**Phase actuelle** : Phase 2 - Review
**Prochaine milestone** : Validation CAE (Novembre 2024)
**Date prévue Phase 3** : Décembre 2024
**Date prévue Phase 4** : Q1-Q2 2025

## Documents de Référence

- [Onboarding Digital - Secteur Particuliers](/registre/secteurs/particuliers/business/onboarding-digital)
- [Architecture Decision Record (ADR)](https://docs.bnc.ca/adr/onboarding-digital-transversal)
- [Cost-Benefit Analysis](https://docs.bnc.ca/cba/onboarding-digital)
- [Risk Assessment](https://docs.bnc.ca/risks/onboarding-digital)
- [Compliance Framework](https://docs.bnc.ca/compliance/onboarding-framework)

## Contacts

**Porteur du dossier** : François Leblanc (francois.leblanc@bnc.ca)
**Tech Lead** : Amélie Gagnon (amelie.gagnon@bnc.ca)
**CAE Lead** : Alain Lefebvre (alain.lefebvre@bnc.ca)
**Compliance** : Marc Dupuis (marc.dupuis@bnc.ca)
**Governance** : architecture-transversale@bnc.ca
