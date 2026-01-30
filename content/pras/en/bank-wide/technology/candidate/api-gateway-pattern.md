---
title: API Gateway Pattern
description: Centralized gateway to manage API requests in a microservices architecture
pra:
  name: API Gateway Pattern
  category: technology
  status: candidate
  tags: [api, gateway, microservices, architecture]
  created_at: "2025-12-03"
  updated_at: "2025-12-03"
  proven_in_use:
    - project: Mobile Banking Application
      team: Digital Retail Team
      date: "2025-11-15"
      feedback: "40% reduction in API latency and simplified authentication for mobile clients"
---

# API Gateway Pattern

## Overview

The API Gateway pattern provides a single entry point for all client requests to a distributed system of microservices. It acts as a reverse proxy that routes requests to appropriate services and can handle cross-cutting concerns such as authentication, rate limiting, and response aggregation.

## Context

### Problem

In a microservices architecture, clients need to interact with multiple independent services. This creates several challenges:

- **Client-side complexity**: Clients must know and manage endpoints for many services
- **Tight coupling**: Clients are directly coupled to the internal structure of microservices
- **Cross-cutting concerns**: Authentication, rate limiting, and monitoring must be implemented in each service
- **Multiple protocols**: Different services may use different protocols (REST, gRPC, WebSocket)

### Solution

The API Gateway serves as a unified facade that:
- Provides a single entry point for all clients
- Routes requests to appropriate backend services
- Aggregates responses from multiple services if needed
- Handles cross-cutting concerns centrally
- Transforms protocols if necessary

## Architecture

### Main Components

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
│  │  Authentication/         │  │
│  │  Authorization           │  │
│  └──────────────────────────┘  │
│  ┌──────────────────────────┐  │
│  │  Rate Limiting           │  │
│  └──────────────────────────┘  │
│  ┌──────────────────────────┐  │
│  │  Routing & Aggregation   │  │
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

### Request Flow

1. **Client** → Sends request to API Gateway
2. **Gateway** → Authenticates and authorizes request
3. **Gateway** → Applies rate limiting
4. **Gateway** → Routes to appropriate backend service(s)
5. **Services** → Process request and respond
6. **Gateway** → Aggregates responses if needed
7. **Gateway** → Transforms response to client format
8. **Client** → Receives response

### Recommended Technologies

- **Kong Gateway**: Mature open-source solution with rich plugins
- **AWS API Gateway**: AWS cloud-native solution
- **Azure API Management**: Microsoft Azure solution
- **NGINX**: Lightweight and performant for simple needs
- **Spring Cloud Gateway**: For Spring/Java ecosystem

## Architecture Decision Records (ADRs)

### ADR-001: Choice of Kong Gateway

**Date**: 2025-11-01

**Status**: Accepted

**Context**: Need for a robust API Gateway solution with support for authentication, rate limiting, and extensibility.

**Decision**: Use Kong Gateway as the API Gateway solution.

**Reasons**:
- Open-source with active community
- Rich plugins (OAuth2, JWT, rate limiting, monitoring)
- High performance (based on NGINX)
- Native database support (PostgreSQL, Cassandra)
- RESTful configuration API
- Multi-cloud support

**Consequences**:
- **Positives**:
  - Extensibility via custom plugins (Lua)
  - Flexible deployment (containers, VMs, cloud)
  - Integrated monitoring and observability
- **Negatives**:
  - Learning curve for advanced configuration
  - Requires infrastructure for database
  - High availability management

**Alternatives Considered**:
- AWS API Gateway: Too coupled to AWS
- NGINX alone: Lacks business features
- Tyk: Less mature than Kong

### ADR-002: JWT Authentication Strategy

**Date**: 2025-11-05

**Status**: Accepted

**Context**: Need to authenticate client requests securely and performantly.

**Decision**: Use JWT (JSON Web Tokens) for authentication via Kong JWT plugin.

**Reasons**:
- Stateless: No need for server-side sessions
- Performant: Local validation without database calls
- Standard: Wide support across ecosystems
- Flexible: Customizable claims

**Consequences**:
- **Positives**:
  - Simple horizontal scalability
  - Reduced load on authentication services
  - Multi-domain/multi-client support
- **Negatives**:
  - Difficulty in revocation (solutions: blacklist, short TTL)
  - Potentially large token size
  - Secret key management

