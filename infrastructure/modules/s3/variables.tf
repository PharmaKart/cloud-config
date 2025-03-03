variable "s3_folders" {
  description = "List of folder names to create in the S3 bucket"
  type        = list(string)
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}
