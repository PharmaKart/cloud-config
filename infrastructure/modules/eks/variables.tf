variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
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

variable "backend_port" {
  description = "The port for the backend"
  type        = number
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}

variable "bastion_sg_id" {
  description = "The ID of the Bastion Security Group"
  type        = string
}

variable "bastion_role_arn" {
  description = "The ARN of the Bastion IAM Role"
  type        = string
}
