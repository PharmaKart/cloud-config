variable "name" {
  description = "The name of the Auto Scaling Group"
  type        = string
}

variable "frontend_subnets" {
  description = "The IDs of the frontend subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}