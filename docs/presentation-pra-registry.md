# Présentation du Registre PRA
## Proven Reusable Architecture - Banque Nationale du Canada

---

# SECTION 1 - INTRODUCTION

---

## Slide 1: Page de Titre

# Registre des Proven Reusable Architecture (PRA)

### Capitaliser sur nos succès architecturaux

**Banque Nationale du Canada**

*Architecture d'Entreprise*

---

## Slide 2: Le Constat

### Les défis actuels

| Problème | Impact |
|----------|--------|
| **Réinvention de la roue** | Perte de temps et d'argent |
| **Duplication des efforts** | Solutions similaires développées en silo |
| **Incohérence entre équipes** | Difficultés d'intégration et maintenance |
| **Connaissance non partagée** | Départs = perte d'expertise |

> *"Chaque équipe refait les mêmes erreurs que d'autres ont déjà surmontées."*

---

## Slide 3: La Solution - Les PRA

### Qu'est-ce qu'un PRA ?

**Une recette de cuisine éprouvée pour l'architecture**

Comme un chef qui documente ses recettes à succès, un PRA capture les solutions architecturales qui ont fait leurs preuves.

### Les 3 Piliers

| Pilier | Description |
|--------|-------------|
| **Proven-in-use** | Validé en production réelle |
| **Réutilisable** | Applicable dans différents contextes |
| **Documenté** | Contexte, décisions, exemples, leçons |

---

# SECTION 2 - COMPRENDRE LES PRA

---

## Slide 4: Anatomie d'un PRA

### Structure Standard

```
1. Résumé Exécutif
   └── Vue d'ensemble en 2-3 phrases

2. Contexte
   └── Quand et pourquoi utiliser ce PRA

3. Problème
   └── Quel défi résout-il ?

4. Solution
   └── Architecture détaillée avec diagrammes

5. Architecture Decision Records (ADR)
   └── Décisions clés et leur justification

6. Exemples de Code
   └── Implémentations concrètes

7. Retours d'Expérience (Proven-in-use)
   └── Projets, équipes, feedback
```

---

## Slide 5: Les 2 Scopes

### Portée des PRA

| Scope | Description | Critère |
|-------|-------------|---------|
| **Bank-Wide** | Transversal - Applicable à tous les secteurs | 3+ proven-in-use |
| **Domain-Wide** | Spécifique à un secteur (Particuliers, Entreprises, Gestion Patrimoine) | 1+ proven-in-use |

### Promotion Domain → Bank-Wide

Un PRA Domain-Wide peut être promu Bank-Wide après validation dans 3+ contextes différents.

```
Domain-Wide (Particuliers) ──► Bank-Wide (Transversal)
        │                              │
   1 proven-in-use              3+ proven-in-use
```

---

## Slide 6: Les 3 Statuts

### Cycle de Vie d'un PRA

| Statut | Couleur | Description |
|--------|---------|-------------|
| **Candidate** | 🔵 Bleu | En cours de validation, 1+ proven-in-use |
| **Approved** | 🟢 Vert | Approuvé et recommandé pour utilisation |
| **Deprecated** | 🔴 Rouge | Obsolète, ne plus utiliser |

### Progression Typique

```
Candidate ────────► Approved ────────► Deprecated
    │                   │                   │
 Validation         Production          Remplacement
```

---

## Slide 7: Les Catégories

### Organisation par Domaine Technique

| Catégorie | Description | Exemples |
|-----------|-------------|----------|
| **Technology** | Infrastructure, Cloud, DevOps | Kubernetes, CI/CD |
| **Integration** | APIs, Messaging, ETL | API Gateway, Kafka |
| **Security** | Auth, Encryption, Compliance | OAuth2, mTLS |
| **Business** | Patterns métier, Domaines | Event Sourcing |

### Catégories Bank-Wide Spéciales

| Catégorie | Description |
|-----------|-------------|
| **CTP** | Cadre Technologique et Pratiques |
| **Software Engineering** | Bonnes pratiques de développement |
| **Pratique Architecture** | Méthodologies d'architecture |

---

# SECTION 3 - GOUVERNANCE

---

## Slide 8: Structure à 2 Niveaux

### Gouvernance des PRA

