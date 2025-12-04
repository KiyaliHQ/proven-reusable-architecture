# Guide Développeur - PRA Registry

> **Guide complet pour les développeurs travaillant sur le PRA Registry**
>
> Dernière mise à jour : 3 décembre 2025

---

## Table des Matières

1. [Introduction](#introduction)
2. [Architecture du Projet](#architecture-du-projet)
3. [Structure des Répertoires](#structure-des-répertoires)
4. [Configuration Fumadocs](#configuration-fumadocs)
5. [Gestion du Contenu](#gestion-du-contenu)
6. [Développement Local](#développement-local)
7. [Bonnes Pratiques](#bonnes-pratiques)
8. [Résolution de Problèmes](#résolution-de-problèmes)
9. [Décisions Architecturales](#décisions-architecturales)

---

## Introduction

### Qu'est-ce que le PRA Registry ?

Le **PRA Registry** est une plateforme de documentation construite avec **Fumadocs** et **Next.js 16** qui catalogue et organise les Proven Reusable Architecture (PRA) de Banque Nationale du Canada.

### Technologies Principales

- **Framework** : Next.js 16.0.1 (App Router) avec Turbopack
- **Documentation** : Fumadocs 14.8.1
- **React** : 19.0.0
- **TypeScript** : 5.x
- **Styling** : Tailwind CSS 3.4.1
- **Package Manager** : PNPM (workspace monorepo)
- **Search** : Orama 3.0.2 (client-side full-text search)

### Principe Fondamental

**Un PRA est une solution éprouvée, validée dans des projets de production réels, documentée et réutilisable.**

---

## Architecture du Projet

### Vue d'Ensemble

```
proven-reusable-architecture/
├── site/                    # Application Next.js Fumadocs
│   ├── app/                 # Next.js App Router
│   ├── lib/                 # Configuration Fumadocs
│   ├── components/          # Composants React
│   └── public/              # Assets statiques
├── content/                 # Contenu MDX (séparé par langue)
│   ├── guides/              # Guides utilisateur
│   │   ├── fr/              # Guides français
│   │   └── en/              # Guides anglais
│   ├── pras-fr/             # PRAs français
│   └── pras-en/             # PRAs anglais
├── templates/               # Templates pour PRAs
├── scripts/                 # Scripts utilitaires
├── docs/                    # Documentation projet
└── .github/                 # Workflows CI/CD

```

### Architecture Bilingue

Le projet utilise une **séparation physique** des contenus FR/EN :

**Pourquoi ?**
- Fumadocs ne supporte pas efficacement les patterns glob pour filtrer les langues
- Pattern `**/fr/**` matchait aussi des paths contenant "fr" (ex: "entre**pr**ises")
- Séparation claire permet une configuration Fumadocs simple et fiable

**Avant (❌ Problématique)** :
```
content/pras/
  ├── bank-wide/
  │   ├── candidate/
  │   │   └── tech/
  │   │       └── test-workflow/
  │   │           ├── fr/page.md
  │   │           └── en/page.md
```

**Après (✅ Actuel)** :
```
content/
  ├── pras-fr/              # Base FR séparée
  │   └── bank-wide/
  │       └── candidate/
  │           └── tech/
  │               └── test-workflow.md
  ├── pras-en/              # Base EN séparée
  │   └── bank-wide/
  │       └── candidate/
  │           └── tech/
  │               └── test-workflow.md
```

### Convention de Nommage des Fichiers

**Fumadocs attend une structure de fichiers PLATE (flat)** :

✅ **Correct** : `category/pra-name.md`
❌ **Incorrect** : `category/pra-name/page.md`

**Exemple** :
```
pras-fr/
  └── bank-wide/
      └── candidate/
          └── tech/
              ├── test-workflow.md      ✅ Correct
              ├── api-gateway.md        ✅ Correct
              └── observability.md      ✅ Correct
```

**Pourquoi ?**
- Fumadocs crée automatiquement des "page nodes" pour les fichiers `.md`
- Structure `page.md` dans sous-dossiers crée des "folder nodes" vides sans contenu
- Résultat : 404 sur toutes les pages PRA

---

## Structure des Répertoires

### `/site` - Application Fumadocs

```
site/
├── app/                          # Next.js App Router
│   ├── (home)/                   # Route group - Homepage
│   │   ├── page.tsx              # Landing page
│   │   └── layout.tsx
│   ├── [lang]/                   # Dynamic language routes
│   │   ├── guides/               # Guides documentation
│   │   │   └── [[...slug]]/
│   │   │       └── page.tsx
│   │   └── registre/             # PRA registry
│   │       └── [[...slug]]/
│   │           └── page.tsx
│   ├── layout.tsx                # Root layout
│   └── global.css                # Global styles
├── lib/                          # Configuration & utilities
│   ├── source.ts                 # Fumadocs source loaders
│   └── layout.shared.tsx         # Shared layout config
├── components/                   # React components
├── public/                       # Static assets
└── source.config.ts              # Fumadocs collections definition
```

### `/content` - Contenu MDX

```
content/
├── guides/                       # Guides utilisateur
│   ├── fr/                       # Guides français
│   │   ├── 01-getting-started.md
│   │   ├── 02-understanding-pra.md
│   │   └── ...
│   └── en/                       # Guides anglais
│       ├── 01-getting-started.md
│       └── ...
├── pras-fr/                      # PRAs français
│   ├── bank-wide/                # PRAs transversaux (tous secteurs)
│   │   ├── approved/             # Status: Approved (3+ proven)
│   │   │   ├── tech/
│   │   │   ├── integration/
│   │   │   ├── security/
│   │   │   └── business/
│   │   └── candidate/            # Status: Candidate (1+ proven)
│   │       └── [same structure]
│   └── domain-wide/              # PRAs spécifiques à un domaine
│       ├── particuliers/         # Retail banking
│       ├── entreprises/          # Corporate banking
│       └── gestion-patrimoine/   # Wealth management
└── pras-en/                      # PRAs anglais
    └── [same structure as pras-fr]
```

### Scopes des PRAs

| Scope | Description | Approbation | Exemples |
|-------|-------------|-------------|----------|
| **Bank-Wide** | Transversal (tous secteurs) | Comité Architectes Experts | API Gateway, CI/CD patterns |
| **Domain-Wide** | Spécifique à un domaine | Comité Gouvernance Domaine | Onboarding client, KYC |

### Status des PRAs

| Status | Critères | Description |
|--------|----------|-------------|
| **Candidate** | 1+ proven-in-use | En validation, usage avec prudence |
| **Approved** | 3+ proven-in-use (Bank-Wide) ou 1+ (Domain) | Recommandé pour usage |
| **Deprecated** | Obsolète | À remplacer, plan de migration fourni |

### Catégories des PRAs

| Catégorie | Description | Exemples |
|-----------|-------------|----------|
| **tech** | Patterns techniques/infrastructure | CI/CD, Observability, IaC |
| **integration** | Patterns d'intégration | API Gateway, Message Broker, Event-Driven |
| **security** | Patterns sécurité | RBAC, Secrets Management, Network Security |
| **business** | Patterns métier | Onboarding, Payment Processing, Notifications |

---

## Configuration Fumadocs

### `source.config.ts` - Définition des Collections

**Localisation** : `site/source.config.ts`

Ce fichier définit toutes les **collections de contenu** pour Fumadocs.

```typescript
import {
  defineConfig,
  defineDocs,
  frontmatterSchema,
  metaSchema,
} from 'fumadocs-mdx/config';
import { remarkMdxMermaid } from 'fumadocs-core/mdx-plugins';

// =========================================
// GUIDES (French and English)
// =========================================

export const guides_fr = defineDocs({
  dir: '../content/guides/fr',
  docs: {
    schema: frontmatterSchema,
    postprocess: {
      includeProcessedMarkdown: true,
    },
  },
  meta: {
    schema: metaSchema,
  },
});

export const guides_en = defineDocs({
  dir: '../content/guides/en',
  docs: {
    schema: frontmatterSchema,
    postprocess: {
      includeProcessedMarkdown: true,
    },
  },
  meta: {
    schema: metaSchema,
  },
});

// =========================================
// PRAs (All scopes and statuses)
// =========================================

export const pras_fr = defineDocs({
  dir: '../content/pras-fr',
  docs: {
    schema: frontmatterSchema,
    postprocess: {
      includeProcessedMarkdown: true,
    },
  },
  meta: {
    schema: metaSchema,
  },
});

export const pras_en = defineDocs({
  dir: '../content/pras-en',
  docs: {
    schema: frontmatterSchema,
    postprocess: {
      includeProcessedMarkdown: true,
    },
  },
  meta: {
    schema: metaSchema,
  },
});

// =========================================
// BACKWARD COMPATIBILITY ALIASES
// =========================================

export const docs_fr = guides_fr;
export const docs_en = guides_en;
export const docs = docs_fr;

export const registre_fr = pras_fr;
export const registre_en = pras_en;

export default defineConfig({
  mdxOptions: {
    remarkPlugins: [remarkMdxMermaid],
  },
});
```

**Points Clés** :
- **2 collections de guides** (FR/EN)
- **2 collections de PRAs** (FR/EN)
- Chaque collection couvre **tous les scopes, statuses et catégories**
- Alias pour rétrocompatibilité (`registre_fr`, `docs_fr`)

### `lib/source.ts` - Source Loaders

**Localisation** : `site/lib/source.ts`

Ce fichier crée les **source loaders** utilisés par Next.js pages pour charger le contenu.

```typescript
import { loader } from 'fumadocs-core/source';
import {
  guides_fr,
  guides_en,
  pras_fr,
  pras_en,
} from 'fumadocs-mdx:collections/server';
import { lucideIconsPlugin } from 'fumadocs-core/source/plugins/lucide';

// Guide sources
const guideSources = {
  en: loader({
    baseUrl: '/en/guides',
    source: guides_en.toFumadocsSource(),
    plugins: [lucideIconsPlugin()],
  }),
  fr: loader({
    baseUrl: '/fr/guides',
    source: guides_fr.toFumadocsSource(),
    plugins: [lucideIconsPlugin()],
  }),
};

// Registry (PRA) sources
const registreSources = {
  en: loader({
    baseUrl: '/en/registre',
    source: pras_en.toFumadocsSource(),
    plugins: [lucideIconsPlugin()],
  }),
  fr: loader({
    baseUrl: '/fr/registre',
    source: pras_fr.toFumadocsSource(),
    plugins: [lucideIconsPlugin()],
  }),
};

export function getGuideSource(lang: 'en' | 'fr') {
  return guideSources[lang];
}

export function getRegistreSource(lang: 'en' | 'fr') {
  return registreSources[lang];
}
```

**Points Clés** :
- Utilise `.toFumadocsSource()` pour convertir collections en sources compatibles
- Pas de `map()` ou logique complexe de fusion
- Chaque langue a sa propre source dédiée
- Plugin Lucide Icons pour le support des icônes

---

## Gestion du Contenu

### Ajouter un Nouveau PRA

#### 1. Choisir Scope, Catégorie et Status

**Scope** :
- `bank-wide/` : Transversal (tous secteurs)
- `domain-wide/[domaine]/` : Spécifique à un domaine

**Catégorie** :
- `tech/`, `integration/`, `security/`, `business/`

**Status** :
- `candidate/` : 1+ proven-in-use (début)
- `approved/` : 3+ proven-in-use (Bank-Wide) ou 1+ (Domain-Wide)

**Exemple de chemin** :
```
content/pras-fr/bank-wide/candidate/tech/mon-nouveau-pra.md
content/pras-en/bank-wide/candidate/tech/my-new-pra.md
```

#### 2. Créer le Fichier MDX

**Utiliser le template** :
```bash
cp templates/pra-template.md content/pras-fr/bank-wide/candidate/tech/mon-pra.md
```

**Structure du Frontmatter** :
```yaml
---
title: Titre du PRA
description: Description courte (1-2 phrases)
pra:
  name: Nom Affiché du PRA
  category: tech|integration|security|business
  status: candidate|approved|deprecated
  tags: [tag1, tag2, tag3]
  created_at: "YYYY-MM-DD"
  updated_at: "YYYY-MM-DD"
  proven_in_use:
    - project: Nom du Projet
      team: Nom de l'Équipe
      date: "YYYY-MM-DD"
      feedback: Retour d'expérience détaillé
---

# Contenu du PRA

## Contexte

[Décrire le problème résolu]

## Architecture

[Diagrammes et description]

## ADRs

### ADR-001: Décision X

[Documentation de la décision]

## Exemples

[Code examples]

## Retours d'Expérience

[Learnings from implementations]
```

#### 3. Créer/Mettre à Jour `meta.json`

Chaque répertoire peut avoir un `meta.json` pour configurer l'ordre et les titres dans la sidebar :

```json
{
  "title": "Tech Patterns",
  "pages": [
    "api-gateway",
    "mon-nouveau-pra",
    "observability"
  ]
}
```

**Si `meta.json` n'existe pas** :
- Fumadocs affichera tous les fichiers `.md` du répertoire
- Ordre alphabétique par défaut

#### 4. Tester Localement

```bash
cd site
pnpm dev
```

Naviguer vers :
- FR : `http://localhost:3000/fr/registre/bank-wide/candidate/tech/mon-nouveau-pra`
- EN : `http://localhost:3000/en/registre/bank-wide/candidate/tech/my-new-pra`

### Mettre à Jour un PRA Existant

1. **Lire le fichier** pour connaître la structure actuelle
2. **Modifier le contenu** (architecture, ADRs, exemples)
3. **Mettre à jour `updated_at`** dans le frontmatter
4. **Ajouter proven-in-use** si nouvelle implémentation
5. **Tester localement**

**Règles** :
- **Ne jamais supprimer** les entrées `proven_in_use` (historique)
- **Ne jamais modifier** les ADRs existantes (ajouter de nouvelles à la place)
- **Toujours mettre à jour** `updated_at`

### Promouvoir un PRA

**Candidate → Approved** :
1. Vérifier critères :
   - Bank-Wide : 3+ proven-in-use multi-domaines
   - Domain-Wide : 1+ proven-in-use dans le domaine
2. Déplacer fichier :
   ```bash
   mv content/pras-fr/bank-wide/candidate/tech/mon-pra.md \
      content/pras-fr/bank-wide/approved/tech/mon-pra.md
   ```
3. Mettre à jour `status: approved` dans frontmatter
4. Mettre à jour `meta.json` dans les deux répertoires

**Domain-Wide → Bank-Wide** :
1. Vérifier critères : 3+ proven-in-use multi-domaines
2. Déplacer fichier :
   ```bash
   mv content/pras-fr/domain-wide/particuliers/candidate/tech/mon-pra.md \
      content/pras-fr/bank-wide/candidate/tech/mon-pra.md
   ```
3. Mettre à jour documentation avec justification applicabilité
4. Soumettre pour approbation Comité Architectes Experts

---

## Développement Local

### Prérequis

- **Node.js** : 18.x ou supérieur
- **PNPM** : 8.x ou supérieur

### Installation

```bash
# Cloner le repository
git clone https://github.com/KiyaliHQ/proven-reusable-architecture.git
cd proven-reusable-architecture

# Installer les dépendances
cd site
pnpm install
```

### Démarrage du Serveur de Développement

```bash
cd site
pnpm dev
```

Le site sera accessible sur `http://localhost:3000`

**Avec Turbopack** (par défaut) :
```bash
pnpm dev
```

**Sans Turbopack** :
```bash
pnpm dev:no-turbo
```

### Scripts Disponibles

```bash
pnpm dev              # Démarrer dev server (Turbopack)
pnpm build            # Build pour production
pnpm start            # Démarrer prod server
pnpm lint             # Linter ESLint
pnpm type-check       # Vérification TypeScript
```

### Structure du Dev Server

**Hot Module Replacement (HMR)** :
- Modifications des composants React → Reload instantané
- Modifications du contenu MDX → Rebuild automatique
- Modifications de `source.config.ts` → Redémarrage requis

**Fichiers Auto-Générés** :
- `.source/` : Fichiers générés par Fumadocs (git ignored)
- `.next/` : Build cache Next.js (git ignored)

**Si problèmes de build** :
```bash
rm -rf .next .source
pnpm dev
```

### Variables d'Environnement

**Actuellement** : Aucune variable d'environnement requise pour le développement local.

**À venir** :
- `NEXT_PUBLIC_SITE_URL` : URL publique du site
- `ORAMA_API_KEY` : Clé API Orama (si backend search)

---

## Bonnes Pratiques

### Gestion du Contenu

1. **Toujours créer les deux versions linguistiques** (FR et EN) en même temps
2. **Maintenir la cohérence des chemins** entre FR et EN
   - ✅ `pras-fr/bank-wide/candidate/tech/api-gateway.md`
   - ✅ `pras-en/bank-wide/candidate/tech/api-gateway.md`
3. **Utiliser des slugs descriptifs** en kebab-case
   - ✅ `digital-onboarding-pattern.md`
   - ❌ `dop.md`
4. **Documenter tous les proven-in-use** avec détails quantifiés
5. **Inclure des diagrammes** (Mermaid supporté)

### Code

1. **Utiliser TypeScript** pour tous les nouveaux composants
2. **Préférer Server Components** sauf si interactivité client nécessaire
3. **Suivre les conventions Next.js App Router**
4. **Utiliser Tailwind CSS** pour le styling
5. **Tester localement** avant commit

### Git Workflow

1. **Toujours travailler sur une branche** :
   ```bash
   git checkout -b feature/nouveau-pra-api-gateway
   ```
2. **Commits descriptifs** :
   ```bash
   git commit -m "feat(pra): Add API Gateway pattern (Bank-Wide Tech Candidate)"
   ```
3. **Pull Request** avec template approprié
4. **Ne jamais commit sur `main`** directement

### Documentation

1. **Mettre à jour `DEVELOPER_GUIDE.md`** si changement architectural
2. **Documenter les décisions** dans les ADRs
3. **Garder README.md à jour**
4. **Ajouter commentaires** dans le code complexe

---

## Résolution de Problèmes

### Erreur : "source.files is not iterable"

**Symptôme** :
```
⨯ TypeError: source.files is not iterable
    at <unknown> (lib/source.ts:51:13)
```

**Cause** :
- Utilisation de `map()` pour fusionner plusieurs collections
- `map()` retourne un objet qui n'a pas la propriété `.files` itérable

**Solution** :
- Simplifier à 2 collections (FR/EN) au lieu de 24
- Passer collections directement via `.toFumadocsSource()`
- Supprimer toute logique de `map()`

### Erreur : 404 sur toutes les pages PRA

**Symptôme** :
- `/fr/registre/bank-wide/candidate/tech/test-workflow` retourne 404
- Site compile sans erreur

**Cause** :
- Structure `pra-name/page.md` au lieu de `pra-name.md`
- Fumadocs crée des folder nodes vides sans page content

**Solution** :
- Aplatir la structure : `page.md` → `pra-name.md`
- Script de migration fourni dans `/scripts/flatten_pra_files.py`

### Erreur : Glob Pattern Matching Wrong Files

**Symptôme** :
- Pattern `**/fr/**` matche aussi des fichiers EN
- Collection FR contient des fichiers EN

**Cause** :
- Glob pattern substring matching (ex: "entreprises" contient "en")
- Fumadocs `defineDocs` ne supporte pas `exclude`

**Solution** :
- Séparation physique des répertoires (`pras-fr/` vs `pras-en/`)
- Pas de pattern glob complexe nécessaire

### Build Errors

**Clear cache et rebuild** :
```bash
cd site
rm -rf .next .source node_modules
pnpm install
pnpm dev
```

**Si erreurs persistent** :
1. Vérifier versions des dépendances (`package.json`)
2. Vérifier syntaxe du frontmatter YAML
3. Vérifier noms de fichiers (pas de caractères spéciaux)
4. Vérifier structure `meta.json`

### Port 3000 Already in Use

```bash
# Tuer le processus sur le port 3000
lsof -ti:3000 | xargs kill -9

# Ou utiliser un autre port
pnpm dev -- --port 3001
```

---

## Décisions Architecturales

### ADR-001 : Séparation Physique des Contenus FR/EN

**Date** : 2 décembre 2025

**Contexte** :
- Fumadocs ne supportait pas efficacement le filtrage FR/EN via glob patterns
- Pattern `**/fr/**` matchait aussi des chemins contenant "fr" (ex: "entreprises")
- `defineDocs` ne supporte pas l'option `exclude`

**Décision** :
- Créer deux bases de répertoires séparées : `pras-fr/` et `pras-en/`
- Dupliquer la structure complète dans chaque base
- Chaque collection pointe directement vers sa base

**Conséquences** :
✅ Configuration Fumadocs simple et fiable
✅ Pas de risque de mélange FR/EN
✅ Performance : pas de filtrage runtime nécessaire
❌ Duplication de structure de répertoires
❌ Scripts de migration nécessaires pour contenu existant

**Alternatives Rejetées** :
- Glob patterns avec `exclude` : Pas supporté par Fumadocs
- Post-filtering des collections : Complexe et peu performant
- Collections séparées par scope/category : 24 collections (trop complexe)

### ADR-002 : Simplification des Collections Fumadocs

**Date** : 2 décembre 2025

**Contexte** :
- Configuration initiale : 24 collections (12 FR + 12 EN)
- Chaque combinaison scope/status/category = 1 collection
- Utilisation de `map()` pour fusionner les collections
- Résultat : Erreur "source.files is not iterable"

**Décision** :
- Réduire à 2 collections de PRAs (FR et EN)
- Chaque collection couvre tous les scopes, statuses et catégories
- Pas de logique de fusion (`map()`) nécessaire

**Conséquences** :
✅ Configuration simple et maintenable
✅ Pas d'erreur d'itération
✅ Sidebar Fumadocs reflète la structure de répertoires
❌ Moins de granularité dans les collections

**Alternatives Rejetées** :
- 24 collections avec fusion : Complexe et causait des erreurs
- Collections par catégorie uniquement : Perd l'organisation scope/status

### ADR-003 : Structure de Fichiers Plate (Flat)

**Date** : 2 décembre 2025

**Contexte** :
- Structure initiale : `pra-name/page.md` (inspirée de Next.js)
- Résultat : 404 sur toutes les pages PRA
- Fumadocs créait des folder nodes sans page content

**Décision** :
- Adopter structure plate : `pra-name.md` (pas de sous-dossier)
- Cohérence avec structure des guides (`01-getting-started.md`)

**Conséquences** :
✅ Fumadocs crée correctement les page nodes
✅ Toutes les pages PRA accessibles
✅ Structure cohérente avec guides
❌ Migration nécessaire pour contenu existant

**Script de Migration** :
```python
# /scripts/flatten_pra_files.py
for page_md in pras_dir.rglob('page.md'):
    pra_name = page_md.parent.name
    new_file = page_md.parent.parent / f"{pra_name}.md"
    shutil.move(str(page_md), str(new_file))
    page_md.parent.rmdir()
```

### ADR-004 : Organisation Bank-Wide vs Domain-Wide

**Date** : 2 décembre 2025

**Contexte** :
- PRAs ont des portées différentes (tous secteurs vs un secteur)
- Processus de gouvernance différents selon portée
- Promotion possible : Domain → Bank-Wide

**Décision** :
- Séparer `bank-wide/` (transversal) et `domain-wide/[domaine]/`
- Sous-structure par status puis category
- Permet promotion par simple déplacement de fichier

**Structure** :
```
pras-fr/
  ├── bank-wide/
  │   ├── approved/
  │   │   ├── tech/
  │   │   ├── integration/
  │   │   ├── security/
  │   │   └── business/
  │   └── candidate/
  │       └── [same]
  └── domain-wide/
      ├── particuliers/
      ├── entreprises/
      └── gestion-patrimoine/
          └── [same structure as bank-wide]
```

**Conséquences** :
✅ Portée claire depuis le chemin du fichier
✅ Processus de gouvernance aligné avec structure
✅ Promotion = simple `mv` de fichier
✅ Scalable (ajout de nouveaux domaines facile)

---

## Annexes

### Ressources Externes

**Fumadocs** :
- Documentation : https://fumadocs.vercel.app/docs
- GitHub : https://github.com/fuma-nama/fumadocs

**Next.js** :
- Documentation : https://nextjs.org/docs
- App Router : https://nextjs.org/docs/app

**Orama Search** :
- Documentation : https://docs.oramasearch.com/

**Tailwind CSS** :
- Documentation : https://tailwindcss.com/docs

### Scripts Utilitaires

**Localisation** : `/scripts/`

1. **`split_pras_by_lang_fixed.py`** : Sépare contenu FR/EN en bases distinctes
2. **`flatten_pra_files.py`** : Aplatit structure `page.md` → `pra-name.md`

**Utilisation** :
```bash
python3 /path/to/script.py
```

### Conventions de Commit

**Format** :
```
<type>(<scope>): <description courte>

[Corps du commit optionnel]

[Footer optionnel]
```

**Types** :
- `feat` : Nouvelle fonctionnalité
- `fix` : Correction de bug
- `docs` : Changements documentation
- `style` : Formatage (pas de changement de code)
- `refactor` : Refactoring code
- `test` : Ajout/modification tests
- `chore` : Tâches maintenance

**Scopes** :
- `pra` : PRAs content
- `guides` : Guides content
- `site` : Application Next.js
- `config` : Configuration files
- `ci` : CI/CD workflows

**Exemples** :
```bash
feat(pra): Add API Gateway pattern (Bank-Wide Tech Candidate)
fix(site): Correct 404 error on PRA pages
docs(guides): Update contributing guide with new structure
refactor(config): Simplify Fumadocs source configuration
```

---

## Support

**Questions ou Problèmes ?**

1. **Documentation** : Vérifier ce guide et `/docs/`
2. **GitHub Issues** : Ouvrir un ticket avec label `question` ou `bug`
3. **Teams** : Canal #pra-registry
4. **Email** : pra-initiative@example.com

---

**Dernière mise à jour** : 3 décembre 2025
**Maintenu par** : Architecture Team, Banque Nationale du Canada
**Version** : 1.0.0
