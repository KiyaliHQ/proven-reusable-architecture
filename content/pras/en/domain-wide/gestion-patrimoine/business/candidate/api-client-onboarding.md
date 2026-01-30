---
title: API-Based Client Onboarding Pattern
description: Standardized architecture for digital client onboarding in wealth management via secure APIs
pra:
  name: API-Based Client Onboarding Pattern
  category: business
  status: candidate
  tags: [onboarding, api, client, digital, wealth-management, kyc, compliance]
  created_at: "2025-12-04"
  updated_at: "2025-12-04"
  proven_in_use:
    - project: Private Wealth Mobile Platform
      team: Wealth Management Digital Team
      date: "2025-10-15"
      feedback: "65% reduction in client onboarding time. API-first architecture enabled seamless integration with external partners (accountants, notaries). Automated KYC validation eliminated 80% of manual errors. Modular design facilitates adding new client types (SMEs, foundations)."
---

## Overview

The **API-Based Client Onboarding Pattern** is a standardized architecture designed to automate and secure the client onboarding process in wealth management. This pattern enables advisors and clients to initiate and complete the onboarding journey digitally while meeting strict regulatory requirements (KYC, AML, FINRA compliance).

### Problem Statement

In wealth management, traditional client onboarding is:
- **Slow**: 4-6 weeks to complete a file
- **Manual**: Repeated entry of the same information across multiple systems
- **Fragmented**: Different processes for different client types (high-net-worth individuals, corporations, foundations)
- **Non-digital**: Paper documents, physical signatures, manual validation

### Solution

This PRA proposes an API-first architecture that:
- Unifies the onboarding journey for all client types
- Integrates real-time KYC/AML validation
- Enables secure electronic signatures
- Orchestrates multi-system workflows (CRM, Core Banking, Compliance)
- Provides a seamless user experience (web, mobile, external partners)

## Context

### Use Cases

**Scenario 1: High-Net-Worth Individual Onboarding**
1. Advisor initiates file from CRM
2. Client receives secure link to complete profile
3. Upload documents (ID, proof of residence, tax declaration)
4. Electronic signature of management contract
5. Automatic KYC validation (risk score, PEP check)
6. Final approval by advisor
7. Core Banking account creation

**Scenario 2: Onboarding via External Partner (Accountant)**
1. Accountant submits client file via partner API
2. Automatic pre-filling of tax information
3. Client completes missing information via portal
4. Compliant validation, accelerated approval
5. Account activation

### Business Context

**Domain**: Wealth Management
- Clients: High-net-worth individuals, SMEs, foundations, trusts
- Regulation: FINRA, SEC, KYC/AML, GDPR
- Stakeholders: Advisors, clients, compliance, operations

**Specific Constraints**
- Strict compliance (complete audit trail)
- Maximum confidentiality (sensitive data)
- 24/7 availability (international clients)
- Integration with legacy systems (mainframe Core Banking)

## Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENTS                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │  Web Portal  │  │  Mobile App  │  │ External API │         │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘         │
└─────────┼──────────────────┼──────────────────┼────────────────┘
          │                  │                  │
          └──────────────────┴──────────────────┘
                             │
                ┌────────────▼────────────┐
                │   API Gateway (Kong)    │
                │  - Auth (OAuth 2.0)     │
                │  - Rate Limiting        │
                │  - SSL/TLS              │
                └────────────┬────────────┘
                             │
          ┌──────────────────┴──────────────────┐
          │                                     │
┌─────────▼─────────┐              ┌───────────▼────────────┐
│ Onboarding Service│              │  Document Service      │
│  (Node.js)        │              │   (Python)             │
│                   │              │  - OCR                 │
│ - Workflow Engine │              │  - Validation          │
│ - State Machine   │◄────────────►│  - Storage (S3)        │
│ - Event Bus       │              └────────────────────────┘
└─────────┬─────────┘
          │
          │         ┌────────────────────────────┐
          ├────────►│  KYC/AML Service           │
          │         │   (Java Spring)            │
          │         │  - Identity Verification   │
          │         │  - Risk Scoring            │
          │         │  - PEP/Sanctions Check     │
          │         └────────────────────────────┘
          │
          │         ┌────────────────────────────┐
          ├────────►│  Signature Service         │
          │         │   (DocuSign API)           │
          │         │  - E-signature             │
          │         │  - Audit Trail             │
          │         └────────────────────────────┘
          │
          │         ┌────────────────────────────┐
          └────────►│  Core Banking Adapter      │
                    │   (MQ/Kafka)               │
                    │  - Account Creation        │
                    │  - Profile Sync            │
                    └────────┬───────────────────┘
                             │
                    ┌────────▼───────────┐
                    │  Core Banking      │
                    │  (Legacy Mainframe)│
                    └────────────────────┘
