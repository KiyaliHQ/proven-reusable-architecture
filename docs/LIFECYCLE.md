# Cycle de Vie des PRA

Ce document décrit le cycle de vie complet d'un Proven Reusable Architecture (PRA), de sa création à son archivage.

**Version** : 1.0
**Dernière mise à jour** : 28 novembre 2025

---

## 📋 Table des Matières

1. [Vue d'Ensemble](#vue-densemble)
2. [États du Cycle de Vie](#états-du-cycle-de-vie)
3. [Transitions d'État](#transitions-détat)
4. [Critères par État](#critères-par-état)
5. [Versioning](#versioning)
6. [Maintenance](#maintenance)
7. [Métriques & Suivi](#métriques--suivi)

---

## 🌐 Vue d'Ensemble

### Diagramme du Cycle de Vie

```
                    ┌─────────────┐
           ┌────────│   IDEATION  │◀────────┐
           │        └──────┬──────┘         │
           │               │                │
           │               │ Création       │
           │               ▼                │
           │        ┌─────────────┐         │
           │        │  CANDIDATE  │         │
           │        └──────┬──────┘         │
           │               │                │
           │               │ Promotion      │ Rejet
           │               │ (3+ proven)    │
           │               ▼                │
           │        ┌─────────────┐         │
           │    ┌──│  APPROVED   │         │
           │    │  └──────┬──────┘         │
           │    │         │                │
           │    │         │ Dépréciation   │
           │    │         ▼                │
           │    │  ┌─────────────┐         │
           │    │  │ DEPRECATED  │─────────┘
           │    │  └──────┬──────┘
           │    │         │
           │    │         │ Archivage
           │    │         ▼
           │    │  ┌─────────────┐
           │    └─▶│  ARCHIVED   │
           │       └─────────────┘
           │               ▲
           │               │
           └───────────────┘
              Archivage direct
```

### Durées Typiques

| État | Durée Minimale | Durée Typique | Durée Maximale |
|------|----------------|---------------|----------------|
| **Candidate** | - | 6 mois | 18 mois |
| **Approved** | 6 mois | 2-3 ans | Indéfinie |
| **Deprecated** | - | 6 mois | 12 mois |

---

## 📊 États du Cycle de Vie

### 1. IDEATION (Pré-PRA)

**Description** : Phase de réflexion avant création formelle

**Caractéristiques** :
- ❌ Pas encore dans le registre
- ✅ Discussion communauté (Teams, Issues)
- ✅ Exploration de faisabilité
- ✅ Recherche de patterns existants

**Actions typiques** :
- Créer une Issue "Proposition PRA"
- Discuter avec la communauté
- Vérifier l'absence de doublons
- Rassembler la documentation initiale

**Durée** : Variable (1-4 semaines)

**Sortie** :
- ✅ Décision de créer un PRA candidat
- ❌ Abandon de l'idée

---

### 2. CANDIDATE (Candidat)

**Description** : PRA en cours de validation, avec au moins 1 implémentation

**Métadonnées** :
```yaml
status: candidate
version: 1.0.0
proven_in_use:
  - project: "Project Alpha"
    team: "Team Infrastructure"
    date: "2024-06-15"
    feedback: "40% réduction temps déploiement"
```

**Caractéristiques** :
- ✅ Documentation complète (template rempli)
- ✅ Au moins 1 ADR
- ✅ Au moins 1 exemple
- ✅ **Minimum 1 proven-in-use**
- ✅ Visible dans le registre (section "Candidats")
- ⚠️ Peut évoluer (changements mineurs/majeurs)

**Objectifs** :
1. Collecter 3+ proven-in-use
2. Stabiliser l'architecture
3. Affiner la documentation
4. Recueillir feedback communauté

**Indicateurs de Santé** :
- 🟢 **Bon** : 1+ nouveau proven-in-use tous les 3 mois
- 🟡 **Moyen** : Pas de nouveau proven-in-use depuis 6 mois
- 🔴 **Mauvais** : Pas de nouveau proven-in-use depuis 12 mois → Archivage

**Durée Typique** : 6-18 mois

**Transition vers APPROVED** :
- ✅ 3+ proven-in-use documentés
- ✅ Au moins 2 équipes différentes
- ✅ Minimum 6 mois en candidat
- ✅ Pas de changements majeurs depuis 3 mois

**Transition vers ARCHIVED** :
- ❌ Non utilisé depuis 12 mois
- ❌ Feedback négatif récurrent
- ❌ Décision Table de Gouvernance

---

### 3. APPROVED (Approuvé)

**Description** : PRA validé avec 3+ implémentations réussies

**Métadonnées** :
```yaml
status: approved
version: 1.0.0
proven_in_use:
  - project: "Project Alpha"
    team: "Team Infrastructure"
    date: "2024-06-15"
    feedback: "40% réduction temps déploiement"
  - project: "Project Beta"
    team: "Team Platform"
    date: "2024-09-10"
    feedback: "Amélioration traçabilité"
  - project: "Project Gamma"
    team: "Team DevOps"
    date: "2025-01-20"
    feedback: "Adoption facile"
```

**Caractéristiques** :
- ✅ **3+ proven-in-use** documentés
- ✅ Architecture stable
- ✅ Documentation mature
- ✅ Publication sur Confluence
- ✅ Recommandé officiellement
- ⚠️ Changements majeurs déconseillés

**Objectifs** :
1. Maintenir la qualité
2. Collecter feedback continu
3. Mise à jour mineure si nécessaire
4. Assistance communauté

**Maintenance** :
- **Mensuelle** : Vérification liens/dépendances
- **Trimestrielle** : Review feedback
- **Annuelle** : Évaluation pertinence

**Indicateurs de Santé** :
- 🟢 **Bon** : Utilisé activement (1+ projet/trimestre)
- 🟡 **Moyen** : Pas d'utilisation depuis 6 mois
- 🔴 **Mauvais** : Pas d'utilisation depuis 12 mois → Considérer dépréciation

**Durée Typique** : 2-3 ans (peut être indéfinie)

**Transition vers DEPRECATED** :
- ❌ Technologie obsolète
- ❌ Meilleur patron disponible (remplacé par PRA-XXX)
- ❌ Non utilisé depuis 12+ mois
- ❌ Feedback négatif récurrent

---

### 4. DEPRECATED (Déprécié)

**Description** : PRA obsolète, remplacé ou non recommandé

**Métadonnées** :
```yaml
status: deprecated
version: 1.2.0
replaced_by: pra-150  # Si remplacé par un nouveau PRA
```

**Caractéristiques** :
- ⚠️ **Banner dépréciation** en haut du README
- ⚠️ Lien vers PRA de remplacement (si applicable)
- ✅ Toujours accessible (lecture seule)
- ❌ Plus recommandé pour nouveaux projets
- ⚠️ Projets existants peuvent continuer

**Banner Exemple** :
```markdown
> ⚠️ **PRA DÉPRÉCIÉ**
>
> Ce PRA est déprécié depuis le DD/MM/YYYY.
> **Raison** : Remplacé par [PRA-150: Nouveau Patron](../pra-150/README.md)
>
> **Projets existants** : Peuvent continuer à l'utiliser
> **Nouveaux projets** : Utiliser le PRA de remplacement
```

**Objectifs** :
1. Communication claire de la dépréciation
2. Migration progressive vers nouveau patron
3. Support limité (questions seulement)

**Maintenance** :
- ❌ Plus de mises à jour fonctionnelles
- ✅ Corrections critiques seulement (sécurité)
- ✅ Réponses aux questions limitées

**Durée** : 6-12 mois

**Transition vers ARCHIVED** :
- ❌ Plus utilisé depuis 6 mois
- ❌ Migration complète vers nouveau patron

---

### 5. ARCHIVED (Archivé)

**Description** : PRA retiré du registre actif

**Caractéristiques** :
- 📦 Marqué `status: deprecated` dans le frontmatter (reste dans son emplacement)
- ❌ Retiré du site Fumadocs
- ❌ Plus visible dans la navigation
- ✅ Conservé dans Git (historique)
- ✅ Accessible via lien direct si besoin

**Raisons d'archivage** :
- Deprecated depuis 6+ mois sans utilisation
- Candidat rejeté définitivement
- Fusionné avec un autre PRA

**Actions** :
```bash
# Archivage = mise à jour du status dans le frontmatter
# Le fichier reste dans content/pras/fr/bank-wide/[category]/operationalized/[pra-name].md
# Mettre à jour: status: deprecated
```

**Durée** : Indéfinie (historique)

---

## 🔄 Transitions d'État

### Matrice de Transitions

| De | À | Déclencheur | Qui peut initier | Approbation requise |
|----|---|-------------|------------------|---------------------|
| **Ideation** | **Candidate** | Création PR | Contributeur | Table Gouvernance (2) |
| **Candidate** | **Approved** | 3+ proven-in-use | Mainteneur, Contributeur | Table Gouvernance (2) |
| **Candidate** | **Archived** | Non utilisé 12+ mois | Table Gouvernance | Table Gouvernance (vote) |
| **Approved** | **Deprecated** | Obsolescence | Mainteneur, Table Gouvernance | Table Gouvernance (2) |
| **Deprecated** | **Archived** | Plus utilisé 6+ mois | Table Gouvernance | Table Gouvernance (vote) |
| **Deprecated** | **Approved** | Réactivation (rare) | Table Gouvernance | Table Gouvernance (unanimité) |

### Détail des Transitions

#### Candidate → Approved

**Critères stricts** :
1. ✅ **3+ proven-in-use** avec feedback quantifié
2. ✅ **Diversité** : Au moins 2 équipes différentes
3. ✅ **Maturité** : Minimum 6 mois en candidat
4. ✅ **Stabilité** : Pas de changements majeurs depuis 3 mois
5. ✅ **Feedback positif** : > 80% satisfaction (si survey)

**Processus** :
1. Mainteneur crée PR `pra/promote-pra-xxx-to-approved`
2. Update métadonnées (`status: approved`)
3. GitHub Actions validation auto
4. Review Table de Gouvernance (2 approvals)
5. Merge → Publication Confluence + Communication

#### Approved → Deprecated

**Raisons valides** :
- Technologie obsolète (ex: Flash, AngularJS 1.x)
- Meilleur patron disponible (PRA plus moderne)
- Sécurité compromise (vulnérabilités non patchables)
- Non utilisé depuis 12+ mois

**Processus** :
1. Mainteneur ou Table Gouvernance crée PR
2. Ajout banner dépréciation
3. Update métadonnées (`status: deprecated`, `replaced_by`)
4. Review Table de Gouvernance
5. Merge → Communication communauté

#### Deprecated → Archived

**Critères** :
- 6+ mois en deprecated
- Plus aucune utilisation active
- Migration complète si applicable

**Processus** :
1. Table de Gouvernance initie
2. Mise à jour `status: deprecated` dans le frontmatter
3. Retrait du site Fumadocs
4. Communication finale

---

## 📏 Critères par État

### Récapitulatif

| Critère | Candidate | Approved | Deprecated | Archived |
|---------|-----------|----------|------------|----------|
| **Proven-in-use** | 1+ | 3+ | N/A | N/A |
| **Équipes différentes** | 1+ | 2+ | N/A | N/A |
| **Durée minimale** | - | 6 mois | - | - |
| **Stabilité** | Peut changer | Stable | Lecture seule | Lecture seule |
| **Recommandé** | ⚠️ Expérimental | ✅ Oui | ❌ Non | ❌ Non |
| **Visible catalogue** | ✅ Oui | ✅ Oui | ⚠️ Avec warning | ❌ Non |
| **Publication Confluence** | ❌ Non | ✅ Oui | ⚠️ Avec warning | ❌ Non |

---

## 🔢 Versioning

### Semantic Versioning

Format : `MAJOR.MINOR.PATCH`

**MAJOR** : Changements incompatibles
- Architecture modifiée substantiellement
- Breaking changes
- Exemple : `1.5.2` → `2.0.0`

**MINOR** : Nouvelles fonctionnalités (compatibles)
- Ajout nouveau cas d'usage
- Nouvel exemple
- Exemple : `1.5.2` → `1.6.0`

**PATCH** : Corrections
- Typos
- Clarifications
- Corrections mineures
- Exemple : `1.5.2` → `1.5.3`

### Quand incrémenter ?

| Type de changement | Version | Exemple |
|--------------------|---------|---------|
| Ajout proven-in-use | PATCH | 1.0.0 → 1.0.1 |
| Ajout exemple | MINOR | 1.0.0 → 1.1.0 |
| Correction typo | PATCH | 1.0.0 → 1.0.1 |
| Architecture modifiée | MAJOR | 1.5.0 → 2.0.0 |
| Promotion candidat→approved | Reset à 1.0.0 | 0.5.3 → 1.0.0 |

---

## 🔧 Maintenance

### Calendrier de Maintenance

#### Hebdomadaire (Mainteneur)

- [ ] Répondre aux questions communauté
- [ ] Trier les Issues GitHub
- [ ] Review des PRs mineures

#### Mensuel (Mainteneur)

- [ ] Vérifier les liens externes
- [ ] Vérifier les dépendances technologiques
- [ ] Mettre à jour versions si nécessaire

#### Trimestriel (Table de Gouvernance)

- [ ] Review feedback communauté
- [ ] Analyser métriques d'utilisation
- [ ] Évaluer santé du PRA
- [ ] Décider actions (maintenance, dépréciation)

#### Annuel (Table de Gouvernance)

- [ ] Audit complet du PRA
- [ ] Évaluation pertinence long terme
- [ ] Révision architecture si technologie évolue
- [ ] Mise à jour standards

---

## 📊 Métriques & Suivi

### Métriques Collectées

| Métrique | Collecte | Fréquence | Usage |
|----------|----------|-----------|-------|
| **Nombre proven-in-use** | Manuel (PR) | Continu | Promotion candidat→approved |
| **Utilisation (projets actifs)** | Survey | Trimestrielle | Santé du PRA |
| **Feedback satisfaction** | Survey | Trimestrielle | Qualité |
| **Recherches site** | Analytics | Continue | Popularité |
| **Issues/Questions** | GitHub | Continue | Clarté documentation |

### Tableau de Bord (Dashboard)

Pour chaque PRA :
- 📊 **Statut actuel** : Candidate / Approved / Deprecated
- 📈 **Proven-in-use count** : X implémentations
- 🕒 **Âge** : X mois depuis création
- 🔥 **Activité** : Dernier usage il y a X mois
- 💬 **Feedback** : X% satisfaction
- 📚 **Maintenance** : Dernière mise à jour il y a X jours

### Alertes Automatiques

- 🟡 **Warning** : Candidat sans nouveau proven-in-use depuis 6 mois
- 🔴 **Critique** : Approved non utilisé depuis 12 mois
- ⚠️ **Action requise** : Liens externes brisés détectés

---

**Document maintenu par** : Équipe Initiative PRA
**Révision** : Trimestrielle
**Prochaine révision** : [Date]
