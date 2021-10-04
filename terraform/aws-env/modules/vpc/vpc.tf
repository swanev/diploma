#resource "aws_vpc" "default" {
#  cidr_block = var.vpc_cidr_block
#}

#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "diploma" {
  cidr_block = var.vpc_cidr_block


}






