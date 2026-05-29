output "dev_user_name" {
  description = "Developer IAM username"
  value       = aws_iam_user.dev_view.name
}

output "dev_access_key_id" {
  description = "Developer access key ID"
  value       = aws_iam_access_key.dev_view.id
}

output "dev_secret_access_key" {
  description = "Developer secret access key"
  value       = aws_iam_access_key.dev_view.secret
  sensitive   = true
}

output "dev_console_password" {
  description = "Developer console password"
  value       = aws_iam_user_login_profile.dev_view.password
  sensitive   = true
}
