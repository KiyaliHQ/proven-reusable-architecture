# Registre PRA - Proven Reusable Architecture

**Capitaliser • Accélérer • Standardiser**

Bienvenue dans le registre des Proven Reusable Architecture (PRA). Ce repository centralise les architectures validées et éprouvées en production pour accélérer la conception et renforcer la cohérence architecturale au sein de l'entreprise.

---

## Qu'est-ce qu'un PRA ?

Un **Proven Reusable Architecture (PRA)** est :

- **Éprouvé** : Validé dans au moins 3 projets en production
- **Documenté** : Architecture, ADR, exemples, retours d'expérience
- **Réutilisable** : Applicable dans différents contextes
- **Maintenu** : Suivi par la communauté et la gouvernance
- **AI-Friendly** : Exploitable par les agents IA pour recommandations

---

## Catalogue

Le catalogue des PRA est généré automatiquement à partir des métadonnées AsciiDoc :

- **[Catalogue FR](./content/pras/fr/index.adoc)** — Tableau de bord des PRA en français
- **[Catalogue EN](./content/pras/en/index.adoc)** — PRA dashboard in English

Chaque PRA est un fichier `.adoc` avec des attributs structurés (`:pra-name:`, `:pra-archetype:`, `:pra-status:`, etc.).

### Scopes

| Scope | Description |
|-------|-------------|
| **bank-wide** | Transversal — validé pour tous les secteurs |
| **domain-wide** | Spécifique à un domaine (particuliers, entreprises, gestion-patrimoine) |

### Archétypes

| Archétype | Description |
|-----------|-------------|
| **integration** | Intégration inter-systèmes |
| **application** | Patterns applicatifs |
| **data** | Architecture de données |
| **security** | Sécurité et conformité |
| **technology** | Infrastructure et plateformes |
| **devops** | CI/CD, observabilité, automation |
| **business** | Patterns métier réutilisables |

### Statuts

| Statut | Description |
|--------|-------------|
| **operationalizing** | En cours de validation (1+ proven-in-use) |
| **operationalized** | Validé et recommandé (3+ proven-in-use bank-wide, 1+ domain-wide) |
| **deprecated** | Obsolète, non recommandé |

---

## Démarrage Rapide

### Utiliser un PRA

1. **Rechercher** un patron dans le [catalogue FR](./content/pras/fr/index.adoc) ou [EN](./content/pras/en/index.adoc)
2. **Consulter** le fichier `.adoc` : architecture, ADR, exemples, retours d'expérience
3. **Implémenter** dans votre projet en suivant le guide
4. **Partager** votre retour (proven-in-use)

### Contribuer un PRA

1. **Vérifier** qu'aucun PRA similaire n'existe
2. **Préparer** votre documentation (1+ implémentation production, ADR, exemples)
3. **Soumettre** via Pull Request :
   ```bash
   git checkout -b pra/nouveau-[archetype]-[nom]
   cp templates/pra-template-fr.adoc content/pras/fr/[scope]/[archetype-ou-domaine]/[nom].adoc
   # Remplir le template
   git commit -m "feat(pra): Add [Nom du PRA]"
   git push origin pra/nouveau-[archetype]-[nom]
   ```
4. **Suivre** le [Guide de Contribution](./docs/CONTRIBUTING.md)

---

## Structure du Repository

```
proven-reusable-architecture/
├── content/                        # Contenu AsciiDoc
│   ├── guides/                     # Guides utilisateur
│   │   ├── fr/                     # Guides français (.adoc)
│   │   └── en/                     # Guides anglais (.adoc)
│   └── pras/                       # PRAs (séparé par langue)
│       ├── fr/                     # PRAs français
│       │   ├── index.adoc          # Dashboard auto-généré
│       │   ├── bank-wide/          # PRAs transversaux
│       │   │   ├── integration/
│       │   │   ├── application/
│       │   │   ├── technology/
│       │   │   ├── devops/
│       │   │   └── ...
│       │   └── domain-wide/        # PRAs spécifiques domaine
│       │       ├── particuliers/
│       │       ├── entreprises/
│       │       └── gestion-patrimoine/
│       └── en/                     # PRAs anglais (même structure)
├── templates/                      # Templates AsciiDoc
│   ├── pra-template-fr.adoc        # Template PRA français
│   ├── pra-template-en.adoc        # Template PRA anglais
│   ├── adr-template.adoc           # Template ADR français
│   └── adr-template-en.adoc        # Template ADR anglais
├── scripts/                        # Scripts utilitaires
│   └── generate-dashboard.sh       # Génère les index.adoc
├── build/                          # Pipelines de publication
│   ├── confluence/                 # Publication Confluence
│   │   ├── publish.sh              # Publie une langue
│   │   └── publish-all.sh          # Publie FR + EN
│   └── ghpages/                    # Publication GitHub Pages
│       └── build.sh                # Génère le site statique
├── docs/                           # Documentation projet
│   ├── DEVELOPER_GUIDE.md
│   ├── CONTRIBUTING.md
│   ├── GOVERNANCE.md
│   ├── LIFECYCLE.md
│   └── STANDARDS.md
├── .github/                        # GitHub configuration
│   ├── agents/                     # Agents Copilot (PRA Explorer, PRA Guide)
│   └── workflows/                  # CI/CD workflows
├── pra-registry.config.yml         # Configuration centrale du registre
└── README.md
```

