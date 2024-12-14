terraform {
  backend "s3" {
    bucket                      = "tf-state-k3s0-k3s1-cluster"
    key                         = "cloudflare-dns-ds-tfstate/terraform.tfstate"
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    force_path_style            = true
    endpoint                    = "https://s3.k3s0.ujstor.com"
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.37"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.47"
    }
  }
  required_version = ">= 1.0.0, < 2.0.0"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "hcloud" {
  token = var.hcloud_token
}
