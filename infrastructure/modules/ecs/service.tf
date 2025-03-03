module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.12.0"

  name = "${var.cluster_name}-service"

  cluster_arn = module.ecs_cluster.arn

  memory = 512
  cpu    = 256

  requires_compatibilities = ["EC2"]
  capacity_provider_strategy = {
    spot = {
      capacity_provider = module.ecs_cluster.autoscaling_capacity_providers["spot"].name
      weight            = 1
      base              = 1
    }
  }

  container_definitions = {
    (var.container_name) = {
      image = var.container_image
      memory = 512
      port_mappings = [
        {
          name          = var.container_name
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = var.container_environment

      enable_cloudwatch_logging              = true
      create_cloudwatch_log_group            = true
      cloudwatch_log_group_name              = "/aws/ecs/${var.cluster_name}-service/${var.container_name}"
      cloudwatch_log_group_retention_in_days = 7

      log_configuration = {
        logDriver = "awslogs"
      }
    }
  }

  load_balancer = {
    service = {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  subnet_ids = var.subnet_ids

  create_security_group = false

  security_group_ids = [aws_security_group.ecs_service_sg.id]



  tags = {
    Name      = "pharmakart-service"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }

  depends_on = [module.ecs_cluster]
}
