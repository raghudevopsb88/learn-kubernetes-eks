provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-d88"
    key    = "learn-kubernetes-eks/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_eks_cluster" "main" {
  name = "main"

  role_arn = aws_iam_role.cluster.arn
  version  = "1.35"

  vpc_config {
    subnet_ids = ["subnet-05fc554f21ead9d55", "subnet-0e99e91ba5863b57b"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "cluster" {
  name = "eks-cluster-main"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}