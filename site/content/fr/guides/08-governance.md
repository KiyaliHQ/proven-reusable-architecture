---
title: 08. Gouvernance
description: Structure et processus de gouvernance du registre PRA
---

# Gouvernance du Registre PRA

Ce document définit la structure de gouvernance, les rôles, et les processus du Registre PRA.

## Table de Gouvernance

La Table de Gouvernance est composée de **5 à 7 architectes senior** issus de différentes équipes.

### Responsabilités

- **Review des soumissions** : Évaluation technique et qualitative des PRAs soumis
- **Approbation** : Décision de passage de Candidate à Approved
- **Maintenance** : Veille sur l'évolution et la pertinence des PRAs
- **Standards** : Définition et évolution des standards de qualité

### Composition

- Minimum 5 membres, maximum 7
- Représentation cross-équipes
- Mandat renouvelable annuellement
- Décisions par consensus ou vote majoritaire

## Processus de Soumission

### 1. Préparation

L'architecte prépare le PRA selon le [template fourni](/templates/pra-template.md).

### 2. Soumission (Pull Request)

- Fork du repository
- Création du fichier PRA dans `pra/candidates/`
- Pull Request avec description détaillée

### 3. Validation Automatique

GitHub Actions vérifie :
- Format YAML du frontmatter
- Présence des sections obligatoires
- Validité des liens
- Au moins 1 proven-in-use documenté

### 4. Review par la Table

- 2-3 membres de la Table reviewent
- Échanges via commentaires PR
- Demandes de clarifications ou améliorations

### 5. Décision

- **Approuvé**  Merge en tant que Candidate
- **Rejeté**  Feedback et fermeture PR
- **Révisions nécessaires**  Itérations

## Critères d'Approbation

### PRA Candidate

 Au moins **1 implémentation prouvée** en production
 Documentation complète (contexte, architecture, ADR, exemples)
 Réutilisabilité démontrée
 Qualité technique validée par la Table

### PRA Approved

 Au moins **3 implémentations prouvées** en production
 Retours positifs des équipes utilisatrices
 Documentation enrichie avec learnings
 Validité confirmée sur plusieurs contextes

## Processus de Deprecation

Un PRA peut être déprécié si :

-  Technologies obsolètes
-  Meilleures alternatives disponibles
-  Retours négatifs répétés
-  Non maintenance pendant 12+ mois

**Processus** :
1. Proposition de deprecation par la Table
2. Discussion avec contributeurs
3. Vote de la Table
4. Migration vers statut `deprecated`
5. Optionnel : Archivage après 6 mois

## Réunions de la Table

- **Fréquence** : Bimensuelle (toutes les 2 semaines)
- **Durée** : 1h maximum
- **Agenda** :
  - Review des nouvelles soumissions
  - Suivi des PRAs candidates
  - Évolutions des standards
  - Points divers

## Communication

- **Canal Slack** : `#pra-governance`
- **Email** : pra-governance@company.com
- **Issues GitHub** : Pour questions et discussions publiques

## Évolution de la Gouvernance

Ce document de gouvernance peut évoluer. Toute modification majeure doit :

1. Être proposée via PR
2. Être discutée en réunion de la Table
3. Être approuvée à l'unanimité ou 2/3 des voix

---

**Parcours recommandé** :
1. [Démarrer avec les PRA](/guides/01-getting-started)
2. [Comprendre les PRA](/guides/02-understanding-pra)
3. [Rôles et Responsabilités](/guides/03-roles-responsibilities)
4. [Cycle de Vie](/guides/04-lifecycle)
5. [Standards de Qualité](/guides/05-standards)
6. [Contribuer un PRA](/guides/06-contributing)
7. [Processus de Promotion](/guides/07-promotion-process)
8.  **Gouvernance** (vous êtes ici)

---

**Navigation** :
-  **Précédent** : [Processus de Promotion](/guides/07-promotion-process)
-  **Retour au début** : [Démarrer avec les PRA](/guides/01-getting-started)
