# GitLab Deployment Architecture

## Description

This document describes the deployment of **GitLab Community Edition** on the
Kubernetes cluster. The installation is managed via the official GitLab Helm
Chart, wrapped in a Flux HelmRelease.

## Design Philosophy

The deployment is optimized for a **Homelab / Small Enterprise** environment,
prioritizing resource efficiency and statelessness over extreme High
Availability.

* **External Services:** To save cluster resources and increase reliability, we
  do *not* use the built-in PostgreSQL, Redis, or MinIO containers. Instead, we
  connect to external services (or separate deployments) on TrueNAS/iSCSI.
* **Statelessness:** No data persists inside the pods. All state is offloaded to
  iSCSI volumes (DB) or Object Storage (Files).
* **Resource Tuning:** Requests and Limits are tuned for 8GB nodes, reducing
  the default footprint of the webservice and sidekiq components.

## Configuration Highlights

| Component      | Strategy      | Details                                                            |
| :---           | :---          | :---                                                               |
| **Webservice** | Scaled Down   | 1 Replica. `800Mi` RAM request.                                    |
| **Runner**     | Authenticated | Uses Authentication Token (`glrt-`) stored in Secret.              |
| **Registry**   | Enabled       | Exposed via Ingress. Uses MinIO backend.                           |
| **Backups**    | CronJob       | Daily backup to S3. Secret `gitlab-rails-secret` persisted in Git. |
| **SSH Access** | Passthrough   | Port 22 passed through Ingress to GitLab Shell.                    |

## Critical Secrets for Recovery

To survive a total cluster destruction and restore a backup, the following
secret **MUST** be preserved and restored before application start:

* **`gitlab-gitlab-rails-secret`**: Contains the encryption keys (`db_key_base`,
  `secret_key_base`) used to encrypt data within the PostgreSQL database.

## Architecture Visualization

```mermaid
graph TD
    User -- HTTPS --> Ingress
    Ingress --> Web[Webservice]
    Ingress --> Reg[Registry]

    Web -- SQL --> Postgres[PostgreSQL (iSCSI)]
    Web -- Redis Protocol --> Redis[Redis (iSCSI)]

    Web -- S3 API --> MinIO[TrueNAS MinIO]
    Reg -- S3 API --> MinIO

    Runner[GitLab Runner] -- HTTPS --> Web
```

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
