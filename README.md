# Registre PRA - Proven Reusable Architecture

**Capitaliser • Accélérer • Standardiser**

Bienvenue dans le registre des Proven Reusable Architecture (PRA). Ce repository centralise les architectures validées et éprouvées en production pour accélérer la conception et renforcer la cohérence architecturale au sein de l'entreprise.

---

## 🎯 Qu'est-ce qu'un PRA ?

Un **Proven Reusable Architecture (PRA)** est :

- ✅ **Éprouvé** : Validé dans au moins 3 projets en production
- ✅ **Documenté** : Architecture, ADR, exemples, retours d'expérience
- ✅ **Réutilisable** : Applicable dans différents contextes
- ✅ **Maintenu** : Suivi par la communauté et la gouvernance
- ✅ **AI-Friendly** : Exploitable par les agents IA pour recommandations

---

## 📚 Catalogue

### 🟢 PRA Approved (Recommandés)

> PRA validés avec 3+ implémentations réussies

| ID | Nom | Catégorie | Tags | Proven-in-Use |
|----|-----|-----------|------|---------------|
| - | *En cours de création* | - | - | - |

**Voir tous les PRA approved** : [`pra/approved/`](./pra/approved/)

### 🟡 PRA Candidates (En Validation)

> PRA avec 1-2 implémentations, en cours de validation

| ID | Nom | Catégorie | Tags | Proven-in-Use |
|----|-----|-----------|------|---------------|
| - | *En cours de création* | - | - | - |

**Voir tous les PRA candidates** : [`pra/candidates/`](./pra/candidates/)

---

## 🚀 Démarrage Rapide

### Pour Utiliser un PRA

