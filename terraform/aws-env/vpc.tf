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

resource "aws_subnet" "diploma" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.10.11${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.diploma.id


}

resource "aws_internet_gateway" "diploma" {
  vpc_id = aws_vpc.diploma.id

  tags = {
    Name = "terraform-eks-diploma"
  }
}

resource "aws_route_table" "diploma" {
  vpc_id = aws_vpc.diploma.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.diploma.id
  }
}

resource "aws_route_table_association" "diploma" {
  count = 2

  subnet_id      = aws_subnet.diploma.*.id[count.index]
  route_table_id = aws_route_table.diploma.id
}