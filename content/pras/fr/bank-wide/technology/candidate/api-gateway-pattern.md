---
title: API Gateway Pattern
description: Passerelle centralisée pour gérer les requêtes API dans une architecture microservices
pra:
  name: API Gateway Pattern
  category: technology
  status: candidate
  tags: [api, gateway, microservices, architecture]
  created_at: "2025-12-03"
  updated_at: "2025-12-03"
  proven_in_use:
    - project: Application Mobile Banking
      team: Équipe Digital Retail
      date: "2025-11-15"
      feedback: "Réduction de 40% de la latence API et simplification de l'authentification pour les clients mobiles"
---

# API Gateway Pattern

## Overview

Le pattern API Gateway fournit un point d'entrée unique pour toutes les requêtes client vers un système distribué de microservices. Il agit comme un reverse proxy qui route les requêtes vers les services appropriés et peut gérer des préoccupations transversales telles que l'authentification, la limitation de débit, et l'agrégation de réponses.

## Context

### Problème

Dans une architecture microservices, les clients doivent interagir avec plusieurs services indépendants. Cela crée plusieurs défis:

- **Complexité côté client**: Les clients doivent connaître et gérer les endpoints de nombreux services
- **Couplage fort**: Les clients sont directement couplés à la structure interne des microservices
- **Préoccupations transversales**: L'authentification, la limitation de débit, et la surveillance doivent être implémentées dans chaque service
- **Protocoles multiples**: Différents services peuvent utiliser des protocoles différents (REST, gRPC, WebSocket)

### Solution

L'API Gateway sert de façade unifiée qui:
- Fournit un point d'entrée unique pour tous les clients
- Route les requêtes vers les services backend appropriés
- Agrège les réponses de plusieurs services si nécessaire
- Gère les préoccupations transversales de manière centralisée
- Transforme les protocoles si nécessaire

## Architecture

### Composants Principaux

```
┌─────────────┐
│   Clients   │
│  (Mobile,   │
│   Web, IoT) │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────┐
│        API Gateway              │
│  ┌──────────────────────────┐  │
│  │  Authentification/       │  │
│  │  Autorisation            │  │
│  └──────────────────────────┘  │
│  ┌──────────────────────────┐  │
│  │  Rate Limiting           │  │
│  └──────────────────────────┘  │
│  ┌──────────────────────────┐  │
│  │  Routage & Agrégation    │  │
│  └──────────────────────────┘  │
│  ┌──────────────────────────┐  │
│  │  Transformation          │  │
│  └──────────────────────────┘  │
└─────────┬───────────────────────┘
          │
    ┌─────┴─────┬─────────┬─────────┐
    ▼           ▼         ▼         ▼
┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
│Service │ │Service │ │Service │ │Service │
│   A    │ │   B    │ │   C    │ │   D    │
└────────┘ └────────┘ └────────┘ └────────┘
```

### Flux de Requête

1. **Client** → Envoie requête à l'API Gateway
2. **Gateway** → Authentifie et autorise la requête
3. **Gateway** → Applique rate limiting
4. **Gateway** → Route vers le(s) service(s) backend approprié(s)
5. **Services** → Traitent la requête et répondent
6. **Gateway** → Agrège les réponses si nécessaire
7. **Gateway** → Transforme la réponse au format client
8. **Client** → Reçoit la réponse

### Technologies Recommandées

- **Kong Gateway**: Solution open-source mature avec plugins riches
- **AWS API Gateway**: Solution cloud-native AWS
- **Azure API Management**: Solution Microsoft Azure
- **NGINX**: Léger et performant pour des besoins simples
- **Spring Cloud Gateway**: Pour écosystème Spring/Java

## Architecture Decision Records (ADRs)

### ADR-001: Choix de Kong Gateway

**Date**: 2025-11-01

**Statut**: Accepté

**Contexte**: Besoin d'une solution API Gateway robuste avec support d'authentification, rate limiting, et extensibilité.

**Décision**: Utiliser Kong Gateway comme solution d'API Gateway.