1. **Rechercher** un patron pertinent :
   - 🔍 [Site Fumadocs](https://pra-registry.example.com) (à venir)
   - 📁 Parcourir [`pra/approved/`](./pra/approved/)

2. **Consulter** la documentation :
   - Architecture & stack tech
   - ADR (décisions architecturales)
   - Exemples concrets
   - Retours d'expérience

3. **Implémenter** dans votre projet :
   - Suivre le guide d'implémentation
   - Adapter à votre contexte
   - S'inspirer des exemples

4. **Partager** votre retour :
   - Contribuer votre proven-in-use
   - Proposer améliorations

### Pour Contribuer un PRA

1. **Vérifier** qu'aucun PRA similaire n'existe
2. **Préparer** votre documentation :
   - Au moins 1 implémentation en production
   - ADR documentées
   - Exemples fonctionnels

3. **Soumettre** via Pull Request :
   ```bash
   git checkout -b pra/nouveau-[category]-[nom]
   cp templates/pra-template.md pra/candidates/[category]/[nom]/README.md
   # Remplir le template
   git commit -m "feat(pra): Add PRA-XXX - [Nom]"
   git push origin pra/nouveau-[category]-[nom]
   ```

4. **Suivre** : [Guide de Contribution](./docs/CONTRIBUTING.md)

---

## 📂 Structure du Repository

```
pra-registry/
├── templates/                 # Templates PRA & ADR
├── docs/                      # Documentation
│   ├── GOVERNANCE.md          # Processus de gouvernance
│   ├── CONTRIBUTING.md        # Guide de contribution
│   ├── LIFECYCLE.md           # Cycle de vie des PRA
│   └── STANDARDS.md           # Standards de qualité
├── pra/                       # PRA eux-mêmes
│   ├── approved/              # PRA recommandés (3+ proven-in-use)
│   │   ├── tech/              # Patterns techniques
│   │   ├── integration/       # Patterns d'intégration
│   │   ├── security/          # Patterns de sécurité
│   │   └── business/          # Patterns métier
│   └── candidates/            # PRA en validation (1-2 proven-in-use)
│       └── [même structure]
├── site/                      # Site Fumadocs (à venir)
├── scripts/                   # Scripts de validation
└── .github/                   # Workflows CI/CD
```

---

## 📖 Documentation

### Pour Commencer

- 📘 [Guide de Contribution](./docs/CONTRIBUTING.md) - Comment soumettre un PRA
- 📙 [Gouvernance](./docs/GOVERNANCE.md) - Processus et rôles
- 📗 [Cycle de Vie](./docs/LIFECYCLE.md) - États des PRA
- 📕 [Standards](./docs/STANDARDS.md) - Critères de qualité

### Templates

- 📄 [Template PRA](./templates/pra-template.md) - Structure complète
- 📄 [Template ADR](./templates/adr-template.md) - Architecture Decision Record
- 📄 [Template Metadata](./templates/metadata-template.yml) - YAML frontmatter

---

## 🎯 Catégories de PRA

### Tech (Techniques)

Patterns d'infrastructure et plateformes

**Exemples** :
- CI/CD & GitOps
- Observabilité & Monitoring
- Infrastructure as Code
- Container Orchestration

### Integration (Intégration)

Patterns d'intégration inter-systèmes

**Exemples** :
- API Gateway
- Message Broker
- Event-Driven Architecture
- Data Synchronisation

### Security (Sécurité)

Patterns de sécurité et conformité

**Exemples** :
- Authentication & Authorization (RBAC, ABAC)
- Secrets Management
- Network Security
- Audit & Compliance

### Business (Métier)

Patterns métier réutilisables

**Exemples** :
- Onboarding Client
- Payment Processing
- Notification System
- Workflow Management

---

## 🏛️ Gouvernance

### Rôles

| Rôle | Responsabilité | Qui |
|------|---------------|-----|
| **Contributeur** | Soumettre & maintenir PRA | Tous architectes |
| **Mainteneur** | Maintenir PRA assignés | Architecte désigné |
| **Table de Gouvernance** | Approuver & arbitrer | 5-7 architectes seniors |
| **Équipe Initiative** | Infrastructure & support | 2-3 personnes dédiées |

### Processus d'Approbation

```
1. Soumission PR (contributeur)
   ↓
2. Validation auto (GitHub Actions)
   ↓
3. Review humaine (Table de Gouvernance - 2 approvals)
   ↓
4. Merge → PRA candidat créé
   ↓
5. Collecte proven-in-use (3+)
   ↓
6. Promotion → PRA approved
```

**Délai de review** : < 5 jours ouvrés

**Voir détails** : [GOVERNANCE.md](./docs/GOVERNANCE.md)

---

## 🔄 Cycle de Vie

```
CANDIDATE (1+ proven)
   ↓ (3+ proven, 6 mois)
APPROVED
   ↓ (obsolète)
DEPRECATED
   ↓ (6 mois)
ARCHIVED
```

**Voir détails** : [LIFECYCLE.md](./docs/LIFECYCLE.md)

---

## 📊 Métriques

> *À venir : Dashboard métriques*

**Objectifs** :
- 🎯 10+ PRA approved en 3 mois
- 🎯 50%+ architectes utilisateurs actifs
- 🎯 80%+ satisfaction (survey)
- 🎯 < 5 jours délai de review

---

## 💡 Principes

### 1. Proven-in-Use (Éprouvé)

Tout PRA doit être basé sur une **expérience réelle en production**, pas théorique.

### 2. Réutilisabilité

Les patrons doivent être **généralisables** et applicables dans différents contextes.

### 3. Qualité

Documentation **complète** avec ADR, exemples et retours d'expérience quantifiés.

### 4. Communauté

Maintien **collaboratif** par la communauté d'architectes.

### 5. Évolution

Amélioration **continue** basée sur les feedbacks et nouvelles technologies.

---

## 🛠️ Technologies

### Core

- **Git** : Source de vérité
- **GitHub** : Collaboration & CI/CD
- **Markdown** : Format documentation (`.md`)

### Site Documentation

- **Fumadocs** : Framework documentation (Next.js)
- **Orama** : Search engine (opensource, client-side)
- **TypeScript** : Type safety
- **Tailwind CSS** : Styling

### Infrastructure

- **PNPM** : Package manager
- **GitHub Actions** : CI/CD
- **Confluence** : Publication permanente

---

## 🤝 Contribuer

Nous encourageons **tous les architectes** à contribuer !

**Types de contributions** :
- 🆕 Nouveau PRA candidat
- 📝 Mise à jour PRA existant
- 📊 Retour d'expérience (proven-in-use)
- 📚 Amélioration documentation
- 🐛 Correction erreurs

**Voir** : [Guide de Contribution](./docs/CONTRIBUTING.md)

---

## 📞 Contact & Support

### Canaux

- **Teams** : [#pra-registry](https://teams.microsoft.com/...)
- **GitHub Issues** : [Questions](https://github.com/org/pra-registry/issues)
- **Email** : pra-initiative@example.com

### Équipe Initiative PRA

- **Lead** : [Nom] ([email@example.com](mailto:email@example.com))
- **Support** : [Nom] ([email@example.com](mailto:email@example.com))

---

## 📜 License

[À définir - ex: MIT, Apache 2.0, ou Internal Use Only]

---

## 🙏 Remerciements

Merci à tous les contributeurs qui font vivre ce registre :

- **Architectes** : Pour vos contributions et retours
- **Équipes de développement** : Pour vos implémentations
- **Table de Gouvernance** : Pour votre review rigoureuse
- **Leadership** : Pour votre soutien à l'initiative

---

**Dernière mise à jour** : 28 novembre 2025
**Version du registre** : 1.0.0 (MVP)
