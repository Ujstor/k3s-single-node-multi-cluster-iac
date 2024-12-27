locals {
  json_data = jsondecode(data.curl.ip_info.response)
  ip        = local.json_data.ip
}

data "curl" "ip_info" {
  http_method = "GET"
  uri         = "https://api.ipify.org?format=json"
}
