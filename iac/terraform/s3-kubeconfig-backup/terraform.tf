terraform {
  backend "s3" {
    bucket                      = "tf-state-k3s0-k3s1-cluster"
    key                         = "kubeconfig-backup-tfstate/terraform.tfstate"
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    force_path_style            = true
    endpoint                    = "https://s3.k3s0.ujstor.com"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }
  required_version = ">= 1.0.0, < 2.0.0"
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3 = "https://s3.k3s0.ujstor.com"
  }
}
