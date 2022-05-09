output load_balancer_id {
    value = aws_lb.lb.id
}
output load_balancer_dns {
    value = aws_lb.lb.dns_name
}
output load_balancer_arn {
    value = aws_lb.lb.arn
}