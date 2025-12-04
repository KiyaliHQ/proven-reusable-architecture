---
title: 07. Processus de Promotion
description: Comment un patron Domaine devient Bank-Wide (Flow 1)
---

# Processus de Promotion (Domaine → Bank-Wide)

**Ceci représente le Flow 1** des trois flows de création de PRA décrits dans [Gouvernance](/guides/08-governance). C'est le flow organique, bottom-up où les PRAs Domaine sont identifiés comme ayant une valeur multi-domaine et promus au statut Bank-Wide.

Ce document décrit le processus permettant de promouvoir un patron Domaine au niveau Bank-Wide, le rendant ainsi applicable à tous les domaines de l'organisation.

##  Vue d'ensemble

La promotion d'un patron Domaine vers le niveau Bank-Wide suit un processus en 4 phases :

```mermaid
graph LR
    A[Phase 1: Proposition] --> B[Phase 2: Revue]
    B --> C[Phase 3: Migration]
    C --> D[Phase 4: Adoption]
```

##  Phase 1 : Proposition

### Déclencheur

Un **Comité de Gouvernance du Domaine** identifie un patron Domaine qui pourrait bénéficier à d'autres domaines.

### Actions requises

1. **Créer dossier de promotion**
   ```
   content/registre/en-promotion/[domaine]-[categorie]-[nom-patron]/
   ```

2. **Documenter la justification**

   Créer `justification.md` :
   ```markdown
   # Justification de Promotion

   ## Patron Proposé
   - **Nom** : [Nom du patron]
   - **Domaine d'origine** : [Domaine]
   - **Catégorie** : tech | integration | security | business

   ## Pourquoi ce patron est d'intérêt Bank-Wide ?
   - [Raison 1 : Besoin récurrent]
   - [Raison 2 : Applicable multi-domaines]
   - [Raison 3 : Mature et éprouvé]

   ## Proven-in-use dans le domaine
   - **Projet 1** : [Nom projet, date, résultats]
   - **Projet 2** : [Nom projet, date, résultats]
   - **Projet 3** : [Nom projet, date, résultats]

   ## Bénéfices attendus
   - [Bénéfice 1]
   - [Bénéfice 2]
   ```

3. **Analyser l'impact multi-domaine**

   Créer `impact-analysis.md` :
   ```markdown
   # Analyse d'Impact Multi-Domaine

   ## Domaines pouvant bénéficier

   ### Domaine 1 : [Nom]
   - **Cas d'usage** : [Description]
   - **Valeur ajoutée** : [Bénéfices]
   - **Effort d'adoption** : Faible | Moyen | Élevé

   ### Domaine 2 : [Nom]
   - **Cas d'usage** : [Description]
   - **Valeur ajoutée** : [Bénéfices]
   - **Effort d'adoption** : Faible | Moyen | Élevé

   ## Adaptations nécessaires
   - [Modification 1 pour généralisation]
   - [Modification 2 pour généralisation]

   ## Risques identifiés
   - [Risque 1 + mitigation]
   - [Risque 2 + mitigation]
   ```

4. **Mettre à jour le patron**

   Dans le frontmatter du patron domaine :
   ```yaml
   promotion_status: proposed
   ```

5. **Soumettre PR**

   ```bash
   git checkout -b promotion/[domaine]-[patron]
   git add content/registre/en-promotion/[dossier]/
   git add content/registre/domaines/[domaine]/[patron].md
   git commit -m "feat: propose promotion [patron] vers Bank-Wide"
   git push origin promotion/[domaine]-[patron]
   ```

##  Phase 2 : Revue

### Assignation

La Pull Request est automatiquement assignée au **Comité de Gouvernance Architectes Experts**.

### Analyse du Comité

Le comité évalue selon ces critères :

#### 1. Réutilisabilité Multi-Domaine

-  Le patron résout-il un problème commun à 3+ domaines ?
-  Les adaptations nécessaires sont-elles mineures ?
-  Les spécificités domaineles peuvent-elles être paramétrées ?

#### 2. Maturité du Patron

-  3+ implémentations prouvées dans le domaine d'origine ?
-  Retours positifs des équipes utilisatrices ?
-  Documentation complète et claire ?

#### 3. Conformité aux Standards Transversaux

-  Respecte les standards techniques entreprise ?
-  Compatible avec l'architecture cible ?
-  Sécurité et conformité validées ?

#### 4. Impact sur la Cohérence d'Entreprise

-  Renforce l'alignement architectural ?
-  Évite la duplication de solutions ?
-  Facilite l'interopérabilité ?

### Décisions Possibles

1. ** Approuvé**  Passe en Phase 3 (Migration)
2. ** Révisions requises**  Retour au domaine avec feedback
3. ** Refusé**  Reste domaine avec justification

### Timeline

