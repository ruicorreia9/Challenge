variable "cluster_name" {
  type        = string
  default     = "my-eks-cluster"
  description = "The name of the EKS cluster"
}

variable "load_balancer_controller_role_arn" {
  description = "ARN of the IAM role for the AWS Load Balancer Controller"
  type        = string
}

variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "The AWS region"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The ID of the VPC"
}
