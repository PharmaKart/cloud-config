resource "aws_security_group" "public_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "${var.vpc_name}-public-sg"
  description = "Allow internet traffic to the public subnets"

  tags = {
    Name      = "public-sg"
    Role      = "public"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_sg_ingress" {
  security_group_id = aws_security_group.public_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTP traffic"

  tags = {
    Name = "HTTP"
  }
}

resource "aws_vpc_security_group_egress_rule" "public_sg_egress" {
  security_group_id = aws_security_group.public_sg.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"

  tags = {
    Name = "All traffic"
  }
}

resource "aws_security_group" "bastion_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "${var.vpc_name}-bastion-sg"
  description = "Allow SSH traffic to the bastion host"

  tags = {
    Name      = "bastion-sg"
    Role      = "bastion"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_sg_ingress" {
  security_group_id = aws_security_group.bastion_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow SSH traffic"

  tags = {
    Name = "SSH"
  }
}

resource "aws_vpc_security_group_egress_rule" "bastion_sg_egress" {
  security_group_id = aws_security_group.bastion_sg.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"

  tags = {
    Name = "All traffic"
  }
}

resource "aws_security_group" "private_sg_frontend" {
  vpc_id      = module.vpc.vpc_id
  name        = "${var.vpc_name}-frontend-sg"
  description = "Allow traffic from the public subnets to the private subnets on port ${var.frontend_port}"

  tags = {
    Name      = "frontend-sg"
    Role      = "private"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_sg_frontend_ingress" {
  security_group_id            = aws_security_group.private_sg_frontend.id
  from_port                    = var.frontend_port
  to_port                      = var.frontend_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.public_sg.id
  description                  = "Allow traffic from the public subnets"

  tags = {
    Name = "HTTP ${var.frontend_port}"
  }
}

resource "aws_vpc_security_group_egress_rule" "private_sg_frontend_egress" {
  security_group_id = aws_security_group.private_sg_frontend.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"

  tags = {
    Name = "All traffic"
  }
}

resource "aws_security_group" "private_sg_backend" {
  vpc_id      = module.vpc.vpc_id
  name        = "${var.vpc_name}-backend-sg"
  description = "Allow traffic from the backend to the frontend on port ${var.backend_port}"

  tags = {
    Name      = "backend-sg"
    Role      = "private"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_sg_backend_ingress" {
  security_group_id            = aws_security_group.private_sg_backend.id
  from_port                    = var.backend_port
  to_port                      = var.backend_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.private_sg_frontend.id
  description                  = "Allow traffic from the frontend"

  tags = {
    Name = "HTTP ${var.backend_port}"
  }
}

resource "aws_vpc_security_group_egress_rule" "private_sg_backend_egress" {
  security_group_id = aws_security_group.private_sg_backend.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"

  tags = {
    Name = "All traffic"
  }
}

resource "aws_security_group" "database_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "${var.vpc_name}-database-sg"
  description = "Allow traffic from the private subnets to the database subnets on port ${var.database_port}"

  tags = {
    Name      = "database-sg"
    Role      = "database"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "database_sg_ingress" {
  security_group_id            = aws_security_group.database_sg.id
  from_port                    = var.database_port
  to_port                      = var.database_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.private_sg_backend.id
  description                  = "Allow traffic from the backend"

  tags = {
    Name = "DB ${var.database_port}"
  }
}

resource "aws_vpc_security_group_egress_rule" "database_sg_egress" {
  security_group_id = aws_security_group.database_sg.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"

  tags = {
    Name = "All traffic"
  }
}
