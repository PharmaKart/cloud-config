module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.12.0"

  name = "${var.cluster_name}-service"

  cluster_arn = module.ecs_cluster.arn

  cpu    = 1024
  memory = 4096

  enable_execute_command = true

  container_definitions = {
    (var.container_name) = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = var.container_image
      port_mappings = [
        {
          name          = var.container_name
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      readonly_root_filesystem = true

      environment = var.container_environment

      enable_cloudwatch_logging              = true
      create_cloudwatch_log_group            = true
      cloudwatch_log_group_name              = "/aws/ecs/${var.cluster_name}-service/${var.container_name}"
      cloudwatch_log_group_retention_in_days = 7

      log_configuration = {
        logDriver = "awslogs"
      }

      memory_reservation = 100
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

  service_tags = {
    Name      = "${var.cluster_name}-service"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }


  tags = {
    Name      = "pharmakart-service"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }

  depends_on = [module.ecs_cluster]
}
