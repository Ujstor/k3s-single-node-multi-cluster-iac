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
    kube_api_k3s2 = {
      zone_id = var.cloudflare_zone_id
      name    = "api.k3s2"
      content = module.k3s_prod.server_info.k3s2-win.ip
      type    = "A"
      ttl     = 60
      proxied = false
    }
    wildcard_k3s2 = {
      zone_id = var.cloudflare_zone_id
      name    = "*.k3s2"
      content = module.k3s_prod.server_info.k3s2-win.ip
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
      content = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAj3Rdv+i/KiBIQ0YiCIVlhoGPKycSyBdEZGGTdfazZVkH+p7NWIKEcwrVx0ExFd7ri2YIAkJKUVlt8gRQ+tmZLGJYB6q0MIfZYC8G/tJsU6xES7DH9dAtgruu4hSUertdid1zX9hFgluHzmwVI4rbx+rMbXyq5VhkjA/ZS2gYw2DUWFXFNsTRMmu/XL1kOHEz0+My65zoQgYz/i99Un0kiGs9NP2DSellOk7TsvbNf/CSMpbnotdUTA/iG2TifiR83Ha9UVaiUW7muxlF5SuVyDD44hToDlisUEk4gpZ7bvxcJorJFFhEQ9COJuKBmM98B8+7ttfI8IzCGqaCu1/1QwIDAQAB"
      type    = "TXT"
      ttl     = 1
    }

  }
  depends_on = [module.k3s_prod]
}
