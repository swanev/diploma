module "ecr" {
  source                         = "./modules/ecr"
  depends_on                     = [module.vpc.vpc_id]  
  ecr_name                       = var.ecr_name
}
