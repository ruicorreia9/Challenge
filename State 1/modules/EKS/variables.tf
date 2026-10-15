variable "vpc_id" {
  type        = string
  default     = ""
  description = "The ID of the VPC"
}

variable "private_subnets" {
  type        = list(string)
  default     = []
  description = "The IDs of the private subnets"
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