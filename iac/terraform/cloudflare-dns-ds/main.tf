module "cloudflare_record" {
  source = "github.com/Ujstor/terraform-hetzner-modules//modules/network/cloudflare_record?ref=v0.0.6"

  cloudflare_record = {
    wordpress-blog = {
      zone_id = var.cloudflare_zone_id
      name    = "@"
      content = data.hcloud_server.k3s1.ipv4_address
      type    = "A"
      ttl     = 60
      proxied = false
    }
    blog_CNAME = {
      zone_id = var.cloudflare_zone_id
      name    = "www"
      content = "dancingspoon.net"
      type    = "CNAME"
      ttl     = 60
      proxied = false
    }
  }
}
