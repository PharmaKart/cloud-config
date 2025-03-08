variable "source_connection_arn" {
  description = "The ARN of the CodeStar Source Connection"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to run the CodePipeline"
  type        = string
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "s3codepipeline_bucket" {
  description = "The S3 bucket to store the CodePipeline artifacts"
  type        = string
}

variable "s3_codepipeline_bucket_arn" {
  description = "The ARN of the S3 bucket to store the CodePipeline artifacts"
  type        = string
}

variable "eks_cluster_name" {
  description = "The EKS cluster name"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The ECS cluster name"
  type        = string
}

variable "frontend_container_name" {
  description = "The name of the frontend container"
  type        = string
}

variable "build_projects" {
  description = "The list of build projects"
  type = map(object({
    repository = string
    image      = string
    type       = string
  }))
}
