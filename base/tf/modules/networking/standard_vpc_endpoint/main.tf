resource "aws_vpc_endpoint" "endpt" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.${var.service}"
  vpc_endpoint_type = var.service == "s3" || var.service == "dynamodb" ? "Gateway" : "Interface"

  security_group_ids = var.service == "s3" || var.service == "dynamodb" ? null : [
    aws_security_group.vpce_sg[0].id,
  ]
  
  subnet_ids = var.service == "s3" || var.service == "dynamodb" ? null : var.subnet_id_list
  route_table_ids = var.service == "s3" || var.service == "dynamodb" ? var.route_table_id_list : null

  private_dns_enabled = var.service == "s3" || var.service == "dynamodb" ? false : true
}

data "aws_region" "current" {}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_security_group" "vpce_sg" {
  count = var.service == "s3" || var.service == "dynamodb" ? 0 : 1
  name        = "${var.project_name}-${var.service}-vpce-sg"
  description = "VPC Endpoint Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.service}-vpce-sg"
    Project = var.project_name
  }
}

resource "aws_security_group_rule" "std_ingress_01" {
  count = var.service == "s3" || var.service == "dynamodb" ? 0 : 1
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.vpce_sg[0].id
}

resource "aws_security_group_rule" "std_egress_01" {
  count = var.service == "s3" || var.service == "dynamodb" ? 0 : 1
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpce_sg[0].id
}
