output "key_name" {
  value = aws_key_pair.this.key_name
}

output "private_key_path" {
  value = var.public_key == "" ? local_sensitive_file.private_key[0].filename : null
}