```

### Key Components

**1. Onboarding Service (Orchestrator)**
- **Responsibility**: Manages complete onboarding workflow
- **Technology**: Node.js + Express + Bull (queue)
- **Patterns**: State Machine (states: INITIATED, DOCS_PENDING, KYC_PENDING, APPROVED, REJECTED)
- **Database**: PostgreSQL (transactional data) + Redis (cache)

**2. Document Service**
- **Responsibility**: Upload, validation, OCR, document storage
- **Technology**: Python + FastAPI + Tesseract OCR
- **Storage**: AWS S3 (encrypted at rest)
- **Validation**: Format (PDF, JPEG), size, fraud detection

**3. KYC/AML Service**
- **Responsibility**: Identity verification, risk scoring, regulatory checks
- **Technology**: Java Spring Boot
- **Integrations**: Third-party APIs (LexisNexis, Thomson Reuters)
- **Output**: Risk score (0-100), recommendation (AUTO_APPROVE, MANUAL_REVIEW, REJECT)

**4. Signature Service**
- **Responsibility**: Legally binding electronic signatures
- **Technology**: DocuSign API integration
- **Compliance**: eIDAS (EU), ESIGN Act (US)

**5. Core Banking Adapter**
- **Responsibility**: Bridge to legacy system
- **Technology**: MQ/Kafka for asynchronous messaging
- **Transformation**: JSON → Mainframe format (COBOL copybook)

### Data Flow

**Step 1: Initiation**
```
Advisor (CRM) → API Gateway → Onboarding Service → Event: ONBOARDING_INITIATED
```

**Step 2: Document Collection**
```
Client → Web Portal → API Gateway → Document Service → S3 Storage
                                   → Event: DOCUMENTS_UPLOADED
                                   → Onboarding Service (state transition)
```

**Step 3: KYC Validation**
```
Onboarding Service → KYC/AML Service → LexisNexis API
                                     → Event: KYC_COMPLETED (score, recommendation)
```

**Step 4: Signature**
```
Onboarding Service → Signature Service → DocuSign API → Client (email)
Client signs → Event: CONTRACT_SIGNED
```

**Step 5: Account Creation**
```
Onboarding Service → Core Banking Adapter → Kafka Topic
                                          → Core Banking (mainframe)
                                          → Event: ACCOUNT_CREATED
```

### Security

**Authentication & Authorization**
- OAuth 2.0 + OpenID Connect (OIDC)
- JWT tokens (15 min expiration)
- Refresh tokens (7 days)
- Role-Based Access Control (RBAC): CLIENT, ADVISOR, COMPLIANCE, ADMIN

**Encryption**
- TLS 1.3 for transit
- AES-256 for data at rest (S3, DB)
- Keys managed via AWS KMS

**Audit & Compliance**
- All events logged (GDPR compliant)
- Immutable audit trail (blockchain for legal proof)
- Retention: 7 years (regulatory requirement)

## ADRs

### ADR-001: State Machine Pattern for Workflow

**Context**
The onboarding process has many steps with complex dependencies, conditional branches (e.g., manual vs automatic KYC), and requires complete traceability.

**Decision**
Implement the workflow as a State Machine with explicit states and validated transitions.

**Alternatives Considered**
1. **Simple linear workflow**: Rejected - too rigid, doesn't handle exceptions
2. **Business Process Model (BPMN)**: Rejected - too much overhead for our case
3. **Pure Event Sourcing**: Rejected - unnecessary complexity for this use case

**Consequences**
- ✅ Improved code readability (explicit states and transitions)
- ✅ Testability: each transition independently testable
- ✅ Traceability: complete history of state changes
- ❌ Initial setup complexity
- ❌ Risk of "state explosion" if poorly managed

**Defined States**
```
INITIATED → DOCUMENTS_PENDING → DOCUMENTS_UPLOADED → KYC_PENDING
  → KYC_APPROVED → SIGNATURE_PENDING → SIGNED → ACCOUNT_CREATION_PENDING
  → COMPLETED

