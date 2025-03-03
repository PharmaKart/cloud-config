output "bucket_url" {
  description = "URL of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.bucket_domain_name
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.arn
}
