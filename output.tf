output "region" {
  value = data.aws_region.current.name
}

output "cluster_name" {
  value = aws_eks_cluster.main.name 
}

output "fargate_pod_execution_role" {
  value = aws_iam_role.fargate_pod_execution_role.arn
}

output "subnet" {
  value = aws_subnet.public.*.id
}