Error states:
  - KYC_REJECTED
  - COMPLIANCE_HOLD
  - INCOMPLETE (timeout)
```

### ADR-002: API-First Architecture with Legacy Core Banking

**Context**
Core Banking is a mainframe system (COBOL) without REST APIs. Direct access requires complex data transformations.

**Decision**
Create a dedicated **Adapter Layer** using asynchronous messaging (Kafka) to decouple modern onboarding from legacy.

**Alternatives Considered**
1. **Synchronous MQ calls**: Rejected - frequent timeouts, tight coupling
2. **Modify Core Banking**: Rejected - too costly, risky
3. **ESB (Enterprise Service Bus)**: Rejected - overhead, vendor lock-in

**Consequences**
- ✅ Decoupling: Onboarding Service doesn't know mainframe format
- ✅ Resilience: Kafka queue handles temporary failures
- ✅ Evolvability: Easy to replace Core Banking later
- ❌ Operational complexity (Kafka cluster to manage)
- ❌ Additional latency (asynchronous)

**Implementation**
```javascript
// Onboarding Service publishes an event
const event = {
  type: 'CREATE_ACCOUNT',
  clientId: '12345',
  profile: { name, ssn, address, ... },
  timestamp: Date.now()
};
await kafka.publish('core-banking-commands', event);

// Core Banking Adapter consumes, transforms, sends to mainframe
```

### ADR-003: Hybrid KYC Validation (Auto + Manual)

**Context**
100% automatic KYC validation can reject legitimate clients (false negatives). 100% manual validation is slow and costly.

**Decision**
**Hybrid system with confidence score**:
- Score ≥ 80: Automatic approval
- Score 50-79: Manual review (Compliance Team)
- Score < 50: Automatic rejection

**Alternatives Considered**
1. **Systematic automatic approval**: Rejected - unacceptable regulatory risk
2. **Systematic manual review**: Rejected - too slow (4-6 weeks)

**Consequences**
- ✅ Balance speed/compliance: 70% of files approved in < 24h
- ✅ Reduces Compliance Team workload
- ❌ Requires model maintenance (ML drift)
- ❌ Complexity in justifying automatic decisions

**Scoring Factors**
```yaml
Positive factors (+):
  - Valid documents (OCR confirmed): +20
  - Verified address (postal database): +15
  - No PEP/sanctions: +25
  - High credit score: +20

Negative factors (-):
  - Expired documents: -30
  - Data inconsistencies: -40
  - PEP detected: -50
  - High-risk country: -25
