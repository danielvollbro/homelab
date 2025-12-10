# GitOps Repository Structure

## Description

This document outlines the organization of the Git repository used to drive the
Kubernetes cluster state via **Flux v2**. It defines the directory layout,
reconciliation order, and the separation of concerns using
**Kustomize Overlays** to manage multiple environments (Production, Staging)
from a single codebase.

## Design Philosophy

The repository structure is architected to eliminate code duplication while
ensuring strict dependency management between system components.

* **Base & Overlays:** We utilize the **Kustomize** pattern.
  * `base/`: Contains common resources shared across all environments (e.g.,
    HelmRelease definitions).
  * `overlays/`: Contains environment-specific patches (e.g., IP addresses,
    Issuer URLs, Hostnames).
* **Layered Reconciliation:** The cluster is reconciled in strict stages
  (`Controllers` -> `Configs` -> `Apps`). This ensures that software, CRDs, and
  Network Pools are fully operational before certificates or applications try to
  use them.
* **Git as Single Source of Truth:** Manual changes to the cluster
  (`kubectl edit`) are prohibited and will be reverted by Flux.

## Directory Hierarchy

The repository is organized into logical layers separating Infrastructure (Terraform) from Cluster State (Flux).

```text
.
├── gitops/flux/                 # CLUSTER STATE (Managed by Flux)
│   ├── infrastructure/
│   │   ├── controllers/         # LAYER 1: Core Software & Network
│   │   │   ├── base/            # Base HelmReleases (Cilium, Cert-Manager, Ingress)
│   │   │   └── overlays/prod/   # Prod specific: IP Pools, Ingress Service Patches
│   │   │
│   │   └── configs/             # LAYER 2: Configuration & CRDs
│   │       ├── base/            # Base Configs (ClusterIssuer)
│   │       └── overlays/prod/   # Prod specific: Wildcard Cert, Issuer Patches
│   │
│   └── apps/                    # LAYER 3: Workloads
│       ├── base/                # Base Applications (GitLab)
│       └── overlays/prod/       # Prod specific: Hostnames, Secrets, Resources
│
└── infrastructure/              # PROVISIONING STATE (Managed by Terraform)
    ├── 01-hypervisors/          # LAYER 0: Physical Hardware (Proxmox)
    ├── 02-platforms/            # LAYER 1: Virtual Infrastructure (K8s VMs)
    └── 03-legacy/               # Standalone/Legacy Systems
```

## Dependency & Reconciliation Flow

Flux reconciles these layers sequentially based on `dependsOn` definitions
managed by Terraform.

| Layer              | Flux Path (Prod)                                       | Description                                                     | Dependencies |
| :----------------- | :----------------------------------------------------- | :-------------------------------------------------------------- | :----------- |
| **0. Bootstrap**   | `infrastructure/02-platforms/k8s-prod`                 | Provisions VMs & Installs Flux                                  | None         |
| **1. Controllers** | `gitops/flux/infrastructure/controllers/overlays/prod` | Installs Core Software (CNI, Ingress, CSI) and Network Pools    | Flux System  |
| **2. Configs**     | `gitops/flux/infrastructure/configs/overlays/prod`     | Installs Resources dependent on Layer 1 (Issuers, Certificates) | Layer 1      |
| **3. Apps**        | `gitops/flux/apps/overlays/prod`                       | End-user workloads (GitLab)                                     | Layer 2      |

## Naming & Standards

To maintain a clean state and support automation, the following standards apply:

* **Overlays:** Every environment MUST have its own overlay directory pointing
  to a common base.
* **Suffixing:** Kustomize `nameSuffix` (e.g., `-prod`) is used to distinguish
  resources between environments automatically.
* **Encryption:** Secrets are encrypted via **SOPS** and stored in `secrets/`
  subdirectories where applicable.
* **Kustomization:** Every directory must contain a `kustomization.yaml`
  explicitly listing resources.

## Workflows

### Adding a new Environment (Ex. Staging)

1. Copy `overlays/prod` to `overlays/staging` in all three layers
   (`controllers`, `configs`, `apps`).
2. Update `kustomization.yaml` `nameSuffix` to `-staging`.
3. Update IP addresses in `controllers` patches (e.g., Ingress IP).
4. Update Hostnames in `apps` patches.
5. Create a new Terraform state in `infrastructure/02-platforms/k8s-staging` pointing to the new overlay paths.

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
