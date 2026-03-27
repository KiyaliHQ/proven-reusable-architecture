# Taxonomie des Archétypes PRA — Définitions et Exemples

**Version** : 1.0 — Brouillon pour validation  
**Date** : 27 mars 2026  
**Auteur** : Amara Fofana  
**Contexte** : Suite à la rencontre du 26 mars 2026 avec Charles Allahwirdian, ce document formalise les définitions des archétypes du registre PRA et fournit des exemples concrets pour chaque catégorie.

---

## 1. Principe de classification

### Question fondamentale

Pour classifier un PRA, posez-vous une seule question :

> **"Quel est le problème principal que ce pattern résout ?"**

Ce n'est pas la technologie qui détermine l'archétype, c'est la **capacité fonctionnelle**. Un même outil peut apparaître dans différents archétypes selon le problème qu'il adresse.

### Règles de classification

1. **Le PRA décrit une capacité fonctionnelle**, pas une plateforme ou un produit.
   - ✅ "File Transfer inter-domaine" (capacité)
   - ❌ "Azure MFT" (produit — c'est un détail d'implémentation à l'intérieur du PRA)

2. **L'archétype est la dimension principale**, les tags apportent la granularité fine.
   - Archétype = classification grossière (6 catégories)
   - Tags = classification fine (illimité, libre)

3. **En cas d'ambiguïté**, le problème principal tranche.
   - MFT : transférer des fichiers entre systèmes → **Integration** (pas Platform Engineering, même si c'est un outil technique)
   - Landing Zone : provisionner un environnement cloud → pas un PRA (one-shot infra, pas réutilisé par les architectes)

4. **Un PRA = un archétype**. Si un pattern couvre plusieurs domaines, choisir celui qui décrit le mieux le problème résolu. Les autres dimensions sont capturées par les tags.

---

## 2. Un PRA = une recette complète, pas un pattern abstrait

### Le PRA va au-delà du pattern

Un PRA n'est pas juste un diagramme d'architecture ou un concept théorique. C'est une **recette complète d'implémentation** validée à la banque. Il répond à la question :

> **"Si je dois résoudre ce problème à la Banque Nationale, comment je fais de A à Z ?"**

Concrètement, un PRA contient :
- Le **pattern architectural** (le "quoi")
- La **recette d'implémentation** suggérée à la banque (le "comment")
- Les **décisions architecturales** qui ont mené à ce choix (le "pourquoi")
- Les **retours d'expérience** de ceux qui l'ont utilisé (le "ça marche ?")

### Le contenu est transversal par nature

Un PRA classé dans l'archétype **Application** (ex : "SPA React") va nécessairement couvrir dans sa recette :
- Comment **déployer** l'application (aspects Platform Engineering)
- Sur quelle **infrastructure** (aspects Platform Engineering)
- Comment la **sécuriser** (aspects Security)
- Comment les **APIs communiquent** (aspects Integration)

**C'est normal et voulu.** L'architecte qui cherche "comment construire une SPA à la banque" trouve dans un seul PRA tout ce dont il a besoin — il n'a pas à assembler 4 PRAs de 4 archétypes différents.

### L'archétype = la porte d'entrée

La distinction est :

| Concept | Rôle | Exemple |
|---------|------|---------|
| **Archétype** | Point d'entrée de recherche — "quel problème je résous" | Application |
| **Contenu du PRA** | Recette complète de bout en bout — incluant tous les aspects cross-cutting | Pattern SPA + déploiement K8s + auth OIDC + CI/CD GitOps |

L'archétype aide l'architecte à **trouver** le PRA. Le contenu du PRA lui donne **tout ce qu'il faut** pour l'implémenter à la banque.

### Principe directeur

> **Un PRA = un problème résolu de bout en bout. L'archétype est la porte d'entrée, pas une frontière artificielle qui sépare les aspects techniques.**

---

## 3. Convention de nommage des PRAs

### Le nom décrit le problème, pas la solution

Le nom d'un PRA est la première chose que l'architecte voit dans le catalogue. Il doit répondre immédiatement à la question : **"Est-ce que ce PRA est pertinent pour mon besoin ?"**

### Règles de nommage

1. **Le nom exprime le problème ou la capacité**, pas la technologie ou le produit.
   - ✅ "Transfert de fichiers sécurisé inter-domaine"
   - ❌ "Azure MFT"
   - ✅ "Authentification centralisée employés"
   - ❌ "SSO SAML avec Azure AD"
   - ✅ "Application web monopage (SPA)"
   - ❌ "React avec Vite"

2. **Le nom doit être compréhensible par un architecte qui ne connaît pas le pattern.**
   - ✅ "Traitement intelligent de documents"
   - ❌ "IDP Pipeline"
   - ✅ "Communication asynchrone par événements"
   - ❌ "Kafka Event Sourcing"

3. **Le nom peut inclure le contexte d'application si ça apporte de la clarté.**
   - ✅ "Onboarding client digital — Parcours compte bancaire"
   - ✅ "API Gateway — Point d'entrée microservices"
   - ✅ "Landing Zone — Fondation cloud Azure"

4. **La technologie spécifique va dans les tags et la sous-catégorie**, pas dans le nom.
   - Nom : "Transfert de fichiers sécurisé inter-domaine"
   - Sous-catégorie : `mft`
   - Tags : `mft, sftp, azure, file-transfer, inter-domain`

### Format suggéré

```
[Capacité / Problème résolu] — [Contexte optionnel]
```

### Exemples de bons noms par archétype

| Archétype | ❌ Mauvais nom | ✅ Bon nom |
|-----------|--------------|-----------|
| Integration | "MFT Azure" | "Transfert de fichiers sécurisé inter-domaine" |
| Integration | "Kong API Gateway" | "Point d'entrée centralisé pour APIs microservices" |
| Application | "React SPA" | "Application web monopage (SPA)" |
| Application | "Node.js BFF" | "Backend dédié par type de client (BFF)" |
| Data | "Snowflake Lakehouse" | "Architecture Data Lake multi-couches" |
| Security | "Azure AD SSO" | "Authentification centralisée employés (SSO)" |
| Security | "MFA Duo" | "Authentification multi-facteurs" |
| Platform Engineering | "Azure Landing Zone" | "Fondation cloud — Zone d'atterrissage Azure" |
| Platform Engineering | "K8s AKS" | "Orchestration de conteneurs (Kubernetes)" |
| Platform Engineering | "ArgoCD GitOps" | "Déploiement déclaratif via GitOps" |
| Platform Engineering | "Terraform Modules" | "Infrastructure as Code — Modules réutilisables" |
| Business | "KYC API" | "Vérification d'identité client (KYC)" |
| Business | "Notification Service" | "Service centralisé de notifications multi-canal" |

### La technologie n'est pas interdite dans le nom

Si la technologie **est** le sujet principal et qu'il n'existe pas d'alternative, elle peut apparaître :
- ✅ "Landing Zone Azure" — parce que le PRA est spécifique à Azure
- ✅ "Orchestration Kubernetes" — parce que Kubernetes est la plateforme standard

La règle c'est : **si on changeait la technologie, est-ce que le nom devrait changer ?** Si oui, la techno est légitime dans le nom. Si non, elle n'a rien à y faire.

---

## 4. Les 6 Archétypes — Définitions et Exemples

### 4.1 Integration

**Définition** : Patterns pour faire **communiquer des systèmes entre eux** — échange de données, protocoles de communication, flux inter-systèmes, orchestration des interactions.

**Question clé** : "Comment deux systèmes (ou plus) échangent-ils des données ou des événements ?"

| # | Exemple | Description |
|---|---------|-------------|
| 1 | **MFT / File Transfer** | Transfert sécurisé de fichiers entre systèmes, incluant les patterns de retry, validation et accusé de réception |
| 2 | **API Gateway** | Point d'entrée centralisé pour les APIs, gestion du routage, rate-limiting, authentification |
| 3 | **Event-Driven Messaging** | Communication asynchrone par événements (Kafka, RabbitMQ), patterns pub/sub, event sourcing |
| 4 | **API Documentation / Management** | Standardisation de l'exposition d'APIs, contrats OpenAPI, versioning, catalogue d'APIs |
| 5 | **ETL / Data Pipeline** | Extraction, transformation et chargement de données entre systèmes sources et cibles |

**Ce qui n'est PAS Integration** :
- Un pattern de design applicatif (→ Application)
- Un outil de plateforme qui ne fait pas de l'échange de données (→ Platform Engineering)

**Nuance inter-domaine / intra-domaine** :
- Un PRA Integration peut être **inter-domaine** (ex : MFT entre Particuliers et Entreprises — standard obligatoire)
- Ou **intra-domaine** (ex : messaging entre microservices dans le même domaine — plus de latitude)

---

### 4.2 Application

**Définition** : Patterns de **conception et structure applicative** — comment architecturer, construire et organiser une application ou ses composants.

**Question clé** : "Comment cette application est-elle structurée ou conçue ?"

| # | Exemple | Description |
|---|---------|-------------|
| 1 | **Single Page Application (SPA)** | Architecture frontend avec rendu côté client, routing SPA, state management |
| 2 | **Micro-frontends** | Décomposition du frontend en modules indépendants déployables séparément |
| 3 | **Backend for Frontend (BFF)** | Couche backend dédiée à un type de client (mobile, web), agrégation de services |
| 4 | **CQRS** | Séparation des modèles de lecture et d'écriture pour optimiser les performances et la scalabilité |
| 5 | **Domain-Driven Design (DDD)** | Structuration du code autour des domaines métier, bounded contexts, ubiquitous language |

**Ce qui n'est PAS Application** :
- Comment faire communiquer deux applications (→ Integration)
- Comment déployer une application (→ Platform Engineering)
- Un processus métier implémenté dans une application (→ Business)

---

### 4.3 Data

**Définition** : Patterns de **gestion, stockage, transformation, qualité et gouvernance de la donnée** — comment organiser et exploiter les données à l'échelle de l'entreprise.

**Question clé** : "Comment la donnée est-elle stockée, transformée, gouvernée ou rendue accessible ?"

| # | Exemple | Description |
|---|---------|-------------|
| 1 | **Data Mesh** | Architecture de données décentralisée, ownership par domaine, data products |
| 2 | **Data Lake / Lakehouse** | Stockage centralisé de données brutes et transformées, architecture multi-couches (bronze/silver/gold) |
| 3 | **Master Data Management (MDM)** | Gestion des données de référence, golden record, réconciliation inter-systèmes |
| 4 | **Data Lineage & Catalog** | Traçabilité de la donnée de la source à la consommation, catalogage, métadonnées |
| 5 | **Real-time Analytics** | Patterns d'analyse en temps réel, streaming analytics, tableaux de bord live |

**Ce qui n'est PAS Data** :
- Déplacer des fichiers entre systèmes (→ Integration, même si les fichiers contiennent des données)
- Un pipeline CI/CD pour déployer un data pipeline (→ Platform Engineering)

---

### 4.4 Security

**Définition** : Patterns d'**authentification, autorisation, protection des données, conformité et sécurité** — comment sécuriser les systèmes, les accès et les données.

**Question clé** : "Comment les utilisateurs, les données ou les systèmes sont-ils protégés ?"

| # | Exemple | Description |
|---|---------|-------------|
| 1 | **SSO / Single Sign-On** | Authentification centralisée, fédération d'identités, SAML/OIDC côté employé et client |
| 2 | **MFA (Multi-Factor Authentication)** | Renforcement de l'authentification par facteurs multiples, patterns d'intégration MFA |
| 3 | **Zero Trust Network** | Architecture réseau sans confiance implicite, micro-segmentation, vérification continue |
| 4 | **Data Encryption at Rest & in Transit** | Patterns de chiffrement des données, gestion des clés, rotation, HSM |
| 5 | **Identity Provider (IDP)** | Gestion centralisée des identités, provisioning, cycle de vie des comptes |

**Ce qui n'est PAS Security** :
- DevOps security / DevSecOps (→ DevOps, car le problème principal est l'automatisation de la sécurité dans le pipeline)
- Transfert sécurisé de fichiers (→ Integration, la sécurité est une propriété du transfert, pas le problème principal)

---

### 4.5 Platform Engineering

**Définition** : Patterns de **déploiement, hébergement, CI/CD, observabilité, automation et opérations** — comment construire, déployer, héberger, monitorer et opérer les solutions de façon automatisée et standardisée à la banque.

**Question clé** : "Comment ma solution est-elle déployée, hébergée et opérée ?"

| # | Exemple | Description |
|---|---------|-------------|
| 1 | **Hébergement de contenu statique** | Pattern S3/CloudFront (ou Azure Blob/CDN), configuration, sécurité, cache, invalidation |
| 2 | **GitOps Pipeline** | Déploiement déclaratif via Git, ArgoCD/Flux, réconciliation automatique, promotion entre environnements |
| 3 | **Infrastructure as Code (IaC)** | Provisioning automatisé avec Terraform/Pulumi, modules réutilisables, gestion de state, conventions BNC |
| 4 | **Observability Stack** | Architecture de monitoring (logs, metrics, traces), OpenTelemetry, alerting, dashboards, SLOs |
| 5 | **Container Deployment Patterns** | Comment déployer sur Kubernetes à la banque, namespace strategy, resource management, health checks |
| 6 | **DevSecOps** | Intégration de la sécurité dans le pipeline CI/CD, SAST/DAST, scanning de vulnérabilités, quality gates |
| 7 | **Feature Flags & Progressive Delivery** | Déploiement progressif, canary releases, blue-green, feature toggles, rollback automatique |
| 8 | **Cloud Migration** | Patterns de migration (lift & shift, re-platform, re-architect), stratégie et exécution |

**Ce qui n'est PAS Platform Engineering** :
- Comment une application est **conçue** (→ Application) — Platform Engineering c'est comment elle est déployée et opérée
- Comment les systèmes **communiquent** (→ Integration)
- La sécurité des **accès et identités** (→ Security) — sauf DevSecOps qui automatise la sécurité dans le pipeline
- Le setup initial d'une Landing Zone — c'est un one-shot infra fait par l'équipe cloud, pas un pattern réutilisé par les architectes au quotidien
- La gouvernance d'une plateforme (ex : "doit-on autoriser Power Platform") — c'est une politique d'entreprise, pas un pattern réutilisable

**Pourquoi "Platform Engineering" plutôt que "Technology" + "DevOps" séparés ?**

Les anciens archétypes Technology et DevOps créaient une ambiguïté : Terraform c'est DevOps ou Technology ? Un hébergement S3 c'est de l'infra ou du déploiement ? Dans la réalité, c'est la même discipline. Les équipes Platform Engineering provisionnent l'infra ET automatisent les déploiements — c'est un continuum, pas deux silos.

Le test qui a tranché : les patterns qui vivaient dans "Technology" (Landing Zone, Container Orchestration, Power Platform) étaient soit des one-shots non réutilisables, soit appartenaient naturellement à d'autres archétypes (Application, Integration). Ce qui restait se fusionnait naturellement avec DevOps.

---

### 4.6 Business

**Définition** : Patterns de **réutilisation de capacités d'affaires, workflows métier et logique domaine** — comment structurer et partager des processus métier réutilisables, incluant la recette technique complète pour les implémenter à la banque.

**Question clé** : "Quel processus métier ou quelle capacité d'affaires ce pattern standardise-t-il ?"

| # | Exemple | Description |
|---|---------|-------------|
| 1 | **Onboarding Client** | Processus standardisé d'ouverture de compte, parcours digital, vérification d'identité |
| 2 | **KYC (Know Your Customer)** | Processus de vérification d'identité client, conformité réglementaire, scoring risque |
| 3 | **Payment Processing** | Patterns de traitement de paiements, réconciliation, gestion des erreurs, idempotence |
| 4 | **Notification Service** | Service centralisé de notifications multi-canal (email, SMS, push), templates, préférences |
| 5 | **Document Generation** | Génération automatisée de documents (relevés, contrats, lettres), templates, multi-format |

**Un PRA Business inclut les aspects techniques.** Comme tout PRA, c'est une recette complète de bout en bout. Un PRA "Onboarding Client Digital" va inclure l'architecture applicative, les intégrations, la sécurité et le déploiement — parce que c'est la recette complète pour implémenter ce processus métier à la banque.

**Ce qui n'est PAS Business** :
- Un **pattern technique générique** réutilisable indépendamment du processus métier. Si le pattern est le même peu importe le contexte métier, il appartient à un autre archétype :
  - Le pattern SPA est le même qu'on fasse de l'onboarding ou un portail partenaire → **Application**
  - Le pattern API Gateway est le même pour tout processus → **Integration**
  - Le pipeline CI/CD est le même peu importe le métier → **Platform Engineering**

**La distinction : le niveau de réutilisabilité**

| | Business PRA | Autres archétypes |
|---|---|---|
| **Réutilisable quand...** | Tu as le **même besoin métier** | Tu as le **même problème technique** |
| **Exemple** | "Onboarding Client" → réutilisable par tout domaine qui fait de l'onboarding | "SPA React" → réutilisable par tout projet qui construit une SPA |
| **Contient des aspects techniques ?** | Oui, la recette complète | Oui, mais découplé du contexte métier |

---

## 5. Dimension inter-domaine vs intra-domaine

Cette dimension est **orthogonale aux archétypes** — un PRA de n'importe quel archétype peut être inter-domaine ou intra-domaine.

### Définitions

| Dimension | Définition | Implication |
|-----------|-----------|-------------|
| **Inter-domaine** | Le pattern s'applique à la communication ou réutilisation **entre** domaines d'affaires (Particuliers ↔ Entreprises ↔ Gestion de Patrimoine) | Standard **obligatoire** — uniformité requise pour la cohérence |
| **Intra-domaine** | Le pattern s'applique **à l'intérieur** d'un domaine ou sous-domaine | Plus de **latitude** — le domaine peut adapter ou choisir des alternatives |
| **Les deux** | Le pattern a des standards obligatoires inter-domaine mais laisse de la flexibilité intra-domaine | Les deux niveaux sont documentés dans le même PRA |

### Exemple concret : File Transfer

```
PRA : File Transfer
Archétype : Integration
Communication : Les deux (inter + intra)

Inter-domaine (obligatoire) :
  → Utiliser MFT (Managed File Transfer)
  → Protocole : SFTP via la plateforme MFT centralisée
  → Chiffrement : TLS 1.3 minimum
  → Monitoring : Dashboard centralisé

Intra-domaine (recommandé, flexible) :
  → MFT recommandé mais S3-to-S3 accepté si justifié
  → Le domaine peut utiliser d'autres mécanismes internes
  → Documenter la justification si déviation du standard
```

### Métadonnée proposée

```
:pra-communication: inter-domain | intra-domain | both
```

---

## 6. Matrice de décision — "Ça va où ?"

Pour les cas ambigus, utilisez cette matrice :

| Si le pattern... | Alors l'archétype est... |
|---|---|
| ...fait communiquer 2+ systèmes (API, fichiers, événements) | **Integration** |
| ...structure la façon dont une application est construite | **Application** |
| ...gère le stockage, la transformation ou la gouvernance de données | **Data** |
| ...protège des accès, des identités ou des données | **Security** |
| ...déploie, héberge ou opère une solution de façon automatisée | **Platform Engineering** |
| ...standardise un processus ou une capacité métier | **Business** |

### Cas ambigus courants

| Pattern | Hésitation | Résolution |
|---------|-----------|------------|
| **MFT / File Transfer** | Integration vs Platform Engineering | **Integration** — le problème est "transférer des fichiers entre systèmes", MFT est l'implémentation |
| **DevSecOps** | Security vs Platform Engineering | **Platform Engineering** — le problème est "automatiser la sécurité dans le pipeline", pas "sécuriser un système" |
| **API Documentation** | Integration vs Application | **Integration** — le problème est "standardiser comment les systèmes exposent et consomment des APIs" |
| **Hébergement S3/CloudFront** | Application vs Platform Engineering | **Platform Engineering** — le problème est "comment héberger du contenu statique", pas "comment construire une app" |
| **SSO** | Security vs Integration | **Security** — le problème est "authentifier de façon centralisée", même si ça implique une intégration |
| **Data Pipeline (ETL)** | Data vs Integration | Dépend : si le focus est sur la **transformation/qualité** des données → **Data**. Si le focus est sur le **déplacement** entre systèmes → **Integration** |
| **IaC / Terraform** | Platform Engineering (infra) vs Platform Engineering (DevOps) | **Platform Engineering** — plus d'ambiguïté, c'est le même archétype |
| **Onboarding Client** | Business vs Application | **Business** — le problème est un processus métier, pas une architecture technique |
| **Power Apps** | Platform Engineering vs Application | **Application** — le problème est "comment construire une app low-code", pas "comment opérer une plateforme" |

---

## 7. Exemples concrets de PRAs par archétype avec tags

Pour illustrer comment la classification fonctionne en pratique :

### Integration
```
PRA: File Transfer Inter-Domaine
:pra-archetype: integration
:pra-tags: mft, sftp, file-transfer, inter-domain
:pra-communication: inter-domain
```

### Application
```
PRA: Single Page Application (SPA) React
:pra-archetype: application
:pra-tags: spa, react, frontend, state-management
:pra-communication: intra-domain
```

### Data
```
PRA: Data Lake Architecture
:pra-archetype: data
:pra-tags: data-lake, lakehouse, bronze-silver-gold, snowflake
:pra-communication: both
```

### Security
```
PRA: Single Sign-On Employés
:pra-archetype: security
:pra-tags: sso, saml, oidc, identity-federation
:pra-communication: inter-domain
```

### Platform Engineering
```
PRA: Hébergement de contenu statique (S3/CloudFront)
:pra-archetype: platform-engineering
:pra-tags: s3, cloudfront, cdn, static-hosting, aws
:pra-communication: both
```

```
PRA: Déploiement déclaratif via GitOps
:pra-archetype: platform-engineering
:pra-tags: gitops, argocd, kubernetes, ci-cd
:pra-communication: both
```

### Business
```
PRA: Onboarding Client Digital
:pra-archetype: business
:pra-tags: onboarding, kyc, parcours-client, digital
:pra-communication: intra-domain
```

---

## 8. Évolution future

### Archétype AI ?

La question d'ajouter **AI** comme 7e archétype a été soulevée. Deux options :

**Option A — AI comme archétype** : si la banque développe suffisamment de patterns AI distincts (RAG, fine-tuning, ML pipeline, LLM integration, AI governance), ça justifie un archétype dédié.

**Option B — AI comme tag** : pour l'instant, les patterns AI peuvent être classés dans les archétypes existants avec un tag `ai` :
- RAG pipeline → **Data** (tag: ai, rag)
- LLM API integration → **Integration** (tag: ai, llm)
- ML model deployment → **Platform Engineering** (tag: ai, mlops)

**Recommandation** : commencer avec AI comme tag. Si le volume de PRAs AI dépasse 5-10 patterns, promouvoir en archétype.

### Ajout de sous-catégories

Le champ `:pra-subcategory:` existant dans les métadonnées permet déjà une classification plus fine sans modifier la taxonomie des archétypes. Exemple :

```
:pra-archetype: integration
:pra-subcategory: file-transfer    ← sous-catégorie spécifique
:pra-tags: mft, sftp, inter-domain ← tags fins
```

---

## 9. Prochaines étapes

1. **Valider** ce document avec Charles et les parties prenantes
2. **Intégrer** les définitions dans `pra-registry.config.yml`
3. **Mettre à jour** les guides (contributing, understanding-pra) avec les définitions
4. **Créer** les exemples concrets de PRAs pour chaque archétype
5. **Décider** sur l'ajout de `:pra-communication:` dans les métadonnées

---

*Ce document est un brouillon pour validation. Les définitions et exemples seront affinés avec les retours des architectes.*
