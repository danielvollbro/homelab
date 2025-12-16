resource "github_repository_file" "infrastructure_controllers_yaml" {
  repository          = var.github_repo
  branch              = "main"
  file                = "gitops/flux/clusters/${var.env}/infrastructure-controllers.yaml"
  content             = <<EOT
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: infrastructure-controllers
  namespace: flux-system
spec:
  interval: 10m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./gitops/flux/infrastructure/controllers/overlays/${var.env}
  prune: true
  wait: true
  decryption:
    provider: sops
    secretRef:
      name: sops-age
EOT
  commit_message      = "Terraform: Manage infrastructure-controllers.yaml"
  overwrite_on_create = true

  depends_on = [flux_bootstrap_git.this]
}

resource "github_repository_file" "infrastructure_configs_yaml" {
  repository          = var.github_repo
  branch              = "main"
  file                = "gitops/flux/clusters/${var.env}/infrastructure-configs.yaml"
  content             = <<EOT
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: infrastructure-configs
  namespace: flux-system
spec:
  interval: 10m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./gitops/flux/infrastructure/configs/overlays/${var.env}
  prune: true
  wait: true
  decryption:
    provider: sops
    secretRef:
      name: sops-age
  dependsOn:
    - name: infrastructure-controllers
EOT
  commit_message      = "Terraform: Manage infrastructure-configs.yaml"
  overwrite_on_create = true

  depends_on = [flux_bootstrap_git.this]
}

resource "github_repository_file" "apps_yaml" {
  repository          = var.github_repo
  branch              = "main"
  file                = "gitops/flux/clusters/${var.env}/apps.yaml"
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
  path: ./gitops/flux/apps/overlays/${var.env}
  prune: true
  wait: true
  decryption:
    provider: sops
    secretRef:
      name: sops-age
  dependsOn:
    - name: infrastructure-configs
EOT
  commit_message      = "Terraform: Manage apps.yaml"
  overwrite_on_create = true

  depends_on = [flux_bootstrap_git.this]
}
