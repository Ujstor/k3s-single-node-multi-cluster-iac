locals {
  home_directory = pathexpand("~")
  kube_directory = "${local.home_directory}/.kube"
}

resource "aws_s3_bucket" "ssh_keys_backup" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "enable" {
  bucket = aws_s3_bucket.ssh_keys_backup.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "prod_kubeconfig" {
  for_each = fileset(local.kube_directory, "*")
  bucket   = aws_s3_bucket.ssh_keys_backup.id
  key      = "kubeconfig/${each.value}"
  source   = "${local.kube_directory}/${each.value}"
  etag     = filemd5("${local.kube_directory}/${each.value}")
}
