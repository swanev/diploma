module "diploma_rds_mysql" {
  source               = "./modules/rds"
  storage              = 10
  engine               = "mysql"
  engine_version       = "8.0.20"
  instance_class       = "db.t2.micro"
  db_name              = "diploma_db"
  username             = "root"
  password             = "temp12345"
#  parameter_group_name = "default.mysql8.0"
  vpc_id               = aws_vpc.diploma.id
  subnet_1_cidr        = "10.10.1.0/24"
  subnet_2_cidr        = "10.10.2.0/24"
}


#resource "aws_db_instance" "diploma_rds_mysql" {
#  allocated_storage    = 10
#  engine               = "mysql"
#  engine_version       = "8.0.20"
#  instance_class       = "db.t2.micro"
#  name                 = "diploma_db"
#  username             = "root"
#  password             = "temp12345"
#  parameter_group_name = "default.mysql8.0"
#  skip_final_snapshot  = true
#}

output "DB-adr" {
   value = module.diploma_rds_mysql.db_instance_address
}