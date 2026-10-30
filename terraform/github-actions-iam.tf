resource "aws_iam_user" "github_actions" {
  name = "github-actions-k8s-demo"

  tags = {
    Project   = "k8s-demo"
    ManagedBy = "Terraform"
  }
}

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
          "ecr:CompleteLayerUpload",
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
