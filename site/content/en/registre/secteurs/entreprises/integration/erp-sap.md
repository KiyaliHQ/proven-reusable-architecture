---
title: ERP SAP S/4HANA Integration
description: Bidirectional banking integration with SAP S/4HANA
---

# ERP SAP S/4HANA Integration

## Overview

Bidirectional banking integration solution between BNC and SAP S/4HANA, enabling automatic synchronization of transactions, statements, and cash positions.

## Context

**Sector**: Corporate
**Status**: Production (stable)
**Proven-in-use**: 24 months
**Clients**: 150+ large enterprises
**Transactions**: 500,000+ transactions/month

## Architecture

### Overview

```mermaid
graph LR
    A[SAP S/4HANA] <--> B[BNC Integration Layer]
    B <--> C[Core Banking]
    B --> D[Document Storage]
    E[Treasury Workstation] --> B
```

### Components

```mermaid
graph TB
    A[SAP S/4HANA] --> B[SAP PI/PO]
    B --> C[EBICS Gateway]
    C --> D[BNC API Gateway]
    D --> E[Banking Services]
    E --> F[Core Banking System]
    E --> G[Statement Generator]
    E --> H[Payment Processing]
```

### Technology Stack

- **SAP Side**: SAP S/4HANA 2021+ with Bank Communication Management (BCM)
- **Integration**: SAP PI/PO (Process Integration/Orchestration)
- **Protocol**: EBICS (Electronic Banking Internet Communication Standard)
- **Format**: ISO 20022 (pain.001, pain.002, camt.053, camt.054)
- **BNC Side**: API Gateway (Kong) + Banking Services (Java Spring Boot)
- **Security**: TLS 1.3, X.509 certificates, Message signing

## Data Flows

### 1. Payments (Outbound)

```mermaid
sequenceDiagram
    participant SAP as SAP S/4HANA
    participant PI as SAP PI/PO
    participant EBICS as EBICS Gateway
    participant BNC as BNC Banking

    SAP->>PI: Payment Order (pain.001)
    PI->>PI: Validation & Enrichment
    PI->>EBICS: EBICS Upload
    EBICS->>BNC: Payment Instruction
    BNC->>BNC: Process Payment
    BNC->>EBICS: Status (pain.002)
    EBICS->>PI: Download Status
    PI->>SAP: Update Payment Status
```

**ISO 20022 Messages**:
- **pain.001**: Customer Credit Transfer Initiation
- **pain.002**: Customer Payment Status Report

### 2. Bank Statements (Inbound)

```mermaid
sequenceDiagram
    participant BNC as BNC Banking
    participant EBICS as EBICS Gateway
    participant PI as SAP PI/PO
    participant SAP as SAP S/4HANA

    BNC->>BNC: Generate Daily Statement
    BNC->>EBICS: Statement (camt.053)
    EBICS->>PI: Download Statement
    PI->>PI: Transform to SAP Format
    PI->>SAP: Post Bank Statement
    SAP->>SAP: Auto-Reconciliation
```

**ISO 20022 Messages**:
- **camt.053**: Bank to Customer Statement
- **camt.054**: Bank to Customer Debit/Credit Notification

### 3. Cash Position (Real-time)

```mermaid
sequenceDiagram
    participant SAP as SAP Treasury
    participant API as BNC API
    participant CBS as Core Banking

    SAP->>API: Get Account Balances
    API->>CBS: Query Balances
    CBS->>API: Return Balances
    API->>SAP: Balance Response (JSON)
    SAP->>SAP: Update Cash Position
```

## SAP Configuration

### Bank Communication Management (BCM)

```abap
" BCM Configuration in SAP
" Transaction: FBCM_SETUP

DATA: ls_bank TYPE bcm_bank_details.

ls_bank-bank_country = 'CA'.
ls_bank-bank_key = '123456789'. " BNC institution number
ls_bank-bank_account = '1234567890'.
ls_bank-currency = 'CAD'.
ls_bank-comm_method = 'EBICS'.

CALL FUNCTION 'BCM_BANK_SETUP'
  EXPORTING
    is_bank_details = ls_bank.
```

### Payment Format Configuration

