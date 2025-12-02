<!--
🌐 MULTILINGUAL SUPPORT

After creating your PRA in French, translate it to English using this prompt with your LLM:

"Translate this PRA document from French to English. Preserve all Markdown formatting,
keep technical terms unchanged, translate only human-readable text in frontmatter and content.
Update internal links from /registre/ to /en/registre/. See templates/TRANSLATION_PROMPT.md for details."

Save the English version to: content/en/registre/[same-path]/[same-filename].md
-->

---
# === MÉTADONNÉES YAML (obligatoires) ===
id: pra-XXX
name: "Nom du PRA"
category: tech                        # tech | integration | security | business
tags:
  - tag1
  - tag2
  - tag3
status: candidate                     # candidate | approved | deprecated
version: 1.0.0
author:
  name: "Prénom Nom"
  email: "prenom.nom@example.com"
maintainer:
  name: "Prénom Nom"
  email: "prenom.nom@example.com"
created: 2025-11-28
updated: 2025-11-28
proven_in_use: []                     # Vide pour candidat, 3+ requis pour approved
  # - project: "Nom du Projet"
  #   team: "Nom de l'Équipe"
  #   date: "2024-01-15"
  #   feedback: "Retour d'expérience concret"
dependencies: []                      # IDs d'autres PRA requis
replaces: null                        # ID du PRA remplacé (si dépréciation)
---

# PRA-XXX: [Nom du PRA]

## 📋 Résumé

[Description en 2-3 phrases du patron, son objectif et sa valeur ajoutée]

**Points clés** :
- ✅ Bénéfice principal 1
- ✅ Bénéfice principal 2
- ✅ Bénéfice principal 3

---

## 🎯 Contexte d'Application

### Quand utiliser ce PRA ?

Ce patron s'applique dans les situations suivantes :

- **Contexte 1** : [Description du contexte métier/technique]
- **Contexte 2** : [Description du contexte métier/technique]
- **Contexte 3** : [Description du contexte métier/technique]

### Quand NE PAS utiliser ce PRA ?

⚠️ **Contre-indications** :

