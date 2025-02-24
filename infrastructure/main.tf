data "aws_availability_zones" "azs" {}

module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = var.vpc_cidr
  vpc_name              = var.vpc_name
  availability_zones    = slice(data.aws_availability_zones.azs.names, 0, 2)
  public_subnet_cidrs   = slice(local.cidr_subnets, 0, 2)
  private_subnet_cidrs  = slice(local.cidr_subnets, 2, 4)
  database_subnet_cidrs = slice(local.cidr_subnets, 4, 6)
  frontend_port         = var.frontend_port
  backend_port          = var.backend_port
  database_port         = var.database_port
}
