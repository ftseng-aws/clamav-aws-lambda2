variable vpc_id {
    type = string
}

variable service {
    type = string
}

variable subnet_id_list {
    type = list
    default = null
}

variable route_table_id_list {
    type = list
    default = null
}

variable project_name {
    type = string
}