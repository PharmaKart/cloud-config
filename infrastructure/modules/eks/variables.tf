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

variable "aws_region" {
  description = "The AWS region"
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

variable "bastion_instance_id" {
  description = "The ID of the Bastion Instance"
  type        = string
}

variable "bastion_public_ip" {
  description = "The public IP of the Bastion Instance"
  type        = string
}

variable "bastion_private_key_path" {
  description = "The path to the private key for the Bastion Instance"
  type        = string
}
