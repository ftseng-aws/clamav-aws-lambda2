variable project_name {
    default = "clamav-lambda-ext"
}

module egress_subnet {
  source = "../tf/modules/networking/standard_egress_subnet"
  project_name = "clamav-lambda-ext"
  vpc_id = module.vpc.vpc_id
  subnet_cidr_block = "10.2.6.0/24"
  subnet_name = "egress_subnet_1"
  subnet_az = "ap-southeast-1a"
  public_subnet = module.standard_public_private_zone.public_subnet_id_list[0]
}

output egress_subnet_id {
  value=module.egress_subnet.subnet_id 
}

module vpc {
    source = "../tf/modules/networking/standard_vpc"
    project_name = "clamav-lambda-ext"
    vpc_name = "vpc-01"
    vpc_cidrblock = "10.2.0.0/16"
    attach_igw = true
}

resource "aws_efs_file_system" "efs" {
  creation_token = "efs-01"

  tags = {
    Name = "efs-01"
    Project_Name = var.project_name
  }
}

resource "aws_efs_access_point" "efs_ap" {
  file_system_id = aws_efs_file_system.efs.id
}

resource "aws_efs_mount_target" "efs_mp" {
  for_each = module.standard_public_private_zone.public_subnet_id_set
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = each.key
  security_groups = [aws_security_group.efs_eni_sg.id]
  depends_on = [module.standard_public_private_zone]
}

resource "aws_security_group" "efs_instance_sg" {
    name = "efs_instance_sg"
    description = "efs_instance_sg"
    vpc_id = module.vpc.vpc_id
    tags = {
        Name = "efs_instance_sg"
        Project_Name = var.project_name
    }
}

resource "aws_security_group_rule" "efs_instance_sg_egress_01" {
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "TCP"
  source_security_group_id = aws_security_group.efs_eni_sg.id
  security_group_id = aws_security_group.efs_instance_sg.id
}


resource "aws_security_group" "efs_eni_sg" {
  name        = "efs_eni_sg"
  description = "efs_eni_sg"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "efs_eni_sg"
    Project_Name = var.project_name
  }
}

resource "aws_security_group_rule" "efs_eni_sg_ingress_01" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "TCP"
  source_security_group_id = aws_security_group.efs_instance_sg.id
  security_group_id = aws_security_group.efs_eni_sg.id
}

resource "aws_security_group" "lambda_standard_sg" {
    name = "lambda_standard_sg"
    description = "lambda_standard_sg"
    vpc_id = module.vpc.vpc_id
    tags = {
        Name = "lambda_standard_sg"
        Project_Name = var.project_name
    }
}

resource "aws_security_group_rule" "lambda_standard_sg_egress_01" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda_standard_sg.id
}

output "lambda_sg_list" {
  value = [aws_security_group.efs_instance_sg.id,aws_security_group.lambda_standard_sg.id]
  
}



output "efs_mp_eni" {
    value = [for eni in aws_efs_mount_target.efs_mp : eni.network_interface_id]
}



output "efs" {
    value = {
        filesystem = {
          id = aws_efs_file_system.efs.id
          arn = aws_efs_file_system.efs.arn
          dns = aws_efs_file_system.efs.dns_name
        }
        access_point = {
          arn = aws_efs_access_point.efs_ap.arn 
        }
    }
}

output igw_id {
    value = module.vpc.igw_id
}

resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2_s3_role_1_${var.project_name}"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
    {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid = ""
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    },
    ]
  })
}

module standard_public_private_zone {
    source = "../tf/modules/networking/standard_public_private_zone"
    vpc_id = module.vpc.vpc_id
    project_name = "clamav-lambda-ext"
    az_count = 3
    igw_id = module.vpc.igw_id
}

output vpc_standard_sg_id {
    value = module.vpc.vpc_standard_sg_id
}


output public_subnet_id_list {
    value = module.standard_public_private_zone.public_subnet_id_list
}


output private_subnet_id_list {
    value = module.standard_public_private_zone.private_subnet_id_list
}

variable al2_ami_id {
    default = "ami-0f511ead81ccde020"
}

variable ubuntu_ami_id {
  default = "ami-0fed77069cd5a6d6c"
}

variable key_name { 
    default = "newkp1"
}

module standard_ec2_fleet {
    source = "../tf/modules/ec2/standard_ec2_fleet"
    ami_id = var.ubuntu_ami_id
    instance_type = "t3.xlarge"
    subnet_id_list = module.standard_public_private_zone.public_subnet_id_list 
    instance_name = "clamav-admin"
    key_name = var.key_name
    ec2_security_group_list = [aws_security_group.ssh_public_sg.id,aws_security_group.efs_instance_sg.id]
    az_count = 1
    project_name = var.project_name
    user_data = "${file("mount_efs.sh")}"
    iam_role = aws_iam_role.ec2_s3_role.id
}


output "ec2_instance_list" {
  value = module.standard_ec2_fleet.instance_list
}

resource "aws_security_group" "ssh_public_sg" {
  name        = "ssh-public-sg"
  description = "ssh-public-sg"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "ssh-public-sg"
    Project_Name = var.project_name
  }
}

resource "aws_security_group_rule" "std_ingress_01" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ssh_public_sg.id
}

resource "aws_security_group_rule" "std_egress_01" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ssh_public_sg.id
}

