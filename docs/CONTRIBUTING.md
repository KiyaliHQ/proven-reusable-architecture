# Guide de Contribution - Registre PRA

Merci de contribuer au registre PRA ! Ce guide vous aidera à soumettre des patrons d'architecture de qualité.

**Version** : 1.0
**Dernière mise à jour** : 28 novembre 2025

---

## 📋 Table des Matières

1. [Avant de Commencer](#avant-de-commencer)
2. [Types de Contributions](#types-de-contributions)
3. [Soumettre un Nouveau PRA](#soumettre-un-nouveau-pra)
4. [Mettre à Jour un PRA Existant](#mettre-à-jour-un-pra-existant)
5. [Standards de Qualité](#standards-de-qualité)
6. [Processus de Review](#processus-de-review)
7. [Checklist Avant Soumission](#checklist-avant-soumission)
8. [Bonnes Pratiques](#bonnes-pratiques)
9. [FAQ](#faq)

---

## 🚀 Avant de Commencer

### Prérequis

- ✅ Compte GitHub avec accès au repository
- ✅ Git installé localement
- ✅ Connaissance Markdown
- ✅ Familiarité avec YAML frontmatter

### Lire d'abord

Avant de contribuer, lisez :
- [GOVERNANCE.md](./GOVERNANCE.md) - Processus de gouvernance
- [LIFECYCLE.md](./LIFECYCLE.md) - Cycle de vie des PRA
- [STANDARDS.md](./STANDARDS.md) - Standards de qualité

---

## 🎯 Types de Contributions

### 1. Nouveau PRA Candidat

Vous avez une architecture validée que vous souhaitez partager.

**Critères** :
- Patron architectural réutilisable
- Au moins **1 implémentation réussie** documentée
- Documentation complète avec exemples

**Voir** : [Soumettre un Nouveau PRA](#soumettre-un-nouveau-pra)

### 2. Mise à Jour PRA Existant

Vous souhaitez améliorer un PRA existant.

**Exemples** :
- Ajouter un retour d'expérience ("proven-in-use")
- Corriger une erreur
- Ajouter un exemple
- Mettre à jour une technologie

**Voir** : [Mettre à Jour un PRA Existant](#mettre-à-jour-un-pra-existant)

### 3. Promotion Candidat → Approved

Vous proposez de promouvoir un PRA candidat.

**Critères** :
- **3+ proven-in-use** documentés
- Au moins 2 équipes différentes
- Minimum 6 mois depuis création

**Voir** : [Processus de Promotion](./GOVERNANCE.md#processus-de-promotion)

### 4. Amélioration Documentation

Vous corrigez ou améliorez la doc (GOVERNANCE, CONTRIBUTING, etc.)

**Processus** :
1. Fork du repo
2. Modification du fichier
3. PR avec description claire

---

## 📝 Soumettre un Nouveau PRA

### Étape 1 : Vérifier l'Existence

**Important** : Éviter les doublons

```bash
# Rechercher dans le registre
cd pra-registry
grep -r "nom-technologie" pra/

# Ou utiliser le site Fumadocs
# https://pra-registry.example.com/catalog
```

Si un PRA similaire existe :
- Option 1 : Contribuer au PRA existant
- Option 2 : Justifier pourquoi un nouveau PRA est nécessaire

### Étape 2 : Préparer la Documentation

Rassemblez :
- ✅ Description du patron
- ✅ Diagrammes architecture
- ✅ ADR (decisions architecturales)
- ✅ Exemples de code
- ✅ Retours d'expérience ("proven-in-use")

### Étape 3 : Créer une Branch

```bash
git checkout main
git pull origin main
git checkout -b pra/nouveau-[category]-[nom-court]

# Exemples:
# pra/nouveau-tech-ci-cd-gitops
# pra/nouveau-security-rbac-spicedb
```

### Étape 4 : Copier le Template

```bash
# Déterminer la catégorie: tech | integration | security | business
CATEGORY="tech"
PRA_NAME="ci-cd-gitops-argocd"

# Créer la structure
mkdir -p content/pras/fr/transversale/$CATEGORY/operationalizing

# Copier le template
cp templates/pra-template.md content/pras/fr/transversale/$CATEGORY/operationalizing/$PRA_NAME.md
```

### Étape 5 : Remplir le Template

Suivez le template section par section :

#### 5.1 Métadonnées YAML

```yaml
---
id: pra-001                           # Demander ID à l'équipe Initiative
name: "CI/CD GitOps avec ArgoCD"
category: tech
tags:
  - ci-cd
  - gitops
  - argocd
  - kubernetes
  - devops
status: candidate
version: 1.0.0
author:
  name: "Votre Nom"
  email: "votre.email@example.com"
maintainer:
  name: "Votre Nom"
  email: "votre.email@example.com"
created: 2025-11-28
updated: 2025-11-28
proven_in_use:
  - project: "Nom du Projet"
    team: "Nom de l'Équipe"
    date: "2024-06-15"
    feedback: "40% réduction temps déploiement"
dependencies: []
replaces: null
---
```

#### 5.2 Sections Principales

- **Résumé** : 2-3 phrases claires
- **Contexte d'Application** : Quand utiliser / ne pas utiliser
- **Problème Résolu** : Description + symptômes
- **Solution** : Architecture + stack tech
- **ADR** : Au moins 1 décision documentée
- **Implémentation** : Étapes concrètes
- **Exemples** : Au moins 1 exemple fonctionnel
- **Retours d'Expérience** : Au moins 1 (3+ pour approved)

### Étape 6 : Ajouter ADR

```bash
# Copier template ADR
cp templates/adr-template.md content/pras/fr/transversale/$CATEGORY/operationalizing/adr/001-choix-argocd-vs-fluxcd.md

# Remplir l'ADR avec la décision architecturale
```

### Étape 7 : Ajouter Exemples

```bash
# Créer dossier exemple
mkdir -p content/pras/fr/transversale/$CATEGORY/operationalizing/examples/azure-pipeline

# Ajouter fichiers d'exemple
# - Code source
# - Configurations
# - README explicatif
```

### Étape 8 : Validation Locale

```bash
# Validation métadonnées YAML
./scripts/validate-metadata.sh content/pras/fr/transversale/$CATEGORY/operationalizing/$PRA_NAME.md

# Validation liens Markdown (optionnel)
# Installer markdown-link-check si besoin
npm install -g markdown-link-check
markdown-link-check content/pras/fr/transversale/$CATEGORY/operationalizing/$PRA_NAME.md
```

### Étape 9 : Commit & Push

```bash
git add .
git commit -m "feat(pra): Add PRA-001 - CI/CD GitOps avec ArgoCD

- Patron GitOps avec ArgoCD pour Kubernetes
- 1 implémentation documentée (Project Alpha)
- ADR: Choix ArgoCD vs FluxCD
- Exemple: Azure Pipeline complet
"

git push origin pra/nouveau-tech-ci-cd-gitops
```

### Étape 10 : Créer Pull Request

1. Aller sur GitHub
2. Cliquer "Compare & pull request"
3. Utiliser le template PR :

```markdown
## Type de Contribution
- [x] Nouveau PRA Candidat
- [ ] Mise à jour PRA existant
- [ ] Promotion Candidat → Approved

## Description
[Description courte du PRA]

## Catégorie
- [x] Tech
- [ ] Integration
- [ ] Security
- [ ] Business

## Checklist
- [x] Template complet
- [x] Métadonnées YAML valides
- [x] Au moins 1 ADR
- [x] Au moins 1 exemple
- [x] Au moins 1 proven-in-use
- [x] Validation locale passée

## Proven-in-Use
- **Projet** : Project Alpha
- **Équipe** : Team Infrastructure
- **Résultat** : 40% réduction temps déploiement

## Liens
- [Documentation ArgoCD](https://argo-cd.readthedocs.io/)
```

4. Assigner labels :
   - `pra-candidat`
   - `category:tech`
   - `review-needed`

### Étape 11 : Review & Merge

- GitHub Actions valide automatiquement
- 2 membres de la Table de Gouvernance review
- Délai max : 5 jours ouvrés
- Une fois approuvé : merge automatique

---

## 🔄 Mettre à Jour un PRA Existant

### Cas 1 : Ajouter un Retour d'Expérience

```bash
git checkout -b pra/update-pra-001-proven-in-use

# Éditer le fichier
vim content/pras/fr/transversale/tech/operationalized/ci-cd-gitops-argocd.md

# Ajouter dans la section "Retours d'Expérience"
# + dans le YAML frontmatter
```

### Cas 2 : Corriger une Erreur

```bash
git checkout -b pra/fix-pra-001-typo

# Correction
# Commit avec prefix "fix:"
git commit -m "fix(pra): Fix typo in PRA-001"
```

### Cas 3 : Ajouter un Exemple

```bash
git checkout -b pra/add-example-pra-001

# Créer nouvel exemple
mkdir -p content/pras/fr/transversale/tech/operationalized/examples/gitlab-ci

# Ajouter fichiers + documentation
```

---

## 📏 Standards de Qualité

### Documentation

- ✅ **Clarté** : Langage clair et accessible
- ✅ **Complétude** : Toutes les sections remplies
- ✅ **Exemples** : Au moins 1 exemple concret
- ✅ **Précision** : Informations exactes et vérifiables

### Code & Exemples

- ✅ **Fonctionnel** : Code testé et fonctionnel
- ✅ **Commenté** : Code commenté si nécessaire
- ✅ **Générique** : Pas de secrets/credentials hardcodés
- ✅ **README** : Chaque exemple a un README

### Métadonnées

- ✅ **Schema valide** : YAML conforme au template
- ✅ **Tags pertinents** : 3-10 tags descriptifs
- ✅ **Proven-in-use** : Minimum 1 pour candidat, 3+ pour approved

### Architecture Decision Records

- ✅ **Complet** : Contexte, options, décision, conséquences
- ✅ **Justifié** : Raisons claires de la décision
- ✅ **Alternatives** : Au moins 2 options comparées

---

## 🔍 Processus de Review

### Review Automatique (GitHub Actions)

```yaml
✅ Validation schema YAML
✅ Validation structure dossiers
✅ Validation liens Markdown
✅ Vérification proven-in-use (count)
```

### Review Humaine (Table de Gouvernance)

**Critères évalués** :
1. **Pertinence** : Patron réutilisable et généralisable ?
2. **Qualité** : Documentation claire et complète ?
3. **Validation** : Proven-in-use crédibles ?
4. **Originalité** : Pas de doublon ?

**Timeline** :
- Jour 0 : Soumission PR
- Jour 1-2 : Review auto + assignation reviewers
- Jour 2-4 : Review humaine + feedback
- Jour 5 : Décision finale (approve/reject/revise)

**Feedback** :
- Commentaires inline sur GitHub
- Discussions constructives
- Suggestions d'amélioration

---

## ✅ Checklist Avant Soumission

### Documentation

- [ ] Toutes les sections du template remplies
- [ ] Résumé en 2-3 phrases clair
- [ ] Quand utiliser / ne pas utiliser défini
- [ ] Architecture décrite ou diagramme fourni
- [ ] Stack technologique listée
- [ ] Au moins 1 ADR documenté
- [ ] Étapes d'implémentation détaillées
- [ ] Au moins 1 exemple concret fourni
- [ ] Au moins 1 retour d'expérience (3+ pour approved)
- [ ] Limitations et pièges documentés
- [ ] Références fournies

### Métadonnées YAML

- [ ] ID unique (demandé à l'équipe Initiative)
- [ ] Nom descriptif
- [ ] Catégorie correcte (tech|integration|security|business)
- [ ] 3-10 tags pertinents
- [ ] Statut correct (candidate pour nouveau)
- [ ] Auteur et mainteneur renseignés
- [ ] Dates créées/mises à jour
- [ ] Proven-in-use avec retours concrets

### Technique

- [ ] Validation locale passée (`validate-metadata.sh`)
- [ ] Liens Markdown tous fonctionnels
- [ ] Code d'exemple testé
- [ ] Pas de secrets/credentials hardcodés
- [ ] Structure de dossiers conforme

### Processus

- [ ] Branch nommée correctement (`pra/nouveau-...`)
- [ ] Commit message descriptif
- [ ] PR utilise le template
- [ ] Labels assignés
- [ ] Pas de doublon vérifié

---

## 💡 Bonnes Pratiques

### Rédaction

1. **Soyez concis** : Phrases courtes et claires
2. **Utilisez des exemples** : Montrez, ne dites pas seulement
3. **Quantifiez** : "40% réduction" > "amélioration significative"
4. **Structurez** : Utilisez listes, tableaux, diagrammes

### Collaboration

1. **Communiquez tôt** : Discutez avant de coder
2. **Acceptez le feedback** : Reviews constructives
3. **Soyez respectueux** : Discussions professionnelles
4. **Partagez** : Retours d'expérience honnêtes

### Maintenance

1. **Mettez à jour** : Gardez vos PRA à jour
2. **Répondez** : Questions communauté
3. **Évoluez** : Proposez améliorations
4. **Documentez** : Nouveaux proven-in-use

---

## ❓ FAQ

### Q: Combien de temps pour review ?
**R** : Maximum 5 jours ouvrés. Moyenne 2-3 jours.

### Q: Puis-je soumettre un PRA sans implémentation ?
**R** : Non. Minimum 1 proven-in-use requis pour candidat.

### Q: Comment obtenir un ID de PRA ?
**R** : Contactez l'équipe Initiative PRA ou laissez vide, l'ID sera assigné lors du merge.

### Q: Puis-je contribuer en français ?
**R** : Oui ! Français et anglais acceptés.

### Q: Et si mon PRA est rejeté ?
**R** : Feedback fourni. Possibilité de réviser et re-soumettre.

### Q: Comment devenir mainteneur ?
**R** : Soumettez des PRA de qualité. Mainteneur assigné au merge.

### Q: Puis-je mettre à jour le PRA d'un autre ?
**R** : Oui ! Soumettez une PR. Le mainteneur reviewera.

### Q: Quelle est la différence candidat/approved ?
**R** : Candidat = 1+ proven-in-use. Approved = 3+ proven-in-use + 6 mois.

---

## 🆘 Besoin d'Aide ?

### Canaux de Support

- **Teams** : [#pra-registry](https://teams.microsoft.com/...)
- **GitHub Issues** : [Questions](https://github.com/org/pra-registry/issues/new?template=question.yml)
- **Email** : pra-initiative@example.com

### Ressources

- [GOVERNANCE.md](./GOVERNANCE.md) - Processus décision
- [LIFECYCLE.md](./LIFECYCLE.md) - Cycle de vie
- [STANDARDS.md](./STANDARDS.md) - Standards qualité
- [Templates](../templates/) - Templates PRA/ADR

---

**Merci de contribuer au registre PRA ! 🎉**

**Document maintenu par** : Équipe Initiative PRA
**Feedback** : Ouvrez une [Issue](https://github.com/org/pra-registry/issues)
