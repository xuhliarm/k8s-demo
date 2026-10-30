resource "aws_iam_policy" "alb_controller" {
  name        = "k8s-demo-aws-load-balancer-controller"
  description = "IAM permissions for AWS Load Balancer Controller"
  policy      = file("${path.module}/policies/aws-load-balancer-controller.json")

  tags = {
    Project   = "k8s-demo"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "alb_controller_nodes" {
  role       = "k8s-demo-eks-node-role"
  policy_arn = aws_iam_policy.alb_controller.arn
}
