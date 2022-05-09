resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.lb_arn
  port              = var.port
  protocol          = var.protocol
  ssl_policy        = var.protocol == "HTTPS" ? "ELBSecurityPolicy-2016-08" : null
  certificate_arn   = var.protocol == "HTTPS" ? var.certificate_arn : null

  default_action {
    type             = var.default_action_type
    target_group_arn = var.target_group_arn
  }
}