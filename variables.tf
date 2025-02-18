variable "default_region" {
  description = "The default region to deploy resources"
  type        = string
  default     = "ca-central-1"
}

locals {
  cidr_subnets = cidrsubnets("10.0.0.0/16", 8, 8, 8, 8, 8, 8)
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "frontend_port" {
  description = "The port for the frontend"
  type        = number
  default     = 3000
}

variable "backend_port" {
  description = "The port for the backend"
  type        = number
  default     = 8080
}

variable "database_port" {
  description = "The port for the database"
  type        = number
  default     = 5432
}

