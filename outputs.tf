##########################
# Output - AWS load balancer DNS name 
##########################
output "alb-dns-name" {
  value = aws_elb.alb.dns_name
}

##########################
# Output - AWS mysql database address
##########################
output "database_endpoint" {
  description = "The endpoint of the database"
  value       = aws_db_instance.rds.address
}

##########################
# Output - AWS mysql database port
##########################
output "database_port" {
  description = "The port of the database"
  value       = aws_db_instance.rds.port
}
