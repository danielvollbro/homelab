variable "env" {
  type        = string
  description = "Specify what environment we are setting up."
}

variable "target_path" {
  type        = string
  description = "Path to where Flux stores manifests."
}

variable "github_repo" {
  type        = string
  description = "The name of the GitHub repository to store Flux manifests."
}

variable "age_key_content" {
  description = "Content of age.agekey file for encrypting secrets."
  type        = string
  sensitive   = true
}

variable "truenas_api_key" {
  description = "API Key for TrueNAS (Democratic CSI)"
  type        = string
  sensitive   = true
}

variable "cloudflare_token" {
  description = "Cloudflare API Token for DNS-01"
  type        = string
  sensitive   = true
}
