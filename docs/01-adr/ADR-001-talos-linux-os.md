# ADR-001: Adoption of Talos Linux as Kubernetes OS

- Status: accepted
- Date: 2025-11-22
- Decision owner: Daniel Vollbro

## Context

We require a robust, secure, and low-maintenance operating system to host the
Kubernetes control plane and worker nodes. The environment is a homelab/small
enterprise setup where minimizing administrative overhead ("Toil") is critical.
Traditional Linux distributions require ongoing package management, security
patching, and configuration management (Ansible/Puppet), which diverts time from
platform development.

## Decision

We will use **Talos Linux** for all Kubernetes nodes.

Talos is an immutable, API-first operating system designed specifically for
Kubernetes. It excludes SSH, shell, and package managers entirely.

## Alternatives considered

- **Ubuntu Server / Debian:** The standard choice. Rejected due to the
maintenance burden (apt-get update, mutable state, configuration drift).
- **k3OS:** Previously popular but now unmaintained/deprecated.
- **Flatcar Container Linux:** A strong contender, but Talos was preferred for
its strictly API-driven configuration model which fits better with Terraform.

## Rationale

Talos aligns perfectly with our "Infrastructure as Code" strategy.
1.  **Immutability:** Nodes are configured via a single YAML manifest. Updates
are performed by swapping the OS image, ensuring the system is always in a known
state.
2.  **Security:** By removing SSH and the console, the attack surface is
drastically reduced.
3.  **Automation:** The machine configuration can be generated and applied
directly via Terraform, eliminating the need for a separate configuration
management layer like Ansible.

## Consequences

### Positive

- Drastic reduction in OS maintenance overhead.
- Enhanced security posture (read-only filesystem, no SSH).
- Simplified upgrades via API.

### Negative

- Steep learning curve for debugging (requires `talosctl` instead of SSH).
- Some CSI drivers or specialized workloads require specific configuration
overrides (e.g., mounting writable paths) to work on a read-only FS.

## Follow-up

- Maintain the `talosctl` config and certificates securely.
- Document the upgrade procedure using Terraform.

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