```xml
<!-- pain.001.001.03 Configuration -->
<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03">
  <CstmrCdtTrfInitn>
    <GrpHdr>
      <MsgId>SAP-BNC-20241127-001</MsgId>
      <CreDtTm>2024-11-27T10:30:00</CreDtTm>
      <NbOfTxs>1</NbOfTxs>
      <CtrlSum>1000.00</CtrlSum>
      <InitgPty>
        <Nm>Acme Corporation</Nm>
        <Id>
          <OrgId>
            <Othr>
              <Id>123456789</Id>
            </Othr>
          </OrgId>
        </Id>
      </InitgPty>
    </GrpHdr>
    <!-- Payment Instructions -->
  </CstmrCdtTrfInitn>
</Document>
```

## BNC Configuration

### EBICS Gateway

```yaml
# EBICS Server Configuration
ebics:
  host: ebics.bnc.ca
  port: 443
  protocol: H005
  encryption:
    algorithm: RSA-4096
    signing: SHA-256
  certificates:
    bank_x002: /certs/bnc_x002.pem
    bank_e002: /certs/bnc_e002.pem
  partners:
    - partner_id: ACMECORP
      user_ids:
        - ACME_TREAS01
        - ACME_TREAS02
      permissions:
        upload:
          - CCT  # Credit Transfer
          - CDD  # Direct Debit
        download:
          - STA  # Statements
          - VMK  # Payment Status
```

### API Endpoints

```typescript
// BNC Banking API
@Controller('banking/sap')
export class SapBankingController {
  // Get account balances
  @Get('accounts/:accountId/balance')
  async getBalance(@Param('accountId') accountId: string) {
    return this.bankingService.getAccountBalance(accountId);
  }

  // Submit payment
  @Post('payments')
  async submitPayment(@Body() payment: Pain001) {
    return this.paymentService.processPayment(payment);
  }

  // Get statement
  @Get('accounts/:accountId/statement')
  async getStatement(
    @Param('accountId') accountId: string,
    @Query('from') from: Date,
    @Query('to') to: Date,
  ) {
    return this.statementService.generateCamt053(accountId, from, to);
  }
}
```

## Supported Payment Types

### Domestic Transfers (EFT)

- **Timing**: Same-day / Next-day
- **Limit**: $25M per transaction
- **Format**: pain.001 (ISO 20022)
- **Volume**: 300k transactions/month

### International Transfers (SWIFT)

- **Timing**: 1-3 business days
- **Currency**: CAD, USD, EUR, GBP (+ 40 others)
- **Format**: MT103 / pain.001
- **Volume**: 50k transactions/month

### Direct Debits

- **Types**: PAD (Pre-Authorized Debit)
- **Frequency**: Daily, Weekly, Monthly
- **Format**: pain.008 (ISO 20022)
- **Volume**: 150k transactions/month

## Automatic Reconciliation

### Matching Rules

```typescript
// Auto-reconciliation logic
interface ReconciliationRule {
  field: 'reference' | 'amount' | 'date' | 'account';
  tolerance?: number; // For amount matching
  priority: number;
}

const rules: ReconciliationRule[] = [
  { field: 'reference', priority: 1 },
  { field: 'amount', tolerance: 0.01, priority: 2 },
  { field: 'date', priority: 3 },
];

// Matching algorithm
function autoMatch(sapPayment, bankStatement) {
  let score = 0;

  if (sapPayment.reference === bankStatement.reference) score += 100;
  if (Math.abs(sapPayment.amount - bankStatement.amount) <= 0.01) score += 50;
  if (isSameDay(sapPayment.date, bankStatement.date)) score += 25;

  return score >= 150; // Threshold for auto-match
}
```

### Reconciliation Rate

- **Auto-matching**: 95%
- **Manual review**: 5%
- **Exceptions**: < 0.5%

## Metrics

### Performance

- **Transaction volume**: 500k+/month
- **Processing time**: < 2 seconds (p95)
- **Availability**: 99.95%
- **Error rate**: < 0.1%

### Adoption

- **Active clients**: 150+ large enterprises
- **Integrated accounts**: 800+
- **Transaction value**: $2B+/month

### SLA

- **Upload acceptance**: < 30 seconds
- **Statement delivery**: Before 8 AM (next business day)
- **Payment execution**: Same-day (if received before 2 PM)
- **Support**: 24/7 for Tier 1 clients

## Security

### EBICS Security

```

  EBICS 3-Key Security Model

  Authentication (A006) - RSA 4096
  Encryption (E002) - RSA 4096
  Signature (X002) - RSA 4096

```

### Certificate Management

