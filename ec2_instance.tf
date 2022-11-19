##########################
# AWS AMI
##########################
data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

##########################
# AWS Elastic IP
##########################
resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
  vpc      = true
}

##########################
# AWS Instance - bastion
##########################
resource "aws_instance" "bastion" {
  ami             = data.aws_ami.ami.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2_bastion.id]
  subnet_id       = aws_subnet.public[0].id
  key_name        = aws_key_pair.access_key.key_name

  tags = {
    "Name" = "${var.tag_pre_fix}ec2_bastion"
  }
}

##########################
# AWS Instance - app servers
##########################
resource "aws_instance" "app_server" {
  count           = var.ec2_app_server_count
  ami             = data.aws_ami.ami.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2_app.id]
  subnet_id       = aws_subnet.private_app[count.index].id
  key_name        = aws_key_pair.access_key.key_name
  user_data       = local.user_data

  tags = {
    "Name" = "${var.tag_pre_fix}ec2_app"
  }
}