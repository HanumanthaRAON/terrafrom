############ EKS Cluster ###################
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc]
  }
 tags = {
   Name = "${terraform.workspace}-PrivateSubnet-*"
 }
}

resource "aws_eks_cluster" "dev-eks-cluster" {
  name     = "${terraform.workspace}-${var.eks_cluster_name}"
  role_arn = aws_iam_role.eks-cluster-dev-role.arn
  

  vpc_config {
    subnet_ids = data.aws_subnets.private.ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access = var.endpoint_public_access
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]
}


data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks-cluster-dev-role" {
  name               = "${terraform.workspace}-.${var.eks_role}"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-dev-role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster-dev-role.name
}

resource "aws_eks_addon" "dev-eks_addon" {
  for_each = toset(var.eks_addons)
  cluster_name = aws_eks_cluster.dev-eks-cluster.name
  addon_name = each.key
  resolve_conflicts = "OVERWRITE"
  
}

