---
title: 03. Rôles et Responsabilités
description: Les différents acteurs du registre PRA et leurs responsabilités
---

# Rôles et Responsabilités

Ce document définit les rôles clés dans l'écosystème du registre PRA et leurs responsabilités respectives.

##  Vue d'ensemble des Rôles

```mermaid
graph TD
    A[Table de Gouvernance] --> B[Équipe Initiative]
    A --> C[Architectes Contributeurs]
    B --> D[Mainteneurs PRA]
    C --> D
    D --> E[Utilisateurs PRA]
```

##  Table de Gouvernance

### Composition

- **Nombre** : 5 à 7 architectes seniors
- **Représentation** : Cross-équipes et cross-secteurs
- **Mandat** : Renouvelable annuellement
- **Décisions** : Par consensus ou vote majoritaire

### Responsabilités

#### 1. Review des Soumissions

- Évaluer techniquement et qualitativement les nouveaux PRA
- Vérifier conformité aux standards
- Demander clarifications ou améliorations
- **Timeline** : Review initiale sous 5 jours ouvrés

#### 2. Approbation des PRA

**Pour les PRA Candidates** :
- Valider conformité au template
- Vérifier proven-in-use (minimum 1)
- Approuver passage en statut Candidate
- **Seuil** : 2 approvals requis

**Pour promotion Approved** :
- Vérifier 3+ proven-in-use documentés
- Valider feedback positif multi-équipes
- Approuver passage en statut Approved
- **Seuil** : 2 approvals requis

#### 3. Gouvernance Transversale

- Décider promotions Sectoriel  Transversal
- Approuver dépréciations
- Valider évolutions de standards
- Arbitrer conflits entre secteurs

#### 4. Maintenance Stratégique

- Review annuelle de tous les PRA Approved
- Identifier PRA obsolètes ou sous-utilisés
- Proposer améliorations processus
- Veiller sur l'évolution technologique

### Réunions

- **Fréquence** : Bimensuelle (toutes les 2 semaines)
- **Durée** : 1h maximum
- **Agenda type** :
  - Review nouvelles soumissions (30 min)
  - Suivi PRA candidates (15 min)
  - Points stratégiques (10 min)
  - Questions diverses (5 min)

### Engagement Attendu

- **Temps** : 2-4 heures/mois
- **Disponibilité** : Review PR sous 48h
- **Participation** : 80%+ réunions

##  Équipe Initiative PRA

### Composition

- **Nombre** : 2-3 personnes dédiées
- **Profils** :
  - 1 Architecte Senior (lead)
  - 1 DevOps/Platform Engineer
  - 1 Developer Experience (DX) Specialist (optionnel)

### Responsabilités

#### 1. Infrastructure & Outillage

- Maintenir repository Git et structure
- Gérer site Fumadocs et Orama search
- Maintenir workflows GitHub Actions
- Gérer sync Confluence
- Monitoring et alertes

#### 2. Support Communauté

- Répondre questions sur `#pra-registry`
- Aider contributeurs avec templates et processus
- Organiser sessions de formation
- Créer documentation et guides

#### 3. Évolution Continue

- Proposer améliorations processus
- Implémenter nouvelles fonctionnalités
- Collecter et analyser feedback
- Roadmap et priorisation

#### 4. Communication

- Newsletter mensuelle
- Annonces nouveaux PRA
- Promotions secteur  transversal
- Stats et métriques d'adoption

### Engagement Attendu

- **Temps** : 20-40% temps de travail
- **Disponibilité** : Support actif communauté
- **Proactivité** : Amélioration continue

##  Architectes Contributeurs

### Qui sont-ils ?

**Tous les architectes** de l'organisation peuvent contribuer :
- Architectes d'entreprise
- Architectes de solution
- Architectes techniques
- Architectes de secteur

### Responsabilités

#### 1. Identifier des Patrons Réutilisables

- Observer patterns récurrents dans projets
- Identifier solutions éprouvées en production
- Évaluer réutilisabilité et généralisation

#### 2. Documenter des PRA

- Utiliser template officiel
- Fournir contexte et ADR complets
- Inclure exemples et proven-in-use
- Respecter standards de qualité

#### 3. Maintenir leurs PRA

- Répondre aux questions utilisateurs
- Intégrer feedback et learnings
- Mettre à jour documentation
- Proposer évolutions

#### 4. Reviewer des PRA

- Participer aux reviews de PRs
- Fournir feedback constructif
- Valider applicabilité dans leur contexte
- Partager expérience similaire

### Droits

-  **Libre choix** : Pas d'obligation d'utiliser un PRA
-  **Accès complet** : Tous les PRA approved et candidates
-  **Support** : Assistance équipe Initiative
-  **Visibilité** : Reconnaissance contributions