```

## Examples

### Example 1: Client API - Initiate Onboarding

**Endpoint**: `POST /api/v1/onboarding/initiate`

**Request**
```json
{
  "clientType": "INDIVIDUAL",
  "initiatedBy": "ADVISOR",
  "advisorEmail": "john.doe@bnc.ca",
  "clientInfo": {
    "firstName": "Marie",
    "lastName": "Tremblay",
    "email": "marie.tremblay@example.com",
    "phone": "+1-514-555-1234",
    "dateOfBirth": "1980-05-15",
    "residenceCountry": "CA",
    "taxResidence": "CA"
  },
  "metadata": {
    "source": "CRM",
    "campaignId": "Q4-2025-PROMO"
  }
}
```

**Response (201 Created)**
```json
{
  "onboardingId": "ONB-2025-00123",
  "status": "INITIATED",
  "nextStep": "DOCUMENTS_UPLOAD",
  "clientPortalUrl": "https://onboarding.bnc.ca/portal/ONB-2025-00123?token=eyJhbGc...",
  "expiresAt": "2025-12-11T14:30:00Z",
  "createdAt": "2025-12-04T14:30:00Z"
}
```

### Example 2: KYC Completed Webhook

**Event received from KYC Service**
```json
{
  "eventType": "KYC_COMPLETED",
  "onboardingId": "ONB-2025-00123",
  "kycResult": {
    "status": "APPROVED",
    "score": 85,
    "checks": {
      "identityVerification": "PASSED",
      "addressVerification": "PASSED",
      "pepCheck": "PASSED",
      "sanctionsCheck": "PASSED",
      "adverseMedia": "PASSED"
    },
    "riskLevel": "LOW",
    "recommendation": "AUTO_APPROVE",
    "reviewedBy": "SYSTEM",
    "completedAt": "2025-12-04T15:45:00Z"
  }
}
```

**Onboarding Service action**
```javascript
async function handleKycCompleted(event) {
  const { onboardingId, kycResult } = event;

  // Update state
  await db.onboardings.update(onboardingId, {
    status: 'KYC_APPROVED',
    kycScore: kycResult.score,
    kycCompletedAt: kycResult.completedAt
  });

  // Trigger next step (signature)
  if (kycResult.recommendation === 'AUTO_APPROVE') {
    await triggerSignatureStep(onboardingId);
  } else if (kycResult.recommendation === 'MANUAL_REVIEW') {
    await notifyComplianceTeam(onboardingId);
  }

  // Publish event
  await eventBus.publish('onboarding.kyc.approved', {
    onboardingId,
    timestamp: Date.now()
  });
}
```

### Example 3: Core Banking Adapter - Message Transformation

**Kafka message (modern JSON)**
```json
{
  "type": "CREATE_ACCOUNT",
  "clientId": "ONB-2025-00123",
  "profile": {
    "firstName": "Marie",
    "lastName": "Tremblay",
    "ssn": "123-45-6789",
    "address": {
      "street": "123 Rue Sherbrooke",
      "city": "Montreal",
      "province": "QC",
      "postalCode": "H3A 1B1"
    },
    "accountType": "WEALTH_MANAGEMENT"
  }
}
```

**Transformation to mainframe format (COBOL copybook)**
```cobol
01  ACCOUNT-CREATE-REQUEST.
    05  TRAN-CODE           PIC X(4)   VALUE 'ACCT'.
    05  CLIENT-ID           PIC X(20)  VALUE 'ONB-2025-00123'.
    05  FIRST-NAME          PIC X(30)  VALUE 'MARIE'.
    05  LAST-NAME           PIC X(30)  VALUE 'TREMBLAY'.
    05  SSN                 PIC 9(9)   VALUE 123456789.
    05  ADDRESS-LINE-1      PIC X(40)  VALUE '123 RUE SHERBROOKE'.
    05  CITY                PIC X(20)  VALUE 'MONTREAL'.
    05  PROVINCE            PIC X(2)   VALUE 'QC'.
    05  POSTAL-CODE         PIC X(7)   VALUE 'H3A1B1'.
    05  ACCOUNT-TYPE        PIC X(3)   VALUE 'WM'.
```

**Adapter code**
```java
@Service
public class CoreBankingAdapter {

    @KafkaListener(topics = "core-banking-commands")
    public void processCommand(String message) {
        CreateAccountCommand cmd = parseJson(message);

        // Transform to COBOL format
        String cobolRecord = CobolTransformer.toCopybook(cmd);

        // Send to MQ
        mqClient.send("ACCT.CREATE.QUEUE", cobolRecord);

        // Wait for response (max 30s)
        String response = mqClient.receiveWithTimeout("ACCT.RESPONSE.QUEUE", 30000);

        // Parse response and publish event
        if (response.contains("SUCCESS")) {
            kafkaProducer.send("core-banking-events",
                new AccountCreatedEvent(cmd.getClientId()));
        }
    }
}
```

## Lessons Learned

### What Works Well

**1. API-First Architecture**
- Rapid adoption by mobile teams (3 weeks to integrate)
- External partners (accountants, notaries) integrated in < 1 month
- Reusability: same API used by web, mobile, and partners

**2. State Machine for Workflow**
- Easier debugging: state visible at all times
- Recovery after error: we know exactly where to resume
- Testing: each transition tested independently (95% coverage)

**3. Hybrid KYC Validation**
- 70% automatic approvals (< 24h)
- 20% manual reviews (2-3 days)
- 10% automatic rejections
- False positive rate < 2%

### Challenges Encountered

**1. Legacy Core Banking Latency**
- **Problem**: Account creation can take 5-10 minutes (overloaded mainframe)
- **Solution**: Asynchronous decoupling (client notified by email when account ready)
- **Future Improvement**: Migration to modern Core Banking (cloud-native)

**2. Large Document Management**
- **Problem**: Uploading 50+ MB PDFs blocks the API
- **Solution**: Pre-signed S3 URLs (client uploads directly to S3, API only receives metadata)
- **Code**:
```javascript
// Generate pre-signed URL
const s3Url = await s3.getSignedUrl('putObject', {
  Bucket: 'onboarding-docs',
  Key: `${onboardingId}/${docType}/${filename}`,
  Expires: 3600, // 1 hour
  ContentType: 'application/pdf'
});

