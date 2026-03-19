# Gouvernance du Registre PRA

**Version** : 1.0
**Dernière mise à jour** : 28 novembre 2025

---

## 📋 Table des Matières

1. [Vision & Objectifs](#vision--objectifs)
2. [Structure de Gouvernance](#structure-de-gouvernance)
3. [Rôles & Responsabilités](#rôles--responsabilités)
4. [Processus de Soumission](#processus-de-soumission)
5. [Critères d'Approbation](#critères-dapprobation)
6. [Processus de Promotion](#processus-de-promotion)
7. [Cycle de Vie des PRA](#cycle-de-vie-des-pra)
8. [Processus de Révision](#processus-de-révision)
9. [Dépréciation & Archivage](#dépréciation--archivage)
10. [Résolution de Conflits](#résolution-de-conflits)

---

## 🎯 Vision & Objectifs

### Vision

Construire un **registre Git-native de Proven Reusable Architecture (PRA)** pour capitaliser les pratiques architecturales éprouvées et accélérer la conception au sein de l'entreprise.

### Objectifs

1. **Capitalisation** : Documenter et partager les architectures validées ("proven-in-use")
2. **Accélération** : Réduire le temps de conception en réutilisant des solutions éprouvées
3. **Cohérence** : Renforcer l'alignement architectural entre équipes et projets
4. **IA-Friendly** : Permettre aux agents IA d'exploiter le registre pour recommander des architectures
5. **Expérience** : Offrir une expérience intuitive aux architectes humains

---

## 🏛️ Structure de Gouvernance

### Table de Gouvernance PRA

**Composition** : 5-7 architectes seniors

**Responsabilités** :
- Review et approbation des PRA
- Maintien des standards de qualité
- Arbitrage en cas de conflit
- Évolution des processus de gouvernance
- Suivi des métriques du registre

**Fréquence de réunion** : Bi-hebdomadaire (2 semaines)

**Quorum** : 3 membres minimum

**Décision** : Majorité simple (50% + 1)

### Équipe Initiative PRA

**Composition** : 2-3 personnes

**Responsabilités** :
- Maintenance infrastructure (repo, CI/CD)
- Support communauté (questions, onboarding)
- Animation (formations, communications)
- Reporting métriques

---

## 👥 Rôles & Responsabilités

### 1. Architecte Contributeur

**Qui** : Tous les architectes de l'entreprise

**Permissions** :
- ✅ Soumettre des PRA candidats
- ✅ Proposer des mises à jour de PRA existants
- ✅ Participer aux discussions
- ✅ Consulter tous les PRA

**Responsabilités** :
- Documenter les PRA selon les templates
- Fournir des retours d'expérience ("proven-in-use")
- Maintenir les PRA dont ils sont mainteneurs
- Justifier les non-utilisations de PRA

### 2. Mainteneur de PRA

**Qui** : Architecte assigné à un PRA spécifique

**Permissions** :
- ✅ Mettre à jour le PRA assigné
- ✅ Valider les PRs pour ce PRA
- ✅ Proposer la dépréciation si nécessaire

**Responsabilités** :
- Maintenir le PRA à jour
- Répondre aux questions
- Collecter les retours d'expérience
- Proposer des évolutions

### 3. Membre Table de Gouvernance

**Qui** : 5-7 architectes seniors désignés

**Permissions** :
- ✅ Toutes les permissions des Contributeurs
- ✅ Approuver/rejeter les PRA
- ✅ Modifier les standards
- ✅ Arbitrer les conflits

**Responsabilités** :
- Review rigoureux des PRA
- Maintien de la qualité du registre
- Évolution de la gouvernance
- Reporting au leadership

### 4. Équipe Initiative

**Qui** : 2-3 personnes dédiées

**Permissions** :
- ✅ Admin complet du repository
- ✅ Configuration CI/CD
- ✅ Gestion des secrets

**Responsabilités** :
- Infrastructure technique
- Support communauté
- Formations & onboarding
- Reporting métriques

---

## 📝 Processus de Soumission

### Étape 1 : Préparation

1. **Vérifier l'existence** : Chercher si un PRA similaire existe déjà
2. **Collecter les données** : Rassembler la documentation et les exemples
3. **Valider le critère "proven-in-use"** :
   - Pour **candidat** : au moins 1 implémentation
   - Pour **approved** : 3+ implémentations documentées

### Étape 2 : Création Branch

```bash
git checkout main
git pull origin main
git checkout -b pra/nouveau-pra-nom-descriptif
```

### Étape 3 : Copie Template

```bash
# Pour un PRA candidat
cp templates/pra-template.md content/pras/fr/transversale/[category]/operationalizing/[pra-name].md

# Créer la version anglaise
cp templates/pra-template.md content/pras/en/transversale/[category]/operationalizing/[pra-name].md
```

### Étape 4 : Remplissage

- Compléter toutes les sections du template
- Ajouter au moins 1 ADR dans `adr/`
- Fournir au moins 1 exemple dans `examples/`
- Documenter les retours d'expérience ("proven-in-use")

### Étape 5 : Validation Locale

```bash
# Validation métadonnées YAML
./scripts/validate-metadata.sh content/pras/fr/transversale/[category]/operationalizing/[pra-name].md

# Validation liens Markdown
# (manuel ou via outil)
```

### Étape 6 : Pull Request

1. Push de la branch
   ```bash
   git add .
   git commit -m "feat(pra): Add PRA-XXX - [Nom]"
   git push origin pra/nouveau-pra-nom-descriptif
   ```

2. Créer PR sur GitHub avec template
   - Titre : `[PRA] Nouveau PRA Candidat: [Nom]`
   - Description : Résumé du PRA
   - Labels : `pra-candidat`, `category:[tech|integration|security|business]`

### Étape 7 : Review Automatique

GitHub Actions exécute :
- ✅ Validation schema YAML
- ✅ Validation structure dossiers
- ✅ Validation liens Markdown
- ✅ Vérification "proven-in-use" (1+ pour candidat)

### Étape 8 : Review Humaine

- **Délai** : 5 jours ouvrés maximum
- **Reviewers** : 2 membres de la Table de Gouvernance
- **Critères** : Voir [Critères d'Approbation](#critères-dapprobation)

### Étape 9 : Merge

Une fois approuvé :
- Merge dans `main`
- PRA candidat créé
- Site Fumadocs auto-déployé
- Communication automatique (Teams/email)

---

## ✅ Critères d'Approbation

### Pour PRA Candidat

| Critère | Requis | Description |
|---------|--------|-------------|
| **Template complet** | ✅ Oui | Toutes les sections remplies |
| **Métadonnées valides** | ✅ Oui | YAML frontmatter conforme au schema |
| **ADR** | ✅ Oui | Au moins 1 ADR documenté |
| **Exemples** | ✅ Oui | Au moins 1 exemple concret |
| **Proven-in-use** | ✅ Oui | **Minimum 1** implémentation documentée |
| **Liens fonctionnels** | ✅ Oui | Tous les liens Markdown valides |
| **Clarté** | ✅ Oui | Documentation claire et compréhensible |
| **Pertinence** | ✅ Oui | Patron réutilisable et généralisable |

### Pour PRA Approved

| Critère | Requis | Description |
|---------|--------|-------------|
| **Tous critères Candidat** | ✅ Oui | Tous les critères ci-dessus |
| **Proven-in-use** | ✅ Oui | **Minimum 3** implémentations documentées |
| **Diversité projets** | ✅ Oui | Au moins 2 équipes différentes |
| **Feedback positif** | ✅ Oui | Retours quantifiés et mesurables |
| **Stabilité** | ✅ Oui | Pas de changements majeurs depuis 3+ mois |

---

## 🚀 Processus de Promotion

### Candidat → Approved

#### Critères de Promotion

1. ✅ **3+ proven-in-use** : Au moins 3 implémentations réussies documentées
2. ✅ **Diversité** : Au moins 2 équipes différentes
3. ✅ **Maturité** : Au moins 6 mois depuis création en candidat
4. ✅ **Stabilité** : Pas de changements majeurs depuis 3 mois
5. ✅ **Feedback positif** : Retours quantifiés et mesurables

#### Processus

1. **Initiation** : Mainteneur ou contributeur crée une PR
   ```bash
   git checkout -b pra/promote-pra-xxx-to-approved
   git mv content/pras/fr/transversale/[category]/operationalizing/[pra-name].md content/pras/fr/transversale/[category]/operationalized/[pra-name].md
   ```

2. **Mise à jour métadonnées**
   ```yaml
   status: approved
   version: 1.0.0  # Reset version si pertinent
   ```

3. **Validation GitHub Actions**
   - Vérification 3+ proven-in-use
   - Vérification diversité équipes
   - Validation schema

4. **Review Table de Gouvernance**
   - 2 approbations requises
   - Validation critères promotion

5. **Merge & Communication**
   - Publication Confluence automatique
   - Annonce communauté (Teams/email)
   - Mise à jour site Fumadocs

---

## 🔄 Cycle de Vie des PRA

### États Possibles

```
┌─────────────┐
│  Candidate  │──────────────────┐
└──────┬──────┘                  │
       │                         │
       │ Promotion               │ Rejet
       │ (3+ proven-in-use)      │
       │                         │
       ▼                         ▼
┌─────────────┐           ┌──────────┐
│  Approved   │──────────▶│ Archived │
└──────┬──────┘ Déprécie └──────────┘
       │
       │ Remplacement
       │
       ▼
┌─────────────┐
│ Deprecated  │
└─────────────┘
```

### Transitions

| De | À | Conditions | Qui peut initier |
|----|---|------------|------------------|
| **Candidate** | **Approved** | 3+ proven-in-use, 6+ mois | Mainteneur, Contributeur |
| **Candidate** | **Archived** | Non utilisé 12+ mois | Table Gouvernance |
| **Approved** | **Deprecated** | Remplacé par nouveau PRA | Mainteneur, Table Gouvernance |
| **Deprecated** | **Archived** | 6+ mois sans utilisation | Table Gouvernance |

---

## 🔍 Processus de Révision

### Révision Trimestrielle

**Objectif** : Maintenir la qualité et la pertinence

**Processus** :
1. Table de Gouvernance examine tous les PRA
2. Vérification des métriques d'utilisation
3. Collecte des feedbacks communauté
4. Identification des PRA à mettre à jour/déprécier

**Critères de révision** :
- ✅ PRA utilisé dans les 6 derniers mois ?
- ✅ Feedback positif récent ?
- ✅ Technologies encore pertinentes ?
- ✅ Documentation à jour ?

### Révision Annuelle

**Objectif** : Évolution stratégique du registre

**Processus** :
1. Analyse des tendances architecturales
2. Identification des gaps
3. Roadmap des nouveaux PRA prioritaires
4. Revue des processus de gouvernance

---

## 🗄️ Dépréciation & Archivage

### Dépréciation

**Critères** :
- ❌ Technologie obsolète
- ❌ Meilleur patron disponible (remplacé par PRA-XXX)
- ❌ Non utilisé depuis 12+ mois
- ❌ Feedback négatif récurrent

**Processus** :
1. Mainteneur propose dépréciation (PR)
2. Review Table de Gouvernance
3. Si approuvé :
   - Update `status: deprecated`
   - Ajouter `replaced_by: pra-XXX` si applicable
   - Ajouter banner dépréciation en haut du README
   - Conserver 6 mois en état deprecated
4. Communication communauté

### Archivage

**Critères** :
- ❌ Deprecated depuis 6+ mois sans utilisation
- ❌ Rejeté définitivement

**Processus** :
1. Mise à jour `status: deprecated` dans le frontmatter
2. Suppression du site Fumadocs
3. Maintien dans Git (historique)

---

## ⚖️ Résolution de Conflits

### Types de Conflits

1. **Désaccord sur l'approbation** : Table de Gouvernance vote (majorité simple)
2. **PRA en doublon** : Table de Gouvernance décide lequel conserver
3. **Désaccord technique** : Escalade au leadership architecture

### Processus d'Escalade

```
Niveau 1: Discussion communauté (Issue GitHub)
   ↓ (non résolu après 2 semaines)
Niveau 2: Table de Gouvernance (vote)
   ↓ (non résolu ou contestation)
Niveau 3: Leadership Architecture (décision finale)
```

---

## 📊 Métriques de Gouvernance

### Métriques Suivies

| Métrique | Cible | Mesure |
|----------|-------|--------|
| **Temps de review PR** | < 5 jours | Médiane |
| **Taux d'approbation** | > 70% | % PRs merged |
| **Utilisation PRA** | > 50% architectes | % actifs/mois |
| **Feedback positif** | > 80% | Survey trimestriel |
| **Nouveaux PRA** | 2-3/mois | Count |

### Reporting

- **Hebdomadaire** : Équipe Initiative (métriques opérationnelles)
- **Mensuel** : Table de Gouvernance (métriques stratégiques)
- **Trimestriel** : Leadership Architecture (business value)

---

## 🔄 Évolution de la Gouvernance

Ce document de gouvernance est vivant et peut être modifié par :

1. **Proposition** : Membre Table de Gouvernance crée PR sur `docs/GOVERNANCE.md`
2. **Discussion** : Communauté commente (min 2 semaines)
3. **Vote** : Table de Gouvernance (majorité ⅔ requise)
4. **Communication** : Annonce changements à la communauté

---

**Document maintenu par** : Équipe Initiative PRA
**Dernière révision** : Trimestrielle
**Prochaine révision** : [Date]
