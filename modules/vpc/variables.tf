variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type = string
    default = "10.0.0.0/16"
}
variable "vpc_name" {
    description = "The name of the VPC"
    type = string
    default = "pharmakart-vpc"
}
variable "availability_zones" {
    description = "The availability zones for the VPC"
    type = list(string)
    default = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
}
variable "public_subnet_cidrs" {
    description = "The CIDR blocks for the public subnets"
    type = list(string)
}
variable "private_subnet_cidrs" {
    description = "The CIDR blocks for the private subnets"
    type = list(string)
}
variable "database_subnet_cidrs" {
    description = "The CIDR blocks for the database subnets"
    type = list(string)
}

variable "frontend_port" {
    description = "The port for the frontend"
    type = number
    default = 3000
}

variable "backend_port" {
    description = "The port for the backend"
    type = number
    default = 8080
}

variable "database_port" {
    description = "The port for the database"
    type = number
    default = 5432
}