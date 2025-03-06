variable "aws_region" {
  description = "The AWS region"
  type        = string

}

variable "database_endpoint" {
  description = "The endpoint of the database"
  type        = string
}

variable "frontend_endpoint" {
  description = "The endpoint of the frontend"
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

variable "sns_topic_arn" {
  description = "The ARN for the SNS topic"
  type        = string
}

variable "sqs_queue_url" {
  description = "The URL for the SQS queue"
  type        = string
}

variable "backend_port" {
  description = "The port for the backend service"
  type        = number
}

variable "db_port" {
  description = "The port of the database"
  type        = number
}

variable "db_user" {
  description = "The user of the database"
  type        = string
}

variable "db_password" {
  description = "The password of the database"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
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