---

## Publication

Le registre est publié via deux canaux :

### GitHub Pages

Site statique avec DataTables.js pour le filtrage interactif.

```bash
./build/ghpages/build.sh
# Génère _site/ avec HTML convertis depuis AsciiDoc
```

Prérequis : `asciidoctor` (gem install asciidoctor) ou Docker.

### Confluence

Publication directe depuis AsciiDoc via Confluence Publisher (Docker).

```bash
# Configurer les variables d'environnement
export CONFLUENCE_URL=https://mycompany.atlassian.net/wiki
export CONFLUENCE_SPACE_KEY=PRA
export CONFLUENCE_USER=user@company.com
export CONFLUENCE_TOKEN=your-api-token
export CONFLUENCE_ANCESTOR_FR=123456
export CONFLUENCE_ANCESTOR_EN=789012

# Publier
./build/confluence/publish-all.sh
```

### Génération du dashboard

```bash
./scripts/generate-dashboard.sh
# Génère content/pras/{fr,en}/index.adoc depuis les attributs :pra-*:
```

---

## Documentation

### Pour Contributeurs

- [Guide de Contribution](./docs/CONTRIBUTING.md) — Comment soumettre un PRA
- [Gouvernance](./docs/GOVERNANCE.md) — Processus et rôles
- [Cycle de Vie](./docs/LIFECYCLE.md) — États des PRA
- [Standards](./docs/STANDARDS.md) — Critères de qualité

### Guides intégrés (AsciiDoc)

- [Guides FR](./content/guides/fr/) — Guides en français
- [Guides EN](./content/guides/en/) — Guides in English

### Templates

- [Template PRA FR](./templates/pra-template-fr.adoc) — Structure PRA complète
- [Template PRA EN](./templates/pra-template-en.adoc) — Full PRA template
- [Template ADR FR](./templates/adr-template.adoc) — Architecture Decision Record
- [Template ADR EN](./templates/adr-template-en.adoc) — ADR template

---

## Technologies

### Core

- **Git** : Source de vérité
- **GitHub** : Collaboration & CI/CD
- **AsciiDoc** : Format documentation (`.adoc`)
- **Asciidoctor** : Moteur de conversion

### Publication

- **GitHub Pages** : Site statique avec DataTables.js
- **Confluence Publisher** : Publication Docker vers Confluence
- **DataTables.js** : Filtrage interactif des tableaux

### Agents IA

- **PRA Explorer** : Recherche et recommandation de PRA
- **PRA Guide** : Aide sur les processus et la gouvernance

---

## Gouvernance

### Rôles

| Rôle | Responsabilité |
|------|---------------|
| **Contributeur** | Soumettre & maintenir PRA |
| **Mainteneur** | Maintenir PRA assignés |
| **Table de Gouvernance** | Approuver & arbitrer |
| **Équipe Initiative** | Infrastructure & support |

### Processus d'Approbation

```
1. Soumission PR (contributeur)
   ↓
2. Validation auto (GitHub Actions)
   ↓
3. Review humaine (Table de Gouvernance - 2 approvals)
   ↓
4. Merge → PRA operationalizing
   ↓
5. Collecte proven-in-use (3+ bank-wide)
   ↓
6. Promotion → PRA operationalized
```

---

## Contribuer

Nous encourageons **tous les architectes** à contribuer !

- Nouveau PRA candidat
- Mise à jour PRA existant
- Retour d'expérience (proven-in-use)
- Amélioration documentation

Voir : [Guide de Contribution](./docs/CONTRIBUTING.md)

---

## Contact & Support

- **Teams** : #pra-registry
- **GitHub Issues** : Questions et suggestions
- **Email** : pra-initiative@example.com

---

**Dernière mise à jour** : 18 mars 2026
**Version du registre** : 2.0.0 (AsciiDoc)
**Format** : AsciiDoc (`.adoc`)
**Configuration** : [`pra-registry.config.yml`](./pra-registry.config.yml)
