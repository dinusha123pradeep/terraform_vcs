provider "aws" {
  region = "us-east-1"
}

locals {
  user_data = <<-EOT
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y httpd.x86_64
  sudo systemctl start httpd.service
  sudo systemctl enable httpd.service
  echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
  EOT
}