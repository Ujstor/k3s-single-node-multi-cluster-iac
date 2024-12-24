module "ssh_key_k3s_prod" {
  source = "github.com/Ujstor/terraform-hetzner-modules//modules/ssh_key?ref=v0.0.8"

  ssh_key_name = "k3s_prod_hetzner_ssh_key"
  ssh_key_path = ".ssh" #create dir before appling tf config if you use custom paths for ssh keys
}

module "k3s_prod" {
  source = "github.com/Ujstor/terraform-hetzner-modules//modules/server?ref=v0.0.8"

  server_config = {
    k3s0-ops = {
      location     = "nbg1"
      server_type  = "cx42"
      ipv6_enabled = false
      subnet_id    = module.network_config.subnet_id.subnet-1.subnet_id
      subnet_ip    = "10.0.1.1"
      labels = {
        cluster = "k3s0"
      }
    }
    k3s1-app = {
      location     = "nbg1"
      server_type  = "cx32"
      ipv6_enabled = false
      subnet_id    = module.network_config.subnet_id.subnet-2.subnet_id
      subnet_ip    = "10.0.2.1"
      labels = {
        cluster = "k3s1"
      }
    }
    k3s2-win = {
      location     = "nbg1"
      server_type  = "cx32"
      ipv6_enabled = false
      subnet_id    = module.network_config.subnet_id.subnet-2.subnet_id
      subnet_ip    = "10.0.2.2"
      labels = {
        cluster = "k3s2"
      }
    }
  }

  use_network       = true
  hcloud_ssh_key_id = [module.ssh_key_k3s_prod.hcloud_ssh_key_id]

  depends_on = [
    module.ssh_key_k3s_prod,
    module.network_config
  ]
}

module "floating_ip" {
  source = "github.com/Ujstor/terraform-hetzner-modules//modules/network/floating_ip?ref=v0.0.8"

  floating_ip_config = {
    ip-1 = {
      server_id       = module.k3s_prod.server_info.k3s0-ops.id
      server_location = module.k3s_prod.server_info.k3s0-ops.location
    }
  }
}

module "network_config" {
  source = "github.com/Ujstor/terraform-hetzner-modules//modules/network/vpc_subnet?ref=v0.0.8"

  vpc_config = {
    vpc_name     = "cluster-vpc"
    vpc_ip_range = "10.0.0.0/16"
  }

  subnet_config = {
    subnet-1 = {
      subnet_ip_range = "10.0.1.0/24"
    }
    subnet-2 = {
      subnet_ip_range = "10.0.2.0/24"
    }
  }

  network_type = "cloud"
  network_zone = "eu-central"
}
