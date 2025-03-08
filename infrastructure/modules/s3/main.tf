resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name      = var.bucket_name
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_object" "s3_folders" {
  for_each = toset(var.s3_folders)

  bucket  = aws_s3_bucket.s3_bucket.id
  key     = "${each.value}/"
  content = ""
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

//Codepipeline bucket

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "pharmakart-codepipeline-bucket"
  force_destroy = true
  tags = {
    Name      = "test-codepipeline-bucket"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_pab" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
