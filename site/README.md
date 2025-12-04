# PRA Registry - Site Fumadocs

> Application Next.js pour le catalogue des Proven Reusable Architecture (PRA)

Ce site est construit avec [Fumadocs](https://fumadocs.dev) et Next.js 16 pour documenter et cataloguer les architectures réutilisables éprouvées de Banque Nationale du Canada.

---

## 🚀 Démarrage Rapide

### Prérequis

- Node.js 18.x ou supérieur
- PNPM 8.x ou supérieur

### Installation

```bash
# Depuis le répertoire site/
pnpm install
```

### Développement

```bash
pnpm dev
```

Le site sera accessible sur [http://localhost:3000](http://localhost:3000)

### Build Production

```bash
pnpm build
pnpm start
```

---

## 📂 Structure du Projet

```
site/
├── app/                       # Next.js App Router
│   ├── (home)/                # Landing page
│   │   └── page.tsx
│   ├── [lang]/                # Routes dynamiques par langue (fr/en)
│   │   ├── guides/            # Documentation guides
│   │   │   └── [[...slug]]/
│   │   │       └── page.tsx
│   │   └── registre/          # Catalogue PRAs
│   │       └── [[...slug]]/
│   │           └── page.tsx
│   ├── layout.tsx             # Layout racine
│   └── global.css             # Styles globaux
├── lib/                       # Configuration & utilitaires
│   ├── source.ts              # Fumadocs source loaders
│   └── layout.shared.tsx      # Configuration layouts partagée
├── components/                # Composants React
├── public/                    # Assets statiques
├── source.config.ts           # Définition collections Fumadocs
├── next.config.mjs            # Configuration Next.js
├── tailwind.config.ts         # Configuration Tailwind CSS
└── tsconfig.json              # Configuration TypeScript
```

---

## 🔧 Fichiers Clés

### `source.config.ts`

Définit les **collections de contenu** pour Fumadocs :

```typescript
export const guides_fr = defineDocs({
  dir: '../content/guides/fr',
  // ...
});

export const guides_en = defineDocs({
  dir: '../content/guides/en',
  // ...
});

export const pras_fr = defineDocs({
  dir: '../content/pras-fr',
  // ...
});

export const pras_en = defineDocs({
  dir: '../content/pras-en',
  // ...
});
```

- **2 collections de guides** (FR/EN)
- **2 collections de PRAs** (FR/EN)
- Chaque collection PRA couvre tous les scopes, statuses et catégories

### `lib/source.ts`

Crée les **source loaders** utilisés par les pages Next.js :

```typescript
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
```

### `lib/layout.shared.tsx`

Configuration partagée pour layouts Fumadocs :
- Navigation
- Sidebar
- Language switcher
- Theme (light mode only)

---

## 📚 Routes

| Route | Description |
|-------|-------------|
| `/` | Page d'accueil (landing page) |
| `/fr/guides/[...slug]` | Guides français |
| `/en/guides/[...slug]` | Guides anglais |
| `/fr/registre/[...slug]` | Catalogue PRAs français |
| `/en/registre/[...slug]` | Catalogue PRAs anglais |
| `/api/search` | API endpoint pour recherche (Orama) |

---

## 🎨 Technologies

### Core

- **Next.js** : 16.0.1 (App Router)
- **React** : 19.0.0
- **TypeScript** : 5.x

### Documentation

- **Fumadocs** : 14.8.1
  - `fumadocs-core` : Core documentation features
  - `fumadocs-ui` : Pre-built UI components
  - `fumadocs-mdx` : MDX processing

### UI & Styling

- **Tailwind CSS** : 3.4.1
- **Lucide Icons** : Icon system

### Search

- **Orama** : 3.0.2 (client-side full-text search)

### Dev Tools

- **Turbopack** : Next.js bundler (dev mode)
- **PNPM** : Package manager

---

## 🛠️ Scripts Disponibles

```bash
pnpm dev              # Démarrer dev server avec Turbopack
pnpm build            # Build pour production
pnpm start            # Démarrer prod server
pnpm lint             # Linter ESLint
pnpm type-check       # Vérification TypeScript
```

---

## 📝 Contenu MDX

Le contenu est stocké dans `/content/` (répertoire parent) :

```
content/
├── guides/
│   ├── fr/           # Guides français
│   │   ├── 01-getting-started.md
│   │   ├── 02-understanding-pra.md
│   │   └── ...
│   └── en/           # Guides anglais
├── pras-fr/          # PRAs français
│   ├── bank-wide/    # Transversaux (tous secteurs)
│   │   ├── approved/
│   │   └── candidate/
│   └── domain-wide/  # Spécifiques à un domaine
│       ├── particuliers/
│       ├── entreprises/
│       └── gestion-patrimoine/
└── pras-en/          # PRAs anglais (même structure)
```

**Format des fichiers** :
- Flat structure : `pra-name.md` (pas `pra-name/page.md`)
- Frontmatter YAML avec métadonnées
- Contenu en Markdown/MDX

---

## 🔍 Ajouter du Contenu

### Ajouter un PRA

1. **Créer le fichier MDX** dans le bon répertoire :
   ```
   content/pras-fr/bank-wide/candidate/tech/mon-pra.md
   content/pras-en/bank-wide/candidate/tech/my-pra.md
   ```

2. **Structure du frontmatter** :
   ```yaml
   ---
   title: Titre du PRA
   description: Description courte
   pra:
     name: Nom Affiché
     category: tech|integration|security|business
     status: candidate|approved|deprecated
     tags: [tag1, tag2]
     created_at: "YYYY-MM-DD"
     updated_at: "YYYY-MM-DD"
     proven_in_use:
       - project: Nom Projet
         team: Nom Équipe
         date: "YYYY-MM-DD"
         feedback: Retour d'expérience
   ---
   ```

3. **Redémarrer le dev server** pour voir les changements

### Ajouter un Guide

1. **Créer le fichier MDX** :
   ```
   content/guides/fr/XX-mon-guide.md
   content/guides/en/XX-my-guide.md
   ```

2. **Structure du frontmatter** :
   ```yaml
   ---
   title: Titre du Guide
   description: Description courte
   ---
   ```

---

## 🐛 Résolution de Problèmes

### Clear Cache

Si le site ne build pas correctement :

```bash
rm -rf .next .source
pnpm dev
```

### Port 3000 Already in Use

```bash
# Tuer le processus
lsof -ti:3000 | xargs kill -9

# Ou utiliser un autre port
pnpm dev -- --port 3001
```

### Erreurs TypeScript

```bash
pnpm type-check
```

### Erreurs de Lint

```bash
pnpm lint
```

---

## 📖 Documentation

**Pour développer sur le projet** :
- [Guide Développeur](../docs/DEVELOPER_GUIDE.md) : Guide complet avec architecture, ADRs, bonnes pratiques

**Fumadocs** :
- [Documentation officielle](https://fumadocs.dev/docs)
- [API Reference](https://fumadocs.dev/docs/headless/source-api)
- [MDX Guide](https://fumadocs.dev/docs/mdx)

**Next.js** :
- [Documentation](https://nextjs.org/docs)
- [App Router](https://nextjs.org/docs/app)

---

## 🎯 Bonnes Pratiques

1. **Always test locally** avant de commit
2. **Use TypeScript** pour tous les nouveaux composants
3. **Prefer Server Components** sauf si interactivité client nécessaire
4. **Follow Next.js conventions** pour file-based routing
5. **Update `updated_at`** dans frontmatter quand contenu modifié

---

## 🚀 Déploiement

### Vercel (Recommandé)

1. Connecter le repository GitHub à Vercel
2. Configuration :
   - Framework Preset : `Next.js`
   - Root Directory : `site`
   - Build Command : `pnpm build`
   - Output Directory : `.next`
3. Deploy automatique sur push vers `main`

### Autre Plateforme

```bash
cd site
pnpm build
pnpm start
```

Le site sera accessible sur `http://localhost:3000`

---

## 📞 Support

**Questions ou Problèmes ?**

1. Consulter le [Guide Développeur](../docs/DEVELOPER_GUIDE.md)
2. Ouvrir un [GitHub Issue](https://github.com/KiyaliHQ/proven-reusable-architecture/issues)
3. Contacter sur Teams : #pra-registry

---

**Dernière mise à jour** : 3 décembre 2025
**Version** : 1.0.0
