---
title: Circuit Breaker Pattern
description: Resilience pattern to manage external service failures
pra:
  name: Circuit Breaker Pattern
  category: integration
  status: candidate
  tags: [resilience, integration, microservices, fault-tolerance]
  created_at: "2025-12-04"
  updated_at: "2025-12-04"
  proven_in_use:
    - project: Payment Platform
      team: Transactions Team
      date: "2025-10-15"
      feedback: "70% reduction in timeouts and improved user experience during third-party service failures"
---

# Circuit Breaker Pattern

## Overview

The Circuit Breaker pattern is a resilience mechanism that protects applications against cascading failures when an external service becomes unavailable or slow.

## Context

### Problem

In a distributed architecture, calls to external services can fail for various reasons:
- Temporarily unavailable service
- High latency
- Network timeout
- Service overload

Without protection, these failures can:
- Block threads
- Exhaust resources
- Propagate errors throughout the system
- Degrade overall user experience

### Solution

The Circuit Breaker acts like an electrical circuit breaker:
- **Closed**: Requests pass through normally
- **Open**: Requests fail fast
- **Half-Open**: Testing service recovery

## Architecture

### Circuit Breaker States

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

### ADR-001: Using Resilience4j

**Date**: 2025-10-01

**Status**: Accepted

**Context**: Need for a mature Java library to implement Circuit Breaker.

**Decision**: Use Resilience4j as the resilience library.

**Reasons**:
- Lightweight library (no heavy external dependencies)
- Modern functional API (Java 8+)
- Native integration with Spring Boot
- Metrics support (Micrometer)
- Complete documentation

**Consequences**:
- **Positives**:
  - Simple configuration via annotations
  - Integrated monitoring
  - High testability
- **Negatives**:
  - Learning curve for functional programming concepts

## Examples

### Spring Boot Configuration

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

### Java Implementation

```java
@Service
public class PaymentService {

    @CircuitBreaker(name = "paymentService", fallbackMethod = "fallbackPayment")
    public PaymentResponse processPayment(PaymentRequest request) {
        // External service call
        return externalPaymentGateway.process(request);
    }

    private PaymentResponse fallbackPayment(PaymentRequest request, Exception ex) {
        // Fallback response
        return PaymentResponse.builder()
            .status(PaymentStatus.PENDING)
            .message("Payment will be processed later")
            .build();
    }
}
```

## Production Feedback

### Payment Platform (October 2025)

**Context**: Integration with sometimes unstable third-party payment gateway.

**Implementation**:
- Circuit Breaker with 50% error threshold
- Sliding window of 10 requests
- 5-second timeout in Open state
- Fallback to payment queue

**Results**:
- ✅ 70% reduction in user timeouts
- ✅ 85% decrease in 500 errors
- ✅ 40% improvement in average response time
- ✅ User experience maintained even during failures

**Challenges Encountered**:
- Initial threshold calibration (too sensitive at first)
- Developer training on resilience concepts
- Managing transient states (Half-Open)

**Lessons Learned**:
- Start with conservative thresholds and adjust progressively
- Monitor Circuit Breaker metrics (dedicated dashboard)
- Test fallback scenarios regularly

## Considerations

### Performance

- Negligible overhead (~1-2ms per request)
- Significant improvement during failures (fail-fast)

### Monitoring

- Export metrics to Prometheus/Grafana
- Alerts on frequent Open/Closed transitions
- Dashboards to visualize circuit states

## See Also

- [Retry Pattern](../retry-pattern.md) - Complementary to Circuit Breaker
- [Timeout Pattern](../timeout-pattern.md) - Protection against slow calls
- [Bulkhead Pattern](../bulkhead-pattern.md) - Resource isolation

## References

- [Resilience4j Documentation](https://resilience4j.readme.io/)
- [Martin Fowler - Circuit Breaker](https://martinfowler.com/bliki/CircuitBreaker.html)
- [Release It! - Michael Nygard](https://pragprog.com/titles/mnee2/release-it-second-edition/)
