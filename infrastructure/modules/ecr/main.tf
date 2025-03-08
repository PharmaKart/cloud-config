resource "aws_ecr_repository" "ecrs" {
  for_each     = toset(var.repository_names)
  name         = each.value
  force_delete = true
  encryption_configuration {
    encryption_type = "AES256"
  }
  image_tag_mutability = "MUTABLE"

  tags = {
    Name      = each.value
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}
