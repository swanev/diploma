# diploma TERRAFORM 0.0.2

This is a Terraform lab which use AWS (EKS, ECR, RDS, CodeBuild, S3) as platform to lounch small application. It's use
s3 (should be created before) for keeping state.

## S3 for tfsate

Go to terraform/pre-aws directory where you need to create a ".tfvars" file (for example terraform.tfvars) with content like:

```sh
aws_access_key_id = "YOUR_KEY_ID"
aws_secret_access_key = "YOUR_SECRET_ACCESS_KEY"
vpc_region = "YOUR_REGION"
bucket_name = "YOUR_BUCKET_NAME"
```

and then execute:

```sh
terraform init
terraform apply
```

## Deploy app

Go to terrafor/aws-env directory where you need to create a ".tfvars" file (for example terraform.tfvars) with content like:

```sh
codestar_connector_credentials = "YOUR CODESATR ARN TO GITHUB"
aws_access_key_id="yoUR ACCESS KEY"
aws_account_id="YOUR ACCOUNT ID"
aws_secret_access_key="YOUR ACCESS KEY"
vpc_region="YOUR REGION"
vpc_name="YOUR VPC NAME"
vpc_cidr_block="YOUR CIDR BLOCK"
vpc_public_subnet="YOUR PUBLOCK CIDR BLOCK"
vpc_private_subnet="YOUR PRIVATE CIDR BLOCK"
vpc_eks_subnet = "YOUT EKS SUBNET"
deploy_type="ecr"
ecr_name="YOUR ECR REPO NAME"
github_repo_name="YOUR GITHUB REPO NAME"
github_repo_owner="YOUR GITHUB REPO OWNER"
cluster-name="YOUR EKS CLUSTER NAME"
bucket_name_art = "YOUR_BUCKET_NAME_FOR_ARTIFACTS"
```
In state.tf file set "bucket" value by "YOUR_BUCKET_NAME_FOR_TFSTATE"

and then execute:

```sh
terraform init
terraform apply
```