**Raisons**:
- Open-source avec communauté active
- Plugins riches (OAuth2, JWT, rate limiting, monitoring)
- Performance élevée (basé sur NGINX)
- Support natif pour bases de données (PostgreSQL, Cassandra)
- API de configuration RESTful
- Support multi-cloud

**Conséquences**:
- **Positives**:
  - Extensibilité via plugins personnalisés (Lua)
  - Déploiement flexible (conteneurs, VMs, cloud)
  - Monitoring et observabilité intégrés
- **Négatives**:
  - Courbe d'apprentissage pour configuration avancée
  - Nécessite infrastructure pour base de données
  - Gestion de la haute disponibilité

**Alternatives Considérées**:
- AWS API Gateway: Trop couplé à AWS
- NGINX seul: Manque de fonctionnalités business
- Tyk: Moins mature que Kong

### ADR-002: Stratégie d'Authentification JWT

**Date**: 2025-11-05

**Statut**: Accepté

**Contexte**: Besoin d'authentifier les requêtes clients de manière sécurisée et performante.

**Décision**: Utiliser JWT (JSON Web Tokens) pour l'authentification via le plugin Kong JWT.

**Raisons**:
- Stateless: Pas besoin de session serveur
- Performant: Validation locale sans appel base de données
- Standard: Large support dans écosystèmes
- Flexible: Claims personnalisables

**Conséquences**:
- **Positives**:
  - Scalabilité horizontale simple
  - Réduction de la charge sur services d'authentification
  - Support multi-domaines/multi-clients
- **Négatives**:
  - Difficulté de révocation (solutions: blacklist, TTL courts)
  - Taille de token potentiellement grande
  - Gestion des secrets de signature

### ADR-003: Rate Limiting par Client

**Date**: 2025-11-10

**Statut**: Accepté

**Contexte**: Prévenir les abus et garantir la qualité de service pour tous les clients.

**Décision**: Implémenter rate limiting basé sur l'identité client (consumer ID) avec quotas différenciés.

**Raisons**:
- Protection contre déni de service
- Fairness entre clients
- Support de tiers payants (premium vs gratuit)

**Quotas**:
- Gratuit: 100 req/minute
- Premium: 1000 req/minute
- Interne: 5000 req/minute

**Conséquences**:
- **Positives**:
  - Stabilité du système
  - Monétisation possible
  - Meilleure expérience utilisateur
- **Négatives**:
  - Complexité de gestion des quotas
  - Support client pour ajustements

## Examples

### Configuration Kong Gateway

```yaml
# kong.yaml - Configuration déclarative
_format_version: "3.0"

services:
  - name: user-service
    url: http://user-service:8080
    routes:
      - name: user-routes
        paths:
          - /api/users
    plugins:
      - name: jwt
      - name: rate-limiting
        config:
          minute: 100
          policy: local

  - name: account-service
    url: http://account-service:8080
    routes:
      - name: account-routes
        paths:
          - /api/accounts
    plugins:
      - name: jwt
      - name: rate-limiting
        config:
          minute: 100
          policy: local

plugins:
  - name: correlation-id
    config:
      header_name: X-Request-ID
      generator: uuid
      echo_downstream: true
```

### Déploiement Docker Compose

```yaml
version: '3.8'

services:
  kong-database:
    image: postgres:14
    environment:
      POSTGRES_USER: kong
      POSTGRES_DB: kong
      POSTGRES_PASSWORD: kong
    volumes:
      - kong-data:/var/lib/postgresql/data

  kong-migration:
    image: kong:3.4
    command: kong migrations bootstrap
    environment:
      KONG_DATABASE: postgres
      KONG_PG_HOST: kong-database
      KONG_PG_USER: kong
      KONG_PG_PASSWORD: kong
    depends_on:
      - kong-database

  kong:
    image: kong:3.4
    environment:
      KONG_DATABASE: postgres
      KONG_PG_HOST: kong-database
      KONG_PG_USER: kong
      KONG_PG_PASSWORD: kong
      KONG_PROXY_ACCESS_LOG: /dev/stdout
      KONG_ADMIN_ACCESS_LOG: /dev/stdout
      KONG_PROXY_ERROR_LOG: /dev/stderr
      KONG_ADMIN_ERROR_LOG: /dev/stderr
      KONG_ADMIN_LISTEN: 0.0.0.0:8001
    ports:
      - "8000:8000"  # Proxy
      - "8443:8443"  # Proxy SSL
      - "8001:8001"  # Admin API
    depends_on:
      - kong-database
      - kong-migration

volumes:
  kong-data:
```

