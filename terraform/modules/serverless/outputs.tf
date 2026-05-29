output "assets_bucket_name" {
  description = "Assets S3 bucket name"
  value       = aws_s3_bucket.assets.bucket
}

output "assets_bucket_arn" {
  description = "Assets S3 bucket ARN"
  value       = aws_s3_bucket.assets.arn
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.asset_processor.function_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.asset_processor.arn
}
