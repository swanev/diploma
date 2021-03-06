################################ ECR VARS ################################

variable "deploy_type" {
  type        = string
  description = "(Required) Must be one of the following ( ecr, ecs, lambda )"
  default = "ecr"  
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
  default = null  
}

variable "aws_account_id" {
  description = "AWS access key"
  default = null  
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  default = null  
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
  default = null
}

variable "vpc_region" {
  description = "AWS region"
  default = null  
}

variable "vpc_cidr_block" {
  description = "Uber IP addressing for demo Network"
  default = "null"
}

variable "vpc_public_subnet" {
  description = "Public 0.0 CIDR for externally accessible subnet"
  default = null  
}

variable "vpc_private_subnet" {
  description = "Private CIDR for internally accessible subnet"
  default = null  
}

################################ RDS VARS ################################


################################ CODE VARS ################################

variable "github_repo_name" {
  type        = string
  description = "The name of the GitHub repository"
  default = null  
}

variable codestar_connector_credentials {
    type = string
}

variable "github_repo_owner" {
  type        = string
  description = "The owner of the GitHub repo"
  default = null
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
  default = null  
}

################################ Buckets for state and artifacts ################################

variable "bucket_name_art"{
  description = "bucket name for artifacts"
  default = null  
}