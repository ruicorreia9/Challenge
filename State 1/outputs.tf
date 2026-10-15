output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "The endpoint of the EKS cluster"
}

output "cluster_certificate_authority_data" {
  value       = module.eks.cluster_certificate_authority_data
  description = "The base64 encoded certificate authority data for the EKS cluster"
}

output "cluster_name" {
  value       = var.cluster_name
  description = "The name of the EKS cluster"
}

output "region" {
  value       = var.region
  description = "The AWS region"
}

output "oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "The ARN of the OIDC provider for the EKS cluster"
}

output "vpc_id" {
  value       = module.networking.vpc_id
  description = "The ID of the VPC"
}

output "public_subnets" {
  value       = module.networking.public_subnets
  description = "The IDs of the public subnets"
}

output "cluster_oidc_issuer_url" {
  value       = module.eks.cluster_oidc_issuer_url
  description = "The OIDC issuer URL of the EKS cluster"
}