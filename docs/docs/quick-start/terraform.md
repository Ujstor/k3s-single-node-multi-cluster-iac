In the node-infra directory under IAC, main.tf defines what infrastructure will be created. The cloudflare_dns.tf is a module that creates DNS records in Cloudflare. DNS records use wildcards for apps that are used as internal tools not available to the public. We also have specific domains for the Kubernetes API, which are referenced in the Ansible inventory file. Other records are for the mail server and other services.

Future security improvement: all internal services will require OpenVPN connection for access.

## Preconfiguration

### Terraform backend
Current terraform.tf, where providers are defined, assumes that you have a MinIO S3 bucket deployed for storing Terraform state.
On the first run, when you don't have your infrastructure up and running, comment out the S3 backend.

```hcl
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
```

### SSH Keys

SSH keys will be automatically generated when you run `terraform apply`, but Terraform expects an .ssh directory inside the node-infra directory.
Later, you can back up your keys in the same MinIO tenant as your Terraform state.
Check config in [s3-ssh-keys-backup](https://github.com/Ujstor/k3s-single-node-multi-cluster-iac/tree/master/iac/terraform/s3-kubeconfig-backup) dir.

## Create Infrastructure

Once you have the API keys in the .auto.tfvars file, you can create the infrastructure:

```bash
terraform init
terraform apply
```

Now you have two servers up and running. The next step is to deploy K3s on each of them using Ansible.
