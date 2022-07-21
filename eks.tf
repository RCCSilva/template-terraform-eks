resource "aws_ecr_repository" "main" {
  name                 = "web-benchmark-ecr"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_eks_cluster" "main" {
  name     = "web-benchmark-eks-cluster"
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids             = concat(aws_subnet.public.*.id, aws_subnet.private.*.id)
    endpoint_public_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_subnet.public
  ]
}

resource "aws_eks_fargate_profile" "main" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "benchmark-fargate-profile"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn

  subnet_ids = aws_subnet.private.*.id

  selector {
    namespace = "default"
  }

  depends_on = [
    aws_eks_cluster.main
  ]
}

resource "aws_eks_fargate_profile" "coredns" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "coredns"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn

  subnet_ids = aws_subnet.private.*.id

  selector {
    namespace = "kube-system"
    labels = {
      k8s-app = "kube-dns"
    }
  }

  depends_on = [
    aws_eks_cluster.main
  ]
}

# resource "aws_eks_addon" "coredns" {
#   addon_name        = "coredns"
#   addon_version     = "v1.8.4-eksbuild.1"
#   cluster_name      = aw
#   resolve_conflicts = "OVERWRITE"
#   depends_on        = [aws_eks_cluster.main]
# }
