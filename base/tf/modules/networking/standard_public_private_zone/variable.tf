
variable project_name {
    description = "project name"
    type = string
}

variable igw_id {
    description = "internet gateway"    
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

variable vpc_id {
    description = "vpc id"
    type = string
}