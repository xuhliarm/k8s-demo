########################################
# AWS EKS Managed Add-on: VPC CNI
########################################

resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "vpc-cni"
  addon_version = "v1.22.4-eksbuild.10"

  configuration_values = jsonencode({
    enableNetworkPolicy = "true"

    nodeAgent = {
      enabled               = true
      enablePolicyEventLogs = "true"
    }
  })

  # Adoption of existing self-managed aws-node resources
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.main
  ]

  tags = {
    Name = "k8s-demo-vpc-cni"
  }
}
