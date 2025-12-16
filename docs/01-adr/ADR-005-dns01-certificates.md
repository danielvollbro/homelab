# ADR-005: TLS Certificates via DNS-01 Challenge

- Status: accepted
- Date: 2025-12-04
- Decision owner: Daniel Vollbro

## Context

All services (internal and external) must be secured via HTTPS. We use
Let's Encrypt for free certificates. The standard validation method (HTTP-01)
requires opening Port 80 to the public internet for every domain validation,
which exposes the cluster to scanning and attacks. Furthermore, HTTP-01 cannot
issue Wildcard certificates.

## Decision

We will use the **DNS-01 Challenge** via **Cert-Manager** and
the **Cloudflare API**.

Cert-Manager will prove ownership of the domain by creating temporary TXT
records in the DNS zone, allowing Let's Encrypt to issue certificates without
any incoming traffic to the cluster.

## Alternatives considered

- **HTTP-01 Challenge:** Rejected. Requires opening Port 80, does not support
wildcards, and exposes internal service names if not careful.
- **Self-Signed Certificates:** Rejected. Causes browser warnings and breaks
automated tools/CI pipelines.
- **Manual Upload:** Rejected. Too much toil to renew every 90 days.

## Rationale

1.  **Security:** No need to open firewalls for validation.
2.  **Wildcards:** Enables issuance of `*.vollbro.se`, simplifying Ingress
configuration (one cert for all subdomains).
3.  **Internal Services:** Allows valid TLS certificates for services that are
strictly internal (VPN/LAN only) and not exposed to the internet.

## Consequences

### Positive

- Valid, trusted HTTPS for all services.
- Ability to use Wildcard certificates.
- Network topology remains hidden/closed during validation.

### Negative

- Hard dependency on Cloudflare DNS and their API availability.
- Requires managing a high-privilege API Token within the cluster.

## Follow-up

- Monitor Cloudflare API token expiration.
- Implement alerts for certificate expiration (as a failsafe).

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
