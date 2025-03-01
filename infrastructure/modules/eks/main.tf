module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_group_defaults = {
    disk_size = 20
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    eks-managed-ng = {
      name = "${var.cluster_name}-nodes"

      min_size = 2
      desired_size = 2
      max_size = 3
    }
  }

  tags = {
    Name = var.cluster_name
    Project     = "Pharmakart"
    ManagedBy = "Terraform"
  }
}