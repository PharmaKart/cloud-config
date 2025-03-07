resource "aws_iam_role" "codebuild-service-role" {
  for_each = var.build_projects
  name     = "codebuild-${each.key}-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name      = "codebuild-${each.key}-service-role"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_policy" "codebuild-base-policy" {
  for_each = var.build_projects
  name     = "CodeBuildBasePolicy-${each.key}-${var.aws_region}"
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        Sid      = "VisualEditor0",
        Effect   = "Allow",
        Action   = "ecr:GetAuthorizationToken",
        Resource = "*"
      },
      {
        Sid    = "VisualEditor1",
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:UploadLayerPart",
          "s3:GetBucketAcl",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "ecr:PutImage",
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "s3:PutObject",
          "s3:GetObject",
          "logs:CreateLogStream",
          "codebuild:UpdateReport",
          "codebuild:BatchPutCodeCoverages",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "codebuild:BatchPutTestCases",
          "s3:GetBucketLocation",
          "ecr:InitiateLayerUpload",
          "s3:GetObjectVersion",
          "ecr:BatchCheckLayerAvailability"
        ],
        Resource : [
          "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/aws/codebuild/${each.key}",
          "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/aws/codebuild/${each.key}:*",
          "arn:aws:codebuild:${var.aws_region}:${var.account_id}:report-group/${each.key}-*",
          "arn:aws:s3:::codepipeline-${var.aws_region}-*",
          "arn:aws:ecr:${var.aws_region}:${var.account_id}:repository/${each.value.image}"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "codebuild-codeconnection-source-credentials" {
  for_each = var.build_projects
  name     = "CodeBuildCodeConnectionsSourceCredentialsPolicy-${each.key}-${var.aws_region}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codeconnections:GetConnectionToken",
          "codeconnections:GetConnection",
          "codeconnections:UseConnection"
        ],
        Resource = [
          "arn:aws:codeconnections:${var.aws_region}:${var.account_id}:connection/d9e8bed7-55ec-491e-af1e-c1e3a93eac94"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild-base-policy-attachment" {
  for_each   = var.build_projects
  role       = aws_iam_role.codebuild-service-role[each.key].name
  policy_arn = aws_iam_policy.codebuild-base-policy[each.key].arn
}

resource "aws_iam_role_policy_attachment" "codebuild-codeconnection-source-credentials-attachment" {
  for_each   = var.build_projects
  role       = aws_iam_role.codebuild-service-role[each.key].name
  policy_arn = aws_iam_policy.codebuild-codeconnection-source-credentials[each.key].arn
}
