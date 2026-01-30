---
title: Patron d'Onboarding Client via API
description: Architecture standardisée pour l'intégration digitale des nouveaux clients en gestion de patrimoine via des APIs sécurisées
pra:
  name: Patron d'Onboarding Client via API
  category: business
  status: candidate
  tags: [onboarding, api, client, digital, gestion-patrimoine, kyc, compliance]
  created_at: "2025-12-04"
  updated_at: "2025-12-04"
  proven_in_use:
    - project: Plateforme Mobile Gestion Privée
      team: Équipe Digitale Gestion de Patrimoine
      date: "2025-10-15"
      feedback: "Réduction de 65% du temps d'onboarding client. Architecture API-first a permis l'intégration facile avec les partenaires externes (comptables, notaires). La validation KYC automatisée a éliminé 80% des erreurs manuelles. Le design modulaire facilite l'ajout de nouveaux types de clients (PME, fondations)."
---

## Overview

Le **Patron d'Onboarding Client via API** est une architecture standardisée conçue pour automatiser et sécuriser le processus d'intégration des nouveaux clients en gestion de patrimoine. Ce patron permet aux conseillers et aux clients d'initier et de compléter le parcours d'onboarding de manière digitale, tout en respectant les exigences réglementaires strictes (KYC, AML, conformité FINRA).

### Problématique

En gestion de patrimoine, l'onboarding client traditionnel est :
- **Lent** : 4-6 semaines pour compléter un dossier
- **Manuel** : Saisie répétée des mêmes informations dans plusieurs systèmes
- **Fragmenté** : Processus différents selon le type de client (particulier fortuné, entreprise, fondation)
- **Non digital** : Documents papier, signatures physiques, validation manuelle

### Solution

Ce PRA propose une architecture API-first qui :
- Unifie le parcours d'onboarding pour tous les types de clients
- Intègre validation KYC/AML en temps réel
- Permet la signature électronique sécurisée
- Orchestre les workflows multi-systèmes (CRM, Core Banking, Compliance)
- Offre une expérience utilisateur fluide (web, mobile, partenaires externes)

## Context

### Cas d'Usage

**Scénario 1 : Onboarding Client Particulier Fortuné**
1. Conseiller initie dossier depuis CRM
2. Client reçoit lien sécurisé pour compléter profil
3. Upload documents (ID, preuve résidence, déclaration fiscale)
4. Signature électronique contrat de gestion
5. Validation KYC automatique (score de risque, PEP check)
6. Approbation finale par conseiller
7. Création compte Core Banking

**Scénario 2 : Onboarding via Partenaire Externe (Comptable)**
1. Comptable soumet dossier client via API partenaire
2. Pre-remplissage automatique des informations fiscales
3. Client complète informations manquantes via portail
4. Validation conforme, approbation accélérée
5. Activation compte

### Contexte Métier

**Domaine** : Gestion de Patrimoine
- Clients : Particuliers fortunés, PME, fondations, trusts
- Réglementation : FINRA, SEC, KYC/AML, GDPR
- Acteurs : Conseillers, clients, compliance, opérations

**Contraintes Spécifiques**
- Conformité stricte (audit trail complet)
- Confidentialité maximale (données sensibles)
- Disponibilité 24/7 (clients internationaux)
- Intégration avec systèmes legacy (mainframe Core Banking)

## Architecture

### Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENTS                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Portail Web  │  │  Mobile App  │  │ API Externe  │         │
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

### Composants Clés

**1. Onboarding Service (Orchestrateur)**
- **Responsabilité** : Gère le workflow complet d'onboarding
- **Technologie** : Node.js + Express + Bull (queue)
- **Patterns** : State Machine (états : INITIATED, DOCS_PENDING, KYC_PENDING, APPROVED, REJECTED)
- **Base de données** : PostgreSQL (données transactionnelles) + Redis (cache)

**2. Document Service**
- **Responsabilité** : Upload, validation, OCR, stockage documents
- **Technologie** : Python + FastAPI + Tesseract OCR
- **Stockage** : AWS S3 (chiffré au repos)
- **Validation** : Format (PDF, JPEG), taille, détection fraude

**3. KYC/AML Service**
- **Responsabilité** : Vérification identité, scoring risque, checks réglementaires
- **Technologie** : Java Spring Boot
- **Intégrations** : APIs tierces (LexisNexis, Thomson Reuters)
- **Output** : Score de risque (0-100), recommandation (AUTO_APPROVE, MANUAL_REVIEW, REJECT)

