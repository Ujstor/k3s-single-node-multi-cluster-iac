module "cloudflare_record" {
  source = "github.com/Ujstor/terraform-hetzner-modules//modules/network/cloudflare_record?ref=v0.0.8"

  cloudflare_record = {
    portfolio = {
      zone_id = var.cloudflare_zone_id
      name    = "@"
      content = data.hcloud_server.k3s1.ipv4_address
      type    = "A"
      ttl     = 1
      proxied = true
    }
    portfolio_CNAME = {
      zone_id = var.cloudflare_zone_id
      name    = "www"
      content = "astipan.com"
      type    = "CNAME"
      ttl     = 1
      proxied = true
    }
    working-hours = {
      zone_id = var.cloudflare_zone_id
      name    = "working-hours"
      content = data.hcloud_server.k3s1.ipv4_address
      type    = "A"
      ttl     = 1
      proxied = true
    }
    todo = {
      zone_id = var.cloudflare_zone_id
      name    = "todo"
      content = data.hcloud_server.k3s1.ipv4_address
      type    = "A"
      ttl     = 1
      proxied = true
    }
    notes-flask = {
      zone_id = var.cloudflare_zone_id
      name    = "notes-flask"
      content = data.hcloud_server.k3s1.ipv4_address
      type    = "A"
      ttl     = 1
      proxied = true
    }
    probit-api = {
      zone_id = var.cloudflare_zone_id
      name    = "probit"
      content = data.hcloud_server.k3s1.ipv4_address
      type    = "A"
      ttl     = 1
      proxied = true
    }
    social-media-api = {
      zone_id = var.cloudflare_zone_id
      name    = "fastapi"
      content = data.hcloud_server.k3s1.ipv4_address
      type    = "A"
      ttl     = 1
      proxied = true
    }
    django-todo = {
      zone_id = var.cloudflare_zone_id
      name    = "django-todo"
      content = data.hcloud_server.k3s1.ipv4_address
      type    = "A"
      ttl     = 1
      proxied = true
    }
  }
}
