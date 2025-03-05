module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  access_entries = {
    bastion_access = {
      principal_arn = var.bastion_role_arn

      policy_associations = {
        admin_access = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  enable_cluster_creator_admin_permissions = true

  cluster_security_group_additional_rules = {
    bastion_to_eks = {
      description              = "Allow bastion to communicate with EKS Control Plane"
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = var.bastion_sg_id
      type                     = "ingress"
    }
  }


  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_group_defaults = {
    disk_size      = 20
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    eks-managed-ng = {
      name = "${var.cluster_name}-nodes"

      min_size     = 2
      desired_size = 2
      max_size     = 3

      iam_role_additional_policies = {
        s3_access = aws_iam_policy.eks_nodes_s3_policy.arn
      }
    }
  }

  tags = {
    Name      = var.cluster_name
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "null_resource" "configure_kubectl" {
  # Ensure this runs after both the bastion and EKS cluster are created
  depends_on = [module.eks]

  # Provisioner to configure kubectl directly
  provisioner "remote-exec" {
    inline = [
      "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.bastion_private_key_path != "" ? file(var.bastion_private_key_path) : file("~/.ssh/id_rsa")
      host        = var.bastion_public_ip
    }
  }
  triggers = {
    bastion_instance_id = var.bastion_instance_id
  }
}
