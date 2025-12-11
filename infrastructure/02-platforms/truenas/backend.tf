terraform {
  /**
    Because MinIO runs on this VM I can't store the state file on it.
  */
  backend "local" {
    path = "terraform.tfstate"
  }
}
