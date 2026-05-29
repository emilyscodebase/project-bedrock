# S3 Assets Bucket
resource "aws_s3_bucket" "assets" {
  bucket = "bedrock-assets-${var.student_id}"

  tags = {
    Name = "bedrock-assets-${var.student_id}"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lambda IAM Role
resource "aws_iam_role" "lambda" {
  name = "bedrock-asset-processor-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "bedrock-asset-processor-role"
  }
}

# Lambda Basic Execution Policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function Code
data "archive_file" "lambda" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"
  source {
    content  = <<EOF
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        logger.info(f"Image received: {key}")
        print(f"Image received: {key}")
    return {
        'statusCode': 200,
        'body': json.dumps('Processing complete')
    }
EOF
    filename = "lambda_function.py"
  }
}

# Lambda Function
resource "aws_lambda_function" "asset_processor" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "bedrock-asset-processor"
  role             = aws_iam_role.lambda.arn
  handler          = "lambda_function.handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  tags = {
    Name = "bedrock-asset-processor"
  }
}

# S3 Lambda Permission
resource "aws_lambda_permission" "s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.assets.arn
}

# S3 Event Notification
resource "aws_s3_bucket_notification" "assets" {
  bucket = aws_s3_bucket.assets.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.asset_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.s3]
}
