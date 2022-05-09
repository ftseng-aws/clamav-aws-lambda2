resource "aws_subnet" "standard_private_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.subnet_az
  tags = {
        Name = var.subnet_name
        Project = var.project_name
    }
}