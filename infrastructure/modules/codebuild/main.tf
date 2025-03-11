resource "aws_codebuild_project" "codebuild" {
  for_each = var.build_projects
  name     = each.key
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:7.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = each.value.image
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.account_id
    }
    dynamic "environment_variable" {
      for_each = each.key == "FrontendSvcProject" ? [1] : []
      content {
        name  = "CONTAINER_NAME"
        value = "frontend-container"
      }
    }
    dynamic "environment_variable" {
      for_each = each.key == "FrontendSvcProject" ? [1] : []
      content {
        name  = "NEXT_PUBLIC_BACKEND_URL"
        value = var.backend_url
      }
    }
  }
  service_role = aws_iam_role.codebuild-service-role[each.key].arn
  source {
    type            = "GITHUB"
    location        = "https://github.com/${each.value.repository}"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  tags = {
    Name      = each.key
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}
