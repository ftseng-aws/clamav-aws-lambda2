resource "aws_subnet" "standard_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.subnet_az
  map_public_ip_on_launch = false
  tags = {
        Name = var.subnet_name
        Project = var.project_name
    }
}

resource "aws_route_table" "standard_egress_subnet_rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.subnet_name}-rt"
  }
}

resource "aws_route" "internet_route" {
  route_table_id            = aws_route_table.standard_egress_subnet_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.standard_nat_gateway.id
  depends_on                = [aws_route_table.standard_egress_subnet_rt]
}

resource "aws_route_table_association" "standard_egress_subnet_rt_assoc" {
  subnet_id      = aws_subnet.standard_subnet.id
  route_table_id = aws_route_table.standard_egress_subnet_rt.id
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_nat_gateway" "standard_nat_gateway"{
    allocation_id = aws_eip.eip.id
    subnet_id = var.public_subnet
      tags = {
        Name = "${var.subnet_name}-natgw"
        Project = var.project_name
    }
}

resource "aws_eip" "eip" {
}