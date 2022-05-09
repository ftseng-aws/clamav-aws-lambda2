module vpce_int {
    for_each = toset(var.service_list)
    source = "../standard_vpc_endpoint"
    vpc_id = var.vpc_id
    service = each.key
    subnet_id_list = each.key == "s3" || each.key == "dynamodb" ? null : var.subnet_id_list
    route_table_id_list = each.key == "s3" || each.key == "dynamodb" ? var.route_table_id_list : null
    project_name = var.project_name
}