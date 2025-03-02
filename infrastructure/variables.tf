variable "default_region" {
  description = "The default region to deploy resources"
  type        = string
}

locals {
  cidr_subnets = cidrsubnets(var.vpc_cidr, 8, 8, 8, 8, 8, 8, 8, 8)
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "frontend_port" {
  description = "The port for the frontend"
  type        = number
}

variable "backend_port" {
  description = "The port for the backend"
  type        = number
}

variable "database_port" {
  description = "The port for the database"
  type        = number
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
}

variable "db_instance_class" {
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
