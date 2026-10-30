# IAM user for GitHub Actions CI/CD
# Used for pushing Docker images to AWS ECR.
# Access keys are managed outside Terraform and stored in GitHub Secrets.

resource "aws_iam_user" "github_actions" {
  name = "github-actions-k8s-demo"

  tags = {
    Project   = "k8s-demo"
    ManagedBy = "Terraform"
  }
}

# Least-privilege IAM policy for pushing images to ECR.

resource "aws_iam_user_policy" "github_actions_ecr" {
  name = "github-actions-ecr-push"
  user = aws_iam_user.github_actions.name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid      = "ECRAuthorization"
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Sid    = "ECRPush"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        Resource = [
          aws_ecr_repository.frontend.arn,
          aws_ecr_repository.backend.arn
        ]
      }
    ]
  })
}
