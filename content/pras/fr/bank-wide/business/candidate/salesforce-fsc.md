---
title: "Promotion: Salesforce FSC"
description: Dossier de promotion de Salesforce FSC vers Transversal
---

# Dossier de Promotion : Salesforce FSC

## Résumé Exécutif

**Proven Reusable Architecture** : Salesforce Financial Services Cloud (FSC)
**Secteur d'origine** : Gestion de Patrimoine
**Statut** :  Phase 2 - Review (En cours)
**Date de soumission** : Octobre 2024
**Porteur** : Marie Bouchard (marie.bouchard@bnc.ca)

## Phase 1 : Proposition  COMPLÉTÉE

### Contexte

Salesforce FSC est déployé depuis **18 mois** dans le secteur Gestion de Patrimoine avec une adoption de **100%** par les 50+ conseillers. La solution gère actuellement **5,000+ clients HNW/UHNW** représentant **$15B+ AUM**.

### Justification de la Promotion

#### Applicabilité Multi-Secteurs

**Secteurs cibles identifiés** :

1. **Entreprises** (PME & Corporatif)
   - Gestion relation commerciale
   - Opportunités de financement
   - Suivi pipeline de ventes
   - **Adaptation** : ~20% (modules corporatifs)

2. **Institutionnel**
   - Gestion investisseurs institutionnels
   - Reporting réglementaire
   - Communication événements
   - **Adaptation** : ~15% (compliance modules)

3. **Particuliers** (High-touch segments)
   - Clientèle premium
   - Services personnalisés
   - Cross-sell opportunities
   - **Adaptation** : ~25% (mass market features)

#### ROI Démontré

**Métriques Business** :
- Client onboarding time : **-50%** (4 jours  2 jours)
- Client satisfaction : **+15%** (4.0  4.6/5)
- Cross-sell rate : **+25%**
- Compliance incidents : **-80%**

**Métriques Techniques** :
- User satisfaction : **4.2/5**
- System availability : **99.95%**
- Response time (p95) : **< 2s**
- Mobile adoption : **40%**

#### Proven-in-Use

- **Durée** : 18 mois en production
- **Incidents critiques** : 0 (6 derniers mois)
- **Uptime** : 99.95%
- **Support tickets** : ~5/mois (tous mineurs)

### Architecture

Voir détails complets dans [Salesforce FSC - Gestion de Patrimoine](/registre/secteurs/gestion-patrimoine/integration/salesforce-fsc).

**Stack** :
- Salesforce FSC Enterprise
- MuleSoft Anypoint Platform
- Salesforce Data Cloud
- Shield Platform Encryption

**Intégrations** :
- Core Banking System
- Portfolio Management (Bloomberg AIM)
- Document Management (OpenText)

## Phase 2 : Review  EN COURS

### Évaluation Technique (CAE)

**Comité** : Comité Architecture Entreprise
**Date début** : Novembre 2024
**Date fin estimée** : Décembre 2024

#### Critères d'Évaluation

| Critère | Score | Commentaire |
|---------|-------|-------------|
| Architecture | 9/10 | Solide, patterns clairs |
| Scalabilité | 8/10 | Testé jusqu'à 10k users |
| Sécurité | 10/10 | Shield + HSM conforme |
| Coûts | 7/10 | Licensing coûteux à l'échelle |
| Documentation | 9/10 | Excellente documentation |
| Support | 8/10 | Équipe compétente |

**Score global** : 8.5/10 

#### Points Forts Identifiés

 **Architecture mature** : 18 mois de production, patterns établis
 **Intégrations robustes** : MuleSoft bien implémenté
 **Sécurité** : Shield Encryption + conformité complète
 **Adoption** : 100% dans secteur d'origine
 **Mobilité** : App mobile performante

#### Points d'Attention

 **Coûts** : $300/user/mois, peut être prohibitif à grande échelle
 **Vendor lock-in** : Dépendance forte à écosystème Salesforce
 **Customizations** : Risque de sur-customisation par secteur
 **Data residency** : Données hébergées chez Salesforce (CA mais US-owned)
 **Training** : Courbe d'apprentissage importante