**4. Signature Service**
- **Responsabilité** : Signature électronique légalement contraignante
- **Technologie** : Intégration DocuSign API
- **Conformité** : eIDAS (EU), ESIGN Act (US)

**5. Core Banking Adapter**
- **Responsabilité** : Bridge vers système legacy
- **Technologie** : MQ/Kafka pour messaging asynchrone
- **Transformation** : Conversion JSON → Format mainframe (COBOL copybook)

### Flux de Données

**Étape 1 : Initiation**
```
Conseiller (CRM) → API Gateway → Onboarding Service → Event: ONBOARDING_INITIATED
```

**Étape 2 : Collecte Documents**
```
Client → Portail Web → API Gateway → Document Service → S3 Storage
                                   → Event: DOCUMENTS_UPLOADED
                                   → Onboarding Service (transition état)
```

**Étape 3 : Validation KYC**
```
Onboarding Service → KYC/AML Service → LexisNexis API
                                     → Event: KYC_COMPLETED (score, recommendation)
```

**Étape 4 : Signature**
```
Onboarding Service → Signature Service → DocuSign API → Client (email)
Client signe → Event: CONTRACT_SIGNED
```

**Étape 5 : Création Compte**
```
Onboarding Service → Core Banking Adapter → Kafka Topic
                                          → Core Banking (mainframe)
                                          → Event: ACCOUNT_CREATED
```

### Sécurité

**Authentification & Autorisation**
- OAuth 2.0 + OpenID Connect (OIDC)
- JWT tokens (expiration 15 min)
- Refresh tokens (7 jours)
- Role-Based Access Control (RBAC) : CLIENT, CONSEILLER, COMPLIANCE, ADMIN

**Chiffrement**
- TLS 1.3 pour transit
- AES-256 pour données au repos (S3, DB)
- Clés gérées via AWS KMS

**Audit & Conformité**
- Tous les événements loggés (GDPR compliant)
- Immutable audit trail (blockchain pour preuves légales)
- Retention : 7 ans (exigence réglementaire)

## ADRs

### ADR-001 : Choix du Pattern State Machine pour Workflow

**Contexte**
Le processus d'onboarding comporte de nombreuses étapes avec dépendances complexes, branches conditionnelles (ex: KYC manuel vs automatique), et nécessite une traçabilité complète.

**Décision**
Implémenter le workflow comme une State Machine avec états explicites et transitions validées.

**Alternatives Considérées**
1. **Workflow linéaire simple** : Rejeté - trop rigide, ne gère pas les cas d'exception
2. **Business Process Model (BPMN)** : Rejeté - overhead trop élevé pour notre cas
3. **Event Sourcing pur** : Rejeté - complexité inutile pour ce use case

**Conséquences**
- ✅ Lisibilité accrue du code (états et transitions explicites)
- ✅ Testabilité : chaque transition testable indépendamment
- ✅ Traçabilité : historique complet des changements d'état
- ❌ Complexité initiale de setup
- ❌ Risque de "state explosion" si mal géré

**États Définis**
```
INITIATED → DOCUMENTS_PENDING → DOCUMENTS_UPLOADED → KYC_PENDING
  → KYC_APPROVED → SIGNATURE_PENDING → SIGNED → ACCOUNT_CREATION_PENDING
  → COMPLETED

États d'erreur :
  - KYC_REJECTED
  - COMPLIANCE_HOLD
  - INCOMPLETE (timeout)
```

### ADR-002 : Architecture API-First avec Core Banking Legacy

**Contexte**
Le Core Banking est un système mainframe (COBOL) sans APIs REST. L'accès direct nécessite des transformations de données complexes.

**Décision**
Créer un **Adapter Layer** dédié utilisant messaging asynchrone (Kafka) pour découpler l'onboarding moderne du legacy.

**Alternatives Considérées**
1. **Appels synchrones MQ** : Rejeté - timeout fréquents, couplage fort
2. **Modifier le Core Banking** : Rejeté - trop coûteux, risqué
3. **ESB (Enterprise Service Bus)** : Rejeté - overhead, vendor lock-in

**Conséquences**
- ✅ Découplage : Onboarding Service ne connaît pas le format mainframe
- ✅ Résilience : Queue Kafka gère les pannes temporaires
- ✅ Évolutivité : Facile de remplacer le Core Banking plus tard
- ❌ Complexité opérationnelle (Kafka cluster à gérer)
- ❌ Latence supplémentaire (asynchrone)

