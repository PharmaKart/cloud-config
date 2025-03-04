# Security Group for the Application Load Balancer
resource "aws_security_group" "alb_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.alb_name}-sg"
  description = "Security group for Frontend Application Load Balancer"

  tags = {
    Name      = "${var.alb_name}-sg"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_ingress" {
  security_group_id = aws_security_group.alb_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTP traffic"

  tags = {
    Name = "HTTP"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_ingress" {
  security_group_id = aws_security_group.alb_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTPS traffic"

  tags = {
    Name = "HTTPS"
  }
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"

  tags = {
    Name = "All traffic"
  }
}
