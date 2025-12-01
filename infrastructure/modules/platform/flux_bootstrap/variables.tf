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
