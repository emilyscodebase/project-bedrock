output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = var.cluster_name
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "assets_bucket_name" {
  description = "Assets S3 bucket name"
  value       = module.serverless.assets_bucket_name
}

output "dev_access_key_id" {
  description = "Developer IAM access key ID"
  value       = module.security.dev_access_key_id
}

output "dev_secret_access_key" {
  description = "Developer IAM secret access key"
  value       = module.security.dev_secret_access_key
  sensitive   = true
}

output "dev_console_password" {
  description = "Developer console password"
  value       = module.security.dev_console_password
  sensitive   = true
}