return { uploadUrl: s3Url };
```

**3. Multi-System Data Consistency**
- **Problem**: Client data duplicated in CRM, Onboarding DB, Core Banking
- **Solution**: Partial Event Sourcing (events broadcast to all systems)
- **Pattern**: Customer Data Hub (CDC on Core Banking → Event Bus → Sync to other systems)

### Success Metrics

**Before PRA**
- Onboarding time: 4-6 weeks
- Abandonment rate: 45%
- Manual entry errors: 25%
- Cost per onboarding: $450

**After PRA (6 months)**
- Onboarding time: 2-5 days (90% reduction)
- Abandonment rate: 18% (60% reduction)
- Entry errors: 5% (80% reduction)
- Cost per onboarding: $120 (73% reduction)
- Client satisfaction (NPS): +35 points

## Trade-offs

### Complexity vs Flexibility

**Choice**: Microservices architecture (5 distinct services)

**Advantages**:
- Independent scaling (Document Service can scale without Onboarding Service)
- Independent deployment (KYC Service can be updated without global downtime)
- Resilience: failure of one service doesn't affect others

**Disadvantages**:
- Operational overhead: 5 services to monitor, deploy, secure
- Debugging complexity: distributed tracing required (Jaeger)
- Network latency: inter-service calls add 50-100ms

**When to Avoid**:
- Low volume (< 100 onboardings/month): modular monolith sufficient
- Team < 5 developers: operational complexity too high

### KYC Validation: Speed vs Compliance

**Choice**: Automatic approval for score ≥ 80

**Advantages**:
- 70% of files approved in < 24h (vs 2-4 weeks)
- Superior client experience
- Reduced Compliance Team workload

**Disadvantages**:
- Regulatory risk: audit may question auto decisions
- Requires ML Ops (monitoring drift, model re-training)
- Dependency on third-party APIs (LexisNexis downtime = blockage)

**When to Avoid**:
- Ultra-strict jurisdiction (e.g., Switzerland, certain US states)
- Lack of ML expertise in team
- Limited budget (third-party KYC APIs are expensive)

### Synchronous vs Asynchronous with Core Banking

**Choice**: Asynchronous messaging (Kafka)

**Advantages**:
- Resilience: queue persists messages during outages
- Decoupling: Onboarding doesn't block if mainframe slow
- Future evolvability: easy to replace Core Banking

**Disadvantages**:
- Latency: client waits for email confirmation (vs immediate response)
- Complexity: Kafka cluster to operate (3+ brokers for HA)
- Debugging: harder to trace errors

**When to Avoid**:
- If modern Core Banking with fast REST APIs (< 2s)
- If immediate confirmation required (e.g., real-time bank transfer)

## Related Patterns

**Patterns Used in this PRA**
- **State Machine Pattern**: Workflow management with explicit states
- **Saga Pattern**: Distributed transactions (rollback on step failure)
- **Adapter Pattern**: Core Banking Adapter isolates legacy
- **Event Sourcing (partial)**: Immutable audit trail for compliance

**Complementary Patterns**
- **Circuit Breaker**: Protect against third-party KYC API failures
- **CQRS**: Separate read (advisor dashboard) and write (workflow)
- **Bulkhead**: Thread pool isolation per service

## References

**Internal Documentation**
- [API Gateway Standards](../tech/api-gateway.md)
- [Event-Driven Architecture Guidelines](../tech/event-driven.md)
- [Compliance & Audit Requirements](../../guides/compliance-guide.md)

**Tools & Technologies**
- Node.js + Express: https://expressjs.com/
- Bull (Job Queue): https://github.com/OptimalBits/bull
- DocuSign API: https://developers.docusign.com/
- AWS S3: https://aws.amazon.com/s3/
- Apache Kafka: https://kafka.apache.org/

**Regulation**
- FINRA Rule 2090 (Know Your Customer): https://www.finra.org/rules-guidance/rulebooks/finra-rules/2090
- eIDAS (EU Digital Signatures): https://ec.europa.eu/digital-building-blocks/wikis/display/DIGITAL/eIDAS

---

**Author**: Wealth Management Digital Team
**Creation Date**: 2025-12-04
**Last Update**: 2025-12-04
**Status**: Candidate (1 validated implementation)
**Contact**: digital-wealth@bnc.ca
