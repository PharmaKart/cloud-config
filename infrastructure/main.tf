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

// Deploying the Bastion module
module "bastion" {
  source           = "./modules/bastion"
  instance_type    = var.bastion_instance_type
  public_subnet_id = element(module.vpc.vpc_public_subnets, 0)
  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
  bastion_name     = var.bastion_name
  aws_region       = var.default_region
  eks_cluster_name = var.eks_cluster_name
  depends_on       = [module.vpc]
}

// Deploying the S3 module
module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  s3_folders  = var.s3_folders
}

// Deploying the EKS module
module "eks" {
  source                   = "./modules/eks"
  cluster_name             = var.eks_cluster_name
  cluster_version          = var.eks_cluster_version
  vpc_id                   = module.vpc.vpc_id
  aws_region               = var.default_region
  subnet_ids               = slice(module.vpc.vpc_private_subnets, 2, 4)
  backend_port             = var.backend_port
  s3_bucket_arn            = module.s3.bucket_arn
  bastion_sg_id            = module.bastion.bastion_sg_id
  bastion_role_arn         = module.bastion.bastion_role_arn
  bastion_instance_id      = module.bastion.bastion_id
  bastion_public_ip        = module.bastion.bastion_public_ip
  bastion_private_key_path = var.bastion_private_key_path
  depends_on               = [module.vpc, module.s3, module.bastion]
}

// Deploying the Ingress Load Balancer module
module "ingress-lb" {
  source                 = "./modules/ingress-lb"
  cluster_name           = var.eks_cluster_name
  cluster_version        = var.eks_cluster_version
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = slice(module.vpc.vpc_public_subnets, 0, 2)
  provider_arn           = module.eks.oidc_provider_arn
  node_security_group_id = module.eks.node_security_group_id
  depends_on             = [module.vpc, module.eks]
}

// Deploying the RDS module
module "rds" {
  source                     = "./modules/rds"
  vpc_id                     = module.vpc.vpc_id
  vpc_name                   = var.vpc_name
  db_engine_version          = var.db_engine_version
  db_major_engine_version    = var.db_major_engine_version
  db_name                    = var.db_name
  db_username                = var.db_username
  db_password                = var.db_password
  db_port                    = var.database_port
  db_subnet_group_name       = module.vpc.vpc_database_subnet_group_name
  rds_instance_class         = var.db_instance_class
  eks_node_security_group_id = module.eks.node_security_group_id
  bastion_sg_id              = module.bastion.bastion_sg_id
  bastion_public_ip          = module.bastion.bastion_public_ip
  bastion_private_key_path   = var.bastion_private_key_path
  depends_on                 = [module.vpc, module.eks, module.bastion]
}

# // Deploying Frontend Application Load Balancer module
module "alb" {
  source         = "./modules/alb"
  alb_name       = var.frontend_alb_name
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.vpc_public_subnets
  frontend_port  = var.frontend_port
  depends_on     = [module.vpc]
}

// Deploying the ECS module
module "ecs" {
  source          = "./modules/ecs"
  cluster_name    = var.ecs_cluster_name
  container_name  = var.frontend_container_name
  container_image = var.frontend_container_image
  container_port  = var.frontend_port
  container_environment = [
    {
      name  = "BACKEND_URL",
      value = "http://ashutoshportfolio.site"
      # value = "http://${module.ingress-lb.load_balancer_hostname}"
    }
  ]
  target_group_arn = module.alb.alb_target_group_arn
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = slice(module.vpc.vpc_private_subnets, 0, 2)
  alb_sg_id        = module.alb.alb_sg_id
  depends_on       = [module.vpc, module.alb, module.ingress-lb]
}

// Deploying the K8s Manifests module
module "k8s-manifests" {
  source                  = "./modules/k8s-manifests"
  backend_port            = var.backend_port
  frontend_endpoint       = "http://${module.alb.alb_dns_name}"
  database_endpoint       = module.rds.instance_endpoint
  stripe_webhook_secret   = var.stripe_webhook_secret
  stripe_secret_key       = var.stripe_secret_key
  jwt_secret              = var.jwt_secret
  sns_topic_arn           = "your-sns-topic-arn"
  sqs_queue_url           = "your-sqs-queue-url"
  db_port                 = var.database_port
  db_user                 = var.db_username
  db_password             = var.db_password
  db_name                 = var.db_name
  gateway_replicas        = var.gateway_replicas
  gateway_image           = var.gateway_image
  authentication_replicas = var.authentication_replicas
  authentication_image    = var.authentication_image
  product_replicas        = var.product_replicas
  product_image           = var.product_image
  order_replicas          = var.order_replicas
  order_image             = var.order_image
  payment_replicas        = var.payment_replicas
  payment_image           = var.payment_image
  reminder_replicas       = var.reminder_replicas
  reminder_image          = var.reminder_image
  depends_on              = [module.vpc, module.eks, module.rds, module.alb, module.ingress-lb, module.ecs]
}
