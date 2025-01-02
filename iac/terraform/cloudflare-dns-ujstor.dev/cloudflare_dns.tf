module "cloudflare_record" {
  source = "github.com/Ujstor/terraform-hetzner-modules//modules/network/cloudflare_record?ref=v0.0.8"

  cloudflare_record = {
    api-k3s2 = {
      zone_id = var.cloudflare_zone_id
      name    = "api.k3s2"
      content = local.ip
      type    = "A"
      ttl     = 3600
      proxied = false
    }
    api-k3s3 = {
      zone_id = var.cloudflare_zone_id
      name    = "api.k3s3"
      content = local.ip
      type    = "A"
      ttl     = 3600
      proxied = false
    }
    api-k3s4 = {
      zone_id = var.cloudflare_zone_id
      name    = "api.k3s4"
      content = local.ip
      type    = "A"
      ttl     = 3600
      proxied = false
    }
    ssh-k3s = {
      zone_id = var.cloudflare_zone_id
      name    = "ssh.k3s"
      content = local.ip
      type    = "A"
      ttl     = 3600
      proxied = false
    }
    ssh-k3s2 = {
      zone_id = var.cloudflare_zone_id
      name    = "ssh.k3s2"
      content = local.ip
      type    = "A"
      ttl     = 3600
      proxied = false
    }
    ssh-k3s3 = {
      zone_id = var.cloudflare_zone_id
      name    = "ssh.k3s3"
      content = local.ip
      type    = "A"
      ttl     = 3600
      proxied = false
    }
    ssh-k3s4 = {
      zone_id = var.cloudflare_zone_id
      name    = "ssh.k3s4"
      content = local.ip
      type    = "A"
      ttl     = 3600
      proxied = false
    }
    nginx = {
      zone_id = var.cloudflare_zone_id
      name    = "nginx"
      content = local.ip
      type    = "A"
      ttl     = 3600
      proxied = false
    }
    grafana-k3s2 = {
      zone_id = var.cloudflare_zone_id
      name    = "grafana.k3s2"
      content = local.ip
      type    = "A"
      ttl     = 3600
      proxied = false
    }
    win-k3s2 = {
      zone_id = var.cloudflare_zone_id
      name    = "win.k3s2"
      content = local.ip
      type    = "A"
      ttl     = 3600
      proxied = false
    }
    grafana-k3s3 = {
      zone_id = var.cloudflare_zone_id
      name    = "grafana.k3s3"
      content = local.ip
      type    = "A"
      ttl     = 3600
      proxied = false
    }
    servicemesh-k3s3 = {
      zone_id = var.cloudflare_zone_id
      name    = "servicemesh.k3s3"
      content = local.ip
      type    = "A"
      ttl     = 3600
      proxied = false
    }
    # api-k3s5 = {
    #   zone_id = var.cloudflare_zone_id
    #   name    = "api.k3s5"
    #   content = data.hcloud_server.k3s5.ipv4_address
    #   type    = "A"
    #   ttl     = 3600
    #   proxied = false
    # }
    # wildcard-k3s5 = {
    #   zone_id = var.cloudflare_zone_id
    #   name    = "*.k3s5"
    #   content = data.hcloud_server.k3s5.ipv4_address
    #   type    = "A"
    #   ttl     = 3600
    #   proxied = false
    # }
  }
}
