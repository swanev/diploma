#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_iam_role" "diploma-cluster" {
  name = "terraform-eks-diploma-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "diploma-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.diploma-cluster.name
}

resource "aws_iam_role_policy_attachment" "diploma-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.diploma-cluster.name
}

resource "aws_security_group" "diploma-cluster" {
  name        = "terraform-eks-diploma-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.diploma.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-diploma"
  }
}

resource "aws_security_group_rule" "diploma-cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.diploma-cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "diploma-eks-cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.diploma-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.diploma-cluster.id]
    subnet_ids         = aws_subnet.diploma[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.diploma-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.diploma-cluster-AmazonEKSVPCResourceController,
  ]
}

#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "diploma-node" {
  name = "terraform-eks-diploma-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "diploma-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.diploma-node.name
}

resource "aws_iam_role_policy_attachment" "diploma-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.diploma-node.name
}

resource "aws_iam_role_policy_attachment" "diploma-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.diploma-node.name
}

resource "aws_eks_node_group" "diploma" {
  cluster_name    = aws_eks_cluster.diploma-eks-cluster.name
  node_group_name = "diploma"
  node_role_arn   = aws_iam_role.diploma-node.arn
  subnet_ids      = aws_subnet.diploma[*].id

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.diploma-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.diploma-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.diploma-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

# Override with variable or hardcoded value if necessary
locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}

data "aws_availability_zones" "available" {}

# Not required: currently used in conjunction with using
# icanhazip.com to determine local workstation external IP
# to open EC2 Security Group access to the Kubernetes cluster.
# See workstation-external-ip.tf for additional information.
provider "http" {}
