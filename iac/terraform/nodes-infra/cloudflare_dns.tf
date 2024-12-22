module "cloudflare_record" {
  source = "github.com/Ujstor/terraform-hetzner-modules//modules/network/cloudflare_record?ref=v0.0.8"

  cloudflare_record = {
    kube_api_k3s0 = {
      zone_id = var.cloudflare_zone_id
      name    = "api.k3s0"
      content = module.k3s_prod.server_info.k3s0-ops.ip
      type    = "A"
      ttl     = 60
      proxied = false
    }
    wildcard_k3s0 = {
      zone_id = var.cloudflare_zone_id
      name    = "*.k3s0"
      content = module.k3s_prod.server_info.k3s0-ops.ip
      type    = "A"
      ttl     = 60
      proxied = false
    }
    kube_api_k3s1 = {
      zone_id = var.cloudflare_zone_id
      name    = "api.k3s1"
      content = module.k3s_prod.server_info.k3s1-app.ip
      type    = "A"
      ttl     = 60
      proxied = false
    }
    wildcard_k3s1 = {
      zone_id = var.cloudflare_zone_id
      name    = "*.k3s1"
      content = module.k3s_prod.server_info.k3s1-app.ip
      type    = "A"
      ttl     = 60
      proxied = false
    }
    plausible_analytics_k3s1 = {
      zone_id = var.cloudflare_zone_id
      name    = "analytics"
      content = module.k3s_prod.server_info.k3s1-app.ip
      type    = "A"
      ttl     = 1
      proxied = true
    }
    github-readme-stats = {
      zone_id = var.cloudflare_zone_id
      name    = "readme"
      content = module.k3s_prod.server_info.k3s1-app.ip
      type    = "A"
      ttl     = 1
      proxied = false
    }
    mx = {
      zone_id  = var.cloudflare_zone_id
      name     = "@"
      content  = "mail.ujstor.com"
      type     = "MX"
      priority = 10
    }
    mail = {
      zone_id = var.cloudflare_zone_id
      name    = "mail"
      content = module.k3s_prod.server_info.k3s0-ops.ip
      type    = "A"
      ttl     = 60
      proxied = false
    }
  }
  depends_on = [module.k3s_prod]
}
