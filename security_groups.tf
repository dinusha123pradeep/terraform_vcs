##########################
# AWS Security group - load balancer 
##########################
resource "aws_security_group" "alb" {
  name   = var.sg_dinusha_elb
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.tag_pre_fix}sg_lb"
  }
}

##########################
# AWS Security group - EC2
##########################
resource "aws_security_group" "ec2_app" {
  name   = var.sg_dinusha_app
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.tag_pre_fix}sg_ec2"
  }
}

##########################
# AWS Security group - EC2 bastion
##########################
resource "aws_security_group" "ec2_bastion" {
  name   = var.sg_dinusha_bastion
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.tag_pre_fix}sg_ec2_bastion"
  }
}

##########################
# AWS Security group - RDS
##########################
resource "aws_security_group" "rds" {
  name   = var.sg_dinusha_rds
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_app.id, aws_security_group.ec2_bastion.id]
  }

  tags = {
    "Name" = "${var.tag_pre_fix}sg_rds"
  }
}