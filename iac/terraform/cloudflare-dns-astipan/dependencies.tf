data "hcloud_server" "k3s1" {
  with_selector = "cluster=k3s1"
}
