---
title: 05. Standards de Qualité
description: Critères et standards pour les Proven Reusable Architecture
---

# Standards de Qualité PRA

Ce document définit les standards de qualité que tous les PRA doivent respecter pour être acceptés dans le registre.

##  Principes Fondamentaux

Un PRA de qualité doit être :

- ** Proven-in-use** : Validé en production réelle
- ** Réutilisable** : Applicable à plusieurs contextes
- ** Bien documenté** : Clair, complet et maintenable
- ** Maintenable** : Évolutif et supporté dans le temps

##  Critères par Statut

### Pour un PRA Candidate

#### Critères Obligatoires

 **Au moins 1 proven-in-use documenté**
- Projet en production (pas dev/staging)
- Feedback concret et mesurable
- Date récente (< 2 ans)

 **Documentation complète**
- Contexte et problème résolu
- Solution et architecture
- ADR (Architecture Decision Records)
- Exemples de code/configuration
- Prérequis clairement définis

 **Réutilisabilité démontrée**
- Patron généralisable
- Non spécifique à un seul projet
- Paramétrable pour différents contextes

 **Qualité technique**
- Respecte standards techniques entreprise
- Sécurité et conformité validées
- Performance acceptable
- Scalabilité considérée

#### Critères Recommandés

-  Diagrammes d'architecture
-  Comparaison avec alternatives
-  Guide de migration (si applicable)
-  FAQ basée sur l'expérience

### Pour un PRA Approved

#### Critères Obligatoires (en plus de Candidate)

 **Au moins 3 proven-in-use documentés**
- Différentes équipes
- Différents contextes d'application
- Feedback positif (satisfaction > 7/10)

 **Documentation enrichie**
- Learnings de multiples implémentations
- Cas d'usage variés
- Pièges courants documentés
- Guide de troubleshooting

 **Maintenance active**
- Mainteneur désigné et actif
- Dernière mise à jour < 6 mois
- Réponses aux questions < 1 semaine

 **Adoption croissante**
- Tendance positive d'utilisation
- Pas de feedback négatif majeur
- Recommandé par pairs

##  Template et Structure

### Structure Obligatoire d'un PRA

Chaque PRA doit contenir les sections suivantes :

#### 1. Frontmatter (Métadonnées YAML)

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
dependencies: []  # IDs autres PRA requis
replaces: null    # ID PRA remplacé
---
```

#### 2. Sections Markdown Obligatoires

```markdown
# PRA-XXX: [Nom du Patron]

##  Résumé
[2-3 phrases décrivant le patron]

##  Contexte d'application

### Quand utiliser ce PRA ?
- [Critère 1]
- [Critère 2]

### Quand NE PAS utiliser ce PRA ?
- [Contre-indication 1]
- [Contre-indication 2]

##  Problème résolu
[Description du problème]

### Symptômes typiques
- [Symptôme 1]
- [Symptôme 2]

##  Solution
[Description de la solution]

### Architecture
[Diagramme ou description]

### Stack technologique
[Table des technologies utilisées]

##  Architecture Decision Records (ADR)
[Liens vers ADR ou résumé décisions clés]

##  Prérequis
- [Prérequis technique 1]
- [Prérequis organisationnel 1]

##  Implémentation
[Guide étape par étape]

##  Exemples
[Code et configurations]

##  Retours d'Expérience
[Learnings des proven-in-use]

##  Limitations & Pièges
[Limitations connues et pièges à éviter]

##  Cycle de vie & Maintenance
[Comment maintenir et faire évoluer]

##  Références
[Liens documentation officielle, contacts]
```

### Sections Optionnelles mais Recommandées

```markdown
##  Migration
[Guide de migration depuis solution précédente]

##  Tests
[Stratégie de test recommandée]

##  Métriques
[KPIs et métriques de succès]

##  Multi-environnement
[Considérations dev/staging/prod]

##  Coûts
[Estimation des coûts (infrastructure, licences)]

