locals {
  ssh_directory = "${path.root}/../nodes-infra/.ssh"
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

resource "aws_s3_object" "prod_ssh_dir" {
  for_each = fileset(local.ssh_directory, "*")
  bucket   = aws_s3_bucket.ssh_keys_backup.id
  key      = "prod_ssh_keys/${each.value}"
  source   = "${local.ssh_directory}/${each.value}"
  etag     = filemd5("${local.ssh_directory}/${each.value}")
}
