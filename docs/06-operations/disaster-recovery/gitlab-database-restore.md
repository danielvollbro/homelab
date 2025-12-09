# GitLab Database Restore Procedure

## Description
This guide covers restoring a GitLab installation from an S3 backup (MinIO).
This is required if the PostgreSQL Persistent Volume was lost or corrupted.

## Prerequisites
* The Kubernetes cluster is running.
* GitLab pods are running (even if failing health checks due to empty DB).
* The `gitlab-rails-secret` (containing encryption keys) matches the one used
  when the backup was created.
  **If this secret is lost, the backup is undecryptable.**

## Procedure

### 1. Identify Backup Timestamp
Check your MinIO bucket (`gitlab-backups`) for the latest tarball.
* Format: `1700000000_2025_12_09_17.6.1_gitlab_backup.tar`
* Timestamp ID: `1700000000_2025_12_09_17.6.1`

### 2. Scale Down Services
Stop processes that write to the DB during restore.

```bash
# In 'gitops/flux/apps/gitlab/overlays/prod/kustomization.yaml', add replicas: 0 patch
# OR temporarily scale manually (Flux will revert eventually):
kubectl scale deployment -n gitlab gitlab-gitlab-webservice-default --replicas=0
kubectl scale deployment -n gitlab gitlab-gitlab-sidekiq-all-in-1-v2 --replicas=0
````

### 3\. Grant Superuser Permissions (Critical)

The restore process requires creating extensions (`pg_trgm`), which the standard
GitLab user cannot do.

1. **Get Postgres Password:**
   ```bash
   kubectl get secret -n gitlab gitlab-gitlab-postgresql-password -o jsonpath="{.data.postgresql-postgres-password}" | base64 --decode
   ```
2. **Log into Postgres Pod:**
   ```bash
   kubectl exec -it -n gitlab gitlab-gitlab-postgresql-0 -c postgresql -- bash
   ```
3. **Grant Superuser:**
   ```bash
   psql -U postgres -d template1
   # SQL Prompt:
   ALTER USER gitlab WITH SUPERUSER;
   \q
   exit
   ```

### 4\. Execute Restore

Run the restore utility from the Toolbox pod.

```bash
# Find Toolbox Pod
kubectl get pods -n gitlab -l app=toolbox

# Run Restore
kubectl exec -it -n gitlab <TOOLBOX_POD_NAME> -- backup-utility --restore -t <TIMESTAMP_ID>
```

* Type `yes` when prompted to overwrite.

### 5\. Post-Restore Cleanup

1. **Revoke Superuser:** Repeat Step 3 but run
   `ALTER USER gitlab WITH NOSUPERUSER;`.
2. **Scale Up:** Revert scaling changes.
3. **Check Health:** Log in to GitLab and verify projects/issues are visible.

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
