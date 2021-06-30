################################ ECR VARS ################################

variable "deploy_type" {
  type        = string
  description = "(Required) Must be one of the following ( ecr, ecs, lambda )"
}

variable "ecr_name" {
  type        = string
  description = "(Optional) The name of the ECR repo. Required if var.deploy_type is ecr or ecs"
  default     = null
}

variable "tags" {
  type        = map
  description = "(Optional) A mapping of tags to assign to the resource"
  default     = {}
}

variable "env_repo_name" {
  type = object({
    variables = map(string)
  })
  default = null
}

################################ CODEBUILD VARS ################################

#variable "name" {
#  type        = string
#  description = "(Required) The name of the codebuild project and artifact bucket"
#}

################################ AWS CREDS VARS ################################

# main creds for AWS connection
variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_account_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
}

################################ VPC, AZ, SUBNET VARS ################################

variable "availability_zone" {
  description = "availability zone used for the demo, based on region"
  default = {
    us-east-1 = "us-east-1a"
    us-west-1 = "us-west-1a"
  }
}

variable "vpc_name" {
  description = "VPC for building demos"
}

variable "vpc_region" {
  description = "AWS region"
}

variable "vpc_cidr_block" {
  description = "Uber IP addressing for demo Network"
}

variable "vpc_public_subnet" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

variable "vpc_private_subnet" {
  description = "Private CIDR for internally accessible subnet"
}

################################ RDS VARS ################################



################################ CODE VARS ################################

variable "github_repo_name" {
  type        = string
  description = "The name of the GitHub repository"
}

variable codestar_connector_credentials {
    type = string
}

variable "github_repo_owner" {
  type        = string
  description = "The owner of the GitHub repo"
}

################################ EKS VARS ################################

variable "aws_region" {
  default = "us-east-2"
}

variable "cluster-name" {
  default = "terraform-eks-diploma"
  type    = string
}

variable "vpc_eks_subnet" {
  description = "EKS CIDR subnet"
}