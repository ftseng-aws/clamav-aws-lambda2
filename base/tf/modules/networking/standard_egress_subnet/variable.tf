variable project_name {
    description = "project name"
    type = string
}

variable vpc_id {
    description = "vpc id"
    type = string
}

variable subnet_cidr_block {
    description = "subnet cidr block"
    type = string
}

variable subnet_name {
    description = "subnet name"
    type = string
}

variable subnet_az {
    description = "subnet az"
    type = string
}

variable igw_id {
    description = "igw id"
    type = string
    default = null
}

variable public_subnet{
    type = string
}