```
┌─────────────────────────────────────────────┐
│     Comité des Architectes Experts          │
│     (Validation Bank-Wide)                  │
│     • Architectes seniors de chaque secteur │
│     • Se réunit mensuellement               │
└───────────────────┬─────────────────────────┘
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
┌───────────┐ ┌───────────┐ ┌───────────┐
│  Comité   │ │  Comité   │ │  Comité   │
│Particuliers│ │Entreprises│ │ Gestion   │
│           │ │           │ │Patrimoine │
└───────────┘ └───────────┘ └───────────┘
   Domain-Wide Validation
```

---

## Slide 9: Les 3 Flux de Création

### Comment naît un PRA ?

| Flux | Nom | Description |
|------|-----|-------------|
| **Flow 1** | Bottom-Up | Équipe projet propose → Domaine valide → Bank-Wide |
| **Flow 2** | Top-Down | Équipe transversale crée directement Bank-Wide |
| **Flow 3** | Bootstrap | Migration d'un standard existant vers le registre |

### Flow 1 - Le Plus Courant

```
Équipe Projet ──► Proposition ──► Comité Domaine ──► Approved Domain
                                                          │
                                                          ▼
                                                  3+ proven-in-use
                                                          │
                                                          ▼
                                              Comité Experts ──► Approved Bank-Wide
```

---

## Slide 10: Critères d'Approbation

### Validation par Scope

| Critère | Domain-Wide | Bank-Wide |
|---------|-------------|-----------|
| **Proven-in-use minimum** | 1 projet | 3 projets |
| **Documentation complète** | ✓ | ✓ |
| **ADR documentés** | ✓ | ✓ |
| **Exemples de code** | Recommandé | Obligatoire |
| **Revue par pairs** | Comité Domaine | Comité Experts |
| **Secteurs couverts** | 1 secteur | Multi-secteur |

---

## Slide 11: Matrice RACI

### Responsabilités

| Activité | Architecte Projet | Comité Domaine | Comité Experts | Mainteneur |
|----------|-------------------|----------------|----------------|------------|
| Proposer PRA | **R** | C | I | - |
| Valider Domain-Wide | C | **A/R** | I | - |
| Valider Bank-Wide | I | C | **A/R** | - |
| Maintenir PRA | C | I | I | **R** |
| Déprécier PRA | I | C | **A** | R |

**R** = Responsable | **A** = Approbateur | **C** = Consulté | **I** = Informé

---

# SECTION 4 - CYCLE DE VIE

---

## Slide 12: Du Candidat à Approved

### Timeline Typique

```
Mois 1-2          Mois 3-4          Mois 5-6          Mois 7+
   │                 │                 │                 │
   ▼                 ▼                 ▼                 ▼
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│ Rédaction│    │ Review  │    │ Pilote  │    │ Approved│
│   Draft │────►│ Comité  │────►│ Projet  │────►│ & Adopté│
└─────────┘    └─────────┘    └─────────┘    └─────────┘
     │              │              │              │
 Documentation   Feedback      Validation     Publication
  initiale       ajustements   en production   officielle
```

---

## Slide 13: Processus de Promotion

### Domain-Wide → Bank-Wide

| Phase | Actions | Durée |
|-------|---------|-------|
| **1. Proposition** | Identifier le PRA mature, préparer dossier | 1-2 semaines |
| **2. Revue** | Présentation au Comité Experts, Q&A | 1 session |
| **3. Migration** | Adapter documentation pour multi-secteur | 2-4 semaines |
| **4. Adoption** | Communication, formation, suivi | Continu |

### Critères de Promotion

- ✓ 3+ proven-in-use dans des contextes différents
- ✓ Feedback positif des équipes
- ✓ Pas de dépendance secteur-spécifique
- ✓ Documentation généralisable

---

## Slide 14: Maintenance Continue

### Garder les PRA Vivants

| Activité | Fréquence | Responsable |
|----------|-----------|-------------|
| **Revue de pertinence** | Annuelle | Mainteneur |
| **Mise à jour technique** | Sur changement | Mainteneur |
| **Collecte feedback** | Continue | Tous |
| **Évaluation dépréciation** | Annuelle | Comité |

