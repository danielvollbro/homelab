# Secret Management (SOPS)

## Description

This document details how sensitive information (API keys, passwords,
private keys) is securely managed within the public/private Git repository
using **Mozilla SOPS**.

## Design Philosophy

* **Encryption at Rest:** No secrets are ever committed to Git in plain text.
* **GitOps Compatible:** Secrets are managed as standard Kubernetes YAML files,
  allowing Flux to apply them just like any other resource.
* **Simple Decryption:** The cluster holds a single private key (Age) capable of
  decrypting all secrets required for bootstrap and operation.

## Key Management

* **Encryption Key:** `age.agekey` (Generated locally via `age-keygen`).
* **Storage:** The private key is stored securely in a Password Manager
  (Bitwarden) and is **never** committed to the repo.
* **Injection:** Terraform injects the private key into the `flux-system`
  namespace during the initial cluster bootstrap.

## Workflow: Adding a New Secret

1. **Create:** Define the Kubernetes Secret locally in a YAML file.
   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: my-secret
     namespace: my-app
   stringData:
     password: "super-secret-value"
   ```
2. **Encrypt:** Run SOPS against the file.
   ```bash
   sops -e -i my-secret.yaml
   ```
   *Note: The file content is now encrypted, but metadata (name, namespace)
   remains readable.*
3. **Commit:** Push the encrypted file to the Git repository.
4. **Deploy:** Flux pulls the file, decrypts it in-memory using the cluster key,
   and applies it.

## Visualization

```mermaid
graph LR
    Dev[Developer] -- "sops -e" --> Git[Git Repo (Encrypted)]
    Git -- Pull --> Flux
    Key[Age Private Key] -- Decrypt --> Flux
    Flux -- Apply (Plaintext) --> Etcd[Kubernetes Etcd]
```

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
