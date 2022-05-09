output "target_group_arn" {
    value = (
    var.target_type == "ip" ? aws_lb_target_group.ip_tg[0].arn : (
    var.target_type == "lambda" ? aws_lb_target_group.lambda_tg[0].arn : (
    var.target_type == "instance" ? aws_lb_target_group.instance_tg[0].arn : null
            )
        )
    )
}

output "tg_lb_security_group_id" {
    value = (
    var.target_type == "ip" ? aws_lb_target_group.ip_tg[0].arn : (
    var.target_type == "lambda" ? aws_lb_target_group.lambda_tg[0].arn : (
    var.target_type == "instance" ? aws_lb_target_group.instance_tg[0].arn : null
            )
        )
    )
}