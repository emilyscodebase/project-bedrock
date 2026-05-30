# Project Bedrock — InnovateMart EKS Deployment

## Overview
Production-grade Kubernetes environment on AWS EKS deploying the Retail Store Sample Application.

## Live Application
http://k8s-retailap-retailst-17d19cf248-1146753240.us-east-1.elb.amazonaws.com

## Architecture
- EKS Cluster: project-bedrock-cluster (v1.34)
- VPC: project-bedrock-vpc (10.0.0.0/16)
- Databases: RDS MySQL, RDS PostgreSQL, DynamoDB
- Ingress: AWS Load Balancer Controller + ALB
- Logging: CloudWatch Observability Add-on
- Serverless: S3 + Lambda event pipeline
- Security: IAM user with RBAC, Secrets Manager

## Prerequisites
- AWS CLI configured
- kubectl installed
- Terraform >= 1.0
- eksctl installed
- helm installed

## Deployment Guide

### 1. Deploy Infrastructure
cd terraform && terraform init && terraform apply -auto-approve

### 2. Configure kubectl
aws eks update-kubeconfig --name project-bedrock-cluster --region us-east-1

### 3. Install AWS Load Balancer Controller
helm repo add eks https://aws.github.io/eks-charts
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=project-bedrock-cluster --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

### 4. Deploy Application
kubectl apply -f k8s/retail-store.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/rbac.yaml

## CI/CD Pipeline
- Pull Request triggers terraform plan posted as PR comment
- Merge to main triggers terraform apply automatically

## Developer Access
IAM user bedrock-dev-view has ReadOnly AWS Console access and Kubernetes view ClusterRole in retail-app namespace.

## Resource Tags
All resources tagged with Project: karatu-2025-capstone

## Grading Credentials
See submission Google Document for bedrock-dev-view credentials.
