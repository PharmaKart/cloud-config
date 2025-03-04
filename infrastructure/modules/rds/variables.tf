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

variable "db_engine_version" {
  description = "The version of the database"
  type        = string
}

variable "db_major_engine_version" {
  description = "The major version of the database"
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

variable "bastion_sg_id" {
  description = "Security group ID of the Bastion host"
  type        = string
}

variable "bastion_private_key_path" {
  description = "The path to the private key for the Bastion host"
  type        = string
}

variable "bastion_public_ip" {
  description = "The public IP address of the Bastion host"
  type        = string
}
