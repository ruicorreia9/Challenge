module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  vpc_id                          = var.vpc_id
  subnet_ids                      = var.private_subnets
  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = var.instance_types
      min_size       = var.number_nodes
      max_size       = var.number_nodes
      desired_size   = var.number_nodes

      subnet_ids = [var.private_subnets[0]]

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }
}