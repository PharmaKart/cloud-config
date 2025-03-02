data "aws_availability_zones" "azs" {}

// Deploying the VPC module
module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = var.vpc_cidr
  vpc_name              = var.vpc_name
  availability_zones    = slice(data.aws_availability_zones.azs.names, 0, 2)
  public_subnet_cidrs   = slice(local.cidr_subnets, 0, 2)
  private_subnet_cidrs  = slice(local.cidr_subnets, 2, 6)
  database_subnet_cidrs = slice(local.cidr_subnets, 6, 8)
  frontend_port         = var.frontend_port
  backend_port          = var.backend_port
  database_port         = var.database_port
}

// Deploying the EKS module
module "eks" {
  source                = "./modules/eks"
  cluster_name          = var.cluster_name
  cluster_version       = var.cluster_version
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = slice(module.vpc.vpc_private_subnets, 2, 4)
  backend_port          = var.backend_port
  depends_on = [ module.vpc ]
}

// Deploying the Ingress Load Balancer module
module "ingress-lb" {
  source                = "./modules/ingress-lb"
  cluster_name          = var.cluster_name
  cluster_version       = var.cluster_version
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = slice(module.vpc.vpc_public_subnets, 0, 2)
  provider_arn         = module.eks.oidc_provider_arn
  depends_on = [ module.vpc, module.eks ]
}