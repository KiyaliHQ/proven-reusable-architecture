# Quick Start - PRA Registry

> Guide de démarrage rapide pour les développeurs

**Dernière mise à jour** : 18 mars 2026

---

## 🚀 Démarrage en 5 Minutes

### 1. Cloner et Installer

```bash
# Cloner le repository
git clone https://github.com/KiyaliHQ/proven-reusable-architecture.git
cd proven-reusable-architecture/site

# Installer les dépendances
pnpm install

# Démarrer le dev server
pnpm dev
```

Le site sera accessible sur **http://localhost:3000**

### 2. Comprendre la Structure

```
proven-reusable-architecture/
├── site/                    # Application Next.js Fumadocs
├── content/                 # Contenu MDX (séparé par langue)
│   ├── guides/              # Guides utilisateur (FR/EN)
│   └── pras/                # PRAs (séparé par langue)
│       ├── fr/              # PRAs français
│       └── en/              # PRAs anglais
├── docs/                    # Documentation projet
└── scripts/                 # Scripts utilitaires
```

### 3. Ajouter un PRA

```bash
# 1. Créer le fichier (flat structure, pas de sous-dossier)
# ✅ Correct
content/pras/fr/transversale/tech/operationalizing/mon-pra.md

# ❌ Incorrect
content/pras/fr/transversale/tech/operationalizing/mon-pra/page.md
```

```yaml
# 2. Ajouter le frontmatter
---
title: Titre du PRA
description: Description courte
pra:
  name: Nom Affiché
  category: tech|integration|security|business
  status: candidate|approved|deprecated
  tags: [tag1, tag2]
  created_at: "2025-12-03"
  updated_at: "2025-12-03"
  proven_in_use:
    - project: Nom du Projet
      team: Nom de l'Équipe
      date: "2025-12-01"
      feedback: Retour d'expérience
---

# Contenu du PRA

## Contexte
...
```

```bash
# 3. Redémarrer le dev server
# Les changements seront visibles
```

### 4. Tester

Naviguer vers :
- FR : `http://localhost:3000/fr/registre/transversale/tech/operationalizing/mon-pra`
- EN : `http://localhost:3000/en/registre/transversale/tech/operationalizing/my-pra`

---

## 📚 Structure du Contenu

### Scopes

| Scope | Chemin | Description |
|-------|--------|-------------|
| **Transversale** | `pras/fr/transversale/` | Transversal (tous secteurs) |
| **Par Domaine** | `pras/fr/par-domaine/[domaine]/` | Spécifique à un domaine |

### Catégories

| Catégorie | Description |
|-----------|-------------|
| **tech** | Patterns techniques/infrastructure |
| **integration** | Patterns d'intégration |
| **security** | Patterns sécurité |
| **business** | Patterns métier |

### Status

| Status | Critères |
|--------|----------|
| **candidate** | 1+ proven-in-use |
| **approved** | 3+ proven-in-use (Transversale) ou 1+ (Domain) |
| **deprecated** | Obsolète, à remplacer |

### Domaines

- **particuliers** : Retail banking
- **entreprises** : Corporate banking
- **gestion-patrimoine** : Wealth management

---

## 🌐 Site GitHub Pages (Build Statique)

Le registre PRA est aussi publié en tant que site statique sur GitHub Pages, construit à partir des fichiers `.adoc` (AsciiDoc).

### Prérequis supplémentaires

```bash
# Installer les gems Ruby
gem install asciidoctor asciidoctor-diagram asciidoctor-diagram-plantuml

# Installer Java (requis par PlantUML pour les diagrammes)
brew install openjdk          # macOS
# apt install openjdk-17-jre  # Ubuntu
```

### Builder localement

```bash
# Depuis la racine du projet
bash build/ghpages/build.sh

# Prévisualiser
cd _site && python3 -m http.server 8787
# → http://localhost:8787/fr/index.html
```

### Déploiement

Le site se déploie **automatiquement** via GitHub Actions à chaque push sur `main`. Voir `.github/workflows/deploy-gh-pages.yml`.

### Diagrammes

Les diagrammes utilisent **PlantUML** (pas Mermaid). Syntaxe dans les fichiers `.adoc` :

```asciidoc
[plantuml]
----
@startuml
rectangle "A" --> rectangle "B"
@enduml
----
```

