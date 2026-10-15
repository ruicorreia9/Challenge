module "networking" {
  source   = "./modules/networking"
  vpc_name = var.vpc_name
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  vpc_id          = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  instance_types  = var.instance_types
  number_nodes    = var.number_nodes

  depends_on = [module.networking]
}