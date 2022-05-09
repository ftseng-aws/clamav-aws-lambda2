resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidrblock
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = var.vpc_name
        Project = var.project_name
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_security_group" "vpc_standard_sg" {
  name        = replace("{placeholder}-std-sg","{placeholder}",var.project_name)
  description = replace("Standard SG for {placeholder} project","{placeholder}",var.project_name)
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = replace("{placeholder}-std-sg","{placeholder}",var.vpc_name)
    Project = var.project_name
  }
}

resource "aws_security_group_rule" "std_ingress_01" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.vpc_standard_sg.id
}

resource "aws_security_group_rule" "std_egress_01" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc_standard_sg.id
}