#### Recommandations CAE

**Recommandation** :  **APPROUVÉ avec conditions**

**Conditions** :

1. **Governance Framework**
   - Création Salesforce Center of Excellence (CoE)
   - Standards de customization stricts
   - Review architecture trimestrielle

2. **Cost Optimization**
   - Négociation licensing volume-based
   - User tiering (full vs limited licenses)
   - Monitoring ROI par secteur

3. **Technical Standards**
   - Documentation patterns obligatoire
   - Code review process
   - Automated testing (80%+ coverage)

4. **Data Governance**
   - Data residency policy
   - Backup/DR strategy
   - PIPEDA compliance review

### Analyse Multi-Secteurs

#### Secteur : Entreprises

**Porteur** : Jean-François Morin (secteur Entreprises)

**Use Cases** :
- Gestion relation commerciale (8,000 clients)
- Pipeline opportunités financement
- Cross-sell produits bancaires
- Reporting activité commerciale

**Adaptations nécessaires** :
- Module gestion corporative
- Intégration ERP clients (SAP)
- Workflow approbations complexes
- Multi-currency support

**Effort estimé** : 4 mois, 3 développeurs

**ROI attendu** :
- Opportunités conversion : +30%
- Temps setup nouveau client : -40%
- Visibilité pipeline : +100%

**Décision** :  Recommande adoption (Q2 2025)

#### Secteur : Institutionnel

**Porteur** : Claude Mercier (secteur Institutionnel)

**Use Cases** :
- Gestion investisseurs institutionnels
- Reporting réglementaire (AMF, IIROC)
- Communication événements corporatifs
- Performance tracking

**Adaptations nécessaires** :
- Compliance modules (AMF/IIROC)
- Advanced reporting
- Document management renforcé
- Audit trail amélioré

**Effort estimé** : 5 mois, 3 développeurs

**ROI attendu** :
- Compliance reporting : -60% temps
- Client satisfaction : +20%
- Audit findings : -50%

**Décision** :  Recommande adoption (Q3 2025)

#### Secteur : Particuliers

**Porteur** : François Leblanc (secteur Particuliers)

**Use Cases** :
- Clientèle premium (segment haut de gamme)
- Services personnalisés
- Cross-sell produits complexes
- Relationship management

**Adaptations nécessaires** :
- Mass-market features (vs. high-touch)
- Intégration mobile banking
- Self-service portal
- Cost optimization (licensing)

**Effort estimé** : 6 mois, 4 développeurs

**ROI attendu** :
- Premium segment growth : +25%
- Cross-sell : +20%
- Customer churn : -15%

**Décision** :  Phase 2 (après Entreprises et Institutionnel)

### Estimation Coûts de Généralisation

#### Setup Initial

| Poste | Coût |
|-------|------|
| Salesforce CoE setup | $200,000 |
| Architecture review | $50,000 |
| Migration tooling | $100,000 |
| Training program | $150,000 |
| **Total Setup** | **$500,000** |

#### Coûts Récurrents (Annual)

| Poste | Gestion Patrimoine | Entreprises | Institutionnel | Total |
|-------|-------------------|-------------|----------------|-------|
| User licenses (50/100/25) | $180,000 | $360,000 | $90,000 | $630,000 |
| Data Cloud | $60,000 | $100,000 | $40,000 | $200,000 |
| Shield Encryption | $45,000 | $90,000 | $22,500 | $157,500 |
| MuleSoft | $120,000 | $180,000 | $80,000 | $380,000 |
| Support & Training | $60,000 | $80,000 | $40,000 | $180,000 |
| **Total Recurring** | **$465,000** | **$810,000** | **$272,500** | **$1,547,500** |

**Total 3 ans** : $500k (setup) + $4.6M (recurring) = **$5.1M**

#### ROI Projection

**Bénéfices attendus (3 ans)** :

