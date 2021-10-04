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

################################ AWS CREDS VARS ################################

# main creds for AWS connection
variable "aws_access_key_id" {
  description = "AWS access key"
  default = null  
}

variable "aws_account_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
}

################################ CODE VARS ################################

variable "github_repo_name" {
  type        = string
  description = "The name of the GitHub repository"
}

variable codestar_connector_credentials {
    type = string
}

################################ RDS VARS ################################

variable "db_instance" {
  type        = string
  description = "The name of the GitHub repository"
  default = null 
}

variable "github_repo_owner" {
  type        = string
  description = "The owner of the GitHub repo"
  default = "null"
}

################################ EKS VARS ################################

variable "cluster-name" {
  default = "terraform-eks-diploma"
  type    = string
}

################################ VPC, AZ, SUBNET VARS ################################

variable "vpc_region" {
  description = "AWS region"
  default = null  
}

################################ Buckets for state and artifacts ################################

variable "bucket_name_art"{
  description = "bucket name for artifacts"
}