# CloudWatch Log Group for EKS Control Plane
resource "aws_cloudwatch_log_group" "eks_control_plane" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-eks-control-plane-logs"
  }
}

# CloudWatch Log Group for Application
resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/eks/${var.cluster_name}/application"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-application-logs"
  }
}

# CloudWatch Log Group for FluentBit
resource "aws_cloudwatch_log_group" "fluentbit" {
  name              = "/aws/eks/${var.cluster_name}/fluentbit"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-fluentbit-logs"
  }
}
