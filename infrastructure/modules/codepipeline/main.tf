resource "aws_codepipeline" "codepipeline" {
  for_each       = var.build_projects
  name           = "${each.key}-pipeline"
  role_arn       = aws_iam_role.codepipeline_role.arn
  pipeline_type  = "V2"
  execution_mode = "QUEUED"

  artifact_store {
    location = var.s3codepipeline_bucket
    type     = "S3"
  }

  trigger {
    provider_type = "CodeStarSourceConnection"
    git_configuration {
      source_action_name = "Source"
      push {
        branches {
          includes = ["main"]
        }
      }
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      region           = var.aws_region
      output_artifacts = ["SourceArtifact"]
      namespace        = "SourceVariables"

      configuration = {
        ConnectionArn    = var.source_connection_arn
        FullRepositoryId = each.value.repository
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      region           = var.aws_region
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"
      namespace        = "BuildVariables"

      configuration = {
        EnvironmentVariables = jsonencode(
          concat(
            [
              {
                "name" : "AWS_DEFAULT_REGION",
                "value" : "${var.aws_region}",
                "type" : "PLAINTEXT"
              },
              {
                "name" : "IMAGE_REPO_NAME",
                "value" : "${each.value.image}",
                "type" : "PLAINTEXT"
              },
              {
                "name" : "AWS_ACCOUNT_ID",
                "value" : "${var.account_id}",
                "type" : "PLAINTEXT"
              }
            ],
            each.key == "FrontendSvcProject" ? [
              {
                "name" : "CONTAINER_NAME",
                "value" : var.frontend_container_name,
                "type" : "PLAINTEXT"
              }
            ] : []
          )
        )
        ProjectName = each.key
      }
    }
  }

  dynamic "stage" {
    for_each = each.value.type == "EKS" ? [1] : []

    content {
      name = "Deploy"

      action {
        name            = "Deploy"
        category        = "Deploy"
        owner           = "AWS"
        region          = var.aws_region
        provider        = "EKS"
        input_artifacts = ["BuildArtifact"]
        namespace       = "DeployVariables"
        version         = "1"

        configuration = {
          ClusterName   = var.eks_cluster_name
          ManifestFiles = "deployment.yml"
        }
      }
    }
  }

  dynamic "stage" {
    for_each = each.value.type == "ECS" ? [1] : []
    content {
      name = "Deploy"

      action {
        name            = "Deploy"
        category        = "Deploy"
        owner           = "AWS"
        region          = var.aws_region
        provider        = "ECS"
        input_artifacts = ["BuildArtifact"]
        namespace       = "DeployVariables"
        version         = "1"

        configuration = {
          ClusterName = var.ecs_cluster_name
          ServiceName = "${var.ecs_cluster_name}-service"
          FileName    = "imagedefinitions.json"
        }
      }
    }

  }

  tags = {
    Name      = "${each.key}-pipeline"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}
