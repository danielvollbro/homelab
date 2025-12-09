# ADR-003: Secret Management via SOPS

- Status: accepted
- Date: 2025-12-04
- Decision owner: Daniel Vollbro

## Context

We are adopting a GitOps approach (Flux v2) where the entire cluster state is
defined in a public/private Git repository. Kubernetes Secrets (API tokens,
passwords, private keys) cannot be stored in Git in plain text due to security
risks. We need a way to encrypt secrets at rest in the repo but have them
decrypted automatically inside the cluster.

## Decision

We will use **Mozilla SOPS** (Secrets OPerationS) with **Age** encryption.

## Alternatives considered

- **Bitnami Sealed Secrets:** A popular choice, but requires a controller to
encrypt secrets. If the cluster is lost, the encryption key might be lost if not
backed up separately.
- **HashiCorp Vault:** Too complex and resource-heavy for the current scale.
- **Kubernetes Secrets (Plain):** Rejected. Unacceptable security risk in Git.

## Rationale

SOPS allows us to encrypt specific values in YAML files while keeping keys
(metadata) readable.
1.  **Git Friendly:** Encrypted files can be diffed and versioned.
2.  **Offline Workflow:** Developers can encrypt/decrypt locally without needing
to talk to the cluster API.
3.  **Flux Integration:** Flux has native support for SOPS/Age, making the
decryption process transparent during reconciliation.

## Consequences

### Positive

- Secrets are encrypted at rest in the Git repository.
- No need for an external "Secrets Manager" service.
- "Zero Touch" restore capability (as long as the private Age key is backed up).

### Negative

- Management of the private `age.agekey` is critical. If lost, all secrets are
unrecoverable.
- Adds an extra step (`sops -e`) to the development workflow.

## Follow-up

- Ensure `age.agekey` is stored in a secure Password Manager (Bitwarden).
- Configure `.sops.yaml` to strictly define which files are encrypted.

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
