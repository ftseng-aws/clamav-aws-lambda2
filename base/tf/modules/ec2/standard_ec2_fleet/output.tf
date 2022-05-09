output instance_id_list {
    value = [for s in aws_instance.ec2 : s.id]
}

output instance_list {
    value = [
        for s in aws_instance.ec2: {
            id = s.id
            public_ip = s.public_ip
        }
    ]
}