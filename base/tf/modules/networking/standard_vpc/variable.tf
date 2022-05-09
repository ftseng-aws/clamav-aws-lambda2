variable vpc_name {
    description = "vpc name"
    type = string
}
variable project_name {
    description = "project name"
    type = string
}

variable vpc_cidrblock {
    description = "vpc cidr bloc"
    type = string
}
variable attach_igw {
    type = bool
    description = "attach IGW"
}