### ADR-003: Per-Client Rate Limiting

**Date**: 2025-11-10

**Status**: Accepted

**Context**: Prevent abuse and ensure quality of service for all clients.

**Decision**: Implement rate limiting based on client identity (consumer ID) with differentiated quotas.

**Reasons**:
- Protection against denial of service
- Fairness between clients
- Support for tiered pricing (premium vs free)

**Quotas**:
- Free: 100 req/minute
- Premium: 1000 req/minute
- Internal: 5000 req/minute

**Consequences**:
- **Positives**:
  - System stability
  - Monetization potential
  - Better user experience
- **Negatives**:
  - Quota management complexity
  - Customer support for adjustments

## Examples

### Kong Gateway Configuration

```yaml
# kong.yaml - Declarative configuration
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

### Docker Compose Deployment

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

### JWT Configuration with Kong Admin API

```bash
# 1. Create a consumer
curl -X POST http://localhost:8001/consumers \
  --data "username=mobile-app"

# 2. Create JWT credentials for the consumer
curl -X POST http://localhost:8001/consumers/mobile-app/jwt \
  --data "algorithm=HS256" \
  --data "secret=my-secret-key"

# 3. Generate a JWT token (Node.js example)
const jwt = require('jsonwebtoken');

const token = jwt.sign(
  {
    iss: 'mobile-app',
    sub: 'user123',
    exp: Math.floor(Date.now() / 1000) + (60 * 60) // 1 hour
  },
  'my-secret-key'
);

console.log(token);
```

### Client Request with JWT

```bash
# Call with JWT authentication
curl -X GET http://localhost:8000/api/users/123 \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### Monitoring with Prometheus

```yaml
# Enable Prometheus plugin
curl -X POST http://localhost:8001/plugins \
  --data "name=prometheus"

# Prometheus scrape config
scrape_configs:
  - job_name: 'kong'
    static_configs:
      - targets: ['kong:8001']
    metrics_path: '/metrics'
```

## Feedback from Production

### Mobile Banking Application (Nov 2025)

**Context**: Mobile app redesign with microservices architecture (15 backend services).

**Implementation**:
- Kong Gateway in HA (3 instances)
- JWT authentication with refresh tokens
- Differentiated rate limiting (retail vs corporate clients)
- Response aggregation for user dashboard

**Results**:
- ✅ 40% reduction in average latency (server-side aggregation)
- ✅ Simplified mobile authentication (JWT instead of sessions)
- ✅ Zero security incidents in 3 months
- ✅ Easy addition of new backend services

**Challenges Encountered**:
- Complex initial configuration (learning curve)
- Setting up high availability (load balancing, failover)
- JWT secret management (rotation, revocation)

**Lessons Learned**:
- Automate Kong configuration (GitOps with Kong decK)
- Monitor gateway metrics (latency, error rate, quotas)
- Test failover scenarios regularly

## Considerations

### Performance

- **Additional latency**: ~5-15ms per request
- **Throughput**: Kong can handle 10,000+ req/sec per instance
- **Optimizations**: Caching, connection pooling, keep-alive

### Security

- **Single Point of Failure**: Gateway becomes critical point
  - Solution: Deploy in high availability
- **DDoS Attack**: Attractive target
  - Solution: Rate limiting, WAF, CDN
- **Secret management**: JWT keys, API keys
  - Solution: Vault, automatic rotation

### Scalability

- **Horizontal**: Add gateway instances (stateless)
- **Vertical**: Increase resources per instance
- **Database**: PostgreSQL/Cassandra must scale with gateway

## See Also

- [Service Mesh Pattern](../service-mesh.md) - Alternative for service-to-service communication
- [BFF Pattern](../bff-pattern.md) - Backend for Frontend, Gateway specialization
- [Circuit Breaker Pattern](../../integration/circuit-breaker.md) - Resilience for backend calls

## References

- [Kong Gateway Documentation](https://docs.konghq.com/gateway/latest/)
- [Martin Fowler - API Gateway Pattern](https://microservices.io/patterns/apigateway.html)
- [AWS API Gateway Best Practices](https://docs.aws.amazon.com/apigateway/latest/developerguide/best-practices.html)
- [NGINX as API Gateway](https://www.nginx.com/learn/api-gateway/)