- **Validity**: 3 years
- **Renewal**: Automatic (90 days before expiration)
- **Revocation**: Support immediate revocation
- **Storage**: HSM (Hardware Security Module)

### Message Integrity

- **Digital Signature**: All messages signed
- **Timestamp**: RFC 3161 compliant
- **Non-repudiation**: 7-year archive

## Monitoring

### Dashboards

```yaml
# Prometheus Metrics
- sap_payments_total{status="success|failed"}
- sap_payment_processing_duration_seconds
- sap_statement_generation_duration_seconds
- ebics_upload_total{client_id}
- ebics_download_total{client_id}
```

### Alerts

```yaml
# Alert Rules
groups:
  - name: sap_integration
    rules:
      - alert: HighPaymentFailureRate
        expr: rate(sap_payments_total{status="failed"}[5m]) > 0.05
        for: 10m
        annotations:
          summary: "High payment failure rate detected"

      - alert: EBICSConnectionFailed
        expr: ebics_connection_errors > 3
        for: 5m
        annotations:
          summary: "EBICS connection failing"
```

## Costs

### Infrastructure

- **EBICS Gateway**: $5,000/month (hosting + licenses)
- **SAP PI/PO**: Client-owned
- **BNC API**: Included in platform costs
- **Monitoring**: $1,000/month

### Transaction Fees

- **Setup fee**: $5,000 (one-time)
- **Monthly fee**: $500/account
- **Transaction fee**: $0.50 (domestic), $15 (international)

**Typical client**: $2,000/month (4 accounts + ~500 transactions)

## Documentation

### Getting Started

#### 1. Onboarding

```bash
# Step 1: Request EBICS access
# Contact: sap-integration@bnc.ca

# Step 2: Generate certificates
openssl genrsa -out client_a006.key 4096
openssl req -new -x509 -key client_a006.key -out client_a006.crt

# Step 3: Send certificates to BNC
# Via secure channel

# Step 4: Receive BNC certificates
# bank_x002.crt, bank_e002.crt

# Step 5: Configure SAP BCM
# Transaction: FBCM_SETUP
```

#### 2. Testing

```bash
# Test EBICS connection
ebics-cli --host ebics.bnc.ca --partner TESTCORP --user TEST01 HPB

# Upload test payment
ebics-cli --host ebics.bnc.ca --partner TESTCORP --user TEST01 CCT test_payment.xml

# Download test statement
ebics-cli --host ebics.bnc.ca --partner TESTCORP --user TEST01 STA
```

### Support

- **Documentation**: https://docs.bnc.ca/sap-integration
- **Technical Support**: sap-support@bnc.ca
- **Emergency**: 1-800-BNC-SAP1 (24/7)
- **Training**: Monthly SAP integration workshop

## Roadmap

### Q1 2025

- [ ] Support SAP S/4HANA Cloud
- [ ] Real-time payment notifications (webhooks)
- [ ] Enhanced reconciliation AI

### Q2 2025

- [ ] Multi-currency virtual accounts
- [ ] Instant payments (Real-Time Rail)
- [ ] Expanded ISO 20022 message types

## Client Use Cases

### Manufacturer (Tier 1)

**Profile**:
- 4 CAD/USD accounts
- 500 payments/week (suppliers)
- 100 international transfers/month
- Daily reconciliation

**Benefits**:
- 95% payment automation
- 80% reduction in reconciliation time
- Real-time visibility on cash position

### Distributor (Tier 2)

**Profile**:
- 2 CAD accounts
- 1,000 direct debits/month (customers)
- 200 payments/month (suppliers)

**Benefits**:
- Centralized payment management
- Reduced data entry errors
- Improved cash flow forecasting

## References

- [EBICS Specification](https://www.ebics.org/)
- [ISO 20022 Standards](https://www.iso20022.org/)
- [SAP Bank Communication Management](https://help.sap.com/docs/SAP_S4HANA_ON-PREMISE/86fcaa1673f34f3e8ef74fea814c85b5/4b5dc59b6b0b4e56a37c8eb98fd6d924.html)

## Contacts

- **Product Owner**: Jean-François Morin (jf.morin@bnc.ca)
- **Integration Lead**: Stéphanie Roy (stephanie.roy@bnc.ca)
- **SAP Architect**: Michel Fortin (michel.fortin@bnc.ca)
- **Support**: sap-integration@bnc.ca
