terraform {
  required_version = ">= 1.11"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.76"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }
}

provider "tls" {}

provider "aws" {
  region = "us-east-1"
}

# In a real scenario, you would want to use a remote state.
