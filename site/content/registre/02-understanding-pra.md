---
title: 02. Comprendre les PRA
description: Anatomie détaillée d'un Proven Reusable Architecture
---

#  Comprendre les PRA

Maintenant que vous connaissez les bases, plongeons dans la structure et l'organisation des Proven Reusable Architecture.

##  Anatomie d'un PRA

Chaque PRA suit une structure standardisée pour garantir clarté et réutilisabilité.

### Structure Obligatoire

```markdown
# PRA-XXX : [Nom du Patron]

##  Résumé
Description concise en 2-3 phrases

##  Contexte d'application
### Quand utiliser ce PRA ?
### Quand NE PAS utiliser ce PRA ?

##  Problème résolu
Description du problème avec symptômes typiques

##  Solution
Architecture, stack technologique, diagrammes

##  Architecture Decision Records (ADR)
Décisions clés et justifications

##  Prérequis
Techniques et organisationnels

##  Implémentation
Guide pas à pas

##  Exemples
Code et configurations réels

##  Retours d'Expérience
Proven-in-use documentés

##  Limitations & Pièges
À connaître avant d'implémenter

##  Maintenance
Comment maintenir et faire évoluer

##  Références
Documentation, contacts
```

### Métadonnées (Frontmatter)

Chaque PRA contient des métadonnées au format YAML :

```yaml
---
id: pra-XXX
name: "Nom du Patron"
category: tech | integration | security | business
tags:
  - tag1
  - tag2
status: candidate | approved | deprecated
version: X.Y.Z
author:
  name: "Prénom Nom"
  email: "email@company.com"
maintainer:
  name: "Prénom Nom"
  email: "email@company.com"
created: YYYY-MM-DD
updated: YYYY-MM-DD
proven_in_use:
  - project: "Nom Projet"
    team: "Nom Équipe"
    date: "YYYY-MM-DD"
    feedback: "Résultats concrets"
dependencies: []
replaces: null
---
```

##  Les 3 Scopes d'un PRA

### 1. Transversal

```mermaid
graph TD
    A[PRA Transversal] --> B[Validé pour TOUS les secteurs]
    B --> C[3+ proven-in-use multi-secteurs]
    B --> D[Approuvé Table Gouvernance]
    B --> E[Documentation enrichie]
```

**Caractéristiques** :
-  Applicable à **tous les secteurs**
-  Validé par la **Table de Gouvernance Transversale**
-  Au moins **3 proven-in-use** de différents secteurs
-  **Recommandé** pour nouveaux projets
-  Localisation : `pra/transversal/[category]/`

**Exemples** :
- Authentication & Authorization
- Observabilité (Logs, Metrics, Traces)
- CI/CD Pipelines
- API Design Standards

### 2. Sectoriel

```mermaid
graph TD
    A[PRA Sectoriel] --> B[Spécifique à un secteur]
    B --> C[1+ proven-in-use dans le secteur]
    B --> D[Approuvé dans le secteur]
    B --> E[Peut être promu Transversal]
```

**Caractéristiques** :
-  Applicable à **un secteur spécifique**
-  Validé par **l'équipe architecture du secteur**
-  Au moins **1 proven-in-use** dans le secteur
-  Peut être promu vers Transversal si réutilisable
-  Localisation : `pra/secteurs/[secteur]/[category]/`

**Exemples** :
- Patterns métier spécifiques (e.g., Booking flow pour secteur voyage)
- Intégrations spécifiques à un domaine
- Workflows sectoriels

### 3. En Promotion

```mermaid
graph TD
    A[PRA En Promotion] --> B[Sectoriel vers Transversal]
    B --> C[En cours de validation]
    B --> D[Observable par tous]
    B --> E[Décision Table Gouvernance]
```

**Caractéristiques** :
-  Patron sectoriel proposé pour devenir transversal
-  En **cours de revue** par la Table de Gouvernance
-  **Observable** par tous les secteurs
-  Peut retourner Sectoriel ou devenir Transversal
-  Localisation : `pra/en-promotion/[secteur]-[patron]/`

**Utilité** :
- Voir patterns émergents
- Participer aux discussions de promotion
- Anticiper futurs standards transversaux

##  Les Statuts d'un PRA

### Candidate

```mermaid
graph LR
    A[1 proven-in-use] --> B[Documentation complète]
    B --> C[Review Table Gouvernance]
    C --> D[PRA Candidate]
```

