output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "EKS cluster CA certificate"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "node_security_group_id" {
  description = "Node security group ID"
  value       = aws_security_group.nodes.id
}

output "node_group_role_arn" {
  description = "Node group IAM role ARN"
  value       = aws_iam_role.node_group.arn
}

output "cluster_role_arn" {
  description = "Cluster IAM role ARN"
  value       = aws_iam_role.cluster.arn
}