### Configuration JWT avec Kong Admin API

```bash
# 1. Créer un consumer
curl -X POST http://localhost:8001/consumers \
  --data "username=mobile-app"

# 2. Créer des credentials JWT pour le consumer
curl -X POST http://localhost:8001/consumers/mobile-app/jwt \
  --data "algorithm=HS256" \
  --data "secret=my-secret-key"

# 3. Générer un JWT token (exemple Node.js)
const jwt = require('jsonwebtoken');

const token = jwt.sign(
  {
    iss: 'mobile-app',
    sub: 'user123',
    exp: Math.floor(Date.now() / 1000) + (60 * 60) // 1 heure
  },
  'my-secret-key'
);

console.log(token);
```

### Requête Client avec JWT

```bash
# Appel avec authentification JWT
curl -X GET http://localhost:8000/api/users/123 \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### Monitoring avec Prometheus

```yaml
# Activer plugin Prometheus
curl -X POST http://localhost:8001/plugins \
  --data "name=prometheus"

# Scrape config Prometheus
scrape_configs:
  - job_name: 'kong'
    static_configs:
      - targets: ['kong:8001']
    metrics_path: '/metrics'
```

## Retours d'Expérience

### Application Mobile Banking (Nov 2025)

**Contexte**: Refonte de l'application mobile avec architecture microservices (15 services backend).

**Implémentation**:
- Kong Gateway en HA (3 instances)
- Authentification JWT avec refresh tokens
- Rate limiting différencié (clients retail vs corporate)
- Agrégation de réponses pour dashboard utilisateur

**Résultats**:
- ✅ Réduction de 40% de la latence moyenne (agrégation côté serveur)
- ✅ Simplification authentification mobile (JWT au lieu de sessions)
- ✅ Zéro incident de sécurité en 3 mois
- ✅ Facilité d'ajout de nouveaux services backend

**Défis Rencontrés**:
- Configuration initiale complexe (courbe d'apprentissage)
- Mise en place de la haute disponibilité (load balancing, failover)
- Gestion des secrets JWT (rotation, révocation)

**Leçons Apprises**:
- Automatiser la configuration Kong (GitOps avec Kong decK)
- Monitorer métriques gateway (latence, taux d'erreur, quotas)
- Tester scénarios de failover régulièrement

## Considérations

### Performance

- **Latence additionnelle**: ~5-15ms par requête
- **Throughput**: Kong peut gérer 10,000+ req/sec par instance
- **Optimisations**: Caching, connection pooling, keep-alive

### Sécurité

- **Single Point of Failure**: Gateway devient point critique
  - Solution: Déploiement en haute disponibilité
- **Attaque DDoS**: Cible attractive
  - Solution: Rate limiting, WAF, CDN
- **Gestion des secrets**: JWT keys, API keys
  - Solution: Vault, rotation automatique

### Scalabilité

- **Horizontal**: Ajouter instances gateway (stateless)
- **Vertical**: Augmenter ressources par instance
- **Database**: PostgreSQL/Cassandra doivent scaler avec gateway

## Voir Aussi

- [Service Mesh Pattern](../service-mesh.md) - Alternative pour communication service-to-service
- [BFF Pattern](../bff-pattern.md) - Backend for Frontend, spécialisation du Gateway
- [Circuit Breaker Pattern](../../integration/circuit-breaker.md) - Résilience pour appels backend

## Références

- [Kong Gateway Documentation](https://docs.konghq.com/gateway/latest/)
- [Martin Fowler - API Gateway Pattern](https://microservices.io/patterns/apigateway.html)
- [AWS API Gateway Best Practices](https://docs.aws.amazon.com/apigateway/latest/developerguide/best-practices.html)
- [NGINX as API Gateway](https://www.nginx.com/learn/api-gateway/)