### Dépréciation

Un PRA devient Deprecated quand :
- Technologie obsolète
- Meilleure alternative disponible
- Plus utilisé depuis 2+ ans

---

# SECTION 5 - COMMENT CONTRIBUER

---

## Slide 15: Processus de Soumission

### 6 Étapes pour Contribuer

```
1. Fork        ──► Créer votre copie du repo
      │
2. Branche    ──► Créer feature/nom-du-pra
      │
3. Documenter ──► Rédiger selon le template
      │
4. PR         ──► Soumettre Pull Request
      │
5. Review     ──► Répondre aux commentaires
      │
6. Merge      ──► Publication automatique
```

### Commandes Git

```bash
git clone https://github.com/bnc/pra-registry.git
git checkout -b feature/mon-nouveau-pra
# ... rédiger documentation ...
git add . && git commit -m "feat: add mon-nouveau-pra"
git push origin feature/mon-nouveau-pra
# Créer PR sur GitHub
```

---

## Slide 16: Template & Standards

### Sections Obligatoires

| Section | Contenu |
|---------|---------|
| **Frontmatter YAML** | Métadonnées (titre, catégorie, statut, tags) |
| **Résumé** | 2-3 phrases d'introduction |
| **Contexte** | Quand utiliser ce PRA |
| **Problème** | Défi adressé |
| **Solution** | Architecture avec diagrammes |
| **ADR** | Décisions et justifications |
| **Proven-in-use** | Projets, équipes, dates, feedback |

### Exemple Frontmatter

```yaml
---
title: API Gateway Pattern
pra:
  name: API Gateway Pattern
  category: integration
  status: approved
  tags: [api, gateway, microservices]
  proven_in_use:
    - project: "Mobile Banking"
      team: "Équipe Particuliers"
      date: "2024-06-15"
      feedback: "Réduction latence de 40%"
---
```

---

## Slide 17: Validation Automatique

### GitHub Actions & Protection

```
Push/PR ──► GitHub Actions ──► Validation ──► Merge
                  │
         ┌───────┴───────┐
         ▼               ▼
    Lint YAML       Lint MDX
         │               │
         ▼               ▼
   Check Schema    Check Links
         │               │
         └───────┬───────┘
                 ▼
         ✓ All Checks Pass
```

### Validations Automatiques

- ✓ Format YAML frontmatter valide
- ✓ Sections obligatoires présentes
- ✓ Liens internes fonctionnels
- ✓ Images référencées existantes

---

# SECTION 6 - LA PLATEFORME

---

## Slide 18: Architecture Technique

### Stack Technologique

| Composant | Technologie | Rôle |
|-----------|-------------|------|
| **Framework** | Next.js 16 | App Router, SSR |
| **Documentation** | Fumadocs | MDX, Navigation |
| **Recherche** | Orama Search | Full-text, Fuzzy matching |
| **Styling** | Tailwind CSS | Design system |
| **Contenu** | MDX | Markdown + React |

### Architecture

```
┌─────────────────────────────────────────┐
│              Next.js 16                 │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐ │
│  │ Guides  │  │ Registre│  │Catalogue│ │
│  │  /guides│  │/registre│  │  /      │ │
│  └────┬────┘  └────┬────┘  └────┬────┘ │
│       └────────────┼───────────┘       │
│                    ▼                    │
│              Fumadocs MDX               │
│                    │                    │
│       ┌────────────┼────────────┐      │
│       ▼            ▼            ▼      │
│   content/     Orama      Tailwind    │
│   guides/      Search        CSS       │
│   pras/                               │
└─────────────────────────────────────────┘
```

---

## Slide 19: Démo Live

### Fonctionnalités à Démontrer

1. **Catalogue interactif**
   - Recherche full-text avec fuzzy matching
   - Filtres par scope, catégorie, statut
   - Tri et pagination

2. **Navigation PRA**
   - Sidebar avec catégories
   - Détail complet d'un PRA
   - Proven-in-use avec feedback

3. **Documentation**
   - Guides d'utilisation
   - Comment contribuer

**URL:** `https://pra-registry.bnc.ca`

---

# SECTION 7 - BÉNÉFICES & ROI

---

