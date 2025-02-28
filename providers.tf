# https://developer.hashicorp.com/terraform/language/providers/requirements#requiring-providers
terraform {
  required_version = "~> 1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2"
    }
  }
}