- **Situation 1** : [Pourquoi ce patron n'est pas adapté]
- **Situation 2** : [Pourquoi ce patron n'est pas adapté]
- **Situation 3** : [Pourquoi ce patron n'est pas adapté]

---

## ❓ Problème Résolu

### Description du problème

[Description détaillée du problème récurrent que ce patron résout]

### Symptômes typiques

Les symptômes suivants indiquent que ce patron peut être utile :

- 🔴 **Symptôme 1** : [Description]
- 🔴 **Symptôme 2** : [Description]
- 🔴 **Symptôme 3** : [Description]

### Impact sans solution

Sans ce patron, les conséquences peuvent être :

- ❌ Impact business 1
- ❌ Impact technique 1
- ❌ Impact organisationnel 1

---

## ✅ Solution

### Description de la solution

[Description détaillée de la solution proposée par ce patron]

### Architecture

[Diagramme architecture ou description textuelle de l'architecture]

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│  Composant  │─────▶│  Composant  │─────▶│  Composant  │
│      A      │      │      B      │      │      C      │
└─────────────┘      └─────────────┘      └─────────────┘
```

### Principes de conception

1. **Principe 1** : [Description]
2. **Principe 2** : [Description]
3. **Principe 3** : [Description]

### Stack Technologique

| Composant | Technologie | Version | Rôle |
|-----------|-------------|---------|------|
| Composant 1 | Technologie 1 | X.Y+ | Description du rôle |
| Composant 2 | Technologie 2 | X.Y+ | Description du rôle |
| Composant 3 | Technologie 3 | X.Y+ | Description du rôle |

---

## 🏗️ Architecture Decision Records (ADR)

Ce PRA s'appuie sur les décisions architecturales suivantes :

### ADR-001: [Titre de la décision]

**Date** : YYYY-MM-DD
**Statut** : Approuvé
**Contexte** : [Voir adr/001-titre-decision.md](./adr/001-titre-decision.md)

**Décision** : [Résumé de la décision prise]

**Alternatives considérées** :
- Alternative 1 : [Pourquoi rejetée]
- Alternative 2 : [Pourquoi rejetée]

**Conséquences** :
- ✅ Avantage 1
- ✅ Avantage 2
- ⚠️ Compromis 1
- ⚠️ Compromis 2

---

## 📦 Prérequis

### Prérequis Techniques

- [ ] Prérequis technique 1
- [ ] Prérequis technique 2
- [ ] Prérequis technique 3

### Prérequis Organisationnels

- [ ] Prérequis organisationnel 1 (ex: formation équipe)
- [ ] Prérequis organisationnel 2 (ex: process de review)
- [ ] Prérequis organisationnel 3

### Compétences Requises

- **Développeurs** : [Compétences nécessaires]
- **Architectes** : [Compétences nécessaires]
- **Ops** : [Compétences nécessaires]

---

## 🚀 Implémentation

### Étape 1 : [Nom de l'étape]

**Objectif** : [Description de l'objectif]

**Actions** :
```bash
# Commandes ou pseudo-code
```

**Validation** :
- [ ] Critère de validation 1
- [ ] Critère de validation 2

### Étape 2 : [Nom de l'étape]

**Objectif** : [Description de l'objectif]

**Actions** :
```bash
# Commandes ou pseudo-code
```

**Validation** :
- [ ] Critère de validation 1
- [ ] Critère de validation 2

### Étape 3 : [Nom de l'étape]

**Objectif** : [Description de l'objectif]

**Actions** :
```bash
# Commandes ou pseudo-code
```

**Validation** :
- [ ] Critère de validation 1
- [ ] Critère de validation 2

---

## 📚 Exemples

### Exemple 1 : [Titre de l'exemple]

**Contexte** : [Description du contexte]

**Implémentation** :

[Voir examples/exemple-1/](./examples/exemple-1/)

```typescript
// Code d'exemple
```

**Résultat** : [Description du résultat obtenu]

### Exemple 2 : [Titre de l'exemple]

**Contexte** : [Description du contexte]

**Implémentation** :

[Voir examples/exemple-2/](./examples/exemple-2/)

```typescript
// Code d'exemple
```

**Résultat** : [Description du résultat obtenu]

---

## 🎓 Retours d'Expérience

> **Note** : Cette section est obligatoire pour un PRA **approved** (3+ retours requis)

### [Nom du Projet] ([Nom de l'Équipe])

**Contexte** : [Description du contexte du projet]

**Période** : [Date de début] - [Date de fin]

**Résultats quantitatifs** :
- ✅ **Métrique 1** : Valeur (ex: 40% réduction temps déploiement)
- ✅ **Métrique 2** : Valeur (ex: 100% traçabilité)
- ✅ **Métrique 3** : Valeur (ex: Zéro incident)

**Résultats qualitatifs** :
- ✅ Amélioration qualitative 1
- ✅ Amélioration qualitative 2

**Leçons apprises** :
- 💡 Leçon 1
- 💡 Leçon 2
- 💡 Leçon 3

**Recommandations** :
- 📌 Recommandation 1
- 📌 Recommandation 2

---

## ⚠️ Limitations & Pièges

### Limitations Connues

1. **Limitation 1**
   - **Description** : [Explication de la limitation]
   - **Impact** : [Impact sur l'utilisation]
   - **Workaround** : [Solution de contournement si disponible]

2. **Limitation 2**
   - **Description** : [Explication de la limitation]
   - **Impact** : [Impact sur l'utilisation]
   - **Workaround** : [Solution de contournement si disponible]

### Pièges Courants

#### ❌ Piège 1 : [Description du piège]

**Symptôme** : [Comment reconnaître le problème]

**Cause** : [Pourquoi ça arrive]

**Solution** : ✅ [Comment l'éviter ou le résoudre]

#### ❌ Piège 2 : [Description du piège]

**Symptôme** : [Comment reconnaître le problème]

**Cause** : [Pourquoi ça arrive]

**Solution** : ✅ [Comment l'éviter ou le résoudre]

---

## 🔄 Cycle de Vie & Maintenance

### Maintenance Régulière

| Fréquence | Actions | Responsable |
|-----------|---------|-------------|
| **Hebdomadaire** | Action hebdomadaire | Équipe Dev |
| **Mensuel** | Action mensuelle | Mainteneur PRA |
| **Trimestriel** | Action trimestrielle | Architecte |
| **Annuel** | Action annuelle | Table Gouvernance |

### Évolutions Prévues

- 🔮 **Court terme (3 mois)** : [Évolutions prévues]
- 🔮 **Moyen terme (6 mois)** : [Évolutions prévues]
- 🔮 **Long terme (1 an+)** : [Évolutions prévues]

### Critères de Dépréciation

Ce PRA sera considéré pour dépréciation si :

- ❌ Critère 1 (ex: technologie obsolète)
- ❌ Critère 2 (ex: meilleur patron disponible)
- ❌ Critère 3 (ex: non utilisé depuis 12 mois)

---

## 📖 Références

### Documentation Officielle

- [Technologie 1 - Docs](https://example.com)
- [Technologie 2 - Docs](https://example.com)
- [Standard/RFC pertinent](https://example.com)

### Articles & Ressources

- [Article 1 - Titre](https://example.com)
- [Article 2 - Titre](https://example.com)

### PRA Connexes

- [PRA-XXX: Nom du PRA](../pra-xxx/README.md) - Relation avec ce PRA

### Contacts & Support

**Mainteneur Principal** : [Nom] ([email@example.com](mailto:email@example.com))
**Mainteneur Secondaire** : [Nom] ([email@example.com](mailto:email@example.com))

**Communauté PRA** : [#pra-registry](https://teams.microsoft.com) (Microsoft Teams)
**Issues GitHub** : [Lien vers issues](https://github.com/org/pra-registry/issues)

---

**Dernière mise à jour** : YYYY-MM-DD
**Version** : X.Y.Z
**Statut** : ✅ Candidate | ✅ Approved | ⚠️ Deprecated
