
output "vpce_id_list" {
    value = [
        for service in var.service_list : map(service, values(module.vpce_int)[*]["vpce_id"])
    ]
}


# output "vpce_arn_list" {
#     value = [
#         for service in var.service_list : map(service, module.vpce_int[*].vpce_arn)
#     ]
# }

