variable "default_region" {
  description = "The default region to deploy resources"
  type        = string
}

variable "account_id" {
  description = "The account ID to deploy resources"
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

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "eks_cluster_version" {
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

variable "db_engine_version" {
  description = "The version of the database"
  type        = string
}

variable "db_major_engine_version" {
  description = "The major version of the database"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "s3_folders" {
  description = "The list of folders to create in the S3 bucket"
  type        = list(string)
}

variable "frontend_alb_name" {
  description = "The name of the Frontend Application Load Balancer"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "frontend_container_name" {
  description = "The name of the frontend container"
  type        = string
}

variable "frontend_container_image" {
  description = "The image to use for the frontend container"
  type        = string
}

variable "bastion_instance_type" {
  description = "The instance type for the Bastion host"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH into the Bastion host"
  type        = list(string)
}

variable "bastion_name" {
  description = "The name of the Bastion host"
  type        = string
}

variable "bastion_private_key_path" {
  description = "The path to the private key for the Bastion host (Empty string to ~/.ssh/id_rsa)"
  type        = string
}

variable "stripe_webhook_secret" {
  description = "The secret for the stripe webhook"
  type        = string
}

variable "stripe_secret_key" {
  description = "The secret key for stripe"
  type        = string
}

variable "jwt_secret" {
  description = "The secret for the JWT"
  type        = string
}

variable "gateway_replicas" {
  description = "The number of replicas for the gateway service"
  type        = number
}

variable "gateway_image" {
  description = "The image for the gateway service"
  type        = string
}

variable "authentication_replicas" {
  description = "The number of replicas for the authentication service"
  type        = number
}

variable "authentication_image" {
  description = "The image for the authentication service"
  type        = string
}

variable "product_replicas" {
  description = "The number of replicas for the product service"
  type        = number
}

variable "product_image" {
  description = "The image for the product service"
  type        = string
}

variable "order_replicas" {
  description = "The number of replicas for the order service"
  type        = number
}

variable "order_image" {
  description = "The image for the order service"
  type        = string
}

variable "payment_replicas" {
  description = "The number of replicas for the payment service"
  type        = number
}

variable "payment_image" {
  description = "The image for the payment service"
  type        = string
}

variable "reminder_replicas" {
  description = "The number of replicas for the reminder service"
  type        = number
}

variable "reminder_image" {
  description = "The image for the reminder service"
  type        = string
}

variable "build_projects" {
  description = "The list of projects to build"
  type = map(object({
    repository = string
    image      = string
    type       = string
  }))
}

variable "source_connection_arn" {
  description = "The connection ARN to the source repository"
  type        = string
}
