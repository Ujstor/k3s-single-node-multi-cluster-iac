output "server_info" {
  value = module.k3s_prod.server_info
}

output "floating_ip_info" {
  value = module.floating_ip.floating_ip_status
}
