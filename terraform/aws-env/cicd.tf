module "cicd" {
  source                         = "./modules/cicd"
  depends_on                     = [module.eks.eks_id]  
  bucket_name_art                = var.bucket_name_art
  vpc_region                     = var.vpc_region
  aws_account_id                 = var.aws_account_id
  aws_access_key_id              = var.aws_access_key_id
  aws_secret_access_key          = var.aws_secret_access_key
  ecr_name                       = var.ecr_name
  cluster-name                   = var.cluster-name
  github_repo_name               = var.github_repo_name
  codestar_connector_credentials = var.codestar_connector_credentials
  db_instance                    = module.diploma_rds_mysql.db_instance_address
}