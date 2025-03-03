# Security Group for the ECS Service
resource "aws_security_group" "ecs_service_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-ecs_service-sg"
  description = "Security group for ECS to Allow ALB traffic"

  tags = {
    Name      = "${var.cluster_name}-ecs_service-sg"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs_service_http_ingress" {
  security_group_id            = aws_security_group.ecs_service_sg.id
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.alb_sg_id
  description                  = "Allow HTTP traffic"

  tags = {
    Name = "HTTP ${var.container_port}"
  }
}

resource "aws_vpc_security_group_egress_rule" "ecs_service_egress" {
  security_group_id = aws_security_group.ecs_service_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"

  tags = {
    Name = "All traffic"
  }
}
