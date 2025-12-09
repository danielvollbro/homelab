# Rotating Secrets (Workflow)

## Description
This guide describes how to update sensitive credentials (e.g., Cloudflare
Tokens, GitLab Runner Tokens) managed by SOPS.

## Procedure

### 1. Decrypt File
Navigate to the secret file location in the repo.

```bash
# Example: Updating Cloudflare Token
cd gitops/flux/infrastructure/configs/base/
sops -d cluster-issuer.yaml > cluster-issuer.dec.yaml
````

### 2\. Edit Secret

Modify the `cluster-issuer.dec.yaml` file with the new credentials.

### 3\. Encrypt & Replace

Encrypt the file back in place.

```bash
sops -e cluster-issuer.dec.yaml > cluster-issuer.yaml
rm cluster-issuer.dec.yaml
```

### 4\. Push & Reconcile

Commit the changes to Git.

```bash
git commit -am "chore: rotate cloudflare token"
git push
flux reconcile kustomization infrastructure-configs
```

### 5\. Force Update (If required)

Some controllers (like Cert-Manager or External-DNS) might cache the secret.
If things don't work immediately, restart the relevant pod.

```bash
kubectl delete pod -n cert-manager -l app.kubernetes.io/name=cert-manager
```

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
