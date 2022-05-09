variable internal {
    type = bool
    description = "whether the load balancer is internal or internet facing" 
}

variable lb_type {
    type = string
    description = "type of lb"
}

variable lb_security_group_id_list {
    type = list
    description = "security group id for load balancer"
}

variable subnet_id_list {
    type = list
    description = "subnet_id_list"
}

variable project_name {
    type = string
    description = "project name"
}

variable vpc_id {
    type = string
    description = "vpc id"
}

