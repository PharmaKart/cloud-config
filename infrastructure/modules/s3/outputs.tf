output "bucket_url" {
  description = "URL of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.bucket_domain_name
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.arn
}

output "codepipeline_bucket" {
  description = "URL of the CodePipeline bucket"
  value       = aws_s3_bucket.codepipeline_bucket.bucket
}

output "codepipeline_bucket_arn" {
  description = "ARN of the CodePipeline bucket"
  value       = aws_s3_bucket.codepipeline_bucket.arn
}
