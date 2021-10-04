
################################ EKS VARS ################################

variable "cluster-name" {
  default = "terraform-eks-diploma"
  type    = string
}

variable "vpc_id" {
  default = "none"
  type    = string
}