terraform{
    backend "s3" {
        bucket = "school16-diploma-tfstate"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-2"    
    }
}

provider "aws" {
    access_key=var.aws_access_key_id
    secret_key=var.aws_secret_access_key
    region=var.vpc_region
}