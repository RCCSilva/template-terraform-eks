resource "aws_iam_role" "eks" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}


resource "aws_iam_role" "fargate_pod_execution_role" {
  name = "eks-fargate-pod-execution-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "fargate_pod_execution_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod_execution_role.name
}

resource "aws_iam_policy" "fargate_pod_logging" {
  name = "fargate-pod-execution-logging-policy"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [{
      Effect : "Allow",
      Action : [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
      ],
      Resource : "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_pod_attachment" {
  role       = aws_iam_role.fargate_pod_execution_role.name
  policy_arn = aws_iam_policy.fargate_pod_logging.arn
}
