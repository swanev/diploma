module "diploma_rds_mysql" {
  source               = "./modules/rds"
  depends_on           = [module.vpc.vpc_id]
  storage              = 10
  engine               = "mysql"
  engine_version       = "8.0.20"
  instance_class       = "db.t2.micro"
  db_name              = "diploma_db"
  username             = "root"
  password             = "temp12345"
  vpc_id               = module.vpc.vpc_id
  subnet_1_cidr        = "10.10.1.0/24"
  subnet_2_cidr        = "10.10.2.0/24"
}

output "DB-adr" {
   value = module.diploma_rds_mysql.db_instance_address
}