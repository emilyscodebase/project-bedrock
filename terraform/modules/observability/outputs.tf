output "control_plane_log_group" {
  description = "Control plane log group name"
  value       = aws_cloudwatch_log_group.eks_control_plane.name
}

output "application_log_group" {
  description = "Application log group name"
  value       = aws_cloudwatch_log_group.application.name
}
