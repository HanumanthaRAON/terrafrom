###############  EKS Node Group ####################################################
data "aws_iam_policy_document" "eks_ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_eks_node_group" "dev_eks_node_group" {
  cluster_name    = aws_eks_cluster.dev-eks-cluster.name
  node_group_name = "${terraform.workspace}-${var.eks_dev_node_group_name}"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = data.aws_subnets.private.ids
  ami_type = var.ami_type
  capacity_type = var.capacity_type
  instance_types = var.instance_types
  disk_size = var.disk_size
  remote_access {
    ec2_ssh_key = ""

  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.dev-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.dev-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.dev-AmazonEC2ContainerRegistryReadOnly,
  ]
  lifecycle {

    ignore_changes = [scaling_config[0].desired_size]
    create_before_destroy = true

  }
}

resource "aws_iam_role" "node_role" {
  name = "${terraform.workspace}-${var.eks_dev_node_role}"
  assume_role_policy = data.aws_iam_policy_document.eks_ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "dev-AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "dev-AmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.node_role.name  
}

resource "aws_iam_role_policy_attachment" "dev-AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.node_role.name
}