##  FAQ
[Questions fréquentes]
```

##  Critères de Qualité par Section

### Contexte d'application 

**Excellent** :
- Critères d'usage précis et actionnables
- Contre-indications claires
- Exemples de contextes applicables
- Trade-offs explicités

**Insuffisant** :
- Critères vagues ou génériques
- Pas de contre-indications
- Applicable "partout"

### Solution 

**Excellent** :
- Architecture claire avec diagrammes
- Technologies justifiées
- Alternatives considérées
- Scalabilité et performance adressées

**Insuffisant** :
- Description textuelle seule
- Pas de justification choix techniques
- Pas de considération alternatives

### ADR (Architecture Decision Records) 

**Excellent** :
- Chaque décision majeure documentée
- Contexte, options, décision, conséquences
- Liens vers ADR détaillés si nécessaire
- Historique des révisions

**Insuffisant** :
- Pas d'ADR
- ADR incomplets ou vagues
- Pas de justification décisions

### Proven-in-use 

**Excellent** :
- Projets nommés en production
- Métriques concrètes (temps, coûts, qualité)
- Learnings spécifiques
- Contact équipe disponible

**Insuffisant** :
- Projets anonymes ou fictifs
- Feedback générique "ça marche bien"
- Pas de métriques
- Projets en dev/POC

### Exemples 

**Excellent** :
- Code complet et exécutable
- Plusieurs exemples (cas simples + complexes)
- Configurations commentées
- Repository exemple disponible

**Insuffisant** :
- Snippets incomplets
- Pseudo-code non exécutable
- Pas de contexte
- Exemples triviaux

##  Checklist de Validation

Avant de soumettre un PRA, vérifier :

### Documentation

- [ ] Toutes les sections obligatoires sont présentes
- [ ] Métadonnées YAML valides
- [ ] Pas de fautes d'orthographe majeures
- [ ] Liens fonctionnels
- [ ] Diagrammes lisibles

### Technique

- [ ] Solution testée en production
- [ ] Respect standards sécurité entreprise
- [ ] Performance validée
- [ ] Scalabilité considérée
- [ ] Dépendances identifiées

### Proven-in-use

- [ ] Minimum requis documenté (1 pour candidate, 3 pour approved)
- [ ] Projets réels nommés
- [ ] Feedback avec métriques
- [ ] Dates récentes (< 2 ans)

### Réutilisabilité

- [ ] Patron généralisable
- [ ] Paramètres configurables
- [ ] Adapté à plusieurs contextes
- [ ] Pas de spécificités projet unique

##  Métriques de Qualité

Les PRA sont évalués sur :

### Complétude (40%)

- Documentation complète
- ADR fournis
- Exemples présents
- Proven-in-use documentés

### Clarté (30%)

- Facilement compréhensible
- Diagrammes clairs
- Instructions actionnables
- Structure logique

### Utilité (20%)

- Résout un problème réel
- Gain de temps démontré
- Adoption croissante
- Feedback positif

### Maintenance (10%)

- Mainteneur actif
- Mises à jour régulières
- Réponses aux questions
- Évolution continue

##  Raisons de Rejet

Un PRA peut être rejeté pour :

### Qualité Insuffisante

-  Documentation incomplète ou confuse
-  Pas de proven-in-use crédible
-  Solution non testée en production
-  Manque d'exemples concrets

### Non-Réutilisabilité

-  Trop spécifique à un projet unique
-  Pas généralisable
-  Problème non récurrent

### Non-Conformité

-  Violation standards sécurité
-  Technologies non approuvées
-  Non-respect des guidelines entreprise

### Duplication

-  PRA similaire existe déjà
-  Pas de valeur ajoutée vs existant
-  Fusion recommandée avec PRA existant

##  Amélioration Continue

### Review Annuelle

Tous les PRA Approved font l'objet d'une review annuelle :

-  Pertinence technique
-  Niveau d'adoption
-  Qualité documentation
-  Activité maintenance

Résultats possibles :
- **Maintenir** : PRA reste approved
- **Améliorer** : Requiert mises à jour
- **Déprécier** : Obsolète ou supplanté

### Feedback Communauté

Les utilisateurs peuvent :
- Proposer améliorations (PR)
- Signaler erreurs (Issues)
- Suggérer clarifications
- Partager nouveaux learnings

##  Support Qualité

Pour questions sur les standards :

- **Canal Teams** : `#pra-quality`
- **Email Table Gouvernance** : pra-governance@company.com
- **Documentation Template** : [Lien vers template]

---

**Parcours recommandé** :
1. [Démarrer avec les PRA](/registre/01-getting-started)
2. [Comprendre les PRA](/registre/02-understanding-pra)
3. [Rôles et Responsabilités](/registre/03-roles-responsibilities)
4. [Cycle de Vie](/registre/04-lifecycle)
5.  **Standards de Qualité** (vous êtes ici)
6. [Contribuer un PRA](/registre/06-contributing)
7. [Processus de Promotion](/registre/07-promotion-process)
8. [Gouvernance](/registre/08-governance)

---

**Navigation** :
-  **Précédent** : [Cycle de Vie](/registre/04-lifecycle)
-  **Suivant** : [Contribuer un PRA](/registre/06-contributing)

---

**Dernière mise à jour** : 2025-11-28
**Prochaine review** : 2026-05-28
