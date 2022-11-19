##########################
# AWS Key pair to access vms
##########################
resource "aws_key_pair" "access_key" {
  key_name   = var.dinusha_ssh_key
  public_key = file(var.public_key_path)

  tags = {
    "Name" = "${var.tag_pre_fix}key"
  }
}