##########################
# AWS VPC
##########################
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" = "${var.tag_pre_fix}vpc"
  }
}

##########################
# AWS SUBNET - public subnets
##########################
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc_public_subnets[count.index]
  availability_zone       = var.vpc_azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.tag_pre_fix}public_subnet_${count.index + 1}"
  }
}

##########################
# AWS SUBNET - private app subnet
##########################
resource "aws_subnet" "private_app" {
  count             = var.private_app_subnet_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.vpc_private_app_subnets[count.index]
  availability_zone = var.vpc_azs[count.index]

  tags = {
    "Name" = "${var.tag_pre_fix}private_app_subnet_${count.index + 1}"
  }
}

##########################
# AWS SUBNET - private db subnet
##########################
resource "aws_subnet" "private_db" {
  count             = var.private_db_subnet_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.vpc_private_db_subnets[count.index]
  availability_zone = var.vpc_azs[count.index]

  tags = {
    "Name" = "${var.tag_pre_fix}private_app_subnet_${count.index + 1}"
  }
}

##########################
# AWS Internet gateway
##########################
resource "aws_internet_gateway" "vpc_ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.tag_pre_fix}internet_gateway"
  }
}

##########################
# AWS Route table - public
##########################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_ig.id
  }

  tags = {
    "Name" = "${var.tag_pre_fix}public_route_table"
  }
}

##########################
# AWS Route table association - public
##########################
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

##########################
# AWS Route table - private
##########################
resource "aws_route_table" "private" {
  count  = var.private_app_subnet_count + var.private_db_subnet_count
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.tag_pre_fix}private_route_table_${count.index + 1}"
  }
}

##########################
# AWS VPC Endpoint
##########################
resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.vpc.id
  service_name    = "com.amazonaws.us-east-1.s3"
  route_table_ids = aws_route_table.private[*].id

  tags = {
    "Name" = "${var.tag_pre_fix}s3_endpoint"
  }
}

##########################
# AWS Route table association - private
##########################
resource "aws_route_table_association" "private" {
  count          = var.private_app_subnet_count + var.private_db_subnet_count
  subnet_id      = element(concat(aws_subnet.private_app[*].id, aws_subnet.private_db[*].id), count.index)
  route_table_id = aws_route_table.private[count.index].id
}

##########################
# AWS DB subnet group
##########################
resource "aws_db_subnet_group" "rds" {
  name       = var.db_subnet_group_name
  subnet_ids = aws_subnet.private_db[*].id
}