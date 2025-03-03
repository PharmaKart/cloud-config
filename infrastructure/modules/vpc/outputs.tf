output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.default_vpc_cidr_block
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_database_subnets" {
  value = module.vpc.database_subnets
}

output "vpc_database_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}

# output "security_group_public" {
#   value = aws_security_group.public_sg.id
# }

# output "security_group_bastion" {
#   value = aws_security_group.bastion_sg.id
# }

# output "security_group_private_frontend" {
#   value = aws_security_group.private_sg_frontend.id
# }

# output "security_group_private_backend" {
#   value = aws_security_group.private_sg_backend.id
# }

# output "security_group_database" {
#   value = aws_security_group.database_sg.id
# }

