variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "eks_node_security_group_id" {
  description = "The ID of the security group for the EKS nodes"
  type        = string
}

variable "rds_instance_class" {
  description = "The instance class to use for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
}

variable "db_username" {
  description = "The username to use for the database"
  type        = string
}

variable "db_password" {
  description = "The password to use for the database"
  type        = string
}

variable "db_port" {
  description = "The port to use for the database"
  type        = number
}

variable "db_subnet_group_name" {
  description = "The name of the database subnet group"
  type        = string
}
