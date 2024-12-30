data "hcloud_server" "k3s5" {
  with_selector = "cluster=k3s5"
}
