module "eks" {
  source       = "./modules/eks"
  depends_on   = [module.vpc.vpc_id]
  cluster-name = var.cluster-name
  vpc_id       = module.vpc.vpc_id
}
