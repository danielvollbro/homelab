# Democratic CSI Driver Configuration

## Description

This document details the configuration and architecture of the
**Container Storage Interface (CSI)** driver used to bridge Kubernetes with
TrueNAS Scale. We utilize **Democratic-CSI** to dynamically provision, attach,
and mount iSCSI block devices as Persistent Volumes (PVs).

## Design Philosophy

The storage layer is designed to be **dynamic** and **automated**, removing the
need for manual volume creation on the SAN.

* **Driver Choice:** `freenas-api-iscsi` is selected for its robust support of
  TrueNAS Scale's ZFS features (snapshots, clones, resizing).
* **Compatibility:** Specific overrides are implemented to support
  **Talos Linux** (which lacks standard writable host paths like `/etc/iscsi`)
  and **TrueNAS Scale 25.x** (which requires updated API handling).
* **Bleeding Edge:** Due to the use of TrueNAS latest versions, the driver
  utilizes the `next` image tag to ensure compatibility with the latest API
  version strings.

## Security Posture & Isolation

* **Privileged Access:** The CSI Node pods run in `privileged` mode. This is a
  required exception to the security policy to allow the pod to execute
  `iscsiadm` and mount block devices on the host kernel.
* **Secret Management:** The TrueNAS API Key is stored in a Kubernetes Secret
  (`truenas-apikey`) in the `kube-system` namespace, managed via Terraform and
  encrypted with SOPS.
* **Traffic Isolation:** iSCSI traffic flows over the specific Storage/Server
  VLAN, separate from the Management network.

## Configuration Schema

The Helm Chart configuration deviates from upstream defaults to accommodate our
specific environment.

### 1. Talos Linux Compatibility
Talos has a read-only root filesystem. The standard CSI behavior of mounting
`/etc/iscsi` from the host fails. We override this to use a writable ephemeral
path.

| Setting                | Value                           | Rationale                                          |
| :---                   | :---                            | :---                                               |
| `mountISCSIDir`        | `true`                          | Enables mounting the config directory.             |
| `iscsiDirHostPath`     | `/var/lib/democratic-csi/iscsi` | A path that Talos permits creation of.             |
| `iscsiDirHostPathType` | `DirectoryOrCreate`             | Forces Kubelet to create the directory if missing. |

### 2. TrueNAS Connectivity
Configuration required to talk to TrueNAS Scale 25.x.

| Setting                     | Value               | Rationale                                                       |
| :---                        | :---                | :---                                                            |
| `driver`                    | `freenas-api-iscsi` | The standard iSCSI driver for TrueNAS.                          |
| `httpConnection.protocol`   | `https`             | TrueNAS enforces HTTPS/HSTS.                                    |
| `httpConnection.apiVersion` | `2`                 | Forces usage of the modern API v2.0 namespace.                  |
| `zvolDedup`                 | *Disabled*          | Explicitly removed to prevent API errors on newer ZFS versions. |

### 3. Image Strategy
| Parameter   | Value  | Reason                                                                                                           |
| :---        | :---   | :---                                                                                                             |
| `image.tag` | `next` | Required to parse version strings of TrueNAS Nightly builds (e.g. "TrueNAS-25.x") which broke the stable driver. |

## Data Flow Visualization

```mermaid
graph TD
    subgraph Kubernetes_Cluster
        PVC[PVC Request]

        subgraph kube_system
            CTRL[CSI Controller Pod]
            NODE[CSI Node Pod<br>(DaemonSet)]
        end

        APP[App Pod]
    end

    subgraph TrueNAS_Scale
        API[HTTPS API<br>Port 443]
        ISCSI[iSCSI Target<br>Port 3260]
        ZFS[(ZFS Pool)]
    end

    PVC -- 1. Claim --> CTRL
    CTRL -- 2. Create Zvol (API) --> API
    API -- 3. Allocate --> ZFS

    NODE -- 4. Login/Attach (iSCSI) --> ISCSI
    NODE -- 5. Format & Mount --> APP

    APP -- 6. R/W Data --> ISCSI

    classDef k8s fill:#e9d8a6,stroke:#333,stroke-width:2px;
    classDef nas fill:#005f73,stroke:#333,stroke-width:2px,color:#fff;
```

## Troubleshooting

Common issues and resolutions for this specific driver setup:

1. **Stuck in `ContainerCreating`:**
   * Check `kubectl describe pod`. If `FailedMount` regarding `/etc/iscsi`,
     verify the Talos path overrides in Helm values.
2. **Controller `CrashLoopBackOff`:**
   * Check logs: `kubectl logs ... -c csi-driver`.
   * If `401 Unauthorized`: Rotate the API Key in Terraform and Secret.
   * If `driver not available for TrueNAS`: Ensure image tag is set to `next`.
3. **`Input/Output Error` in App Pod:**
   * Indicates iSCSI session drop. Restart the App Pod to force re-login.

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
