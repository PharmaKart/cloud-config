variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "container_name" {
  description = "The name of the container"
  type        = string
}

variable "container_image" {
  description = "The image to use for the container"
  type        = string
}

variable "container_port" {
  description = "The port to expose on the container"
  type        = number
}

variable "container_environment" {
  description = "The environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
}

variable "target_group_arn" {
  description = "The ARN of the target group"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "The ID of the security group for the ALB"
  type        = string
}

variable "autoscaling_group_arn" {
  description = "The ARN of the Auto Scaling Group"
  type        = string
}
