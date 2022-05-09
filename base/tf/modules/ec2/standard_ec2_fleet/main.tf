resource "aws_instance" "ec2" {
  count = var.az_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id_list[count.index]
  vpc_security_group_ids = var.ec2_security_group_list
  key_name = var.key_name
  user_data = var.user_data
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.id

  tags = {
    Name = "ec2_${var.instance_name}-${count.index}"
    Project_Name = var.project_name
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-${var.instance_name}-instance-profile"
  role = var.iam_role
}