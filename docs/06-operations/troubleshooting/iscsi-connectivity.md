# Troubleshooting iSCSI Connectivity

## Symptoms
* **Status:** Pods (Ex. Postgres, Redis, Gitaly) stuck in `ContainerCreating`.
* **Events:** `kubectl describe pod` shows:
  * `MountVolume.SetUp failed`
  * `iscsiadm: Could not login to [portal: 10.0.50.20,3260]`
  * `timeout expired waiting for volumes to attach or mount`
* **Context:** TrueNAS/Storage server was recently rebooted or updated.

## Root Cause Analysis

### 1. Stale iSCSI Sessions (Most Common)
When the storage server reboots, the TCP connections from the Kubernetes nodes
are severed. However, the CSI driver and the underlying OS (`iscsid`) often fail
to detect this immediately, holding onto "Zombie" sessions. The pods wait
indefinitely for I/O that will never come.

### 2. Kernel/dmesg Logs (Talos Specific)
Since `kubectl debug` is restricted by PodSecurity policies in Talos, use
`talosctl` to check the kernel logs directly.

```bash
# Check dmesg on the node running the stuck pod
talosctl -n <NODE_IP> dmesg | grep -i iscsi
```

* **Normal:** New logs with current timestamps showing connection attempts.
* **Stale:** No logs for several hours/days (System thinks it's connected).
* **Auth Error:** `login failed` (CHAP password mismatch).

## Resolution Workflow

### Fix 1: Restart CSI Driver (The "Kick")

Force the Democratic-CSI driver to restart. This kills the stale processes and
forces a fresh login to TrueNAS.

```bash
# Delete all democratic-csi pods in kube-system
kubectl delete pods -n kube-system -l app.kubernetes.io/name=democratic-csi

# Wait for the new CSI pods to become `Running`.
kubectl get pods -n kube-system -l app.kubernetes.io/name=democratic-csi
```

### Fix 2: Restart Stuck Workloads

Once the CSI driver is fresh, the application pods are often still stuck in a
"failed mount" backoff loop. They must be restarted to trigger a new mount
request.

```bash
# Example: Restarting GitLab pods
kubectl delete pod -n gitlab -l app=gitaly
kubectl delete pod -n gitlab -l app.kubernetes.io/name=postgresql
kubectl delete pod -n gitlab -l app.kubernetes.io/name=redis
```

### Fix 3: Verify TrueNAS Config

If Fix 1 & 2 failed, verify physical reachability.

1.  **Service Status:** Ensure iSCSI service is `Running` in TrueNAS.
2.  **Portal IPs:** Did TrueNAS change IP? Check
`infrastructure/controllers/base/democratic-csi-iscsi.yaml`.
3.  **Initiators:** Ensure "Allow All Initiators" is checked (or ACLs are
correct) in TrueNAS iSCSI settings.

### Fix 4: The Nuclear Option (Node Reboot)

If the iSCSI session is hung deep within the Linux kernel, a node reboot might
be required.

```bash
talosctl -n <NODE_IP> reboot
```

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
