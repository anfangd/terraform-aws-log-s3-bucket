terraform {
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.83"
    }

    external = {
      source  = "hashicorp/external"
      version = ">= 2.3.4"
    }
  }
}
