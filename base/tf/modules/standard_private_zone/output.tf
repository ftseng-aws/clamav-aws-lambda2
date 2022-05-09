output "subnet_id_list" {
    value = [for s in module.standard_private_subnet : s.subnet_id]
}
 
