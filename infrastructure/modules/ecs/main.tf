module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.12.0"

  cluster_name = var.cluster_name

  default_capacity_provider_use_fargate = false
  autoscaling_capacity_providers = {
    spot = {
      auto_scaling_group_arn         = var.autoscaling_group_arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 5
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 60
      }

      default_capacity_provider_strategy = {
        weight = 60
        base   = 20
      }
    }
  }

  tags = {
    Name      = var.cluster_name
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}
