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

1. **Validation Automatique** : GitHub Actions vérifie format, liens, métadonnées
2. **Review par la Table de Gouvernance** : 2-3 architectes reviewent le contenu
3. **Itérations** : Vous recevrez des feedbacks et demandes de clarification
4. **Approbation** : Une fois approuvé, le PRA est mergé en tant que **Candidate**

## Critères de Qualité

Votre PRA sera évalué sur :

-  **Proven-in-use** : Au moins 1 implémentation documentée
-  **Réutilisabilité** : Généralisable à d'autres contextes
-  **Clarté** : Documentation claire et complète
-  **ADR** : Décisions architecturales justifiées
-  **Exemples** : Code et configurations concrètes

## Passage de Candidate à Approved

Pour qu'un PRA candidate devienne **approved**, il doit :

-  Avoir **3+ implémentations prouvées** en production
-  Retours positifs des équipes ayant implémenté
-  Documentation mise à jour avec learnings

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
