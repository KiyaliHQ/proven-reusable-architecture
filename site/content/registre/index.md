---
title: Registre PRA - Banque Nationale
description: Bibliothèque d'architectures éprouvées pour accélérer vos projets avec qualité et cohérence
---

# Bienvenue dans le Registre PRA 

## Ne réinventez pas la roue, réutilisez ce qui fonctionne

Vous démarrez un nouveau projet ? Vous cherchez la meilleure façon d'implémenter l'authentification, le CI/CD, ou l'intégration avec Salesforce ? **Le Registre PRA est votre bibliothèque d'architectures validées en production.**

##  C'est quoi un PRA ?

Un **PRA (Proven Reusable Architecture)** est une **solution éprouvée** qui a déjà fait ses preuves dans de vrais projets de la Banque Nationale.

```mermaid
graph LR
    A[Problème récurrent] --> B[Solution documentée]
    B --> C[Validée en prod]
    C --> D[Réutilisable]
    D --> E[PRA]
```

### En 4 points clés

 **Prouvée en production** : Validée dans au moins 3 implémentations réelles chez BNC
 **Réutilisable** : Généralisable à différents contextes et projets
 **Documentée** : Avec contexte, décisions architecturales (ADR), exemples de code et retours d'expérience
 **Maintenue** : Versionnée et supportée par la communauté architecture BNC

### Analogie simple

Pensez aux PRA comme des **recettes de cuisine éprouvées** :

- La recette (le PRA) a été testée plusieurs fois 
- Elle fonctionne dans différentes cuisines (contextes) 
- Elle documente les ingrédients (stack tech), les étapes (implémentation) et les pièges à éviter 
- Vous pouvez l'adapter à vos goûts (votre contexte) 

##  Démarrage rapide

### Vous êtes développeur ?

**Besoin : "Je dois implémenter de l'authentification"**

1.  Allez dans [Transversal > Security](/registre/transversal)
2.  Trouvez le PRA "Authentication & SSO"
3.  Vérifiez si votre contexte correspond
4.  Suivez le guide d'implémentation
5.  Documentez votre retour d'expérience

### Vous êtes architecte ?

**Besoin : "Je veux contribuer une architecture validée"**

1.  Consultez les [Standards de Qualité](/registre/05-standards)
2.  Préparez votre documentation (ADR, exemples, proven-in-use)
3.  Suivez le [Guide de Contribution](/registre/06-contributing)
4.  Soumettez votre PRA à la Table de Gouvernance

### Vous découvrez les PRA ?

**Besoin : "Je veux comprendre le système PRA"**

Suivez notre **parcours guidé en 8 étapes** :

1. [Démarrer avec les PRA](/registre/01-getting-started) - Introduction et premiers pas
2. [Comprendre les PRA](/registre/02-understanding-pra) - Anatomie détaillée
3. [Rôles et Responsabilités](/registre/03-roles-responsibilities) - Qui fait quoi
4. [Cycle de Vie](/registre/04-lifecycle) - De Candidate à Approved
5. [Standards de Qualité](/registre/05-standards) - Critères d'excellence
6. [Contribuer un PRA](/registre/06-contributing) - Processus de soumission
7. [Processus de Promotion](/registre/07-promotion-process) - Sectoriel  Transversal
8. [Gouvernance](/registre/08-governance) - Structure et décisions

##  Organisation du Registre

Le registre est organisé en **3 scopes** selon leur portée :

###  Transversal

**Pour qui ?** Tous les secteurs de la Banque Nationale
**Maturité** : Validés par la Table de Gouvernance Transversale
**Exemples** : Authentication SSO, CI/CD GitOps, API Gateway, RBAC/ABAC

 [Explorer les PRAs Transversaux](/registre/transversal)

###  Secteurs

**Pour qui ?** Équipes d'un secteur spécifique (Particuliers, Entreprises, Gestion de Patrimoine)
**Maturité** : Validés dans leur secteur, en attente de promotion transversale
**Exemples** : Onboarding Digital (Particuliers), Intégration ERP SAP (Entreprises)

 [Explorer les PRAs Sectoriels](/registre/secteurs)

###  En Promotion

**Pour qui ?** Tous (en observation)
**Statut** : Patrons sectoriels proposés pour devenir transversaux
**Utilité** : Voir les patterns émergents avant leur généralisation

 [Explorer les PRAs en Promotion](/registre/en-promotion)

