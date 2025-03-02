# Security group for the RDS instance
resource "aws_security_group" "database_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.vpc_name}-database-sg"
  description = "Allow traffic from backend to the database on port ${var.db_port}"

  tags = {
    Name      = "database-sg"
    Role      = "database"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "database_ingress" {
  security_group_id            = aws_security_group.database_sg.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.eks_node_security_group_id
  description                  = "Allow traffic from the backend"

  tags = {
    Name = "DB ${var.db_port}"
  }
}

resource "aws_vpc_security_group_egress_rule" "database_egress" {
  security_group_id = aws_security_group.database_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"

  tags = {
    Name = "All traffic"
  }
}
