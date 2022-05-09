variable "project_name" {
    type = string
}

variable "target_group_name" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "target_id_list" {
    type = list
}

variable "port" {
    type = number
}

variable "protocol" {
    type = string
}

variable "health_check" {
    type = bool
    description = "health check"
}

variable "target_type" {
    type = string
}