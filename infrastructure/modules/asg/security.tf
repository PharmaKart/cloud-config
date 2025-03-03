# Security Group for the Auto Scaling Group
resource "aws_security_group" "asg_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.name}-sg"
  description = "Security group for Frontend Application Load Balancer"

  tags = {
    Name      = "${var.name}-sg"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "asg_http_ingress" {
  security_group_id = aws_security_group.asg_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTP traffic"

  tags = {
    Name = "ASG HTTP 80"
  }
}

resource "aws_vpc_security_group_ingress_rule" "asg_https_ingress" {
  security_group_id = aws_security_group.asg_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTPS traffic"

  tags = {
    Name = "ASG HTTPS 443"
  }
}

resource "aws_vpc_security_group_egress_rule" "asg_egress" {
  security_group_id = aws_security_group.asg_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"

  tags = {
    Name = "All traffic"
  }
}
