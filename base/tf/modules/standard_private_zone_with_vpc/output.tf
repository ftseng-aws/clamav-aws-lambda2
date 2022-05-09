output "vpc_id" {
   value = module.vpc.vpc_id
}

output "vpc_arn" {
   value = module.vpc.vpc_arn
}

output "vpc_cidrblock" {
   value = module.vpc.vpc_cidrblock
}

output "vpc_default_rt" {
   value = module.vpc.vpc_default_rt
}

output "vpc_standard_sg_id" {
    value = module.vpc.vpc_standard_sg_id
}

output "vpc_default_sg_id" {
    value = module.vpc.vpc_default_sg_id
}

output "subnet_id_list" {
    value = [for s in module.standard_private_subnet : s.subnet_id]
 }