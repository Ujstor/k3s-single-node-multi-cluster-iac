terraform {
  # backend "s3" {
  #   bucket                      = "tf-state-k3s0-k3s1-cluster"
  #   key                         = "nodes-infra-tfstate/terraform.tfstate"
  #   region                      = "us-east-1"
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   skip_region_validation      = true
  #   skip_requesting_account_id  = true
  #   force_path_style            = true
  #   endpoint                    = "https://s3.k3s0.ujstor.com"
  # }
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.47"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.37"
    }
  }
  required_version = ">= 1.0.0, < 2.0.0"
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
