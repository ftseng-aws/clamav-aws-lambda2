output "vpc_id" {
   value = aws_vpc.vpc.id
}

output "vpc_arn" {
   value = aws_vpc.vpc.arn
}

output "vpc_cidrblock" {
   value = aws_vpc.vpc.cidr_block
}

output "vpc_default_rt" {
   value = aws_vpc.vpc.default_route_table_id
}

output "vpc_standard_sg_id" {
    value = aws_security_group.vpc_standard_sg.id
}

output "vpc_default_sg_id" {
    value = aws_vpc.vpc.default_security_group_id
}

output "igw_id" {
    value = var.attach_igw ? aws_internet_gateway.igw[0].id : null
}