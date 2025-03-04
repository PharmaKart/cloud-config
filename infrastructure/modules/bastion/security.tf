# Security group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.bastion_name}-sg"
  description = "Security group for Bastion Host"

  tags = {
    Name      = "${var.bastion_name}-sg"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  for_each = toset(var.allowed_ssh_cidr)

  security_group_id = aws_security_group.bastion_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value
  description       = "Allow SSH traffic"

  tags = {
    Name = "SSH"
  }
}

resource "aws_vpc_security_group_egress_rule" "bastion_egress" {
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"

  tags = {
    Name = "All traffic"
  }
}