##  Catégories de PRAs

Quel que soit le scope, les PRAs sont organisés en 4 catégories :

###  Tech

Patterns d'infrastructure et plateformes

**Exemples** : CI/CD, Observabilité (Prometheus/Grafana), Infrastructure as Code (Terraform), Orchestration (Kubernetes)

###  Integration

Patterns d'intégration inter-systèmes

**Exemples** : API Gateway, Message Broker (Kafka/RabbitMQ), Event-Driven Architecture, Data Synchronization

###  Security

Patterns de sécurité et conformité

**Exemples** : RBAC/ABAC, Secrets Management (Vault), Network Security (Zero Trust), Audit & Compliance

###  Business

Patterns métier réutilisables

**Exemples** : Customer Onboarding, Payment Processing, Notification System, Workflow Orchestration

##  Pourquoi utiliser les PRAs ?

###  Gain de Temps

- Pas besoin de réinventer la roue
- Solutions prêtes à l'emploi avec exemples de code
- Retours d'expérience documentés = moins d'essais-erreurs

**Exemple concret** : Implémenter un CI/CD GitOps avec ArgoCD prend 2 jours au lieu de 2 semaines de recherche et POC.

###  Qualité

- Solutions validées en production réelle
- Best practices intégrées
- Pièges courants documentés et évités

**Exemple concret** : Le PRA "RBAC avec CASL" inclut les cas limites de gestion des permissions que vous auriez découverts après plusieurs bugs.

###  Cohérence

- Alignement architectural entre équipes
- Vocabulaire commun (moins de malentendus)
- Standards partagés (plus facile à maintenir)

**Exemple concret** : Tous les projets utilisent la même stack d'observabilité  un nouvel architecte peut rapidement comprendre n'importe quel projet.

###  ROI Mesurable

- **Réduction 40-60%** du temps de conception architecture
- **+30%** de réutilisation de code et composants
- **-50%** des incidents de production (grâce aux learnings documentés)

##  Questions Fréquentes

### Dois-je obligatoirement utiliser un PRA ?

**Non.** Les PRAs sont des **recommandations**, pas des obligations.

**Mais** : Si un PRA applicable existe et que vous ne l'utilisez pas, vous devrez justifier pourquoi lors des revues d'architecture (pour éviter la duplication d'efforts).

### Puis-je adapter un PRA à mon contexte ?

**Oui, absolument !** Les PRAs sont des **patrons**, pas du code figé.

**Important** : Documentez vos adaptations et partagez vos learnings pour enrichir le PRA.

### Combien de PRAs y a-t-il actuellement ?

Le registre contient actuellement :
- **~15 PRAs Transversaux** (validés pour tous)
- **~20 PRAs Sectoriels** (spécifiques à un secteur)
- **~5 PRAs en Promotion** (en cours de validation transversale)

### Comment sont validés les PRAs ?

Chaque PRA passe par un processus rigoureux :

1. **Soumission**  Review technique par la Table de Gouvernance
2. **Candidate**  Validé avec 1+ proven-in-use
3. **Approved**  Validé avec 3+ proven-in-use de différentes équipes

[En savoir plus sur le Cycle de Vie](/registre/04-lifecycle)

### Qui décide si un PRA sectoriel devient transversal ?

La **Table de Gouvernance Transversale** (5-7 architectes senior cross-équipes).

[En savoir plus sur la Gouvernance](/registre/08-governance)

##  Prochaines Étapes

### Vous êtes pressé ?

 [Explorez le catalogue Transversal](/registre/transversal) et trouvez un PRA pour votre besoin

### Vous avez 15 minutes ?

 Suivez le [Guide de Démarrage](/registre/01-getting-started) pour une introduction complète

### Vous voulez tout comprendre ?

 Parcourez les [8 guides numérotés](/registre/01-getting-started) dans l'ordre

##  Besoin d'Aide ?

- **Canal Teams** : `#pra-registry`
- **Email** : pra-support@company.com
- **Issues GitHub** : [Ouvrir une issue](https://github.com/org/pra-registry/issues)
- **Table de Gouvernance** : pra-governance@company.com

---

**Dernière mise à jour** : 2025-11-28
**Contributeurs actifs** : 45+ architectes BNC
**PRAs validés** : 40+ patterns éprouvés
