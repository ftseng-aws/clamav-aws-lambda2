resource "aws_subnet" "standard_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.subnet_az
  map_public_ip_on_launch = var.public
  tags = {
        Name = var.subnet_name
        Project = var.project_name
    }
}

resource "aws_route_table" "standard_public_subnet_rt" {
  count = var.public ? 1 : 0
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.subnet_name}-rt"
  }
}

resource "aws_route" "internet_route" {
  count = var.public ? 1 : 0
  route_table_id            = aws_route_table.standard_public_subnet_rt[0].id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = var.public ? var.igw_id : null
  depends_on                = [aws_route_table.standard_public_subnet_rt[0]]
}

resource "aws_route_table_association" "standard_public_subnet_rt_assoc" {
  count = var.public ? 1 : 0
  subnet_id      = aws_subnet.standard_subnet.id
  route_table_id = aws_route_table.standard_public_subnet_rt[0].id
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}