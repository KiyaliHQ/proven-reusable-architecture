---
title: Circuit Breaker Pattern
description: Patron de résilience pour gérer les défaillances de services externes
pra:
  name: Circuit Breaker Pattern
  category: integration
  status: candidate
  tags: [resilience, integration, microservices, fault-tolerance]
  created_at: "2025-12-04"
  updated_at: "2025-12-04"
  proven_in_use:
    - project: Plateforme de Paiement
      team: Équipe Transactions
      date: "2025-10-15"
      feedback: "Réduction de 70% des timeouts et amélioration de l'expérience utilisateur lors de défaillances de services tiers"
---

# Circuit Breaker Pattern

## Vue d'ensemble

Le patron Circuit Breaker est un mécanisme de résilience qui protège les applications contre les défaillances en cascade lorsqu'un service externe devient indisponible ou lent.

## Contexte

### Problème

Dans une architecture distribuée, les appels à des services externes peuvent échouer pour diverses raisons :
- Service temporairement indisponible
- Latence élevée
- Timeout réseau
- Surcharge du service

Sans protection, ces défaillances peuvent :
- Bloquer des threads
- Épuiser les ressources
- Propager les erreurs à travers le système
- Dégrader l'expérience utilisateur globale

### Solution

Le Circuit Breaker agit comme un interrupteur électrique :
- **Closed** (Fermé) : Les requêtes passent normalement
- **Open** (Ouvert) : Les requêtes échouent rapidement (fail-fast)
- **Half-Open** (Semi-ouvert) : Test de récupération du service

## Architecture

### États du Circuit Breaker

```
        Success Count++
    ┌─────────────────────┐
    │                     │
    │      CLOSED         │
    │   (Normal State)    │
    │                     │
    └─────────┬───────────┘
              │
              │ Failure Threshold Exceeded
              ▼
    ┌─────────────────────┐
    │                     │
    │       OPEN          │
    │   (Fail Fast)       │
    │                     │
    └─────────┬───────────┘
              │
              │ Timeout Elapsed
              ▼
    ┌─────────────────────┐
    │                     │
    │    HALF-OPEN        │
    │  (Testing Recovery) │
    │                     │
    └─────────┬───────────┘
              │
              │ Success → Back to CLOSED
              │ Failure → Back to OPEN
```

## Architecture Decision Records (ADRs)

### ADR-001: Utilisation de Resilience4j

**Date**: 2025-10-01

**Statut**: Accepté

**Contexte**: Besoin d'une bibliothèque Java mature pour implémenter le Circuit Breaker.

**Décision**: Utiliser Resilience4j comme bibliothèque de résilience.

**Raisons**:
- Bibliothèque légère (sans dépendances externes lourdes)
- API fonctionnelle moderne (Java 8+)
- Intégration native avec Spring Boot
- Support de métriques (Micrometer)
- Documentation complète

**Conséquences**:
- **Positives**:
  - Configuration simple via annotations
  - Monitoring intégré
  - Testabilité élevée
- **Négatives**:
  - Courbe d'apprentissage pour concepts de programmation fonctionnelle

## Exemples

### Configuration Spring Boot

```yaml
# application.yml
resilience4j.circuitbreaker:
  configs:
    default:
      registerHealthIndicator: true
      slidingWindowSize: 10
      minimumNumberOfCalls: 5
      permittedNumberOfCallsInHalfOpenState: 3
      automaticTransitionFromOpenToHalfOpenEnabled: true
      waitDurationInOpenState: 5s
      failureRateThreshold: 50
      eventConsumerBufferSize: 10
  instances:
    paymentService:
      baseConfig: default
```

### Implémentation Java

```java
@Service
public class PaymentService {

    @CircuitBreaker(name = "paymentService", fallbackMethod = "fallbackPayment")
    public PaymentResponse processPayment(PaymentRequest request) {
        // Appel au service externe
        return externalPaymentGateway.process(request);
    }

    private PaymentResponse fallbackPayment(PaymentRequest request, Exception ex) {
        // Réponse de secours
        return PaymentResponse.builder()
            .status(PaymentStatus.PENDING)
            .message("Payment will be processed later")
            .build();
    }
}
```

## Feedback de Production

### Plateforme de Paiement (Octobre 2025)

**Contexte**: Intégration avec passerelle de paiement tierce parfois instable.

**Implémentation**:
- Circuit Breaker avec seuil de 50% d'erreurs
- Fenêtre glissante de 10 requêtes
- Timeout de 5 secondes en état Open
- Fallback vers mise en queue des paiements

**Résultats**:
- ✅ Réduction de 70% des timeouts utilisateur
- ✅ Diminution de 85% des erreurs 500
- ✅ Temps de réponse moyen amélioré de 40%
- ✅ Expérience utilisateur maintenue même lors de défaillances

**Défis Rencontrés**:
- Calibrage initial des seuils (trop sensible au début)
- Formation des développeurs aux concepts de résilience
- Gestion des états transitoires (Half-Open)

**Leçons Apprises**:
- Commencer avec des seuils conservateurs et ajuster progressivement
- Monitorer les métriques du Circuit Breaker (dashboard dédié)
- Tester les scénarios de fallback régulièrement

## Considérations

### Performance

- Overhead négligeable (~1-2ms par requête)
- Amélioration significative lors de défaillances (fail-fast)

### Monitoring

- Exporter les métriques vers Prometheus/Grafana
- Alertes sur transitions fréquentes Open/Closed
- Dashboards pour visualiser l'état des circuits

## Voir Aussi

- [Retry Pattern](../retry-pattern.md) - Complémentaire au Circuit Breaker
- [Timeout Pattern](../timeout-pattern.md) - Protection contre les appels lents
- [Bulkhead Pattern](../bulkhead-pattern.md) - Isolation des ressources

## Références

- [Resilience4j Documentation](https://resilience4j.readme.io/)
- [Martin Fowler - Circuit Breaker](https://martinfowler.com/bliki/CircuitBreaker.html)
- [Release It! - Michael Nygard](https://pragprog.com/titles/mnee2/release-it-second-edition/)
