variable "cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL of the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "The ARN of the OIDC provider for the EKS cluster"
  type        = string
}