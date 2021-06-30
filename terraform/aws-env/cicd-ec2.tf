resource "aws_instance" "app_server" {
  ami           = "ami-0d8d212151031f51c"
  instance_type = "t2.micro"

  tags = {
    Name = "school-app"
  }
}