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
      content = module.floating_ip.floating_ip_status.ip-1.ip
      type    = "A"
      ttl     = 60
      proxied = false
    }
    mail-dkms = {
      zone_id = var.cloudflare_zone_id
      name    = "mail._domainkey.ujstor.com"
      content = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuXHXT77jxdu/FnWzj8syAeJjRqu7QVZauYMxCYI1bADDR5eVXeffg8fS6Zo9KDxHni3JAg2RawjPXtTjSHrZCVNND1JBbBF74YwUzJbNa3SQ6aFrA4zET6FDdxaHkDblW7fU/HTaqrVJ4F7+OaFePxc6Na8Qoltxk1cTmEY2ojqPN99zwi0Mm3LvqEFFY69je9mng8J3uP+LmEWe7fVoHf21+lRSqkcfGfCJRwQHPKTZioGIaVCNvDTe+7KxTyFGaHjs6SmH2+7Hws+8RXpgfQqzDT7EAgUXrNszTzInCMpV+1vm0QJ6gDaZUyc6ZOUNt7kIskGXh+Kv3nb69sImGwIDAQAB"
      type    = "TXT"
      ttl     = 1
    }

  }
  depends_on = [module.k3s_prod]
}
