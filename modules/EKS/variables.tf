variable "vpc" {
  description = "VPC ID for EKS CLUSTER CREATION"
}

variable "eks_cluster_name" {
  default = "eks-cluster"
}

variable "endpoint_private_access" {
  default = true
}

variable "endpoint_public_access" {
  default = false
}

variable "eks_role" {
  default = "eks-cluster-role"
}

variable "eks_addons" {
  description = "ADDONS FOR EKS CLUSTERS"
  type = list(string)
  default = [ "coredns" , "kube-proxy" , "vpc-cni" , "aws-ebs-csi-driver"]
}

variable "eks_dev_node_group_name" {
  default = "node-group"
 
}

variable "eks_dev_node_role" {
  default = "node-group-role"
}

variable "ami_type" {
  default = "AL2_x86_64"
}

variable "capacity_type" {
  default = "ON_DEMAND"
}

variable "instance_types" {
  default = ["t3.micro"]
}

variable "disk_size" {
  default = 20
}

variable "desired_size" {
  default = 1
}

variable "max_size" {
  default = 2
}

variable "min_size" {
  default = 1
}

variable "max_unavailable" {
  default = 1
}