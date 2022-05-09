
variable project_name {
    description = "project name"
    type = string
}

variable vpc_cidrblock {
    description = "vpc cidr bloc"
    type = string
}

variable az_count {
    description = "number of AZs"
    type = number
}

variable subnet_az_mapping {
    description = "subnet az mapping"
    type = list 
    default = ["a","b","c"]
}

data "aws_region" "current" {}