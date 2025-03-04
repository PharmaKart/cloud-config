variable "alb_name" {
  description = "The name of the ALB"
  type        = string
}

variable "frontend_port" {
  description = "The port for the frontend"
  type        = number
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "The IDs of the public subnets"
  type        = list(string)
}
