# ADR-003: iSCSI for Persistent Storage

- Status: accepted
- Date: 2025-12-03
- Decision owner: Daniel Vollbro

## Context

Stateful workloads (PostgreSQL, Redis) running in Kubernetes require persistent
storage. The underlying storage hardware is a TrueNAS Scale server. While NFS is
easier to configure, it often introduces permission issues ("root squash") and
performance bottlenecks for database workloads which require reliable
block-level access.

## Decision

We will use **iSCSI** via the **Democratic-CSI** driver to provision persistent
volumes.

Volumes will be dynamically provisioned as Zvols on TrueNAS and mounted as raw
block devices or ext4 filesystems inside the pods.

## Alternatives considered

- **NFS:** Rejected for database workloads due to permission complexities
(chown/chmod issues with Bitnami containers) and lack of block-level locking.
- **Longhorn / Rook Ceph:** Rejected. Since we already have a robust ZFS storage
appliance (TrueNAS), running a distributed storage layer on top of the compute
nodes would waste resources (RAM/CPU) and introduce unnecessary complexity.
- **Local Path:** Rejected. Ties workloads to specific nodes, preventing
failover or migration.

## Rationale

iSCSI provides a standard block device interface that behaves like a local disk.
1.  **Reliability:** Databases expect block storage.
2.  **Features:** Leverages ZFS snapshots, compression, and cloning natively on
the SAN.
3.  **Isolation:** Usage of a dedicated VLAN (50) for storage traffic ensures
performance does not impact the management plane.

## Consequences

### Positive

- High performance for database I/O.
- Solves "Permission Denied" errors common with NFS.
- Offloads storage management to the TrueNAS appliance.

### Negative

- More complex network configuration (requires dedicated VLAN/Subnets).
- Zvols consume more space overhead than files on ZFS.
- Requires specific `iscsid` extensions on Talos Linux.

## Follow-up

- Monitor ZFS pool usage on TrueNAS.
- Ensure the dedicated Storage VLAN is correctly routed/firewalled.

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
