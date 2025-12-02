---
title: 01. Démarrer avec les PRA
description: Guide de démarrage pour comprendre et utiliser les Proven Reusable Architecture
---

#  Démarrer avec les PRA

Bienvenue dans le **Registre des Proven Reusable Architecture (PRA)** !

Ce guide vous aidera à comprendre rapidement ce qu'est un PRA et comment l'utiliser dans vos projets.

##  Qu'est-ce qu'un PRA ?

Un **Proven Reusable Architecture (PRA)** est une **solution éprouvée** à un problème récurrent d'architecture logicielle.

### En 3 points clés

1. ** Proven-in-use** : Validé en production réelle (pas théorique)
2. ** Réutilisable** : Applicable à plusieurs contextes et projets
3. ** Bien documenté** : Contexte, architecture, exemples, retours d'expérience

### Analogie Simple

Pensez aux PRA comme des **recettes de cuisine éprouvées** :
- La recette (le PRA) a été testée plusieurs fois
- Elle fonctionne dans différentes cuisines (contextes)
- Elle documente les ingrédients (stack tech), les étapes (implémentation) et les pièges à éviter

##  Pourquoi utiliser les PRA ?

### Gain de Temps
-  Éviter de réinventer la roue
-  Solutions prêtes à l'emploi
-  Retours d'expérience documentés

### Qualité
-  Solutions validées en production
-  Best practices intégrées
-  Pièges courants documentés

### Cohérence
-  Alignement architectural entre équipes
-  Vocabulaire commun
-  Standards partagés

##  Comment naviguer dans le registre ?

Le registre PRA est organisé en **3 scopes** :

```mermaid
graph TD
    A[Registre PRA] --> B[Transversal]
    A --> C[Secteurs]
    A --> D[En Promotion]

    B --> B1[Approuvés pour tous]
    C --> C1[Spécifiques à un secteur]
    D --> D1[En cours de validation transversale]
```

###  Transversal
- **Pour qui ?** Tous les secteurs de l'organisation
- **Maturité** : Validés par la Table de Gouvernance
- **Exemples** : Authentification, Observabilité, CI/CD

###  Secteurs
- **Pour qui ?** Équipes d'un secteur spécifique
- **Maturité** : Validés dans leur secteur
- **Exemples** : Patterns métier spécifiques

###  En Promotion
- **Pour qui ?** Tous (en observation)
- **Statut** : En cours de validation pour devenir transversal
- **Utilité** : Voir les patterns émergents

##  Vos premiers pas

### 1 Je veux **utiliser** un PRA

```mermaid
graph LR
    A[Identifier mon besoin] --> B[Consulter Transversal]
    B --> C[Lire le PRA]
    C --> D[Vérifier contexte d'application]
    D --> E[Implémenter]
    E --> F[Documenter mon proven-in-use]
```

**Action** : Parcourez la section [Transversal](/registre/transversal)

### 2 Je veux **contribuer** un PRA

```mermaid
graph LR
    A[J'ai une solution éprouvée] --> B[Vérifier critères]
    B --> C[Documenter le PRA]
    C --> D[Soumettre PR]
    D --> E[Review Table Gouvernance]
    E --> F[PRA Candidate]
```

**Action** : Consultez le guide [Contribuer](/registre/06-contributing)

### 3 Je veux **comprendre** la gouvernance

**Action** : Suivez ce parcours dans l'ordre :
1. [Comprendre les PRA](/registre/02-understanding-pra)
2. [Rôles et Responsabilités](/registre/03-roles-responsibilities)
3. [Cycle de Vie](/registre/04-lifecycle)
4. [Gouvernance](/registre/08-governance)

##  Exemple Concret

### Scénario : "Je dois implémenter de l'authentification"

#### Étape 1 : Rechercher
Allez dans **Transversal > Security** et cherchez "Authentication"

#### Étape 2 : Vérifier l'applicabilité
Lisez la section **"Quand utiliser ce PRA ?"**
-  Application web avec utilisateurs
-  Besoin de SSO
-  Application interne sans login

#### Étape 3 : Lire la documentation
- Contexte et problème résolu
- Architecture proposée
- Stack technologique (Auth0, Keycloak, etc.)
- Exemples de code

#### Étape 4 : Implémenter
Suivez le guide d'implémentation pas à pas

#### Étape 5 : Feedback
Documentez votre implémentation dans les **proven-in-use**

##  Questions Fréquentes

### Dois-je obligatoirement utiliser un PRA ?

**Non.** Les PRA sont des **recommandations**, pas des obligations.

**Mais** : Si un PRA applicable existe et que vous ne l'utilisez pas, vous devrez justifier pourquoi (lors des revues d'architecture).

### Puis-je adapter un PRA à mon contexte ?

**Oui, absolument !** Les PRA sont des **patrons**, pas du code figé.

**Important** : Documentez vos adaptations et partagez vos learnings.

### Combien de temps pour qu'un PRA soit approuvé ?

- **Candidate** : 5-10 jours (review initiale)
- **Approved** : Quand 3 proven-in-use documentés

### Je ne trouve pas de PRA pour mon besoin

**Options** :
1. Cherchez dans les **secteurs** (peut-être existe dans un autre secteur)
2. Cherchez dans **En Promotion** (peut-être en cours de validation)
3. **Contribuez !** Votre solution peut devenir un nouveau PRA

##  Prochaines Étapes

Maintenant que vous comprenez les bases, continuez votre apprentissage :

 **Suivant** : [Comprendre les PRA](/registre/02-understanding-pra) - Anatomie détaillée d'un PRA

---

**Parcours recommandé** :
1.  **Démarrer avec les PRA** (vous êtes ici)
2. [Comprendre les PRA](/registre/02-understanding-pra)
3. [Rôles et Responsabilités](/registre/03-roles-responsibilities)
4. [Cycle de Vie](/registre/04-lifecycle)
5. [Standards de Qualité](/registre/05-standards)
6. [Contribuer un PRA](/registre/06-contributing)
7. [Processus de Promotion](/registre/07-promotion-process)
8. [Gouvernance](/registre/08-governance)

---

**Besoin d'aide ?**
- **Canal Teams** : `#pra-registry`
- **Email** : pra-support@company.com
- **Documentation** : Ce site

---

**Dernière mise à jour** : 2025-11-28
