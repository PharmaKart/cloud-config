# Public Read Access Policy
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.s3_bucket.arn}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.s3_bucket_public_access_block]
}


resource "aws_s3_bucket_policy" "sse_and_ssl_policy" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "SSEAndSSLPolicy",
    Statement = [
      {
        Sid       = "DenyUnEncryptedObjectUploads",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:PutObject",
        Resource  = "arn:aws:s3:::pharmakart-codepipeline-bucket/*",
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" : "aws:kms"
          }
        }
      },
      {
        Sid       = "DenyInsecureConnections",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource  = "arn:aws:s3:::pharmakart-codepipeline-bucket/*",
        Condition = {
          Bool = {
            "aws:SecureTransport" : "false"
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.codepipeline_bucket_pab]
}