- **Review initiale** : 1 semaine
- **Discussion** : 1-2 semaines si clarifications
- **Décision finale** : Maximum 4 semaines

##  Phase 3 : Migration (si approuvé)

### 7. Nettoyage et Généralisation

Le mainteneur du patron (avec support du comité) :

1. **Retire les spécificités domaineles**
   - Remplace références spécifiques par paramètres génériques
   - Documente les points de configuration

2. **Enrichit la documentation**
   - Ajoute exemples multi-domaines
   - Documente les variations domaineles
   - Crée guide d'adaptation

### 8. Migration Technique

```bash
# Déplacer le patron
git mv content/registre/domaines/[domaine]/[categorie]/[patron].md \
       content/registre/Bank-Wide/[categorie]/[patron].md

# Mettre à jour metadata
# Dans le frontmatter :
scope: Bank-Wide
original_sector: [domaine-origine]
promotion_status: promoted
promotion_date: YYYY-MM-DD
```

### 9. Marquage Historique

Dans le domaine d'origine, créer une redirection :

```markdown
---
title: [Nom Patron]
redirect: /registre/Bank-Wide/[categorie]/[patron]
---

# [Nom Patron]

 Ce patron a été **promu au niveau Bank-Wide** le [date].

Il est maintenant accessible à tous les domaines :
 [Voir le patron Bank-Wide](/registre/Bank-Wide/[categorie]/[patron])
```

### 10. Communication

Email automatique envoyé à :
- Tous les architectes
- Responsables architecture de chaque domaine
- Liste de diffusion PRA

Template :
```
Sujet:  Nouveau patron Bank-Wide : [Nom Patron]

Le patron "[Nom Patron]" du domaine [Domaine] a été promu
au niveau Bank-Wide.

Bénéfices : [Résumé]
Domaines applicables : [Liste]
Documentation : [Lien]

Utilisez-le dans vos nouveaux projets !
```

### 11. Archive Promotion

```bash
# Archiver le dossier de promotion
git mv content/registre/en-promotion/[dossier]/ \
       content/registre/en-promotion/archive/YYYY-MM-[patron]/
```

##  Phase 4 : Adoption

### Encouragement Multi-Domaine

Le Comité Architectes Experts :
- Présente le patron en réunion architecture d'entreprise
- Identifie projets pilotes dans différents domaines
- Organise sessions de Q&A

### Feedback et Amélioration

Les équipes adoptantes :
- Documentent leurs implémentations (proven-in-use)
- Remontent feedbacks et suggestions
- Proposent améliorations via PR

### Évolution Continue

Le mainteneur (désormais au niveau Bank-Wide) :
- Intègre les learnings multi-domaines
- Publie updates régulières
- Maintient compatibilité entre domaines

##  Métriques de Succès

Une promotion est considérée réussie si :

-  **3+ domaines** adoptent le patron dans les 6 mois
-  **80%+ satisfaction** des équipes utilisatrices
-  **Réduction duplication** : pas de nouveau patron domaine similaire
-  **Documentation maintenue** : < 3 mois depuis dernière update

##  FAQ

### Combien de temps prend le processus ?

**Minimum** : 6 semaines (2 semaines review + 4 semaines migration)
**Typique** : 2-3 mois (avec révisions et communication)

### Qui décide de la promotion ?

Le **Comité de Gouvernance Architectes Experts**, avec consultation du domaine d'origine.

### Peut-on proposer plusieurs patrons simultanément ?

Oui, mais max **2 promotions actives** par domaine pour éviter surcharge.

### Que se passe-t-il si la promotion est refusée ?

Le patron reste domaine. La justification du refus est documentée et peut être réévaluée après 6 mois.

### Un patron Bank-Wide peut-il être "rétrogradé" ?

Non. Si un patron Bank-Wide devient obsolète, il passe à `deprecated`, mais ne retourne pas au niveau domaine.

##  Support

Pour toute question sur les promotions :

- **Canal Teams** : `#pra-promotions`
- **Email Comité** : pra-governance@company.com
- **Issues GitHub** : Tag `promotion` sur vos PRs

---

**Parcours recommandé** :
1. [Démarrer avec les PRA](/guides/01-getting-started)
2. [Comprendre les PRA](/guides/02-understanding-pra)
3. [Rôles et Responsabilités](/guides/03-roles-responsibilities)
4. [Cycle de Vie](/guides/04-lifecycle)
5. [Standards de Qualité](/guides/05-standards)
6. [Contribuer un PRA](/guides/06-contributing)
7.  **Processus de Promotion** (vous êtes ici)
8. [Gouvernance](/guides/08-governance)

---

**Navigation** :
-  **Précédent** : [Contribuer un PRA](/guides/06-contributing)
-  **Suivant** : [Gouvernance](/guides/08-governance)

---

**Dernière mise à jour** : 2025-12-02
**Prochaine review** : 2026-06-02
