resource "aws_lb_target_group" "instance_tg" {
  count = var.target_type == "instance" ? 1 : 0
  name     = "${var.project_name}-${var.target_group_name}-instance-tg"
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  
  health_check {
    enabled = var.health_check
    path = var.health_check ? "/" : null
    port = var.health_check ? var.port : null
    protocol = (var.protocol == "HTTPS" || var.health_check) ? "HTTPS" : "HTTP"
  }
}

resource "aws_lb_target_group" "ip_tg" {
  count = var.target_type == "ip" ? 1 : 0
  name = "${var.project_name}-${var.target_group_name}-ip-tg"
  port = var.port
  protocol = var.protocol
  vpc_id = var.vpc_id
  target_type = var.target_type
  
    health_check {
    enabled = var.health_check
    path = var.health_check ? "/" : null
    port = var.health_check ? var.port : null
    protocol = var.health_check ? var.protocol : null
  }
}

resource "aws_lb_target_group" "lambda_tg" {
  count = var.target_type == "lambda" ? 1 : 0
  target_type = var.target_type
}


resource "aws_lb_target_group_attachment" "instance_tg_att" {
  count = var.target_type == "instance" ? length(var.target_id_list) : 0
  target_group_arn = aws_lb_target_group.instance_tg[0].arn
  target_id        = var.target_id_list[count.index]
  port             = var.port
}

resource "aws_lb_target_group_attachment" "ip_tg_att" {
  count = var.target_type == "ip" ? length(var.target_id_list) : 0
  target_group_arn = aws_lb_target_group.ip_tg[0].arn
  target_id        = var.target_id_list[count.index]
  port             = var.port
}


resource "aws_lb_target_group_attachment" "lambda_tg_att" {
  count = var.target_type == "lambda" ? length(var.target_id_list) : 0
  target_group_arn = aws_lb_target_group.lambda_tg[0].arn
  target_id        = var.target_id_list[count.index]
}


resource "aws_security_group" "tg_lb_sg" {
  name        = "${var.project_name}-${var.target_group_name}-tg-lb-sg"
  description = "TG LB Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.target_group_name}-tg-lb-sg"
    Project = var.project_name
  }
}

resource "aws_lambda_permission" "with_lb" {
  count = var.target_type == "lambda" ? 1 : 0
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = var.target_id_list[count.index]
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda_tg[count.index].arn
}