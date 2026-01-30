---
title: Test API Gateway Pattern
description: Pattern de test pour valider le workflow approve-pra-candidate
pra:
  name: API Gateway Test Pattern
  category: technology
  status: candidate
  tags: [api, gateway, microservices, test]
  created_at: "2025-12-03"
  updated_at: "2025-12-03"
  proven_in_use:
    - project: Mobile Banking App
      team: Retail Digital Team
      date: "2025-11-15"
      feedback: Successfully implemented API gateway for microservices aggregation. Reduced client-side complexity by 60%.
---

## API Gateway Test Pattern

## Overview

Ce PRA décrit un pattern d'API Gateway pour gérer l'agrégation de microservices dans les applications du domaine Particuliers.

**Problème résolu** : Complexité excessive côté client lors de l'interaction avec plusieurs microservices.

**Solution** : Implémenter une API Gateway centralisée qui agrège les appels vers les microservices backend.

## Context

**Problématique** :

Dans l'architecture microservices du domaine Particuliers, les applications clientes (mobile, web) doivent interagir avec de nombreux microservices indépendants. Cela crée plusieurs défis :
- Multiplicité des appels réseau
- Gestion complexe de l'authentification
- Couplage fort entre client et services
- Difficulté de versioning des APIs

**Solution** :

Un API Gateway agit comme point d'entrée unique pour toutes les requêtes clientes. Il offre :
- Agrégation de données provenant de multiples services
- Authentification et autorisation centralisées
- Transformation et adaptation des réponses
- Gestion du rate limiting et du caching

## Architecture

### Architecture Globale

```
┌─────────────┐
│   Client    │
│  (Mobile)   │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────┐
│      API Gateway            │
│  - Authentification         │
│  - Agrégation              │
│  - Rate Limiting           │
│  - Caching                 │
└──────┬──────────────────────┘
       │
       ├──────────┬──────────┬──────────┐
       ▼          ▼          ▼          ▼
   ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
   │Account │ │Payment │ │Profile │ │Notify  │
   │Service │ │Service │ │Service │ │Service │
   └────────┘ └────────┘ └────────┘ └────────┘
```

### Composants Clés

1. **Gateway Layer** : Point d'entrée unique
2. **Aggregation Layer** : Composition de réponses
3. **Backend Services** : Microservices métier

### Technologies

- **Gateway** : Kong, AWS API Gateway, ou custom (Node.js/Express)
- **Auth** : OAuth 2.0 / JWT
- **Cache** : Redis
- **Monitoring** : Prometheus + Grafana

## ADR

### ADR-001: Choix de Kong comme API Gateway

**Contexte** : Besoin d'un API Gateway robuste et scalable pour le domaine Particuliers.

**Décision** : Utiliser Kong comme plateforme d'API Gateway.

**Raisons** :
- Open source avec support entreprise
- Riche écosystème de plugins
- Performance élevée (basé sur Nginx)
- Support natif de Kubernetes
- Communauté active

**Alternatives considérées** :
- AWS API Gateway : Vendor lock-in
- Custom solution : Coût de maintenance élevé
- Apigee : Coût de licence prohibitif

**Conséquences** :
- ✅ Solution éprouvée et scalable
- ✅ Extensibilité via plugins
- ⚠️  Courbe d'apprentissage initiale
- ⚠️  Nécessite infrastructure dédiée

### ADR-002: Agrégation côté gateway vs côté client

**Contexte** : Décider où effectuer l'agrégation de données provenant de multiples services.

**Décision** : Effectuer l'agrégation côté gateway (Backend for Frontend pattern).

**Raisons** :
- Réduit le nombre d'appels réseau depuis le client
- Simplifie le code client
- Permet l'optimisation des requêtes backend
- Facilite le caching

**Conséquences** :
- ✅ Meilleure performance perçue côté client
- ✅ Logique métier centralisée
- ⚠️  Gateway devient point critique
- ⚠️  Nécessite gestion de la charge

## Examples

### Exemple 1: Endpoint d'agrégation de profil utilisateur

```javascript
// API Gateway - Aggregation endpoint
app.get('/api/v1/user/:userId/dashboard', async (req, res) => {
  const userId = req.params.userId;

  // Appels parallèles aux microservices
  const [profile, accounts, transactions] = await Promise.all([
    profileService.getProfile(userId),
    accountService.getAccounts(userId),
    transactionService.getRecentTransactions(userId, 10)
  ]);

  // Agrégation de la réponse
  const dashboard = {
    user: {
      name: profile.name,
      email: profile.email,
    },
    accounts: accounts.map(acc => ({
      id: acc.id,
      type: acc.type,
      balance: acc.balance,
    })),
    recentTransactions: transactions.map(tx => ({
      id: tx.id,
      amount: tx.amount,
      date: tx.date,
      description: tx.description,
    })),
  };

  res.json(dashboard);
});
```

### Exemple 2: Configuration Kong (YAML)

```yaml
_format_version: "2.1"

services:
  - name: profile-service
    url: http://profile-service:8080
    routes:
      - name: profile-route
        paths:
          - /api/v1/profile

  - name: account-service
    url: http://account-service:8080
    routes:
      - name: account-route
        paths:
          - /api/v1/accounts

plugins:
  - name: jwt
    config:
      key_claim_name: kid
      secret_is_base64: false

  - name: rate-limiting
    config:
      minute: 100
      policy: local

  - name: cors
    config:
      origins:
        - https://mobile.bnc.ca
      methods:
        - GET
        - POST
        - PUT
        - DELETE
      credentials: true
```

### Exemple 3: Client-side usage (React Native)

```typescript
// Client simplifié grâce à l'API Gateway
const DashboardScreen = () => {
  const [dashboard, setDashboard] = useState(null);
  const { userId } = useAuth();

  useEffect(() => {
    // Un seul appel au lieu de 3+
    fetch(`https://api.bnc.ca/api/v1/user/${userId}/dashboard`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
      .then(res => res.json())
      .then(data => setDashboard(data));
  }, [userId]);

  return (
    <View>
      <ProfileHeader user={dashboard?.user} />
      <AccountList accounts={dashboard?.accounts} />
      <TransactionList transactions={dashboard?.recentTransactions} />
    </View>
  );
};
```

## Proven-in-use

### Mobile Banking App (Retail Digital Team - 2025-11-15)

**Contexte** : Refonte de l'application mobile banque pour les clients Particuliers.

**Implémentation** :
- API Gateway avec Kong sur Kubernetes
- Agrégation de 8 microservices backend
- Support de 500K+ utilisateurs actifs
- Déploiement sur AWS EKS

**Résultats** :
- ✅ **Réduction de 60% de la complexité côté client**
- ✅ **Performance** : Temps de chargement du dashboard réduit de 2.5s à 0.8s
- ✅ **Fiabilité** : Disponibilité de 99.95%
- ✅ **Scalabilité** : Support de 10K requêtes/seconde en période de pointe

**Feedback** : "L'API Gateway a considérablement simplifié notre architecture mobile. L'équipe frontend peut maintenant se concentrer sur l'UX plutôt que sur l'orchestration de microservices."

**Métriques** :
- Nombre d'appels API par page réduit : 12 → 3
- Taille des payloads optimisée : -40%
- Time to First Byte (TTFB) : 250ms en moyenne
- Taux d'erreur : < 0.1%

**Learnings** :
- Importance du monitoring granulaire de la gateway
- Nécessité de caching agressif pour les données peu volatiles
- Circuit breaker essentiel pour la résilience
- Documentation OpenAPI facilitant l'adoption par les équipes
