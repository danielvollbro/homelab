# Disaster Recovery Plan: Total Cluster Loss

## Description
This runbook details the procedure to recover the environment in the event of a
total cluster destruction (e.g., accidental deletion, hardware failure).

**Assumptions:**
* TrueNAS storage (iSCSI Zvols and S3 Buckets) is intact.
* The Git repository is accessible.
* The `age.agekey` (SOPS Private Key) is available locally.

## Prerequisites
1.  **Local Environment:** Terraform, Flux CLI, and `talosctl` installed.
2.  **Secrets:** `age.agekey` located at the path defined in `variables.tf`.
3.  **Access:** Admin access to Proxmox and TrueNAS.
4.  **Backend config file:** `backend.config` fetched from bitwarden containing
    all backend specific configuration is available in
    `infrastructure/environments/prod`.

## Phase 1: Infrastructure Provisioning
This step recreates the VMs, bootstraps Kubernetes, and installs Flux.

1.  **Navigate to Terraform:**
    ```bash
    cd infrastructure/environments/prod
    ```
2.  **Initialize & Apply:**
    ```bash
    terraform init -backend-config=backend.config
    terraform apply
    ```
    *Wait for the cluster to form and Flux to bootstrap.*

## Phase 2: Flux Reconciliation
Flux will automatically start applying the Git repository. Monitor the progress
to ensure layers come up in the correct order.

1.  **Monitor Controllers (Layer 1):**
    ```bash
    flux get kustomizations -w
    ```
    *Wait for `infrastructure-controllers` to become `Ready`.*
    *Verify Ingress IP assignment (`kubectl get svc -n flux-system`).*

2.  **Monitor Configs (Layer 2):**
    *Wait for `infrastructure-configs` to become `Ready`.*
    *Verify ClusterIssuer is active.*

3.  **Monitor Apps (Layer 3):**
    *Wait for `apps` to become `Ready`.*

## Phase 3: Data Restoration
The applications are now running, but the databases are empty (unless PVs were
reused).

* **If PVs were reused:** The app should just start working.
* **If PVs were recreated:** Follow the application-specific restore guides.
  * [GitLab Database Restore](./gitlab-database-restore.md)

## Recovery Visualization

```mermaid
graph TD
    Start[Disaster Event] --> TF[Terraform Apply]
    TF -- Creates --> VMs[Talos VMs]
    TF -- Bootstraps --> Flux[Flux Controllers]

    Flux -- Pulls --> Git[Git Repo]
    Git -- Applies --> Layer1[CNI / Ingress / CSI]
    Layer1 -- Ready --> Layer2[Certs / Configs]
    Layer2 -- Ready --> Layer3[Apps (GitLab)]

    Layer3 -- Mounts --> Storage[TrueNAS iSCSI]
    Storage -- Restore Data --> Restore[Restore Procedure]
```

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
