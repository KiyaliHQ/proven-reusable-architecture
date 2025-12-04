# Scripts de Migration

> Scripts Python utilisés pour la migration de l'architecture du contenu

**Date**: 3 décembre 2025

---

## Contexte

Ces scripts ont été utilisés pour migrer l'architecture du contenu PRA de l'ancienne structure vers la nouvelle structure bilingue séparée.

**Migration effectuée**: 3 décembre 2025

---

## Scripts

### 1. `split_pras_by_lang_fixed.py`

**Objectif**: Séparer les contenus FR et EN en bases distinctes

**Ancien format**:
```
content/pras/
  └── bank-wide/
      └── candidate/
          └── tech/
              └── test-workflow/
                  ├── fr/page.md
                  └── en/page.md
```

**Nouveau format**:
```
content/
  ├── pras-fr/
  │   └── bank-wide/candidate/tech/test-workflow/page.md
  └── pras-en/
      └── bank-wide/candidate/tech/test-workflow/page.md
```

**Usage**:
```bash
python3 scripts/migration/split_pras_by_lang_fixed.py
```

---

### 2. `flatten_pra_files.py`

**Objectif**: Aplatir la structure de fichiers (supprimer les sous-dossiers `page.md`)

**Ancien format**:
```
pras-fr/bank-wide/candidate/tech/test-workflow/page.md
```

**Nouveau format**:
```
pras-fr/bank-wide/candidate/tech/test-workflow.md
```

**Raison**: Fumadocs attend une structure plate pour créer correctement les page nodes.

**Usage**:
```bash
python3 scripts/migration/flatten_pra_files.py
```

---

### 3. Autres Scripts (Archive)

- **`split_pras_by_lang.py`**: Version initiale (buggy) du script de séparation
- **`restructure_pras.py`**: Script de restructuration intermédiaire
- **`add_include.py`**: Script pour ajouter des patterns include
- **`update_include_patterns.py`**: Script pour mettre à jour les patterns

**Note**: Ces scripts sont conservés pour référence historique mais ne doivent plus être utilisés.

---

## Ordre d'Exécution (Archive)

Pour référence, voici l'ordre dans lequel les scripts ont été exécutés lors de la migration:

1. **`split_pras_by_lang_fixed.py`** - Séparer FR/EN
2. **`flatten_pra_files.py`** - Aplatir la structure

**Résultat**: Migration complète réussie, site fonctionnel.

---

## Notes Importantes

⚠️ **Ces scripts ont déjà été exécutés et la migration est terminée.**

⚠️ **Ne PAS ré-exécuter ces scripts** sauf si vous devez restaurer une ancienne structure.

⚠️ **La structure actuelle est la bonne** : `content/pras-fr/` et `content/pras-en/` avec fichiers plats.

---

## Références

- **ADR-001**: Séparation physique des contenus FR/EN
- **ADR-003**: Structure de fichiers plate
- **DEVELOPER_GUIDE.md**: Documentation complète de l'architecture
- **CHANGELOG.md**: Historique des changements

---

**Dernière mise à jour**: 3 décembre 2025
