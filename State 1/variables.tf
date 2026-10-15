variable "vpc_name" {
  type        = string
  default     = "my-vpc"
  description = "The name of the VPC"
}

variable "cluster_name" {
  type        = string
  default     = "my-cluster"
  description = "The name of the EKS cluster"
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.small"]
  description = "The instance types for the EKS node group"
}

variable "number_nodes" {
  type        = number
  default     = 2
  description = "The number of nodes in the EKS node group"
}

variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "The AWS region"
}