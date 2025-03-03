module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.13.0"

  name = var.alb_name

  load_balancer_type = "application"

  vpc_id  = var.vpc_id
  subnets = var.public_subnets

  enable_deletion_protection = false

  create_security_group = false

  security_groups = [aws_security_group.alb_sg.id]

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "${var.alb_name}-ecs-service"
      }
    }
  }

  target_groups = {
    "${var.alb_name}-ecs-service" = {
      backend_protocol                  = "HTTP"
      backend_port                      = var.frontend_port
      target_type                       = "ip"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 2
        unhealthy_threshold = 2
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
      }

      create_attachment = false
    }
  }

  tags = {
    Name      = var.alb_name
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}
