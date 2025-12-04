---
title: 06. Guide de Contribution
description: Comment contribuer au registre PRA
---

# Guide de Contribution

Vous souhaitez soumettre un nouveau PRA ? Suivez ce guide étape par étape.

## Prérequis

Avant de soumettre un PRA, assurez-vous que :

-  Votre architecture a été **validée en production** dans au moins **1 projet réel**
-  Vous disposez de **retours d'expérience concrets** (metrics, learnings, feedback)
-  La solution est **réutilisable** et **généralisable** à d'autres contextes
-  Vous pouvez **documenter** le contexte, les décisions et les exemples

## Choisir le Scope de Votre PRA

Avant de commencer, déterminez quel scope s'applique :

### PRA Domaine
Soumettez un **PRA Domaine** si votre patron :
- Est spécifique à un domaine (Particuliers, Entreprises, Gestion de Patrimoine)
- Contient des patterns fonctionnels ou techniques pour votre domaine
- A au moins **1 proven-in-use dans votre domaine**
- Sera reviewé par votre **Comité de Gouvernance du Domaine**

### PRA Bank-Wide
Soumettez un **PRA Bank-Wide** si votre patron :
- Est applicable à travers **plusieurs domaines**
- A démontré une **applicabilité multi-domaine**
- A au moins **1 proven-in-use** (avec potentiel multi-domaine clair)
- Sera reviewé par le **Comité de Gouvernance Architectes Experts**

