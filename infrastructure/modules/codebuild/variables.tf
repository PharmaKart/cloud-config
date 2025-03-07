variable "account_id" {
  description = "The account ID to deploy resources"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "build_projects" {
  description = "The list of projects to deploy"
  type = map(object({
    repository = string
    image      = string
  }))
}

variable "source_connection_arn" {
  description = "The source connection ARN"
  type        = string
}