| Bénéfice | Valeur Annuelle | 3 Ans |
|----------|----------------|-------|
| Productivity gains | $800,000 | $2,400,000 |
| Revenue increase (cross-sell) | $1,200,000 | $3,600,000 |
| Cost reduction (ops) | $400,000 | $1,200,000 |
| Compliance savings | $300,000 | $900,000 |
| **Total Bénéfices** | **$2,700,000** | **$8,100,000** |

**ROI** : ($8.1M - $5.1M) / $5.1M = **59%**
**Payback period** : **~22 mois**

## Phase 3 : Migration  PLANIFIÉE (Q1 2025)

### Validation Gouvernance

**Comité** : Comité de Gouvernance Transversal
**Date prévue** : Janvier 2025

### Plan de Migration

#### Workstreams

1. **Salesforce CoE Setup** (8 semaines)
   - Recruter CoE team (5 personnes)
   - Setup gouvernance et standards
   - Créer template de base

2. **Secteur Entreprises** (16 semaines)
   - Customizations corporatives
   - Intégration SAP
   - UAT avec 10 clients pilotes
   - Rollout 100 users

3. **Secteur Institutionnel** (20 semaines)
   - Modules compliance
   - Advanced reporting
   - UAT avec 5 clients pilotes
   - Rollout 25 users

### Risques Identifiés

| Risque | Impact | Probabilité | Mitigation |
|--------|--------|-------------|------------|
| Dépassement budget licensing | High | Medium | Negotiation volume Salesforce |
| Résistance adoption | Medium | High | Change management fort |
| Complexité intégrations | High | Medium | Phased approach, PoCs |
| Data migration issues | High | Low | Automated tools + validation |
| Performance à l'échelle | Medium | Low | Load testing avant rollout |

## Phase 4 : Adoption  PLANIFIÉE (Q2 2025)

### Plan de Rollout

#### Entreprises (Q2 2025)

- **Week 1-2** : Training 20 early adopters
- **Week 3-8** : Pilot avec 20 users, 50 clients
- **Week 9-16** : Rollout 80 remaining users
- **Week 17+** : Stabilization, support

#### Institutionnel (Q3 2025)

- **Week 1-2** : Training 10 early adopters
- **Week 3-6** : Pilot avec 10 users, 20 clients
- **Week 7-12** : Rollout 15 remaining users
- **Week 13+** : Stabilization, support

### Success Metrics

**Adoption** :
- User adoption : > 80% @ 3 mois
- Active usage : > 60% daily active users
- Mobile adoption : > 30%

**Business** :
- Cross-sell rate : +20% vs. baseline
- Client satisfaction : > 4.0/5
- Productivity gain : +25% vs. legacy tools

**Technical** :
- Availability : > 99.9%
- Performance : p95 < 2s
- Incident rate : < 5/mois

### Support Model

**Salesforce CoE** :
- 2 Architects
- 3 Developers
- 2 Admins
- 1 Product Owner

**Support Tiers** :
- L1 : Secteur teams (basic questions)
- L2 : CoE (configuration, bugs)
- L3 : Salesforce support (platform issues)

## Statut Actuel

**Phase actuelle** : Phase 2 - Review
**Prochaine milestone** : Validation CAE (Décembre 2024)
**Date prévue Phase 3** : Janvier 2025
**Date prévue Phase 4** : Q2-Q3 2025

## Documents de Référence

- [Salesforce FSC - Secteur Gestion de Patrimoine](/registre/secteurs/gestion-patrimoine/integration/salesforce-fsc)
- [Architecture Decision Record (ADR)](https://docs.bnc.ca/adr/salesforce-fsc-transversal)
- [Cost-Benefit Analysis](https://docs.bnc.ca/cba/salesforce-fsc)
- [Risk Assessment](https://docs.bnc.ca/risks/salesforce-fsc)

## Contacts

**Porteur du dossier** : Marie Bouchard (marie.bouchard@bnc.ca)
**CAE Lead** : Alain Lefebvre (alain.lefebvre@bnc.ca)
**CoE Lead** : Luc Tremblay (luc.tremblay@bnc.ca)
**Governance** : architecture-transversale@bnc.ca
