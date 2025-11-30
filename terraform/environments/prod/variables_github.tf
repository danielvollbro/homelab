variable "github_username" {
  type        = string
  description = "The GitHub username owning the repository."
}

variable "github_token" {
  type        = string
  sensitive   = true
  description = "The GitHub token with access to create repositories."
}

variable "github_repo" {
  type        = string
  description = "The GitHub repository name."
}
