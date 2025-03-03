# IAM Policy for EKS Nodes to Upload Files to S3
resource "aws_iam_policy" "eks_nodes_s3_policy" {
  name        = "EKSNodesS3Policy"
  description = "Allows EKS nodes to upload files to S3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject", "s3:ListBucket"],
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}
