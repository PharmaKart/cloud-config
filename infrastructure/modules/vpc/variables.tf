variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}
variable "availability_zones" {
  description = "The availability zones for the VPC"
  type        = list(string)
}
variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}
variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}
variable "database_subnet_cidrs" {
  description = "The CIDR blocks for the database subnets"
  type        = list(string)
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

