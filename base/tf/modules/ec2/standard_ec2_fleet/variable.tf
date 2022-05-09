variable ami_id {
    type = string
    description = "AMI image id"
}
variable user_data {
    type = string
    default = null
}
variable instance_type {
    type = string
    description = "Instane Type"
}

variable az_count {
    type = number
    description = "number of AZs"
}

variable instance_name {
    type = string
    description = "ec2 instance name"
}

variable subnet_id_list {
    type = list
    description = "subnet id list"
}

variable ec2_security_group_list {
    type = list
    description = "ec2 security group list"
}

variable key_name {
    type = string
    default = null
}

variable project_name {
    type = string
}

variable iam_role {
    type = string
}