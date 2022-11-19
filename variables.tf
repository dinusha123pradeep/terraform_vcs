variable "tag_pre_fix" {
  description = "AWS tag prefix"
  type        = string
  default     = "dinusha_ha_"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "dinusha-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "vpc_private_app_subnets" {
  description = "Private APP subnets for VPC"
  type        = list(string)
  default     = ["10.10.3.0/24", "10.10.4.0/24"]
}

variable "vpc_private_db_subnets" {
  description = "Private DB subnets for VPC"
  type        = list(string)
  default     = ["10.10.5.0/24", "10.10.6.0/24"]
}

variable "sg_dinusha_bastion" {
  description = "Security group name for bastion host"
  type        = string
  default     = "dinusha_sg_bastion"
}

variable "sg_dinusha_app" {
  description = "Security group name for app servers"
  type        = string
  default     = "dinusha_sg_app"
}

variable "sg_dinusha_rds" {
  description = "Security group name for db servers"
  type        = string
  default     = "sg_dinusha_rds"
}

variable "sg_dinusha_elb" {
  description = "Security group name for app ELB"
  type        = string
  default     = "dinusha_sg_elb"
}

variable "dinusha_ssh_key" {
  description = "Dinusha SSH key name"
  type        = string
  default     = "dinusha_ssh_key"
}

variable "public_key_path" {
  description = "Public key path"
  type        = string
  default     = "keys/dinusha_public_key.pub"
}

variable "dinusha_app_elb" {
  description = "App ELB name"
  type        = string
  default     = "AppLB"
}

variable "ec2_app_server_count" {
  description = "EC2 App server count"
  type        = number
  default     = 1
}

variable "public_subnet_count" {
  description = "Public subnet count"
  type        = number
  default     = 1
}

variable "private_app_subnet_count" {
  description = "Private app subnet count"
  type        = number
  default     = 1
}

variable "private_db_subnet_count" {
  description = "Private db subnet count"
  type        = number
  default     = 1
}

variable "db_subnet_group_name" {
  description = ""
  type        = string
  default     = "dinusha_rds_subnet_group"
}

variable "db_settings" {
  type = map(any)
  default = {
    allocated_storage   = 5
    engine              = "mysql"
    engine_version      = "8.0.27"
    instance_class      = "db.t2.micro"
    db_name             = "dinusha_ha"
    skip_final_snapshot = true
  }
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}