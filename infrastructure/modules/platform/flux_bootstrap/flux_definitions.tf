resource "github_repository_file" "infrastructure_yaml" {
  repository          = var.github_repo
  branch              = "main"
  file                = "${var.target_path}/infrastructure.yaml"
  content             = <<EOT
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: infrastructure
  namespace: flux-system
spec:
  interval: 10m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./gitops/flux/infrastructure
  prune: true
  wait: true
  decryption:
    provider: sops
    secretRef:
      name: sops-age
EOT
  commit_message      = "Terraform: Manage infrastructure.yaml"
  overwrite_on_create = true

  depends_on = [flux_bootstrap_git.this]
}

resource "github_repository_file" "apps_yaml" {
  repository          = var.github_repo
  branch              = "main"
  file                = "${var.target_path}/apps.yaml"
  content             = <<EOT
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: apps
  namespace: flux-system
spec:
  interval: 10m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./gitops/flux/apps
  prune: true
  wait: true
  dependsOn:
    - name: infrastructure
EOT
  commit_message      = "Terraform: Manage apps.yaml"
  overwrite_on_create = true

  depends_on = [flux_bootstrap_git.this]
}