**Note** : La plupart des PRAs commencent comme PRAs Domaine. Les PRAs Bank-Wide proviennent typiquement de :
- Équipes transversales (Software Engineering, Sécurité, etc.) - [**Flow 2**](/guides/08-governance#-flow-2--top-down-équipes-transversales---bank-wide)
- PRAs Domaine promus vers Bank-Wide - [**Flow 1**](/guides/08-governance#-flow-1--organique-domaine---bank-wide)
- Initiative Bootstrap (transitoire) - [**Flow 3**](/guides/08-governance#-flow-3--bootstrap-transitoire)

## Processus de Soumission

### 1. Fork et Clone

```bash
git clone https://github.com/KiyaliHQ/proven-reusable-architecture.git
cd proven-reusable-architecture
```

### 2. Créer une Branche

```bash
git checkout -b feature/pra-nom-de-votre-pra
```

### 3. Créer Votre PRA (Bilingue)

**IMPORTANT**: Vous devez créer **deux versions** de votre PRA (français ET anglais).

#### Structure des Dossiers

- **PRA Bank-Wide** : `content/pras-{lang}/bank-wide/candidate/{category}/nom-du-pra.md`
- **PRA Domain-Wide** : `content/pras-{lang}/domain-wide/{domain}/candidate/{category}/nom-du-pra.md`

Où :
- `{lang}` = `fr` ou `en`
- `{category}` = `tech`, `integration`, `security`, ou `business`
- `{domain}` = `particuliers`, `entreprises`, ou `gestion-patrimoine` (si domain-wide)

#### Exemples

**PRA Bank-Wide Tech** (applicable à tous les secteurs) :
```bash
content/pras-fr/bank-wide/candidate/tech/api-gateway-pattern.md
content/pras-en/bank-wide/candidate/tech/api-gateway-pattern.md
```

**PRA Domain-Wide Security** (Particuliers) :
```bash
content/pras-fr/domain-wide/particuliers/candidate/security/kyc-verification.md
content/pras-en/domain-wide/particuliers/candidate/security/kyc-verification.md
```

### 4. Utiliser le Template

Copiez le template PRA et remplissez toutes les sections :

```yaml
---
title: Nom de Votre PRA
description: Description concise du PRA
pra:
  name: Nom de Votre PRA
  category: tech|integration|security|business
  status: candidate
  tags: [tag1, tag2, tag3]
  created_at: "YYYY-MM-DD"
  updated_at: "YYYY-MM-DD"
  proven_in_use:
    - project: Nom du Projet
      team: Nom de l'Équipe
      date: "YYYY-MM-DD"
      feedback: "Retours d'expérience concrets"
---

## Vue d'ensemble
[Votre documentation...]

## Contexte
[Le problème et la solution...]

## Architecture
[Diagrammes et composants...]

## Architecture Decision Records (ADRs)
[Décisions architecturales documentées...]

## Exemples
[Code et configurations concrètes...]

## Feedback de Production
[Retours d'implémentations réelles...]
```

**Sections obligatoires** :
- Vue d'ensemble (Overview)
- Contexte (Context)
- Architecture
- ADRs (Architecture Decision Records)
- Exemples (Examples)
- Au moins **1 proven-in-use** documenté

### 5. Créer une Pull Request

```bash
git add content/pras-fr/ content/pras-en/
git commit -m "feat: add PRA - Nom du PRA (Bank-Wide Tech Candidate)"
git push origin feature/pra-nom-de-votre-pra
```

Ensuite, créez une Pull Request sur GitHub.

### 6. Validation Automatique ✨

**Dès l'ouverture de votre PR**, le système automatisé va :

1. ✅ **Valider la structure**
   - Métadonnées complètes
   - Sections obligatoires présentes
   - Au moins 1 proven-in-use documenté
   - Versions FR et EN présentes

2. ✅ **Assigner les reviewers**
   - **Bank-Wide** → `@KiyaliHQ/comite-architectes-experts`
   - **Domain-Wide Particuliers** → `@KiyaliHQ/comite-gov-particuliers`
   - **Domain-Wide Entreprises** → `@KiyaliHQ/comite-gov-entreprises`
   - **Domain-Wide Patrimoine** → `@KiyaliHQ/comite-gov-patrimoine`

3. ✅ **Poster un commentaire de statut**
   - Checklist de validation
   - Prochaines étapes
   - Timeline (2-4 semaines pour Bank-Wide, 5-10 jours pour Domain-Wide)

**⚠️ Protection du Framework** : Vous ne pouvez modifier que les fichiers dans `content/`. Toute modification en dehors de ce dossier (`site/`, `.github/`, `docs/`, etc.) sera automatiquement bloquée.

## Processus de Review

Le processus de review suit ces étapes :

### 1. Validation Automatique (Immédiate)

GitHub Actions vérifie automatiquement :
- Format et métadonnées
- Sections obligatoires
- Requirement proven-in-use (1+ pour Candidate)
- Exigence bilingue (FR + EN)

### 2. Review par Comité de Gouvernance

**Pour PRAs Domain-Wide** (Particuliers, Entreprises, Gestion de Patrimoine) :
- 📅 **Rencontre du comité domaine** : Vous serez invité à présenter votre PRA
- 🎤 **Présentation** : Expliquez le contexte, l'architecture, les bénéfices
- 💬 **Discussion** : Le comité pose des questions et fournit du feedback
- ✅ **Validation** : Le comité valide ou demande des changements
- 👥 **Approbations GitHub** : 2 approbations requises de `@KiyaliHQ/comite-gov-{domaine}`
- ⏱️ **Timeline** : 5-10 jours ouvrés

**Pour PRAs Bank-Wide** (Transversal) :
- 📅 **Rencontre du comité expert** : Vous serez invité à présenter votre PRA
- 🎤 **Présentation** : Expliquez le contexte, l'architecture, les bénéfices
- 💬 **Discussion** : Le comité pose des questions et valide l'applicabilité multi-domaine
- ✅ **Validation** : Le comité valide ou demande des changements
- 👥 **Approbations GitHub** : 2 approbations requises de `@KiyaliHQ/comite-architectes-experts`
- ⏱️ **Timeline** : 2-4 semaines

### 3. Suivi en Temps Réel

Vous recevrez des notifications automatiques à chaque étape :
- ⏳ **0/2 approvals** : En attente de la rencontre au comité
- ✅ **1/2 approvals** : Première approbation reçue (après la rencontre)
- ✅✅ **2/2 approvals** : PRA approuvé, prêt à merger
- 🔄 **Changes Requested** : Des modifications sont demandées

### 4. Itérations (Si Nécessaire)

Si le comité demande des changements :
1. Vous recevrez un commentaire détaillé avec le feedback
2. Effectuez les modifications sur votre branche
3. Pushez vos changements (`git push`)
4. La validation re-exécute automatiquement
5. Demandez une re-review au comité

### 5. Merge et Publication

Une fois **2/2 approbations** reçues :
- ✅ Votre PR peut être mergée
- 🚀 Votre PRA est publié sur le registre avec le status **Candidate**
- 📊 Il apparaît dans le catalogue et la documentation

## Critères de Qualité

Votre PRA sera évalué sur :

-  **Proven-in-use** : Au moins 1 implémentation documentée
-  **Réutilisabilité** : Généralisable à d'autres contextes
-  **Clarté** : Documentation claire et complète
-  **ADR** : Décisions architecturales justifiées
-  **Exemples** : Code et configurations concrètes

## Passage de Candidate à Approved

Les exigences diffèrent selon le scope :

### PRA Domaine : Candidate → Approved

Pour qu'un PRA Domaine Candidate devienne **Domaine Approved**, il doit :

-  Avoir **1+ implémentation prouvée dans le domaine** (déjà satisfait pour Candidate)
-  Retours positifs des équipes du domaine (satisfaction > 7/10)
-  Documentation enrichie avec learnings spécifiques au domaine
-  Réutilisabilité confirmée au sein du domaine
-  Review et approbation par le **Comité de Gouvernance du Domaine**

### PRA Bank-Wide : Candidate → Approved

Pour qu'un PRA Bank-Wide Candidate devienne **Bank-Wide Approved**, il doit :

-  Avoir **3+ implémentations prouvées de différents domaines/équipes**
-  Retours positifs multi-domaine (satisfaction > 7/10)
-  Documentation enrichie avec learnings multi-contextes
-  Applicabilité multi-domaine validée
-  Review et approbation par le **Comité de Gouvernance Architectes Experts**

## Questions ?

Consultez :

- [Gouvernance](/guides/08-governance)
- [Cycle de Vie](/guides/04-lifecycle)
- [Standards](/guides/05-standards)

---

**Parcours recommandé** :
1. [Démarrer avec les PRA](/guides/01-getting-started)
2. [Comprendre les PRA](/guides/02-understanding-pra)
3. [Rôles et Responsabilités](/guides/03-roles-responsibilities)
4. [Cycle de Vie](/guides/04-lifecycle)
5. [Standards de Qualité](/guides/05-standards)
6.  **Contribuer un PRA** (vous êtes ici)
7. [Processus de Promotion](/guides/07-promotion-process)
8. [Gouvernance](/guides/08-governance)

---

**Navigation** :
-  **Précédent** : [Standards de Qualité](/guides/05-standards)
-  **Suivant** : [Processus de Promotion](/guides/07-promotion-process)

Ou ouvrez une issue sur GitHub.
