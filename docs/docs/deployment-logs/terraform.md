```bash
 t apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.cloudflare_record.cloudflare_record.domain_recorda["github-readme-stats"] will be created
  + resource "cloudflare_record" "domain_recorda" {
      + allow_overwrite = false
      + content         = (known after apply)
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "readme"
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 1
      + type            = "A"
      + value           = (known after apply)
      + zone_id         = "954d9bc1391a15cc29a993894cbf65fb"
    }

  # module.cloudflare_record.cloudflare_record.domain_recorda["kube_api_k3s0"] will be created
  + resource "cloudflare_record" "domain_recorda" {
      + allow_overwrite = false
      + content         = (known after apply)
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "api.k3s0"
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 60
      + type            = "A"
      + value           = (known after apply)
      + zone_id         = "954d9bc1391a15cc29a993894cbf65fb"
    }

  # module.cloudflare_record.cloudflare_record.domain_recorda["kube_api_k3s1"] will be created
  + resource "cloudflare_record" "domain_recorda" {
      + allow_overwrite = false
      + content         = (known after apply)
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "api.k3s1"
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 60
      + type            = "A"
      + value           = (known after apply)
      + zone_id         = "954d9bc1391a15cc29a993894cbf65fb"
    }

  # module.cloudflare_record.cloudflare_record.domain_recorda["mail"] will be created
  + resource "cloudflare_record" "domain_recorda" {
      + allow_overwrite = false
      + content         = (known after apply)
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "mail"
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 60
      + type            = "A"
      + value           = (known after apply)
      + zone_id         = "954d9bc1391a15cc29a993894cbf65fb"
    }

  # module.cloudflare_record.cloudflare_record.domain_recorda["mail-dkms"] will be created
  + resource "cloudflare_record" "domain_recorda" {
      + allow_overwrite = false
      + content         = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAj3Rdv+i/KiBIQ0YiCIVlhoGPKycSyBdEZGGTdfazZVkH+p7NWIKEcwrVx0ExFd7ri2YIAkJKUVlt8gRQ+tmZLGJYB6q0MIfZYC8G/tJsU6xES7DH9dAtgruu4hSUertdid1zX9hFgluHzmwVI4rbx+rMbXyq5VhkjA/ZS2gYw2DUWFXFNsTRMmu/XL1kOHEz0+My65zoQgYz/i99Un0kiGs9NP2DSellOk7TsvbNf/CSMpbnotdUTA/iG2TifiR83Ha9UVaiUW7muxlF5SuVyDD44hToDlisUEk4gpZ7bvxcJorJFFhEQ9COJuKBmM98B8+7ttfI8IzCGqaCu1/1QwIDAQAB"
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "mail._domainkey.ujstor.com"
      + proxiable       = (known after apply)
      + ttl             = 1
      + type            = "TXT"
      + value           = (known after apply)
      + zone_id         = "954d9bc1391a15cc29a993894cbf65fb"
    }

  # module.cloudflare_record.cloudflare_record.domain_recorda["mx"] will be created
  + resource "cloudflare_record" "domain_recorda" {
      + allow_overwrite = false
      + content         = "mail.ujstor.com"
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "@"
      + priority        = 10
      + proxiable       = (known after apply)
      + ttl             = (known after apply)
      + type            = "MX"
      + value           = (known after apply)
      + zone_id         = "954d9bc1391a15cc29a993894cbf65fb"
    }

  # module.cloudflare_record.cloudflare_record.domain_recorda["plausible_analytics_k3s1"] will be created
  + resource "cloudflare_record" "domain_recorda" {
      + allow_overwrite = false
      + content         = (known after apply)
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "analytics"
      + proxiable       = (known after apply)
      + proxied         = true
      + ttl             = 1
      + type            = "A"
      + value           = (known after apply)
      + zone_id         = "954d9bc1391a15cc29a993894cbf65fb"
    }

  # module.cloudflare_record.cloudflare_record.domain_recorda["wildcard_k3s0"] will be created
  + resource "cloudflare_record" "domain_recorda" {
      + allow_overwrite = false
      + content         = (known after apply)
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "*.k3s0"
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 60
      + type            = "A"
      + value           = (known after apply)
      + zone_id         = "954d9bc1391a15cc29a993894cbf65fb"
    }

  # module.cloudflare_record.cloudflare_record.domain_recorda["wildcard_k3s1"] will be created
  + resource "cloudflare_record" "domain_recorda" {
      + allow_overwrite = false
      + content         = (known after apply)
      + created_on      = (known after apply)
      + hostname        = (known after apply)
      + id              = (known after apply)
      + metadata        = (known after apply)
      + modified_on     = (known after apply)
      + name            = "*.k3s1"
      + proxiable       = (known after apply)
      + proxied         = false
      + ttl             = 60
      + type            = "A"
      + value           = (known after apply)
      + zone_id         = "954d9bc1391a15cc29a993894cbf65fb"
    }

  # module.floating_ip.hcloud_floating_ip.main["ip-1"] will be created
  + resource "hcloud_floating_ip" "main" {
      + delete_protection = false
      + home_location     = "nbg1"
      + id                = (known after apply)
      + ip_address        = (known after apply)
      + ip_network        = (known after apply)
      + name              = (known after apply)
      + server_id         = (known after apply)
      + type              = "ipv4"
    }

  # module.floating_ip.hcloud_floating_ip_assignment.main["ip-1"] will be created
  + resource "hcloud_floating_ip_assignment" "main" {
      + floating_ip_id = (known after apply)
      + id             = (known after apply)
      + server_id      = (known after apply)
    }

  # module.k3s_prod.hcloud_server.server["k3s0-ops"] will be created
  + resource "hcloud_server" "server" {
      + allow_deprecated_images    = false
      + backup_window              = (known after apply)
      + backups                    = false
      + datacenter                 = (known after apply)
      + delete_protection          = false
      + firewall_ids               = (known after apply)
      + id                         = (known after apply)
      + ignore_remote_firewall_ids = false
      + image                      = "debian-12"
      + ipv4_address               = (known after apply)
      + ipv6_address               = (known after apply)
      + ipv6_network               = (known after apply)
      + keep_disk                  = false
      + labels                     = {
          + "cluster" = "k3s0"
        }
      + location                   = "nbg1"
      + name                       = "k3s0-ops"
      + primary_disk_size          = (known after apply)
      + rebuild_protection         = false
      + server_type                = "cx42"
      + shutdown_before_deletion   = false
      + ssh_keys                   = (known after apply)
      + status                     = (known after apply)

      + public_net {
          + ipv4         = (known after apply)
          + ipv4_enabled = true
          + ipv6         = (known after apply)
          + ipv6_enabled = false
        }
    }

  # module.k3s_prod.hcloud_server.server["k3s1-app"] will be created
  + resource "hcloud_server" "server" {
      + allow_deprecated_images    = false
      + backup_window              = (known after apply)
      + backups                    = false
      + datacenter                 = (known after apply)
      + delete_protection          = false
      + firewall_ids               = (known after apply)
      + id                         = (known after apply)
      + ignore_remote_firewall_ids = false
      + image                      = "debian-12"
      + ipv4_address               = (known after apply)
      + ipv6_address               = (known after apply)
      + ipv6_network               = (known after apply)
      + keep_disk                  = false
      + labels                     = {
          + "cluster" = "k3s1"
        }
      + location                   = "nbg1"
      + name                       = "k3s1-app"
      + primary_disk_size          = (known after apply)
      + rebuild_protection         = false
      + server_type                = "cx32"
      + shutdown_before_deletion   = false
      + ssh_keys                   = (known after apply)
      + status                     = (known after apply)

      + public_net {
          + ipv4         = (known after apply)
          + ipv4_enabled = true
          + ipv6         = (known after apply)
          + ipv6_enabled = false
        }
    }

  # module.k3s_prod.hcloud_server_network.subnet_controler["k3s0-ops"] will be created
  + resource "hcloud_server_network" "subnet_controler" {
      + id          = (known after apply)
      + ip          = "10.0.1.1"
      + mac_address = (known after apply)
      + server_id   = (known after apply)
      + subnet_id   = (known after apply)
    }

  # module.k3s_prod.hcloud_server_network.subnet_controler["k3s1-app"] will be created
  + resource "hcloud_server_network" "subnet_controler" {
      + id          = (known after apply)
      + ip          = "10.0.2.1"
      + mac_address = (known after apply)
      + server_id   = (known after apply)
      + subnet_id   = (known after apply)
    }

  # module.network_config.hcloud_network.network will be created
  + resource "hcloud_network" "network" {
      + delete_protection        = false
      + expose_routes_to_vswitch = false
      + id                       = (known after apply)
      + ip_range                 = "10.0.0.0/16"
      + name                     = "cluster-vpc"
    }

  # module.network_config.hcloud_network_subnet.deployment_subnet["subnet-1"] will be created
  + resource "hcloud_network_subnet" "deployment_subnet" {
      + gateway      = (known after apply)
      + id           = (known after apply)
      + ip_range     = "10.0.1.0/24"
      + network_id   = (known after apply)
      + network_zone = "eu-central"
      + type         = "cloud"
    }

  # module.network_config.hcloud_network_subnet.deployment_subnet["subnet-2"] will be created
  + resource "hcloud_network_subnet" "deployment_subnet" {
      + gateway      = (known after apply)
      + id           = (known after apply)
      + ip_range     = "10.0.2.0/24"
      + network_id   = (known after apply)
      + network_zone = "eu-central"
      + type         = "cloud"
    }

  # module.ssh_key_k3s_prod.hcloud_ssh_key.default will be created
  + resource "hcloud_ssh_key" "default" {
      + fingerprint = (known after apply)
      + id          = (known after apply)
      + labels      = {}
      + name        = "k3s_prod_hetzner_ssh_key"
      + public_key  = (known after apply)
    }

  # module.ssh_key_k3s_prod.tls_private_key.ssh_key will be created
  + resource "tls_private_key" "ssh_key" {
      + algorithm                     = "RSA"
      + ecdsa_curve                   = "P224"
      + id                            = (known after apply)
      + private_key_openssh           = (sensitive value)
      + private_key_pem               = (sensitive value)
      + private_key_pem_pkcs8         = (sensitive value)
      + public_key_fingerprint_md5    = (known after apply)
      + public_key_fingerprint_sha256 = (known after apply)
      + public_key_openssh            = (known after apply)
      + public_key_pem                = (known after apply)
      + rsa_bits                      = 4096
    }

Plan: 20 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + floating_ip_info = {
      + ip-1 = {
          + ip = (known after apply)
        }
    }
  + server_info      = {
      + k3s0-ops = {
          + id       = (known after apply)
          + ip       = (known after apply)
          + location = "nbg1"
          + status   = (known after apply)
        }
      + k3s1-app = {
          + id       = (known after apply)
          + ip       = (known after apply)
          + location = "nbg1"
          + status   = (known after apply)
        }
    }

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.ssh_key_k3s_prod.tls_private_key.ssh_key: Creating...
module.network_config.hcloud_network.network: Creating...
module.network_config.hcloud_network.network: Creation complete after 1s [id=10492590]
module.network_config.hcloud_network_subnet.deployment_subnet["subnet-2"]: Creating...
module.network_config.hcloud_network_subnet.deployment_subnet["subnet-1"]: Creating...
module.network_config.hcloud_network_subnet.deployment_subnet["subnet-1"]: Creation complete after 0s [id=10492590-10.0.1.0/24]
module.network_config.hcloud_network_subnet.deployment_subnet["subnet-2"]: Creation complete after 0s [id=10492590-10.0.2.0/24]
module.ssh_key_k3s_prod.tls_private_key.ssh_key: Creation complete after 3s [id=9e11b6418aec7baa38f093f482364833f6befd2c]
module.ssh_key_k3s_prod.hcloud_ssh_key.default: Creating...
module.ssh_key_k3s_prod.hcloud_ssh_key.default: Provisioning with 'local-exec'...
module.ssh_key_k3s_prod.hcloud_ssh_key.default (local-exec): (output suppressed due to sensitive value in config)
module.ssh_key_k3s_prod.hcloud_ssh_key.default: Creation complete after 0s [id=25799555]
module.k3s_prod.hcloud_server.server["k3s0-ops"]: Creating...
module.k3s_prod.hcloud_server.server["k3s1-app"]: Creating...
module.k3s_prod.hcloud_server.server["k3s0-ops"]: Still creating... [10s elapsed]
module.k3s_prod.hcloud_server.server["k3s1-app"]: Still creating... [10s elapsed]
module.k3s_prod.hcloud_server.server["k3s0-ops"]: Creation complete after 14s [id=57994659]
module.k3s_prod.hcloud_server.server["k3s1-app"]: Creation complete after 18s [id=57994660]
module.k3s_prod.hcloud_server_network.subnet_controler["k3s0-ops"]: Creating...
module.k3s_prod.hcloud_server_network.subnet_controler["k3s1-app"]: Creating...
module.floating_ip.hcloud_floating_ip.main["ip-1"]: Creating...
module.floating_ip.hcloud_floating_ip.main["ip-1"]: Creation complete after 0s [id=77726092]
module.floating_ip.hcloud_floating_ip_assignment.main["ip-1"]: Creating...
module.floating_ip.hcloud_floating_ip_assignment.main["ip-1"]: Creation complete after 1s [id=77726092]
module.k3s_prod.hcloud_server_network.subnet_controler["k3s1-app"]: Creation complete after 9s [id=57994660-10492590]
module.k3s_prod.hcloud_server_network.subnet_controler["k3s0-ops"]: Still creating... [10s elapsed]
module.k3s_prod.hcloud_server_network.subnet_controler["k3s0-ops"]: Creation complete after 17s [id=57994659-10492590]
module.cloudflare_record.cloudflare_record.domain_recorda["wildcard_k3s1"]: Creating...
module.cloudflare_record.cloudflare_record.domain_recorda["mx"]: Creating...
module.cloudflare_record.cloudflare_record.domain_recorda["wildcard_k3s0"]: Creating...
module.cloudflare_record.cloudflare_record.domain_recorda["kube_api_k3s0"]: Creating...
module.cloudflare_record.cloudflare_record.domain_recorda["github-readme-stats"]: Creating...
module.cloudflare_record.cloudflare_record.domain_recorda["mail"]: Creating...
module.cloudflare_record.cloudflare_record.domain_recorda["plausible_analytics_k3s1"]: Creating...
module.cloudflare_record.cloudflare_record.domain_recorda["mail-dkms"]: Creating...
module.cloudflare_record.cloudflare_record.domain_recorda["kube_api_k3s1"]: Creating...
module.cloudflare_record.cloudflare_record.domain_recorda["plausible_analytics_k3s1"]: Creation complete after 3s [id=d02a40ac7a10935db7698aa25bcae0a3]
module.cloudflare_record.cloudflare_record.domain_recorda["wildcard_k3s0"]: Creation complete after 3s [id=2657bd7703a2a9be94b8db0da9ef9538]
module.cloudflare_record.cloudflare_record.domain_recorda["wildcard_k3s1"]: Creation complete after 3s [id=a05cdc8f2ac62137fade131bd2b81ead]
module.cloudflare_record.cloudflare_record.domain_recorda["kube_api_k3s0"]: Creation complete after 3s [id=7ea0964004fcb90789b8bc8715375ece]
module.cloudflare_record.cloudflare_record.domain_recorda["mail"]: Creation complete after 4s [id=b1b5fd4f63927ab4860ecb7df6d96ea3]
module.cloudflare_record.cloudflare_record.domain_recorda["mail-dkms"]: Creation complete after 4s [id=054825545f80ac1238b31d80649ce219]
module.cloudflare_record.cloudflare_record.domain_recorda["mx"]: Creation complete after 4s [id=8a59e60835130e5f8bc0e737d3cbfcce]
module.cloudflare_record.cloudflare_record.domain_recorda["github-readme-stats"]: Creation complete after 4s [id=417d8256371c0b75fe3f1d13adcb8d35]
module.cloudflare_record.cloudflare_record.domain_recorda["kube_api_k3s1"]: Creation complete after 5s [id=35cdec5b72f9976fb3c48a100c99afea]

Apply complete! Resources: 20 added, 0 changed, 0 destroyed.

Outputs:

floating_ip_info = {
  "ip-1" = {
    "ip" = "49.13.32.42"
  }
}
server_info = {
  "k3s0-ops" = {
    "id" = "57994659"
    "ip" = "188.245.179.200"
    "location" = "nbg1"
    "status" = "running"
  }
  "k3s1-app" = {
    "id" = "57994660"
    "ip" = "49.13.159.158"
    "location" = "nbg1"
    "status" = "running"
  }
}
```
