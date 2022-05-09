variable lb_arn {
    type = string
}

variable port {
    type = number
}

variable default_action_type {
    type = string
    default = "forward"
}

variable target_group_arn {
    type = string
}

variable protocol {
    type = string
}

variable certificate_arn {
    type = string
    default = null
}