**Implémentation**
```javascript
// Onboarding Service publie un événement
const event = {
  type: 'CREATE_ACCOUNT',
  clientId: '12345',
  profile: { name, ssn, address, ... },
  timestamp: Date.now()
};
await kafka.publish('core-banking-commands', event);

// Core Banking Adapter consomme, transforme, envoie au mainframe
```

### ADR-003 : Validation KYC Hybride (Auto + Manuelle)

**Contexte**
La validation KYC 100% automatique peut rejeter des clients légitimes (faux négatifs). La validation 100% manuelle est lente et coûteuse.

**Décision**
Système **hybride avec score de confiance** :
- Score ≥ 80 : Approbation automatique
- Score 50-79 : Revue manuelle (Compliance Team)
- Score < 50 : Rejet automatique

**Alternatives Considérées**
1. **Approbation automatique systématique** : Rejeté - risque réglementaire inacceptable
2. **Revue manuelle systématique** : Rejeté - trop lent (4-6 semaines)

**Conséquences**
- ✅ Balance vitesse/conformité : 70% des dossiers approuvés en < 24h
- ✅ Réduit charge Compliance Team
- ❌ Nécessite maintenance du modèle de scoring (ML drift)
- ❌ Complexité de justification des décisions automatiques

**Scoring Factors**
```yaml
Facteurs positifs (+):
  - Documents valides (OCR confirmé) : +20
  - Adresse vérifiée (base de données postale) : +15
  - Pas de PEP/sanctions : +25
  - Score crédit élevé : +20

Facteurs négatifs (-):
  - Documents expirés : -30
  - Incohérences données : -40
  - PEP détecté : -50
  - Pays à haut risque : -25
```

## Examples

### Exemple 1 : API Client - Initier Onboarding

**Endpoint** : `POST /api/v1/onboarding/initiate`

