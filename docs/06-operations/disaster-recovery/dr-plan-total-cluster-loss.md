# Disaster Recovery Plan: Total Cluster Loss

## Description
This runbook details the procedure to recover the environment in the event of a
total cluster destruction (e.g., accidental deletion, hardware failure).

**Assumptions:**
* Physical Servers (Layer 0) are running and configured.
* TrueNAS storage (iSCSI Zvols and S3 Buckets) is intact.
* The Git repository is accessible.
* The `age.agekey` (SOPS Private Key) is available locally.

## Prerequisites
1.  **Local Environment:** Terraform, Flux CLI, and `talosctl` installed.
2.  **Secrets:** `age.agekey` located at the path defined in `variables.tf`
(usually repo root).
3.  **Access:** Admin access to Proxmox and TrueNAS (via VPN or LAN).
4.  **Backend Config:** The `backend.config` file (containing sensitive S3
state credentials) must be fetched from Bitwarden and placed
in `infrastructure/02-platforms/k8s-prod`.

## Phase 1: Infrastructure Provisioning
This step recreates the VMs, bootstraps Kubernetes, and installs Flux.

1.  **Navigate to Terraform:**
    ```bash
    cd infrastructure/02-platforms/k8s-prod
    ```
2.  **Initialize & Apply:**
    ```bash
    # Initialize with the secure backend config
    terraform init -backend-config=backend.config

    # Generate a terraform plan to validate changes
    terraform plan -out tfplan

    # Apply the infrastructure
    terraform apply "tfplan"
    ```
    * Wait for the cluster to form and Flux to bootstrap (approx 5-10 mins).
    * **Result:** 3 Control Plane nodes are created, Talos boots, and Flux is
    injected.

3.  **Retrieve Access:**
    ```bash
    terraform output -raw kubeconfig > ~/.kube/config
    kubectl get nodes
    ```

## Phase 2: Flux Reconciliation
Flux will automatically start applying the Git repository. Monitor the progress
to ensure layers come up in the correct order.

1.  **Monitor Controllers (Layer 1):**
    ```bash
    flux get kustomizations -w
    ```
    *Wait for `infrastructure-controllers` to become `Ready`.*
    * *Verification:* Check that Ingress has an External IP:
        ```bash
        kubectl get svc -n ingress-nginx
        ```

2.  **Monitor Configs (Layer 2):**
    *Wait for `infrastructure-configs` to become `Ready`.*
    * *Verification:* Check that ClusterIssuer is active:
        ```bash
        kubectl get clusterissuers
        ```

3.  **Monitor Apps (Layer 3):**
    *Wait for `apps` to become `Ready`.*
    * *Verification:* Check workloads:
        ```bash
        kubectl get pods -n gitlab
        ```

## Phase 3: Data Restoration

The applications are now running. Data status depends on the storage
persistence.

* **Scenario A: PVs Reused:** If the iSCSI volumes on TrueNAS were preserved,
the app should automatically attach and start working immediately.
* **Scenario B: PVs Recreated:** If volumes were lost/deleted, the database will
be empty. Proceed to the restore guide:
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
