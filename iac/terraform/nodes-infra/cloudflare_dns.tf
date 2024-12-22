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
      content = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlKuh1diP0S5sKdXtlMnjqtDijNqXAHnsHo4jRySPS8TgjwJIKuKa8jq4LlsStZoUXcCEGlqJuBnUqVUeOoBkCrJRqQqh3sg1YgPTzKIfqb6Yq10x6N//BftlgvIB7y0I/UdcE6S3i4Umub0xB6/A7pY6tXtqqlT91jDvl1gN2wugQF0unsPrqzVyplOkS8mT2Uz08gtrgf3Aa7gQ+IQo93hciLH0I/Ik9LK5Lfj62J4SfMUAAQBw5gSETi0ZIlzd9xkziBYpx6xDDjqEp8L2fbejstYlERMDIQOaKibvCwG2VF52oIMkNuu7R4qpChjsnbvFqa7hSQCfAluwjl2bfwIDAQAB"
      type    = "TXT"
      ttl     = 1
    }

  }
  depends_on = [module.k3s_prod]
}
