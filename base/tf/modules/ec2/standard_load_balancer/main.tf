resource "aws_lb" "lb" {
  name               = "${var.project_name}-${var.lb_type}-lb"
  internal           = var.internal
  load_balancer_type = var.lb_type
  security_groups    = var.lb_type == "application" ? concat(var.lb_security_group_id_list, [aws_security_group.internet_lb_sg.id]) : null
  
  
  subnets            = var.subnet_id_list

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-${var.lb_type}-lb"
  }
}



resource "aws_security_group" "internet_lb_sg" {
  name        = "${var.project_name}-internet-lb-sg"
  description = "${var.project_name} project"
  vpc_id      = var.vpc_id

  tags = {
    Name ="${var.project_name}-internet-lb--sg"
    Project = var.project_name
  }
}

resource "aws_security_group_rule" "std_ingress_01" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.internet_lb_sg.id
}


resource "aws_security_group_rule" "std_ingress_02" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.internet_lb_sg.id
}

resource "aws_security_group_rule" "std_egress_01" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.internet_lb_sg.id
}