module standard_public_subnet {
    count = var.az_count 
    source = "../standard_subnet"
    project_name = var.project_name
    subnet_cidr_block = cidrsubnet(data.aws_vpc.vpc.cidr_block,8,count.index)
    vpc_id = var.vpc_id
    subnet_name = "public_zone_public_subnet_${count.index}"
    subnet_az = "${data.aws_region.current.name}${var.subnet_az_mapping[count.index]}"
    igw_id = var.igw_id
    public = true
}

module standard_private_subnet {
    count = var.az_count 
    source = "../standard_subnet"
    project_name = var.project_name
    subnet_cidr_block = cidrsubnet(data.aws_vpc.vpc.cidr_block,8,count.index + var.az_count)
    vpc_id = var.vpc_id
    subnet_name = "private_zone_private_subnet_${count.index}"
    subnet_az = "${data.aws_region.current.name}${var.subnet_az_mapping[count.index]}"
    public = false
}

data "aws_vpc" "vpc" {
    id = var.vpc_id
}