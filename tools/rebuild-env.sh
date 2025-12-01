#!/usr/bin/env bash
set -e

env="$1"
if [[ -z "$env" ]]; then
  echo "Usage: $0 <environment>"
  exit 1
fi

terraform_bin="$(which terraform || true)"
if [[ -z "$terraform_bin" ]]; then
  echo "Terraform is not installed. Please install Terraform to proceed."
  exit 1
fi

env_path="$(dirname "${BASH_SOURCE[0]}")/../infrastructure/environments/$env"
cd "$env_path" || { echo "Environment directory '$env_path' does not exist."; exit 1; }

echo "Rebuilding environment for: $env"
terraform init -backend-config=backend.config --reconfigure
terraform plan -out=tfplan
terraform apply -auto-approve tfplan

echo "Terraform environment rebuilt successfully."
exit 0
