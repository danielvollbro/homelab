# Troubleshooting iSCSI Connectivity

## Symptoms
* Pods (Postgres, Redis) stuck in `ContainerCreating`.
* `kubectl describe pod` shows:
  * `MountVolume.SetUp failed`
  * `iscsiadm: Could not login to [portal: 10.0.50.20,3260]`
  * `timeout expired`

## Root Cause Analysis

### 1. Network Reachability
Can the Talos node reach TrueNAS on the SAN VLAN?

```bash
# Spawn a debug shell on the node
kubectl debug node/talos-node-0 -it --image=curlimages/curl -- sh

# Test connectivity
ping 10.0.50.20
telnet 10.0.50.20 3260
````

### 2\. TrueNAS Configuration

* **Service:** Is the iSCSI service running in TrueNAS?
* **Portal:** Is the Portal listening on `0.0.0.0` or specifically `10.0.50.20`?
* **Initiators:** Is "Allow All Initiators" checked (for debugging)?

### 3\. Democratic-CSI Logs

Check the driver logs for API errors.

```bash
kubectl logs -n kube-system -l app=democratic-csi-controller -c csi-driver
```

* **401 Unauthorized:** API Key is wrong/expired. Rotate secret.
* **Connection Refused:** TrueNAS IP changed.

## Resolution: TrueNAS IP Changed

If the NAS moved IP (e.g., `.20` -\> `.30`), you must:

1. Update `democratic-csi-iscsi.yaml` in `infrastructure/controllers/base/`.
2. Push to Git.
3. `flux reconcile kustomization infrastructure-controllers`.
4. **Important:** Restart the CSI pods to pick up the new config.
   ```bash
   kubectl delete pod -n kube-system -l app=democratic-csi-node
   kubectl delete pod -n kube-system -l app=democratic-csi-controller
   ```

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
