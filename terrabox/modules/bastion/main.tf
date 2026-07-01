resource "aws_instance" "this" {
  count = var.enable_bastion ? 1 : 0

  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  vpc_security_group_ids     = var.security_group_ids
  associate_public_ip_address = true

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  tags = {
    Name = "${var.name}-${var.env}"
  }
}