**Critères** :
-  **1+ proven-in-use** documenté en production
-  Documentation complète (toutes sections obligatoires)
-  Réutilisabilité démontrée
-  Qualité technique validée

**Utilisation** :
- Peut être utilisé avec **prudence**
- **Retour d'expérience requis**
- Aide à atteindre 3 proven-in-use pour promotion

**Badge** :  Candidate

### Approved

```mermaid
graph LR
    A[3+ proven-in-use] --> B[Feedback positif]
    B --> C[Maintenance active]
    C --> D[PRA Approved]
```

**Critères** :
-  **3+ proven-in-use** documentés
-  Retours **positifs** (satisfaction > 7/10)
-  Documentation **enrichie** avec learnings
-  Mainteneur **actif** (< 6 mois depuis update)

**Utilisation** :
- **Recommandé** pour tous projets applicables
- Support garanti
- Maintenance régulière

**Badge** :  Approved

### Deprecated

```mermaid
graph LR
    A[Technologie obsolète] --> D[PRA Deprecated]
    B[Meilleure alternative] --> D
    C[Feedback négatif répété] --> D
```

**Raisons** :
-  Technologies obsolètes
-  Meilleures alternatives disponibles
-  Retours négatifs répétés
-  Non maintenance (12+ mois)

**Utilisation** :
-  **Non recommandé** pour nouveaux projets
-  Maintenance uniquement pour existants
-  Alternative recommandée documentée

**Badge** :  Deprecated

##  Comment choisir le bon PRA ?

### Workflow de Sélection

```mermaid
graph TD
    A[J'ai un besoin] --> B{PRA Transversal existe ?}
    B -->|Oui| C[Vérifier contexte d'application]
    B -->|Non| D{PRA Sectoriel existe ?}

    C -->|Applicable| E[Utiliser PRA Transversal]
    C -->|Non applicable| D

    D -->|Oui| F[Vérifier contexte]
    D -->|Non| G[Consulter En Promotion]

    F -->|Applicable| H[Utiliser PRA Sectoriel]
    F -->|Non applicable| G

    G -->|Trouvé| I[Évaluer pattern émergent]
    G -->|Non trouvé| J[Créer nouveau PRA ?]
```

### Questions à se poser

#### 1. Le PRA résout-il mon problème ?
-  Lire section **"Problème résolu"**
-  Vérifier **symptômes typiques**

#### 2. Mon contexte est-il compatible ?
-  Lire section **"Quand utiliser ce PRA ?"**
-  Vérifier **"Quand NE PAS utiliser ce PRA ?"**

#### 3. Ai-je les prérequis ?
-  Stack technologique compatible
-  Compétences équipe
-  Infrastructure disponible

#### 4. Le PRA est-il mature ?
-  **Approved** : Go direct
-  **Candidate** : Évaluer risque
-  **Deprecated** : Éviter

##  Catégories de PRA

### Tech
Patterns techniques et infrastructures
- CI/CD, Deployment, Monitoring, Testing

### Integration
Intégrations entre systèmes
- API Design, Event-Driven, Message Queues

### Security
Sécurité et conformité
- Authentication, Authorization, Data Protection

### Business
Patterns métier
- Workflows, Business Rules, Domain Models

##  Prochaines Étapes

Vous comprenez maintenant la structure des PRA. Continuez votre apprentissage :

 **Suivant** : [Rôles et Responsabilités](/registre/03-roles-responsibilities) - Qui fait quoi dans l'écosystème PRA

---

**Parcours recommandé** :
1. [Démarrer avec les PRA](/registre/01-getting-started)
2.  **Comprendre les PRA** (vous êtes ici)
3. [Rôles et Responsabilités](/registre/03-roles-responsibilities)
4. [Cycle de Vie](/registre/04-lifecycle)
5. [Standards de Qualité](/registre/05-standards)
6. [Contribuer un PRA](/registre/06-contributing)
7. [Processus de Promotion](/registre/07-promotion-process)
8. [Gouvernance](/registre/08-governance)

---

**Navigation** :
-  **Précédent** : [Démarrer avec les PRA](/registre/01-getting-started)
-  **Suivant** : [Rôles et Responsabilités](/registre/03-roles-responsibilities)

---

**Dernière mise à jour** : 2025-11-28