### Devoirs

-  **Justification** : Expliquer si on n'utilise pas un PRA applicable
-  **Feedback** : Partager retours sur PRA utilisés
-  **Documentation** : Documenter proven-in-use
-  **Respect** : Suivre processus et standards

##  Mainteneurs PRA

### Qui sont-ils ?

Architectes désignés comme responsables d'un ou plusieurs PRA spécifiques.

### Responsabilités

#### 1. Ownership du PRA

- Garantir qualité et actualité
- Décider évolutions et modifications
- Valider PRs de contributions externes

#### 2. Documentation

- Maintenir documentation à jour
- Enrichir avec nouveaux learnings
- Clarifier points ambigus
- Ajouter exemples

#### 3. Support Utilisateurs

- Répondre questions sur le PRA
- Aider adoption dans nouveaux projets
- Débloquer problèmes d'implémentation
- Collecter feedback

#### 4. Évolution

- Proposer améliorations basées sur feedback
- Adapter aux nouvelles versions technologiques
- Identifier besoins de dépréciation
- Créer versions successeurs si nécessaire

### Durée Engagement

- **Minimum** : 1 an
- **Transfert** : Possible avec validation Table Gouvernance
- **Rotation** : Encouragée tous les 2-3 ans

##  Utilisateurs PRA

### Qui sont-ils ?

- **Développeurs** : Implémentent les PRA dans le code
- **Architectes** : Utilisent les PRA dans conceptions
- **Product Owners** : Référencent les PRA dans specs
- **Tech Leads** : Recommandent les PRA à leurs équipes

### Responsabilités

#### 1. Utilisation Appropriée

- Comprendre contexte d'application du PRA
- Respecter guidelines et best practices
- Adapter aux spécificités projet (avec justification)

#### 2. Feedback

- Documenter implémentation (proven-in-use)
- Signaler problèmes ou limitations
- Proposer améliorations
- Partager learnings

#### 3. Contribution

- Enrichir exemples et cas d'usage
- Corriger erreurs documentation
- Proposer clarifications
- Aider autres utilisateurs

### Droits

-  **Accès libre** : Tous les PRA sans restriction
-  **Support** : Aide mainteneurs et communauté
-  **Adaptation** : Flexibilité dans implémentation (justifiée)
-  **Contribution** : Proposer modifications via PR

##  Matrice RACI

| Activité | Table Gouv. | Équipe Init. | Contributeurs | Mainteneurs | Utilisateurs |
|----------|-------------|--------------|---------------|-------------|--------------|
| Soumettre nouveau PRA | C | I | **R** | I | I |
| Review PRA candidate | **R/A** | C | C | I | I |
| Approuver PRA candidate | **A** | I | I | C | I |
| Maintenir infrastructure | I | **R/A** | I | I | I |
| Maintenir PRA | I | C | I | **R/A** | C |
| Utiliser PRA | I | I | I | C | **R/A** |
| Promouvoir sectorieltransversal | **A** | C | R | C | I |
| Déprécier PRA | **A** | C | C | R | C |
| Former communauté | C | **R/A** | C | C | I |

**Légende** :
- **R** : Responsable (fait le travail)
- **A** : Approbateur (décide)
- **C** : Consulté (donne input)
- **I** : Informé (reçoit notification)

##  Contacts

### Table de Gouvernance
- **Email** : pra-governance@company.com
- **Membres** : Voir [Page Gouvernance](/registre/governance)

### Équipe Initiative
- **Canal Teams** : `#pra-initiative`
- **Email** : pra-team@company.com
- **Lead** : [Nom Lead Équipe]

### Support Communauté
- **Canal Teams** : `#pra-registry`
- **Email** : pra-support@company.com
- **GitHub Issues** : [Lien Repository]

---

**Parcours recommandé** :
1. [Démarrer avec les PRA](/guides/01-getting-started)
2. [Comprendre les PRA](/guides/02-understanding-pra)
3.  **Rôles et Responsabilités** (vous êtes ici)
4. [Cycle de Vie](/guides/04-lifecycle)
5. [Standards de Qualité](/guides/05-standards)
6. [Contribuer un PRA](/guides/06-contributing)
7. [Processus de Promotion](/guides/07-promotion-process)
8. [Gouvernance](/guides/08-governance)

---

**Navigation** :
-  **Précédent** : [Comprendre les PRA](/guides/02-understanding-pra)
-  **Suivant** : [Cycle de Vie](/guides/04-lifecycle)

---

**Dernière mise à jour** : 2025-11-28
**Prochaine review** : 2026-05-28