**Request**
```json
{
  "clientType": "INDIVIDUAL",
  "initiatedBy": "CONSEILLER",
  "conseillerEmail": "jean.dupont@bnc.ca",
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

### Exemple 2 : Webhook KYC Completed

**Événement reçu du KYC Service**
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

**Action du Onboarding Service**
```javascript
async function handleKycCompleted(event) {
  const { onboardingId, kycResult } = event;

  // Mettre à jour état
  await db.onboardings.update(onboardingId, {
    status: 'KYC_APPROVED',
    kycScore: kycResult.score,
    kycCompletedAt: kycResult.completedAt
  });

  // Déclencher prochaine étape (signature)
  if (kycResult.recommendation === 'AUTO_APPROVE') {
    await triggerSignatureStep(onboardingId);
  } else if (kycResult.recommendation === 'MANUAL_REVIEW') {
    await notifyComplianceTeam(onboardingId);
  }

  // Publier événement
  await eventBus.publish('onboarding.kyc.approved', {
    onboardingId,
    timestamp: Date.now()
  });
}
```

### Exemple 3 : Core Banking Adapter - Transformation Message

**Message Kafka (JSON moderne)**
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

**Transformation vers format mainframe (COBOL copybook)**
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

**Code Adapter**
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

### Ce qui Fonctionne Bien

**1. Architecture API-First**
- Adoption rapide par les équipes mobiles (3 semaines pour intégrer)
- Partenaires externes (comptables, notaires) intégrés en < 1 mois
- Réutilisation : même API utilisée par web, mobile, et partenaires

**2. State Machine pour Workflow**
- Debugging facilité : état visible à tout moment
- Reprise après erreur : on sait exactement où reprendre
- Testing : chaque transition testée indépendamment (couverture 95%)

**3. Validation KYC Hybride**
- 70% d'approbations automatiques (< 24h)
- 20% revues manuelles (2-3 jours)
- 10% rejets automatiques
- Taux de faux positifs < 2%

### Défis Rencontrés

**1. Latence du Core Banking Legacy**
- **Problème** : Création compte peut prendre 5-10 minutes (mainframe surchargé)
- **Solution** : Découplage asynchrone (client notifié par email quand compte prêt)
- **Amélioration Future** : Migration vers Core Banking moderne (cloud-native)

**2. Gestion des Documents Volumineux**
- **Problème** : Upload de PDF de 50+ MB bloque l'API
- **Solution** : Pre-signed URLs S3 (client upload directement vers S3, API reçoit seulement metadata)
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

**3. Cohérence Données Multi-Systèmes**
- **Problème** : Données client dupliquées dans CRM, Onboarding DB, Core Banking
- **Solution** : Event Sourcing partiel (événements diffusés à tous les systèmes)
- **Pattern** : Customer Data Hub (CDC sur Core Banking → Event Bus → Sync vers autres systèmes)

### Métriques de Succès

**Avant PRA**
- Temps d'onboarding : 4-6 semaines
- Taux d'abandon : 45%
- Erreurs saisie manuelle : 25%
- Coût par onboarding : $450

**Après PRA (6 mois)**
- Temps d'onboarding : 2-5 jours (réduction 90%)
- Taux d'abandon : 18% (réduction 60%)
- Erreurs saisie : 5% (réduction 80%)
- Coût par onboarding : $120 (réduction 73%)
- Satisfaction client (NPS) : +35 points

## Trade-offs

### Complexité vs Flexibilité

**Choix** : Architecture microservices (5 services distincts)

**Avantages** :
- Scaling indépendant (Document Service peut scaler sans Onboarding Service)
- Déploiement indépendant (KYC Service peut être mis à jour sans downtime global)
- Résilience : panne d'un service n'affecte pas les autres

**Inconvénients** :
- Overhead opérationnel : 5 services à monitorer, déployer, sécuriser
- Complexité debugging : traces distribuées nécessaires (Jaeger)
- Latence réseau : appels inter-services ajoutent 50-100ms

**Quand Éviter** :
- Volume faible (< 100 onboardings/mois) : monolithe modulaire suffit
- Équipe < 5 développeurs : complexité opérationnelle trop élevée

### Validation KYC : Vitesse vs Conformité

**Choix** : Approbation automatique pour score ≥ 80

**Avantages** :
- 70% des dossiers approuvés en < 24h (vs 2-4 semaines)
- Expérience client supérieure
- Charge réduite pour Compliance Team

**Inconvénients** :
- Risque réglementaire : audit peut questionner décisions auto
- Nécessite ML Ops (monitoring drift, re-training modèle)
- Dépendance aux APIs tierces (LexisNexis downtime = blocage)

**Quand Éviter** :
- Juridiction ultra-stricte (ex: Suisse, certains états US)
- Absence d'expertise ML dans l'équipe
- Budget limité (APIs KYC tierces coûteuses)

### Synchrone vs Asynchrone avec Core Banking

**Choix** : Messaging asynchrone (Kafka)

**Avantages** :
- Résilience : queue persiste les messages en cas de panne
- Découplage : Onboarding ne bloque pas si mainframe lent
- Évolutivité future : facile de remplacer Core Banking

**Inconvénients** :
- Latence : client attend email confirmation (vs réponse immédiate)
- Complexité : Kafka cluster à opérer (3+ brokers pour HA)
- Debugging : plus difficile de tracer les erreurs

**Quand Éviter** :
- Si Core Banking moderne avec APIs REST rapides (< 2s)
- Si besoin de confirmation immédiate (ex: transfert bancaire temps réel)

## Related Patterns

**Patterns Utilisés dans ce PRA**
- **State Machine Pattern** : Gestion workflow avec états explicites
- **Saga Pattern** : Transactions distribuées (rollback si échec étape)
- **Adapter Pattern** : Core Banking Adapter isole le legacy
- **Event Sourcing (partiel)** : Audit trail immuable pour compliance

**Patterns Complémentaires**
- **Circuit Breaker** : Protéger contre pannes KYC API tierce
- **CQRS** : Séparer lecture (dashboard conseiller) et écriture (workflow)
- **Bulkhead** : Isolation des pools de threads par service

## Références

**Documentation Interne**
- [API Gateway Standards](../tech/api-gateway.md)
- [Event-Driven Architecture Guidelines](../tech/event-driven.md)
- [Compliance & Audit Requirements](../../guides/compliance-guide.md)

**Outils & Technologies**
- Node.js + Express : https://expressjs.com/
- Bull (Job Queue) : https://github.com/OptimalBits/bull
- DocuSign API : https://developers.docusign.com/
- AWS S3 : https://aws.amazon.com/s3/
- Apache Kafka : https://kafka.apache.org/

**Réglementation**
- FINRA Rule 2090 (Know Your Customer) : https://www.finra.org/rules-guidance/rulebooks/finra-rules/2090
- eIDAS (EU Digital Signatures) : https://ec.europa.eu/digital-building-blocks/wikis/display/DIGITAL/eIDAS

---

**Auteur** : Équipe Digitale Gestion de Patrimoine
**Date de Création** : 2025-12-04
**Dernière Mise à Jour** : 2025-12-04
**Statut** : Candidate (1 implémentation validée)
**Contact** : digital-patrimoine@bnc.ca
