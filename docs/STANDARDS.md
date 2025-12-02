# Standards de Qualité - Registre PRA

Ce document définit les standards de qualité pour tous les Proven Reusable Architecture (PRA) du registre.

**Version** : 1.0
**Dernière mise à jour** : 28 novembre 2025

---

## 📋 Table des Matières

1. [Principes Fondamentaux](#principes-fondamentaux)
2. [Standards de Documentation](#standards-de-documentation)
3. [Standards Techniques](#standards-techniques)
4. [Standards d'Exemples](#standards-dexemples)
5. [Standards de Métadonnées](#standards-de-métadonnées)
6. [Standards ADR](#standards-adr)
7. [Standards de Validation](#standards-de-validation)
8. [Checklist Qualité](#checklist-qualité)

---

## 🎯 Principes Fondamentaux

### 1. Proven-in-Use (Éprouvé en Production)

**Principe** : Tout PRA doit être basé sur une expérience réelle, pas théorique.

✅ **Bon** :
```yaml
proven_in_use:
  - project: "E-commerce Platform v2"
    team: "Team Checkout"
    date: "2024-06-15"
    feedback: "40% réduction temps déploiement, 0 incidents en 6 mois"
```

❌ **Mauvais** :
```yaml
proven_in_use:
  - project: "Projet Test"
    team: "Équipe"
    date: "2024-01-01"
    feedback: "Ça marche bien"
```

**Critères** :
- ✅ Nom de projet réel
- ✅ Équipe identifiable
- ✅ Date précise
- ✅ Feedback **quantifié** et mesurable

---

### 2. Réutilisabilité

**Principe** : Le patron doit être applicable dans **différents contextes**, pas spécifique à un seul projet.

✅ **Bon** : "CI/CD GitOps avec ArgoCD pour Kubernetes"
- Applicable à tout projet Kubernetes
- Technologie standard
- Pattern généralisable

❌ **Mauvais** : "CI/CD pour Project Alpha avec script bash custom"
- Spécifique à un projet
- Solution non standard
- Non réutilisable ailleurs

---

### 3. Généralisation

**Principe** : Documenter le **patron**, pas l'implémentation spécifique.

✅ **Bon** :
```markdown
## Stack Technologique

| Composant | Technologie | Version | Rôle |
|-----------|-------------|---------|------|
| GitOps Tool | ArgoCD | 2.9+ | Déploiement continu |
| Container Orchestrator | Kubernetes | 1.28+ | Runtime |
```

❌ **Mauvais** :
```markdown
On utilise ArgoCD 2.10.3 sur notre cluster AKS avec 5 nodes D4s_v5
```

---

### 4. Clarté & Accessibilité

**Principe** : Documentation **claire** pour tous niveaux (junior à senior).

✅ **Bon** :
```markdown
### Quand utiliser ce PRA ?

- **Projets microservices** : Plus de 3 services déployés indépendamment
- **Équipes multiples** : Plusieurs équipes contribuant au même cluster
- **Déploiements fréquents** : 5+ déploiements par semaine
```

❌ **Mauvais** :
```markdown
### Quand utiliser

Utiliser quand GitOps est requis
```

---

## 📖 Standards de Documentation

### Structure Obligatoire

Toutes les sections du template doivent être remplies :

1. ✅ **Résumé** (2-3 phrases)
2. ✅ **Contexte d'Application** (Quand utiliser / ne pas utiliser)
3. ✅ **Problème Résolu** (Description + symptômes)
4. ✅ **Solution** (Architecture + stack)
5. ✅ **ADR** (Au moins 1)
6. ✅ **Prérequis** (Techniques + organisationnels)
7. ✅ **Implémentation** (Étapes détaillées)
8. ✅ **Exemples** (Au moins 1)
9. ✅ **Retours d'Expérience** (Proven-in-use)
10. ✅ **Limitations & Pièges**
11. ✅ **Références**

### Longueur

| Section | Minimum | Optimal | Maximum |
|---------|---------|---------|---------|
| **Résumé** | 2 phrases | 3 phrases | 5 phrases |
| **Contexte** | 3 points | 5 points | 10 points |
| **Solution** | 200 mots | 500 mots | 1000 mots |
| **Implémentation** | 3 étapes | 5 étapes | 10 étapes |
| **Total README** | 1500 mots | 3000 mots | 5000 mots |

### Ton & Style

✅ **Faire** :
- Utiliser un langage simple et direct
- Phrases courtes (< 25 mots)
- Voix active ("Utiliser ArgoCD" vs "ArgoCD doit être utilisé")
- Listes à puces pour clarté
- Exemples concrets

❌ **Éviter** :
- Jargon sans explication
- Phrases longues et complexes
- Langage trop technique
- Assumptions implicites

### Formatage

✅ **Bon** :
```markdown
## Implémentation

### Étape 1 : Installation ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
\`\`\`

**Validation** :
- [ ] Pods ArgoCD en running
- [ ] Service argocd-server accessible
```

❌ **Mauvais** :
```markdown
Implémentation
Installer ArgoCD avec kubectl apply. Vérifier que ça marche.
```

---

## 🔧 Standards Techniques

### Code & Configuration

#### 1. Pas de Secrets Hardcodés

❌ **JAMAIS** :
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
stringData:
  password: "MyP@ssw0rd123"  # ❌ MAUVAIS
```

✅ **TOUJOURS** :
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
stringData:
  password: "${DB_PASSWORD}"  # ✅ BON - Variable d'environnement
```

#### 2. Exemples Génériques

✅ **Bon** :
```yaml
# values.yaml
image:
  repository: myapp
  tag: "1.0.0"

environment:
  DATABASE_URL: "postgresql://user:password@db:5432/mydb"
```

❌ **Mauvais** :
```yaml
# values.yaml
image:
  repository: "acr.azurecr.io/project-alpha/checkout-service"  # Trop spécifique
  tag: "2.5.3-hotfix-20241115"
```

#### 3. Versions Minimum Spécifiées

✅ **Bon** :
```markdown
| Composant | Technologie | Version | Rôle |
|-----------|-------------|---------|------|
| Kubernetes | K8s | **1.28+** | Orchestration |
| ArgoCD | ArgoCD | **2.9+** | GitOps |
```

❌ **Mauvais** :
```markdown
Nécessite Kubernetes récent et ArgoCD
```

#### 4. Compatibilité Documentée

```markdown
### Compatibilité

**Testé avec** :
- ✅ Kubernetes 1.28, 1.29, 1.30
- ✅ ArgoCD 2.9.x, 2.10.x
- ⚠️ Non testé avec Kubernetes < 1.28

**Limitations connues** :
- ❌ Ne fonctionne pas avec Docker Swarm
- ⚠️ Performances dégradées avec clusters < 3 nodes
```

---

## 📚 Standards d'Exemples

### Structure d'un Exemple

```
examples/
└── azure-pipeline-complete/
    ├── README.md              # Documentation de l'exemple
    ├── azure-pipelines.yml    # Fichier principal
    ├── manifests/             # Manifests Kubernetes
    │   ├── deployment.yaml
    │   └── service.yaml
    └── screenshots/           # Captures d'écran si pertinent
        └── pipeline-success.png
```

### README.md d'Exemple

**Obligatoire** :
```markdown
# Exemple : Azure Pipeline Complet

## Description
Pipeline CI/CD complet avec ArgoCD pour déploiement sur AKS.

## Prérequis
- Azure DevOps account
- Azure Kubernetes Service (AKS) cluster
- ArgoCD installé sur le cluster

## Structure
\`\`\`
.
├── azure-pipelines.yml    # Pipeline configuration
├── manifests/             # K8s manifests
\`\`\`

## Usage

1. Copier `azure-pipelines.yml` dans votre repo
2. Modifier les variables :
   - `AZURE_SUBSCRIPTION`
   - `AKS_CLUSTER_NAME`
3. Créer pipeline dans Azure DevOps
4. Déclencher build

## Résultat Attendu
- ✅ Image Docker buildée et poussée vers ACR
- ✅ Manifests mis à jour dans Git
- ✅ ArgoCD synchronise automatiquement

## Troubleshooting
[...]
```

### Qualité du Code

✅ **Bon** :
```yaml
# azure-pipelines.yml
trigger:
  branches:
    include:
      - main
      - develop

variables:
  # Modifier ces valeurs selon votre environnement
  AZURE_SUBSCRIPTION: 'MySubscription'
  AKS_CLUSTER_NAME: 'my-aks-cluster'
  IMAGE_NAME: 'myapp'
  IMAGE_TAG: '$(Build.BuildId)'

stages:
  - stage: Build
    jobs:
      - job: BuildAndPush
        steps:
          # Étape 1: Build Docker image
          - task: Docker@2
            displayName: 'Build Docker image'
            inputs:
              command: build
              dockerfile: Dockerfile
              tags: $(IMAGE_TAG)
```

❌ **Mauvais** :
```yaml
# Copier-coller de prod sans commentaires
trigger:
  - main
variables:
  SUB: 'abc-def-ghi'
  AKS: 'prod-aks-we'
  IMG: 'checkout'
stages:
  - stage: B
    jobs:
      - job: BP
```

---

## 🏷️ Standards de Métadonnées

### YAML Frontmatter

#### Obligatoire

```yaml
---
id: pra-001                    # Format: pra-XXX (3 chiffres)
name: "Nom Complet du PRA"     # Descriptif, unique
category: tech                 # tech|integration|security|business
tags:                          # 3-10 tags
  - tag1
  - tag2
status: candidate              # candidate|approved|deprecated
version: 1.0.0                 # Semantic versioning
author:
  name: "Prénom Nom"
  email: "email@example.com"
maintainer:
  name: "Prénom Nom"
  email: "email@example.com"
created: 2025-11-28            # YYYY-MM-DD
updated: 2025-11-28            # YYYY-MM-DD
proven_in_use:                 # 1+ pour candidate, 3+ pour approved
  - project: "Nom Projet"
    team: "Nom Équipe"
    date: "2024-06-15"
    feedback: "Feedback quantifié"
dependencies: []               # IDs autres PRA
replaces: null                 # ID PRA remplacé
---
```

#### Règles de Validation

| Champ | Type | Format | Validation |
|-------|------|--------|------------|
| **id** | string | `pra-XXX` | Regex: `^pra-\d{3}$` |
| **name** | string | 10-100 chars | Non vide, unique |
| **category** | enum | - | `tech\|integration\|security\|business` |
| **tags** | array | - | 3-10 éléments, lowercase, kebab-case |
| **status** | enum | - | `candidate\|approved\|deprecated` |
| **version** | string | `X.Y.Z` | Semantic versioning |
| **created** | date | `YYYY-MM-DD` | ISO 8601 |
| **proven_in_use** | array | - | 1+ pour candidate, 3+ pour approved |

### Tags

**Format** : `kebab-case` (lowercase avec tirets)

✅ **Bon** :
```yaml
tags:
  - ci-cd
  - gitops
  - argocd
  - kubernetes
  - devops
```

❌ **Mauvais** :
```yaml
tags:
  - CI/CD          # Pas de majuscules ou /
  - Git Ops        # Pas d'espaces
  - ArgoCD         # Pas de CamelCase
```

**Catégories de tags** :
- **Technologie** : `kubernetes`, `docker`, `argocd`
- **Pattern** : `gitops`, `event-driven`, `cqrs`
- **Domaine** : `ci-cd`, `security`, `monitoring`
- **Niveau** : `beginner`, `intermediate`, `advanced`

---

## 📋 Standards ADR

### Structure ADR

✅ **Complet** :
```markdown
# ADR-001: Choix ArgoCD vs FluxCD

**Date** : 2024-05-15
**Statut** : Approuvé
**Décideurs** : Alice, Bob, Charlie

## Contexte
[Problème à résoudre]

## Options Considérées
### Option 1 : ArgoCD
**Avantages** :
- UI native
[...]

**Inconvénients** :
- Consommation mémoire
[...]

### Option 2 : FluxCD
[...]

## Décision
Nous avons choisi **ArgoCD** car [raisons]

## Conséquences
- ✅ Adoption facilitée
- ⚠️ Consommation mémoire
```

❌ **Incomplet** :
```markdown
# ADR-001: ArgoCD

On a choisi ArgoCD car c'est mieux.
```

### Critères Minimum

- ✅ Contexte clair (pourquoi cette décision ?)
- ✅ Au moins **2 options** comparées
- ✅ Avantages/inconvénients documentés
- ✅ Décision justifiée
- ✅ Conséquences identifiées

---

## ✅ Standards de Validation

### Validation Automatique (CI)

```yaml
# .github/workflows/validate-pra.yml
- Validation schema YAML ✅
- Validation structure dossiers ✅
- Validation liens Markdown ✅
- Vérification proven-in-use count ✅
- Validation tags format ✅
- Validation versioning ✅
```

### Validation Manuelle (Review)

**Checklist Reviewer** :
- [ ] Documentation claire et complète ?
- [ ] Patron réutilisable (pas spécifique projet) ?
- [ ] Proven-in-use crédibles et quantifiés ?
- [ ] Exemples fonctionnels et génériques ?
- [ ] ADR complets et justifiés ?
- [ ] Pas de secrets hardcodés ?
- [ ] Références valides ?

---

## 📋 Checklist Qualité

### Avant Soumission

#### Documentation
- [ ] Template 100% complet
- [ ] Résumé en 2-3 phrases clair
- [ ] Contexte d'application défini (quand/quand pas)
- [ ] Problème résolu documenté
- [ ] Solution avec architecture
- [ ] Stack tech listée avec versions
- [ ] Étapes implémentation détaillées
- [ ] Au moins 1 exemple concret
- [ ] Retours d'expérience (1+ pour candidate, 3+ pour approved)
- [ ] Limitations documentées
- [ ] Références fournies

#### Métadonnées
- [ ] ID unique assigné
- [ ] Nom descriptif (10-100 chars)
- [ ] Catégorie correcte
- [ ] 3-10 tags en kebab-case
- [ ] Version semantic
- [ ] Auteur/mainteneur renseignés
- [ ] Dates ISO 8601
- [ ] Proven-in-use avec feedback quantifié

#### Technique
- [ ] Au moins 1 ADR complet
- [ ] ADR avec 2+ options comparées
- [ ] Au moins 1 exemple avec README
- [ ] Code commenté si nécessaire
- [ ] Pas de secrets hardcodés
- [ ] Versions minimum spécifiées
- [ ] Compatibilité documentée

#### Validation
- [ ] Validation locale passée
- [ ] Liens Markdown fonctionnels
- [ ] Code d'exemple testé
- [ ] Pas de doublons vérifiés
- [ ] Structure dossiers conforme

### Pendant Review

- [ ] Feedback constructif reçu
- [ ] Corrections appliquées
- [ ] Validation finale passée

### Après Merge

- [ ] PRA visible dans catalogue
- [ ] Site Fumadocs à jour
- [ ] Communication communauté
- [ ] Métriques suivi activées

---

**Document maintenu par** : Table de Gouvernance PRA
**Révision** : Trimestrielle
**Prochaine révision** : [Date]
