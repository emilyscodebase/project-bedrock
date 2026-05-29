variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "project-bedrock"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "project-bedrock-cluster"
}

variable "student_id" {
  description = "Student ID for unique resource naming"
  type        = string
  default     = "altsooe025-3738"
}
