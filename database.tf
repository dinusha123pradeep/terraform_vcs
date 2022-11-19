##########################
# AWS Database instance
##########################
resource "aws_db_instance" "rds" {
  allocated_storage      = var.db_settings.allocated_storage
  engine                 = var.db_settings.engine
  engine_version         = var.db_settings.engine_version
  instance_class         = var.db_settings.instance_class
  db_name                = var.db_settings.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds.id
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = var.db_settings.skip_final_snapshot
  multi_az               = true
}