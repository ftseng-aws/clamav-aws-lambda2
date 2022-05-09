output "subnet_id_list" {
    value = [for s in module.standard_public_subnet : s.subnet_id]
}
 