## Slide 20: Bénéfices Concrets

### Valeur pour l'Organisation

| Bénéfice | Description | Impact |
|----------|-------------|--------|
| **Gain de temps** | Réutiliser vs réinventer | -40% temps conception |
| **Qualité** | Solutions éprouvées | -60% bugs architecture |
| **Cohérence** | Standards partagés | +50% maintenabilité |
| **Connaissance** | Documentation centralisée | Résilience équipes |

### ROI Estimé

```
Coût moyen développement pattern: 80h
Nombre réutilisations/an/PRA: ~5
Économie par PRA: 5 × 80h × 60% = 240h/an

Avec 20 PRA actifs:
Économie annuelle: 20 × 240h = 4,800h = ~600 jours-homme
```

---

## Slide 21: Métriques de Succès

### KPIs du Registre

| Métrique | Cible | Mesure |
|----------|-------|--------|
| **Nombre de PRA Approved** | 30+ | Croissance du catalogue |
| **Proven-in-use par PRA** | 5+ en moyenne | Adoption réelle |
| **Temps moyen approbation** | < 3 mois | Efficacité processus |
| **Satisfaction utilisateurs** | > 4/5 | Surveys trimestriels |
| **Contributions/trimestre** | 5+ nouveaux PRA | Engagement communauté |

### Dashboard de Suivi

- Approved: **12** PRA
- Candidate: **8** PRA
- Total proven-in-use: **47** projets
- Contributeurs actifs: **23** architectes

---

# SECTION 8 - VOTRE RÔLE

---

## Slide 22: En tant qu'Architecte

### Vos Responsabilités

| Action | Description |
|--------|-------------|
| **Consulter** | Vérifier le registre avant de concevoir |
| **Utiliser** | Implémenter les PRA approuvés |
| **Documenter** | Ajouter vos proven-in-use |
| **Contribuer** | Proposer de nouveaux PRA |
| **Reviewer** | Participer aux revues de pairs |

### Vos Droits

- ✓ Accès complet au registre
- ✓ Proposer des améliorations
- ✓ Voter pour priorisation
- ✓ Participer aux comités

---

## Slide 23: Prochaines Étapes

### 4 Actions Concrètes

| # | Action | Timeline |
|---|--------|----------|
| **1** | Explorer le registre | Cette semaine |
| **2** | Identifier un PRA applicable à votre projet | 2 semaines |
| **3** | Documenter un proven-in-use | 1 mois |
| **4** | Proposer un candidat PRA | 3 mois |

### Ressources

- 📖 Guide de démarrage: `/guides/getting-started`
- 📝 Template PRA: `/guides/contributing`
- 💬 Slack: `#pra-registry`
- 📧 Support: `pra-support@bnc.ca`

---

# SECTION 9 - CONCLUSION

---

## Slide 24: Points Clés à Retenir

### Résumé

| Concept | À Retenir |
|---------|-----------|
| **PRA** | Solution éprouvée, documentée, réutilisable |
| **Scopes** | Bank-Wide (transversal) vs Domain-Wide (secteur) |
| **Statuts** | Candidate → Approved → Deprecated |
| **Gouvernance** | 2 niveaux (Domaine + Experts) |
| **Contribution** | Fork → Documenter → PR → Review → Merge |

### Le Registre PRA c'est...

> **"Capitaliser sur nos succès pour accélérer nos projets futurs"**

- Une source unique de vérité architecturale
- Un accélérateur de décisions
- Une communauté de pratique

---

## Slide 25: Questions & Contacts

### Q&A

*Vos questions sont les bienvenues !*

### Contacts

| Canal | Lien |
|-------|------|
| **Slack** | `#pra-registry` |
| **Email Support** | `pra-support@bnc.ca` |
| **Governance** | `pra-governance@bnc.ca` |
| **GitHub** | `github.com/bnc/pra-registry` |

### Liens Utiles

- 🌐 Registre: `https://pra-registry.bnc.ca`
- 📚 Documentation: `https://pra-registry.bnc.ca/guides`
- 📋 Catalogue: `https://pra-registry.bnc.ca/catalogue`

---

**Merci !**

*Ensemble, construisons une architecture cohérente et performante.*
