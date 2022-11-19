##########################
# AWS Application load balancer
##########################
resource "aws_elb" "alb" {
  name            = var.dinusha_app_elb
  internal        = false
  security_groups = [aws_security_group.alb.id]
  subnets         = aws_subnet.public[*].id

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  instances                   = aws_instance.app_server[*].id
  cross_zone_load_balancing   = true
  idle_timeout                = 100
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    "Name" = "${var.tag_pre_fix}alb"
  }
}