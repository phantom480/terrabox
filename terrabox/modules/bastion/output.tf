output "public_ip" {
  value = var.enable_bastion ? aws_instance.this[0].public_ip : null
}

output "instance_id" {
  value = var.enable_bastion ? aws_instance.this[0].id : null
}
