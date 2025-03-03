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
