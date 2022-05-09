output "public_subnet_id_list" {
    value = [for s in module.standard_public_subnet : s.subnet_id]
}
 
output "private_subnet_id_list" {
    value = [for s in module.standard_private_subnet : s.subnet_id]
}

output "public_subnet_id_set" {
    value = toset([for s in module.standard_public_subnet : s.subnet_id])
}
 

output "private_subnet_id_set" {
    value = toset([for s in module.standard_private_subnet : s.subnet_id])
}
 
