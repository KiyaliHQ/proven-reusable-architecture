---
title: Test API Gateway Pattern
description: Test pattern to validate the approve-pra-candidate workflow
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

This PRA describes an API Gateway pattern for managing microservices aggregation in Retail Banking applications.

**Problem Solved**: Excessive client-side complexity when interacting with multiple microservices.

**Solution**: Implement a centralized API Gateway that aggregates calls to backend microservices.

## Context

**Challenge**:

In the Retail Banking microservices architecture, client applications (mobile, web) must interact with numerous independent microservices. This creates several challenges:
- Multiple network calls
- Complex authentication management
- Tight coupling between client and services
- API versioning difficulties

**Solution**:

An API Gateway acts as a single entry point for all client requests. It provides:
- Data aggregation from multiple services
- Centralized authentication and authorization
- Response transformation and adaptation
- Rate limiting and caching management

## Architecture

### Global Architecture

```
┌─────────────┐
│   Client    │
│  (Mobile)   │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────┐
│      API Gateway            │
│  - Authentication           │
│  - Aggregation             │
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

### Key Components

1. **Gateway Layer**: Single entry point
2. **Aggregation Layer**: Response composition
3. **Backend Services**: Business microservices

### Technologies

- **Gateway**: Kong, AWS API Gateway, or custom (Node.js/Express)
- **Auth**: OAuth 2.0 / JWT
- **Cache**: Redis
- **Monitoring**: Prometheus + Grafana

## ADR

### ADR-001: Choice of Kong as API Gateway

**Context**: Need for a robust and scalable API Gateway for Retail Banking.

**Decision**: Use Kong as the API Gateway platform.

**Reasons**:
- Open source with enterprise support
- Rich plugin ecosystem
- High performance (based on Nginx)
- Native Kubernetes support
- Active community

**Alternatives Considered**:
- AWS API Gateway: Vendor lock-in
- Custom solution: High maintenance cost
- Apigee: Prohibitive licensing cost

**Consequences**:
- ✅ Proven and scalable solution
- ✅ Extensibility via plugins
- ⚠️ Initial learning curve
- ⚠️ Requires dedicated infrastructure

### ADR-002: Gateway-side vs client-side aggregation

**Context**: Decide where to perform data aggregation from multiple services.

**Decision**: Perform aggregation gateway-side (Backend for Frontend pattern).

**Reasons**:
- Reduces number of network calls from client
- Simplifies client code
- Allows backend query optimization
- Facilitates caching

**Consequences**:
- ✅ Better perceived client-side performance
- ✅ Centralized business logic
- ⚠️ Gateway becomes critical point
- ⚠️ Requires load management

## Examples

### Example 1: User profile aggregation endpoint

```javascript
// API Gateway - Aggregation endpoint
app.get('/api/v1/user/:userId/dashboard', async (req, res) => {
  const userId = req.params.userId;

  // Parallel calls to microservices
  const [profile, accounts, transactions] = await Promise.all([
    profileService.getProfile(userId),
    accountService.getAccounts(userId),
    transactionService.getRecentTransactions(userId, 10)
  ]);

  // Response aggregation
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

### Example 2: Kong Configuration (YAML)

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

### Example 3: Client-side usage (React Native)

```typescript
// Simplified client thanks to API Gateway
const DashboardScreen = () => {
  const [dashboard, setDashboard] = useState(null);
  const { userId } = useAuth();

  useEffect(() => {
    // Single call instead of 3+
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

**Context**: Mobile banking app redesign for Retail customers.

**Implementation**:
- API Gateway with Kong on Kubernetes
- Aggregation of 8 backend microservices
- Support for 500K+ active users
- Deployment on AWS EKS

**Results**:
- ✅ **60% reduction in client-side complexity**
- ✅ **Performance**: Dashboard load time reduced from 2.5s to 0.8s
- ✅ **Reliability**: 99.95% availability
- ✅ **Scalability**: Supports 10K requests/second at peak

**Feedback**: "The API Gateway has significantly simplified our mobile architecture. The frontend team can now focus on UX rather than microservices orchestration."

**Metrics**:
- API calls per page reduced: 12 → 3
- Payload sizes optimized: -40%
- Time to First Byte (TTFB): 250ms average
- Error rate: < 0.1%

**Learnings**:
- Importance of granular gateway monitoring
- Need for aggressive caching for low-volatility data
- Circuit breaker essential for resilience
- OpenAPI documentation facilitating team adoption
