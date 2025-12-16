# ADR-006: Separate Prod and Staging Clusters

- Status: accepted
- Date: 2025-12-16
- Decision owner: Daniel Vollbro

## Context

To ensure system stability and high availability, I need the ability to validate
changes before they affect production workloads.
While application-level testing can often be handled via logic separation
(namespaces), I also need to validate **infrastructure-level** changes.
This includes:
* Upgrading the Operating System (Talos Linux) and Kubernetes versions.
* Replacing or reconfiguring core network components (CNI, BGP, MetalLB,
Cilium).
* Testing disaster recovery procedures that involve cluster
destruction/recreation.

Performing these tests in a shared environment poses a significant risk to
running services.

## Decision

I will provision **separate Talos Kubernetes Clusters** (`k8s-prod` and
`k8s-staging`) on Proxmox. This ensures complete isolation at the infrastructure
level, allowing for aggressive testing of core components without risking the
stability of production services.

## Alternatives considered

- **Single Cluster with Namespaces:** Rejected.
  While namespace isolation is sufficient for application testing, it shares the
  same Control Plane, CNI (Container Network Interface), and OS kernel. A
  misconfiguration in the networking layer or a failed OS upgrade in "staging"
  would bring down the entire cluster, causing a production outage.

- **vCluster (Virtual Clusters):** Rejected.
  Although vCluster provides better isolation than namespaces, it still relies
  on the host cluster's underlying networking and storage drivers. It does not
  allow for accurate testing of bare-metal/OS-level upgrades or CNI
  replacements.

## Rationale

The primary driver for this decision is the need to experiment with the
**Platform** itself, not just the applications running on top of it.
Since this environment utilizes Talos Linux and GitOps for immutable
infrastructure, the "Infrastructure as Code" (IaC) needs to be tested just as
rigorously as application code.

By separating the clusters:
1.  **Blast Radius Containment:** A catastrophic failure in Staging (e.g.,
breaking the CNI) has zero impact on Production.
2.  **Lifecycle Management:** I can validate Talos OS upgrades and Kubernetes
minor version bumps in Staging weeks before rolling them out to Prod.
3.  **Security:** Complete network segmentation ensures that experimental
workloads cannot access production secrets or databases.

## Consequences

### Positive
* **Safe Experimentation:** Enables "fearless" testing of deep infrastructure
changes (e.g., swapping kube-proxy for Cilium, changing BGP peers).
* **True Production Parity:** The staging cluster can be an exact replica of
production, ensuring that configuration drifts are caught early.
* **Disaster Recovery Training:** Provides a safe environment to practice
cluster restoration from backups (Velero).

### Negative
* **Resource Overhead:** Requires dedicated resources (CPU/RAM) for a second
Control Plane and system pods (Prometheus, Cert-Manager, Flux) which increases
the baseline footprint on the Proxmox hypervisors.
* **Management Complexity:** Maintenance effort increases as two distinct
clusters must be patched and monitored.
* **GitOps Complexity:** The Flux repository structure must handle multi-cluster
configuration (e.g., via `overlays` or separate directories), increasing the
complexity of the codebase.

## Follow-up

* Refine the Terraform code to allow the Staging cluster to be **ephemeral**
(spun up/down on demand) to mitigate resource overhead when not actively
testing.
* Restructure the GitOps repository (`gitops/flux/`) to support a base/overlay
structure that shares common configurations between Prod and Staging to reduce
code duplication.

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
