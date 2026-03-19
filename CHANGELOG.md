# Changelog

Tous les changements notables de ce projet seront documentés dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/lang/fr/).

---

## [1.0.0] - 2025-12-03

### 🎉 Version Initiale (MVP)

#### Ajouté

**Infrastructure**
- Site Fumadocs avec Next.js 16 et Turbopack
- Configuration bilingue complète (FR/EN)
- Architecture de contenu séparée par langue (pras-fr/, pras-en/)
- Support MDX avec Fumadocs 14.8.1
- Search client-side avec Orama 3.0.2

**Structure de Contenu**
- Organisation Transversale (transversal) et Par Domaine (par secteur)
- Catégories : tech, integration, security, business
- Status : candidate, approved, deprecated
- Domaines : particuliers, entreprises, gestion-patrimoine

**Documentation**
- Guide développeur complet (`docs/DEVELOPER_GUIDE.md`)
- README mis à jour avec structure actuelle
- Documentation ADRs intégrée

**Features**
- Navigation bilingue avec language switcher
- Sidebar dynamique reflétant structure de répertoires
- Breadcrumb navigation
- Support Mermaid pour diagrammes

#### Modifié

**Migration Architecture**
- Migration de structure `pra-name/page.md` vers `pra-name.md` (flat structure)
- Séparation physique des contenus FR/EN (auparavant imbriqués)
- Simplification collections Fumadocs : 24 → 2 collections PRAs

**Configuration**
- Refonte complète `source.config.ts` pour architecture simplifiée
- Suppression logique `map()` dans `lib/source.ts`
- Chemins de base URL alignés avec structure répertoires

#### Corrigé

**Bugs Critiques**
- ✅ Erreur "source.files is not iterable" (collections mal configurées)
- ✅ 404 sur toutes les pages PRA (structure fichiers incorrecte)
- ✅ Mélange contenus FR/EN (glob patterns inefficaces)

**Problèmes Configuration**
- ✅ Pattern glob `**/fr/**` matchant aussi chemins avec "en" dans nom
- ✅ Fumadocs créant folder nodes vides au lieu de page nodes
- ✅ Build cache causant erreurs de routing

#### Décisions Architecturales

**ADR-001 : Séparation Physique des Contenus FR/EN**
- **Décision** : Créer bases de répertoires séparées (pras-fr/, pras-en/)
- **Raison** : Fumadocs ne supporte pas efficacement filtrage glob FR/EN
- **Impact** : Configuration simple et fiable, pas de mélange FR/EN

**ADR-002 : Simplification des Collections Fumadocs**
- **Décision** : Réduire de 24 à 2 collections PRAs (FR + EN)
- **Raison** : Éviter erreur "source.files is not iterable" causée par map()
- **Impact** : Configuration maintenable, sidebar reflète structure de répertoires

**ADR-003 : Structure de Fichiers Plate (Flat)**
- **Décision** : Adopter `pra-name.md` au lieu de `pra-name/page.md`
- **Raison** : Fumadocs attend structure plate pour créer page nodes
- **Impact** : Toutes pages PRA accessibles, cohérence avec guides

**ADR-004 : Organisation Transversale vs Par Domaine**
- **Décision** : Séparer transversale/ et par-domaine/[domaine]/
- **Raison** : Refléter portée et processus de gouvernance différents
- **Impact** : Portée claire depuis chemin, promotion = simple mv

#### Scripts de Migration

**Ajouté**
- `scripts/split_pras_by_lang_fixed.py` : Séparer contenu FR/EN
- `scripts/flatten_pra_files.py` : Aplatir structure page.md

#### Tests

**Validé**
- ✅ Guides FR/EN (tous retournent 200)
- ✅ Transversale PRAs (tech, integration, business)
- ✅ Par Domaine PRAs (particuliers, entreprises, gestion-patrimoine)
- ✅ Navigation (sidebar, breadcrumb, language switcher)
- ✅ Rendu contenu (titres, sections, diagrammes)

---

## [Unreleased]

### À Venir

**Features Planifiées**
- [ ] Catalogue interactif avec recherche et filtres
- [ ] Dashboard analytics (PRAs les plus vus, etc.)
- [ ] Système de commentaires/feedback sur PRAs
- [ ] Export catalogue (CSV, PDF)
- [ ] RSS feed pour nouveaux PRAs
- [ ] Workflow GitHub Actions pour validation automatique
- [ ] Intégration CI/CD avec checks de qualité
- [ ] Déploiement production sur Vercel/Netlify

**Contenu**
- [ ] Ajouter PRAs transversaux (objectif : 20+)
- [ ] Compléter PRAs sectoriels pour les 3 domaines
- [ ] Documenter processus de promotion avec exemples réels
- [ ] Ajouter tutoriels vidéo pour PRAs clés

**Documentation**
- [ ] Guide de contribution détaillé
- [ ] Guide de gouvernance complet
- [ ] Standards de qualité PRA
- [ ] Processus de lifecycle

---

## Notes de Migration

### De l'Ancienne vers Nouvelle Structure

**Si vous avez des PRAs dans l'ancien format** :

1. **Séparer FR/EN** :
   ```bash
   python3 scripts/split_pras_by_lang_fixed.py
   ```

2. **Aplatir structure** :
   ```bash
   python3 scripts/flatten_pra_files.py
   ```

3. **Vérifier chemins** :
   - Avant : `pras/transversale/candidate/tech/mon-pra/fr/page.md`
   - Après : `pras-fr/transversale/candidate/tech/mon-pra.md`

4. **Rebuild cache** :
   ```bash
   cd site
   rm -rf .next .source
   pnpm dev
   ```

---

## Liens

- **Repository** : https://github.com/KiyaliHQ/proven-reusable-architecture
- **Documentation** : [docs/DEVELOPER_GUIDE.md](./docs/DEVELOPER_GUIDE.md)
- **Issues** : https://github.com/KiyaliHQ/proven-reusable-architecture/issues
- **Fumadocs** : https://fumadocs.vercel.app/docs

---

**Dernière mise à jour** : 3 décembre 2025
