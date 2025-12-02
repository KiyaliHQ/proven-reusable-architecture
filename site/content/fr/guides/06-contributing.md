---
title: 06. Guide de Contribution
description: Comment contribuer au registre PRA
---

# Guide de Contribution

Vous souhaitez soumettre un nouveau PRA ? Suivez ce guide étape par étape.

## Prérequis

Avant de soumettre un PRA, assurez-vous que :

-  Votre architecture a été **validée en production** dans au moins **1 projet réel**
-  Vous disposez de **retours d'expérience concrets** (metrics, learnings, feedback)
-  La solution est **réutilisable** et **généralisable** à d'autres contextes
-  Vous pouvez **documenter** le contexte, les décisions et les exemples

## Choisir le Scope de Votre PRA

Avant de commencer, déterminez quel scope s'applique :

### PRA Domaine
Soumettez un **PRA Domaine** si votre patron :
- Est spécifique à un domaine (Particuliers, Entreprises, Gestion de Patrimoine)
- Contient des patterns fonctionnels ou techniques pour votre domaine
- A au moins **1 proven-in-use dans votre domaine**
- Sera reviewé par votre **Comité de Gouvernance du Domaine**

### PRA Bank-Wide
Soumettez un **PRA Bank-Wide** si votre patron :
- Est applicable à travers **plusieurs domaines**
- A démontré une **applicabilité multi-domaine**
- A au moins **1 proven-in-use** (avec potentiel multi-domaine clair)
- Sera reviewé par le **Comité de Gouvernance Architectes Experts**

**Note** : La plupart des PRAs commencent comme PRAs Domaine. Les PRAs Bank-Wide proviennent typiquement de :
- Équipes transversales (Software Engineering, Sécurité, etc.) - [**Flow 2**](/guides/08-governance#-flow-2--top-down-équipes-transversales---bank-wide)
- PRAs Domaine promus vers Bank-Wide - [**Flow 1**](/guides/08-governance#-flow-1--organique-domaine---bank-wide)
- Initiative Bootstrap (transitoire) - [**Flow 3**](/guides/08-governance#-flow-3--bootstrap-transitoire)

## Processus de Soumission

### 1. Fork et Clone

```bash
git clone https://github.com/votre-org/pra-registry.git
cd pra-registry
```

### 2. Créer une Branche

```bash
git checkout -b pra/nom-de-votre-pra
```

### 3. Utiliser le Template

Copiez le template PRA :

```bash
cp templates/pra-template.md pra/candidates/pra-XXX-nom-du-pra.md
```

### 4. Remplir le PRA

Complétez toutes les sections du template :

- **Métadonnées** (YAML frontmatter)
- **Vue d'ensemble**
- **Contexte**
- **Architecture** (schémas, composants)
- **ADR** (Architecture Decision Records)
- **Exemples** (code, configurations)
- **Proven-in-use** (implémentations réelles avec feedback)

### 5. Vérifications Locales

Avant de soumettre, vérifiez :

```bash
# Valider les métadonnées
pnpm validate:metadata

# Valider les liens
pnpm validate:links

# Prévisualiser le site
pnpm dev
```

### 6. Créer une Pull Request

```bash
git add .
git commit -m "feat: ajout PRA-XXX - Nom du PRA"
git push origin pra/nom-de-votre-pra
```

Créez ensuite une Pull Request sur GitHub avec :

- **Titre** : `[PRA] Nom du PRA`
- **Description** : Résumé du PRA et contexte de soumission

## Processus de Review

Le processus de review dépend du scope de votre PRA :

### Review PRA Domaine

1. **Validation Automatique** : GitHub Actions vérifie format, liens, métadonnées
2. **Review par Comité de Gouvernance du Domaine** : 2 approbations requises de votre comité domaine
3. **Itérations** : Vous recevrez des feedbacks et demandes de clarification
4. **Approbation** : Une fois approuvé, le PRA est mergé en tant que **Domaine Candidate**
5. **Timeline** : 5-10 jours ouvrés

### Review PRA Bank-Wide

1. **Validation Automatique** : GitHub Actions vérifie format, liens, métadonnées
2. **Review par Comité de Gouvernance Architectes Experts** : 2 approbations requises des architectes experts
3. **Validation Multi-domaine** : Vérification de l'applicabilité à travers les domaines
4. **Itérations** : Vous recevrez des feedbacks et demandes de clarification
5. **Approbation** : Une fois approuvé, le PRA est mergé en tant que **Bank-Wide Candidate**
6. **Timeline** : 2-4 semaines

## Critères de Qualité

Votre PRA sera évalué sur :

-  **Proven-in-use** : Au moins 1 implémentation documentée
-  **Réutilisabilité** : Généralisable à d'autres contextes
-  **Clarté** : Documentation claire et complète
-  **ADR** : Décisions architecturales justifiées
-  **Exemples** : Code et configurations concrètes

## Passage de Candidate à Approved

Les exigences diffèrent selon le scope :

### PRA Domaine : Candidate → Approved

Pour qu'un PRA Domaine Candidate devienne **Domaine Approved**, il doit :

-  Avoir **1+ implémentation prouvée dans le domaine** (déjà satisfait pour Candidate)
-  Retours positifs des équipes du domaine (satisfaction > 7/10)
-  Documentation enrichie avec learnings spécifiques au domaine
-  Réutilisabilité confirmée au sein du domaine
-  Review et approbation par le **Comité de Gouvernance du Domaine**

### PRA Bank-Wide : Candidate → Approved

Pour qu'un PRA Bank-Wide Candidate devienne **Bank-Wide Approved**, il doit :

-  Avoir **3+ implémentations prouvées de différents domaines/équipes**
-  Retours positifs multi-domaine (satisfaction > 7/10)
-  Documentation enrichie avec learnings multi-contextes
-  Applicabilité multi-domaine validée
-  Review et approbation par le **Comité de Gouvernance Architectes Experts**

## Questions ?

Consultez :

- [Gouvernance](/guides/08-governance)
- [Cycle de Vie](/guides/04-lifecycle)
- [Standards](/guides/05-standards)

---

**Parcours recommandé** :
1. [Démarrer avec les PRA](/guides/01-getting-started)
2. [Comprendre les PRA](/guides/02-understanding-pra)
3. [Rôles et Responsabilités](/guides/03-roles-responsibilities)
4. [Cycle de Vie](/guides/04-lifecycle)
5. [Standards de Qualité](/guides/05-standards)
6.  **Contribuer un PRA** (vous êtes ici)
7. [Processus de Promotion](/guides/07-promotion-process)
8. [Gouvernance](/guides/08-governance)

---

**Navigation** :
-  **Précédent** : [Standards de Qualité](/guides/05-standards)
-  **Suivant** : [Processus de Promotion](/guides/07-promotion-process)

Ou ouvrez une issue sur GitHub.