Voir le [Guide Développeur](./DEVELOPER_GUIDE.md#diagrammes-plantuml) pour les détails.

---

## 🛠️ Commandes Essentielles

```bash
# Développement
pnpm dev              # Démarrer dev server

# Build
pnpm build            # Build production
pnpm start            # Démarrer prod server

# Qualité
pnpm lint             # Linter ESLint
pnpm type-check       # TypeScript check

# Clear cache (si problèmes)
rm -rf .next .source
pnpm dev
```

---

## 🔧 Configuration Fumadocs

### `site/source.config.ts`

Définit les **collections de contenu** :

```typescript
// 2 collections de guides (FR/EN)
export const guides_fr = defineDocs({ dir: '../content/guides/fr' });
export const guides_en = defineDocs({ dir: '../content/guides/en' });

// 2 collections de PRAs (FR/EN)
export const pras_fr = defineDocs({ dir: '../content/pras/fr' });
export const pras_en = defineDocs({ dir: '../content/pras/en' });
```

**Chaque collection PRA couvre tous les scopes, statuses et catégories.**

### `site/lib/source.ts`

Crée les **source loaders** pour Next.js :

```typescript
const registreSources = {
  en: loader({
    baseUrl: '/en/registre',
    source: pras_en.toFumadocsSource(),
  }),
  fr: loader({
    baseUrl: '/fr/registre',
    source: pras_fr.toFumadocsSource(),
  }),
};
```

---

## 🐛 Problèmes Courants

### 404 sur les Pages PRA

**Cause** : Structure `pra-name/page.md` au lieu de `pra-name.md`

**Solution** :
```bash
# Déplacer et renommer
mv content/pras/fr/transversale/tech/operationalizing/mon-pra/page.md \
   content/pras/fr/transversale/tech/operationalizing/mon-pra.md
```

### Erreur "source.files is not iterable"

**Cause** : Configuration Fumadocs incorrecte (usage de `map()`)

**Solution** : Vérifier `source.config.ts` - doit avoir 2 collections PRAs (FR/EN), pas 24

### Mélange FR/EN

**Cause** : Glob patterns incorrects ou répertoires non séparés

**Solution** : Séparer physiquement `pras/fr/` et `pras/en/` (répertoires dédiés par langue)

### Clear Cache

```bash
cd site
rm -rf .next .source
pnpm dev
```

---

## 📖 Documentation Complète

**Pour développeurs** :
- **[Guide Développeur](./DEVELOPER_GUIDE.md)** : Architecture complète, ADRs, bonnes pratiques

**Pour contributeurs** :
- [Guide de Contribution](./CONTRIBUTING.md) : Comment soumettre un PRA
- [Gouvernance](./GOVERNANCE.md) : Processus et rôles
- [Cycle de Vie](./LIFECYCLE.md) : États des PRA
- [Standards](./STANDARDS.md) : Critères de qualité

**Changelog** :
- [CHANGELOG.md](../CHANGELOG.md) : Historique des changements

---

## 🎯 Bonnes Pratiques

### 1. Structure des Fichiers

✅ **Correct** : `pras/fr/transversale/tech/operationalizing/api-gateway.md`
❌ **Incorrect** : `pras/fr/transversale/tech/operationalizing/api-gateway/page.md`

### 2. Bilingue Toujours

Créer **FR et EN** en même temps avec chemins cohérents :
- `pras/fr/transversale/tech/operationalizing/api-gateway.md`
- `pras/en/transversale/tech/operationalizing/api-gateway.md`

### 3. Frontmatter Complet

```yaml
pra:
  name: Nom Affiché           # ✅ Requis
  category: tech              # ✅ Requis
  status: candidate           # ✅ Requis
  tags: [api, gateway]        # ✅ Requis
  created_at: "2025-12-03"    # ✅ Requis
  updated_at: "2025-12-03"    # ✅ Requis
  proven_in_use:              # ✅ Au moins 1
    - project: Projet A
      team: Équipe X
      date: "2025-11-15"
      feedback: "Amélioration 40% performance"
```

### 4. Mise à Jour

Toujours mettre à jour `updated_at` quand contenu modifié :

```yaml
updated_at: "2025-12-03"  # Date actuelle
```

### 5. Git Workflow

```bash
# Toujours travailler sur une branche
git checkout -b feature/nouveau-pra-api-gateway

# Commits descriptifs
git commit -m "feat(pra): Add API Gateway pattern (Transversale Tech Candidate)"

# Pull Request avec review
# Ne jamais commit sur main directement
```

---

## 🚀 Prochaines Étapes

1. **Explorer** : Naviguer dans `/content/pras/fr/` pour voir exemples
2. **Lire** : [Guide Développeur](./DEVELOPER_GUIDE.md) pour détails architecture
3. **Créer** : Ajouter votre premier PRA
4. **Contribuer** : Soumettre une PR avec le template approprié

---

## 📞 Support

**Questions ?**
1. [Guide Développeur](./DEVELOPER_GUIDE.md) - Documentation complète
2. [GitHub Issues](https://github.com/KiyaliHQ/proven-reusable-architecture/issues) - Reporter un bug
3. Teams : #pra-registry - Discussion

---

**Bonne chance et bon codage! 🚀**
