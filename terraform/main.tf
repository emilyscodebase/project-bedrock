terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket = "project-bedrock-tfstate-627099234229"
    key    = "project-bedrock/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "karatu-2025-capstone"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  aws_region   = var.aws_region
}

module "eks" {
  source          = "./modules/eks"
  project_name    = var.project_name
  cluster_name    = var.cluster_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
}

module "rds" {
  source          = "./modules/rds"
  project_name    = var.project_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  eks_sg_id       = module.eks.node_security_group_id
}

module "dynamodb" {
  source       = "./modules/dynamodb"
  project_name = var.project_name
}

module "serverless" {
  source       = "./modules/serverless"
  project_name = var.project_name
  student_id   = var.student_id
}

module "observability" {
  source       = "./modules/observability"
  project_name = var.project_name
  cluster_name = var.cluster_name
}

module "security" {
  source        = "./modules/security"
  project_name  = var.project_name
  student_id    = var.student_id
  assets_bucket = module.serverless.assets_bucket_name
}
