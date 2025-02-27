variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default     = "tf-state-k3s0-k3s1-cluster"
}
